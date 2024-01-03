import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutterproject/Products/product_model.dart';
import 'package:flutterproject/order/order_model.dart' as local;
import 'package:firebase_auth/firebase_auth.dart';

import 'order_model.dart';

class OrderController extends GetxController {
  RxMap<Product, int> selectedProducts = <Product, int>{}.obs;
  Rx<double> orderTotal = 0.0.obs;
  String userId = "";
  FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Ajoutez la déclaration ici

  RxList<local.Order> orders = <local.Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUserId();
    fetchOrdersFromFirebase();
  }

  void getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  Future<void> fetchOrdersFromFirebase() async {
    try {
      final QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      orders.assignAll(
        ordersSnapshot.docs.map(
          (doc) {
            final data = doc.data() as Map<String, dynamic>;
            final List<Map<String, dynamic>> productsList =
                List<Map<String, dynamic>>.from(data['products']);
            final Map<Product, int> products = {
              for (var item in productsList)
                Product.fromMap(Map<String, dynamic>.from(item['product'])):
                    item['quantity']
            };

            return local.Order(
              userId: data['userId'],
              products: products,
              total: data['total'],
            );
          },
        ),
      );
    } catch (e) {
      print('Error fetching orders from Firebase: $e');
    }
  }

  void addProductToOrder(Product product, int quantity) {
    if (selectedProducts.containsKey(product)) {
      selectedProducts[product] = selectedProducts[product]! + quantity;
    } else {
      selectedProducts[product] = quantity;
    }
    orderTotal += product.price * quantity;
  }

  void removeProductFromOrder(Product product) {
    if (selectedProducts.containsKey(product)) {
      orderTotal -= product.price * selectedProducts[product]!;
      selectedProducts.remove(product);
    }
  }

  void clearOrder() {
    selectedProducts.clear();
    orderTotal.value = 0.0;
  }

  local.Order generateOrder() {
    return local.Order(
      products: Map.from(selectedProducts),
      total: orderTotal.value,
      userId: userId,
    );
  }
}
