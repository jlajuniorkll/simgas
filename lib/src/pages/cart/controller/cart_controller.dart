import 'package:dartt_shop/src/constants/keys.dart';
import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/models/endereco_model.dart';
import 'package:dartt_shop/src/models/item_model.dart';
import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/models/pagamento_model.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/cart/repository/cart_repository.dart';
import 'package:dartt_shop/src/pages/cart/result/cart_result.dart';
import 'package:dartt_shop/src/pages/commons/payment_dialog.dart';
import 'package:dartt_shop/src/pages/home/controller/home_controller.dart';
import 'package:dartt_shop/src/services/pagamento_helper.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoder_buddy/geocoder_buddy.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class CartController extends GetxController {
  final CartRepository cartRepository;

  CartController(this.cartRepository);

  final authController = Get.find<AuthController>();
  final prodController = Get.find<HomeController>();
  final utilServices = UtilsServices();

  TextEditingController controllerCep = TextEditingController();
  List<MeiosPagamentoModel> meiosPagamento = [];
  List<CartItemModel> cartItems = [];
  bool isCheckoutLoading = false;
  // EnderecoModel endereco = EnderecoModel();
  EnderecoModel entrega = EnderecoModel();
  FormaPagamento dropdownValue = list.first;
  bool condictions = false;
  int meioPagamento = 0;
  int nParcelas = 1;
  int typeAdress = 0;
  bool isLoading = false;

  @override
  void onInit() async {
    super.onInit();
    await getCartItems();
  }

  void setCheckoutLoading(bool value) {
    isCheckoutLoading = value;
    update();
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  void setMeiosPagamento(MeiosPagamentoModel value) {
    meiosPagamento.clear();
    meiosPagamento.add(value);
    update();
  }

  void setTypeAdress(int value) {
    typeAdress = value;
    update();
  }

  void setCondictions(bool value) {
    condictions = value;
    update();
  }

  void setMeioPagamento(int value) {
    meioPagamento = value;
    update();
  }

  void setNParcelas(int value) {
    nParcelas = value;
    update();
  }

  void setDropDownButton(FormaPagamento value) {
    dropdownValue = value;
    update();
  }

  //void setEndereco(EnderecoModel value) {
  //  endereco = value;
  //  update();
  // }

  void setEntrega(EnderecoModel value) {
    entrega = value;
    update();
  }

  void setControllerCep(String value) {
    controllerCep.text = value;
    update();
  }

  Future<void> getCartItems() async {
    setLoading(true);
    final CartResult<List<CartItemModel>> result =
        await cartRepository.getCartItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );
    setLoading(false);

    result.when(success: (data) async {
      cartItems = data;
      if (prodController.allProducts.isEmpty) {
        await prodController.getAllProductsHiper();
      }
      for (var c in cartItems) {
        final prod =
            prodController.allProducts.where((p) => p.id == c.productId).first;
        c.item = ItemModel(
            itemName: prod.itemName,
            imgUrl: prod.imgUrl,
            unit: prod.unit,
            price: prod.price,
            description: prod.description,
            categoria: prod.categoria);
      }
      update();
    }, error: (message) {
      utilServices.showToast(message: message, isError: true);
    });
  }

  double cartTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item.totalPrice();
    }
    return total;
  }

  Future checkoutCart() async {
    setCheckoutLoading(true);
    List<CartItemModelHiper> cartModelHiper = [];
    for (var i in cartItems) {
      cartModelHiper.add(CartItemModelHiper(
          produtoId: i.productId,
          quantidade: i.quantity.toDouble(),
          precoUnitarioBruto: i.totalPrice(),
          precoUnitarioLiquido: i.totalPrice()));
    }
    CartResult<OrderModel> result = await cartRepository.checkoutCart(
        token: authController.user.token!,
        total: cartTotalPrice(),
        cliente: authController.user,
        items: cartModelHiper,
        meiosPagamento: meiosPagamento,
        enderecoModel:
            authController.user.endereco ?? authController.user.entrega!,
        entrega: authController.user.entrega!);
    setCheckoutLoading(false);
    result.when(success: (order) {
      cartItems.clear();
      setEntrega(EnderecoModel());
      meiosPagamento.clear();
      update();
      showDialog(
          context: Get.context!,
          builder: ((_) {
            return PaymentDialog(
              order: order,
            );
          }));
    }, error: (message) {
      utilServices.showToast(message: message);
    });
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item!.id == item.id);
  }

  Future<void> addItemToCart(
      {required ItemModel item, int quantity = 1}) async {
    int itemIndex = getItemIndex(item);
    if (itemIndex >= 0) {
      final product = cartItems[itemIndex];
      await changeItemQuantity(
          item: product, quantity: (product.quantity + quantity));
    } else {
      final CartResult<String> result = await cartRepository.addItemToCart(
          userId: authController.user.id!,
          token: authController.user.token!,
          productId: item.id.toString(),
          quantity: quantity);
      result.when(success: (data) {
        cartItems.add(CartItemModel(
            id: data, item: item, quantity: quantity, productId: item.id));
      }, error: (message) {
        utilServices.showToast(message: message, isError: true);
      });
    }
    update();
  }

  Future<bool> changeItemQuantity(
      {required CartItemModel item, required int quantity}) async {
    final result = await cartRepository.changeItemQuantity(
        token: authController.user.token!,
        cartItemId: item.id,
        quantity: quantity);

    if (result) {
      if (quantity == 0) {
        cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      } else {
        cartItems.firstWhere((cartItem) => cartItem.id == item.id).quantity =
            quantity;
      }
      update();
    } else {
      utilServices.showToast(
          message: "Erro ao alterar a quantidade do produto", isError: true);
    }
    return result;
  }

  int getCartTotalItems() {
    return cartItems.isEmpty
        ? 0
        : cartItems.map((e) => e.quantity).reduce((a, b) => a + b);
  }

  Future<void> getCep({required String cep, bool isSearch = false}) async {
    setLoading(true);
    final result = await cartRepository.fecthCep(cep: cep);
    if (result['erro'] == "true" || result['erro'] == true) {
      if (isSearch) {
        utilServices.showToast(message: "Erro ao buscar CEP! Tente novamente.");
      } else {
        utilServices.showToast(
            message: "Complete seu perfil e cadastre seu endere??o!");
      }
    } else {
      setEntrega(EnderecoModel(
          cep: result['cep'] as String,
          logradouro: result['logradouro'] as String,
          bairro: result['bairro'] as String,
          cidade: result['localidade'] as String,
          estado: result['uf'] as String,
          codigoIBGE: result['ibge'] as String));
      setControllerCep(result['cep'] as String);
    }
    setLoading(false);
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

      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          googleMapApiKey: keyGoogleMap);
      getCep(cep: data.postalCode);
      setLoading(false);
      return true;
    } catch (e) {
      utilServices.showToast(message: "Busque por cep ou digite seu endere??o!");
      setLoading(false);
      return false;
    }
  }

  Future<void> saveAddressDelivery() async {
    final result = await cartRepository.saveAddressDelivery(
        token: authController.user.token!, address: entrega);
    result.when(success: (data) {
      authController.user.idEntrega = data;
      authController.getEnderecoSaved();
      authController.update();
    }, error: (message) {
      utilServices.showToast(message: message, isError: true);
    });
    update();
  }
}

// geocodeAPI: 760857287847265987379x79577
// GoogleAPI: AIzaSyDNQO29-7VwIFwXG8L9oYYD34CrNNcEjws
