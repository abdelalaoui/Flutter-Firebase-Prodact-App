import 'package:flutter/material.dart';
import 'package:flutterproject/Products/product_controller.dart';
import 'package:flutterproject/Products/product_model.dart';
import 'package:flutterproject/Products/product_page.dart';
import 'package:flutterproject/order/order_page.dart';
import 'package:flutterproject/order/orders_details.dart';
import 'package:get/get.dart';

class ProductListView extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(ProductPage());
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
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Price: \$${product.price}'),
                      onTap: () {
                        // Implement navigation to product details if needed
                      },
                      onLongPress: () async {
                        // Delete product
                        await productController.deleteProduct(product.id!);
                      },
                    );
                  },
                )),
          ),
        ],
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            // Naviguez vers la page où vous allez créer la commande
            Get.to(OrderPage());
          },
          child: Text('Make Order'),
        ),
        ElevatedButton(
          onPressed: () {
            // Naviguez vers la page où vous allez créer la commande
            Get.to(OrderDetails());
          },
          child: Text(' Orders'),
        ),
      ],
    );
  }
}
