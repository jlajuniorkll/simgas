import 'package:dartt_shop/src/constants/keys.dart';
import 'package:dartt_shop/src/models/endereco_model.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/profile/repository/address_repository.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

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
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false;
        }
      }

      locationData = await location.getLocation();

      double? latitude = locationData.latitude;
      double? longitude = locationData.longitude;
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: latitude!,
          longitude: longitude!,
          googleMapApiKey: keyGoogleMap);
      getCep(data.postalCode);
      setLoading(false);
      return true;
    } catch (e) {
      utilServices.showToast(message: "Busque por cep ou digite seu endereço!");
      setLoading(false);
      return false;
    }
  }
}
