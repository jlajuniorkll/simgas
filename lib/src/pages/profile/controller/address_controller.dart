import 'package:dartt_shop/src/constants/keys.dart';
import 'package:dartt_shop/src/models/endereco_model.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/profile/repository/address_repository.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AddressController extends GetxController {
  final AddressRepository addressRepository;

  AddressController(this.addressRepository);

  TextEditingController controllerCep = TextEditingController();
  final utilServices = UtilsServices();
  final authController = Get.find<AuthController>();
  EnderecoModel endereco = EnderecoModel();
  int typeAdress = 0;
  bool isLoading = false;

  /*@override
  void onInit() {
    super.onInit();
    // getPosition();
  }*/

  void setTypeAdress(int value) {
    typeAdress = value;
    update();
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  void setEndereco(EnderecoModel value) {
    endereco = value;
    update();
  }

  void setControllerCep(String value) {
    controllerCep.text = value;
    update();
  }

  Future<void> saveAddress() async {
    final result = await addressRepository.saveAddress(
        token: authController.user.token!, address: endereco);
    result.when(success: (data) {
      authController.user.idEndereco = data;
      authController.getEnderecoSaved();
      authController.update();
    }, error: (message) {
      utilServices.showToast(message: message, isError: true);
    });
    update();
  }

  Future<void> getCep(String cep) async {
    setLoading(true);
    final result = await addressRepository.fecthCep(cep: cep);
    setLoading(false);
    if (result['erro'] == "true" || result['erro'] == true) {
      utilServices.showToast(message: "Erro ao buscar CEP! Tente novamente.");
    } else {
      setEndereco(EnderecoModel(
          cep: result['cep'] as String,
          logradouro: result['logradouro'] as String,
          bairro: result['bairro'] as String,
          cidade: result['localidade'] as String,
          estado: result['uf'] as String,
          codigoIBGE: result['ibge'] as String));
      setControllerCep(result['cep'] as String);
    }
  }

  Future<bool> getPosition() async {
    setLoading(true);
    try {
      LocationPermission permissao;
      if (await Permission.location.isRestricted) {
        bool ativado = await Geolocator.isLocationServiceEnabled();
        if (!ativado) {
          utilServices.showToast(
              message: "Habilite sua localização em seu dispositivo!");
          return false;
        }
        permissao = await Geolocator.checkPermission();
        if (permissao == LocationPermission.denied) {
          permissao = await Geolocator.requestPermission();
          if (permissao == LocationPermission.denied) {
            utilServices.showToast(message: "Autorize o acesso a localização!");
            return false;
          }
        }
        if (permissao == LocationPermission.deniedForever) {
          utilServices.showToast(message: "Autorize o acesso a localização!");
          return false;
        }
        Position posicao = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        double latitude = posicao.latitude;
        double longitude = posicao.longitude;
        GeoData data = await Geocoder2.getDataFromCoordinates(
            latitude: latitude,
            longitude: longitude,
            googleMapApiKey: keyGoogleMap);
        getCep(data.postalCode);
        setLoading(false);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      utilServices.showToast(message: "Busque por cep ou digite seu endereço!");
      setLoading(false);
      return false;
    }
  }
}
