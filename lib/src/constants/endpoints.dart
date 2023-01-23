const String baseUrl = 'https://parseapi.back4app.com/functions';
const String baseUrlHiper = 'http://ms-ecommerce.hiper.com.br/api/v1';
const String chaveIdHiper =
    '05234bb2b12c65dc3319b9db6540d6d2492f5cea7bd1e550ff11d73e5d4e9b89';
const String baseCep = "https://viacep.com.br/ws/";

abstract class Endpoints {
  static const String signin = '$baseUrl/login';
  static const String signup = '$baseUrl/signup';
  static const String validateToken = '$baseUrl/validate-token';
  static const String resetPassword = '$baseUrl/reset-password';
  static const String getAllCategories = '$baseUrl/get-category-list';
  static const String getAllProducts = '$baseUrl/get-product-list';
  static const String getCartItems = '$baseUrl/get-cart-items';
  static const String addItemToCart = '$baseUrl/add-item-to-cart';
  static const String changeItemQuantity = '$baseUrl/modify-item-quantity';
  static const String checkout = '$baseUrl/checkout-order';
  static const String getAllOrders = '$baseUrl/get-orders';
  static const String getOrderItems = '$baseUrl/get-order-items';
  static const String changePassword = '$baseUrl/change-password';
  static const String getTokenHiper =
      '$baseUrlHiper/auth/gerar-token/$chaveIdHiper';
  static const String getProductsHiper =
      '$baseUrlHiper/produtos/pontoDeSincronizacao';
  static const String postPedidoDeVenda = '$baseUrlHiper/pedido-de-venda/';
  static const String getCep = baseCep;
}
