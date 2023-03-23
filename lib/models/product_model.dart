class ProductModel {
  String productName;
  String productDescription;
  String productImage;
  int estimatedDelivery;
  int productPrice;
  bool popular;
  ProductModel(
      {required this.productDescription,
      required this.productImage,
      required this.estimatedDelivery,
      required this.productPrice,
      required this.popular,
      required this.productName});

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productDescription: map['productDescription'] ?? '',
      productImage: map['productImage'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice'] ?? 0,
      estimatedDelivery: map['estimatedDelivery'] ?? 5,
      popular: map['popular'] ?? false,
    );
  }
}
