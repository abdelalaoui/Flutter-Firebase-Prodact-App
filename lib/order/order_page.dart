import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/order/order_model.dart' as local;
import 'package:flutterproject/order/order_controller.dart';
import 'package:get/get.dart';
import 'package:flutterproject/Products/product_controller.dart';
import 'package:flutterproject/Products/product_model.dart';

class OrderPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final OrderController orderController = Get.put(OrderController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an Order'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              local.Order order = orderController.generateOrder();
              await _showOrderDialog(context, order);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: productController.products.length,
                  itemBuilder: (context, index) {
                    Product product = productController.products[index];
                    return InkWell(
                      onTap: () async {
                        int? quantity = await _showQuantityDialog(context);
                        if (quantity != null && quantity > 0) {
                          orderController.addProductToOrder(product, quantity);
                        }
                      },
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text('Price: \$${product.price}'),
                        tileColor: orderController.selectedProducts
                                .containsKey(product)
                            ? Colors.blue[100]
                            : null,
                        selected: orderController.selectedProducts
                            .containsKey(product),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Future<int?> _showQuantityDialog(BuildContext context) async {
    int quantity = 1;

    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Quantity'),
              content: Column(
                children: [
                  Text('Choose the quantity for this product:'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(quantity);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showOrderDialog(BuildContext context, local.Order order) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Summary'),
          content: Column(
            children: [
              Text('Selected Products:'),
              for (Product product in order.products.keys)
                ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    'Price: \$${product.price}, Quantity: ${order.products[product]}',
                  ),
                ),
              SizedBox(height: 10),
              Text('Total: \$${order.total.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                orderController.clearOrder();
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () async {
                await _saveOrderToFirebase(order);
                orderController.clearOrder();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveOrderToFirebase(local.Order order) async {
    try {
      List<Map<String, dynamic>> productsList = [];

      order.products.forEach((product, quantity) {
        productsList.add({
          'product': product.toMap(),
          'quantity': quantity,
        });
      });

      // Obtenez l'utilisateur actuel
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Ajoutez l'ID de l'utilisateur à la commande avant de l'enregistrer
        order.userId = user.uid;

        // Enregistrez la commande dans Firebase
        await _firestore.collection('orders').add({
          ...order.toMap(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Order saved to Firebase: ${order.toString()}');
      } else {
        print('User not logged in. Unable to save order.');
      }
    } catch (e) {
      print('Error saving order to Firebase: $e');
    }
  }
}
