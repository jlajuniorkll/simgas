import 'package:dartt_shop/src/pages/profile/controller/address_controller.dart';
import 'package:dartt_shop/src/pages/profile/repository/address_repository.dart';
import 'package:get/get.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressRepository>(
      () => AddressRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.put(AddressController(Get.find()));
  }
}
