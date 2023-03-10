import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/models/item_model.dart';
import 'package:dartt_shop/src/page_routes/app_pages.dart';
import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductTile extends StatefulWidget {
  const ProductTile(
      {Key? key, required this.item, required this.cartAnimationMethod})
      : super(key: key);

  final ItemModel item;
  final Function cartAnimationMethod;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  final UtilsServices utilsServices = UtilsServices();
  final controller = Get.find<CartController>();

  IconData tileIcon = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(() {
      tileIcon = Icons.check;
    });

    await Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        tileIcon = Icons.add_shopping_cart_outlined;
      });
    });
  }

  final GlobalKey imageGk = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(PagesRoutes.productRoute, arguments: widget.item);
          },
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: Hero(
                          tag: widget.item.id,
                          child:
                              Image.network(widget.item.imgUrl, key: imageGk))),
                  Text(
                    widget.item.itemName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        utilsServices.priceToCurrency(widget.item.price),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.customSwatchColor),
                      ),
                      Text(
                        '/${widget.item.unit}',
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15), topRight: Radius.circular(20)),
            child: Material(
              child: InkWell(
                onTap: () {
                  switchIcon();
                  controller.addItemToCart(item: widget.item);
                  widget.cartAnimationMethod(imageGk);
                },
                child: Ink(
                  height: 40,
                  width: 35,
                  decoration: BoxDecoration(
                    color: CustomColors.customSwatchColor,
                  ),
                  child: Icon(
                    tileIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
