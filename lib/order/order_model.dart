// order_model.dart

import 'package:flutterproject/Products/product_model.dart';

class Order {
  String userId;
  Map<Product, int> products;
  double total;

  Order({
    required this.userId,
    required this.products,
    required this.total,
  });

  // Méthode pour convertir l'objet Order en une Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'products': [
        for (var entry in products.entries)
          {'product': entry.key.toMap(), 'quantity': entry.value}
      ],
      'total': total,
    };
  }
}
