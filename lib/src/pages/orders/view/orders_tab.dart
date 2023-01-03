import 'package:dartt_shop/src/pages/orders/controller/orders_controller.dart';
import 'package:dartt_shop/src/pages/orders/view/components/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pedidos"),
        ),
        body: GetBuilder<AllOrdersController>(
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: () => controller.getAllOrders(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) => OrderTile(
                  order: controller.allOrders[index],
                ),
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemCount: controller.allOrders.length,
              ),
            );
          },
        ));
  }
}
