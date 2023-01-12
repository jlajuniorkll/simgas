import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/pages/commons/payment_dialog.dart';
import 'package:dartt_shop/src/pages/orders/controller/order_controller.dart';
import 'package:dartt_shop/src/pages/orders/view/components/order_statuswidget.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTile extends StatelessWidget {
  OrderTile({Key? key, required this.order}) : super(key: key);

  final OrderModel order;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: GetBuilder<OrderController>(
            init: OrderController(order),
            global: false,
            builder: (controller) {
              return ExpansionTile(
                onExpansionChanged: (value) {
                  if (value && order.items.isEmpty) {
                    controller.getOrderItems();
                  }
                },
                // initiallyExpanded: order.status == "pending_payment",
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Pedido: ${order.id}'),
                    Text(
                      utilsServices.formateDateTime(order.createdDateTime!),
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.black),
                    )
                  ],
                ),
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: controller.isLoading
                    ? [
                        Container(
                          height: 80,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      ]
                    : [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    height: 150,
                                    child: ListView(
                                      children: controller.order.items
                                          .map((orderItem) {
                                        return _OrderItemWidget(
                                          utilsServices: utilsServices,
                                          orderItem: orderItem,
                                        );
                                      }).toList(),
                                    ),
                                  )),
                              VerticalDivider(
                                color: CustomColors.customSwatchColor,
                                thickness: 1.5,
                                width: 8,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: OrderStatusWidget(
                                    status: order.status,
                                    isOverDue: order.isOverDue,
                                  )),
                            ],
                          ),
                        ),
                        Text.rich(TextSpan(
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            children: [
                              const TextSpan(
                                  text: "Total: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: utilsServices
                                      .priceToCurrency(order.doubleTotal))
                            ])),
                        Visibility(
                          visible: order.status == "pending_payment" &&
                              !order.isOverDue,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: ((_) {
                                      return PaymentDialog(
                                        order: order,
                                      );
                                    }));
                              },
                              icon: Image.asset(
                                'assets/appimages/pix.png',
                                height: 18,
                                filterQuality: FilterQuality.high,
                              ),
                              label: const Text("Ver QRCode Pix")),
                        )
                      ],
              );
            },
          )),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  const _OrderItemWidget({
    Key? key,
    required this.utilsServices,
    required this.orderItem,
  }) : super(key: key);

  final UtilsServices utilsServices;
  final CartItemModel orderItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            '${orderItem.quantity} ${orderItem.item?.unit} ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: Text(orderItem.item?.itemName ??
                  'Erro! Entre em contato com a loja!')),
          Text(utilsServices.priceToCurrency(orderItem.totalPrice())),
        ],
      ),
    );
  }
}
