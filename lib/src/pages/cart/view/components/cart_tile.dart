import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/pages/commons/quantity_widget.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartTile extends StatefulWidget {
  const CartTile({Key? key, required this.cartItem}) : super(key: key);

  final CartItemModel cartItem;

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final UtilsServices utilsServices = UtilsServices();
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: widget.cartItem.item?.imgUrl != null
            ? Image.network(
                widget.cartItem.item!.imgUrl,
                height: 60.0,
                width: 60.0,
              )
            : Image.asset(
                'assets/appimages/notimage.png',
                height: 60.0,
                width: 60.0,
              ),
        title: Text(
          widget.cartItem.item?.itemName ?? 'Não enviado',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: QuantityWidget(
          value: widget.cartItem.quantity,
          suffixText: widget.cartItem.item?.unit ?? '0',
          result: (quantity) {
            setState(() {
              controller.changeItemQuantity(
                  item: widget.cartItem, quantity: quantity);
            });
          },
          isRemovable: true,
        ),
        subtitle: Text(
          utilsServices.priceToCurrency(widget.cartItem.totalPrice()),
          style: TextStyle(
              color: CustomColors.customSwatchColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
