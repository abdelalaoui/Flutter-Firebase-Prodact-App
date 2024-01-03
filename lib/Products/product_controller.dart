import 'package:flutter/foundation.dart';
import 'package:flutterproject/Products/product_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ProductController extends GetxController {
  RxList<Product> products = <Product>[].obs;

  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Appeler fetchProducts lorsque le contrôleur est initialisé
  }

  Future<void> fetchProducts() async {
    try {
      var snapshot = await productsCollection.get();
      products.value = snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>)..id = doc.id)
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await productsCollection.add(product.toMap());
      await fetchProducts();
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await productsCollection.doc(product.id).update(product.toMap());
      await fetchProducts();
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await productsCollection.doc(productId).delete();
      await fetchProducts();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}
