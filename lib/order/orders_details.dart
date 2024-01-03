import 'package:flutter/material.dart';
import 'package:flutterproject/order/order_controller.dart';
import 'package:flutterproject/order/order_model.dart';
import 'package:get/get.dart';

class OrderDetails extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: orderController.orders.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Affiche le texte du nombre d'ordres
                      return ListTile(
                        title: Text(
                            'Number of Orders: ${orderController.orders.length}'),
                      );
                    } else {
                      // Affiche les éléments d'ordre normaux
                      Order order = orderController.orders[index - 1];
                      return ListTile(
                        subtitle:
                            Text('Total: \$${order.total.toStringAsFixed(2)}'),
                        // Ajoutez d'autres informations d'affichage d'ordre si nécessaire
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
