class Product {
  final String id;
  final String uid;
  final String name;
  final double price;
  final double sellingPrice;
  final String category;
  final String status;
  final String image;

  Product({
    required this.id,
    required this.uid,
    required this.name,
    required this.price,
    required this.sellingPrice,
    required this.category,
    required this.status,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      uid: json['uid'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      category: json['category'],
      status: json['status'],
      image: json['image'],
    );
  }
}
