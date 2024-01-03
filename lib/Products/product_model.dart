class Product {
  String? id;
  String name;
  double price;
  int quantity;
  String? image;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
      image: map['image'],
    );
  }
}
