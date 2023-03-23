class CartModel {
  String productName;
  String productDescription;
  String productImage;
  int estimatedDelivery;
  int productPrice;
  int quantity;
  CartModel(
      {required this.productDescription,
      required this.productImage,
      required this.estimatedDelivery,
      required this.productPrice,
      required this.quantity,
      required this.productName});

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productDescription: map['productDescription'] ?? '',
      productImage: map['productImage'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: map['productPrice'] ?? 0,
      quantity: map['quantity'] ?? 1,
      estimatedDelivery: map['estimatedDelivery'] ?? 5,
    );
  }
  Map<String, dynamic> toJson() => {
        'productDescription': productDescription,
        'productImage': productImage,
        'productPrice': productPrice,
        'quantity': quantity,
        'productName': productName,
        'estimatedDelivery': estimatedDelivery,
      };
}
