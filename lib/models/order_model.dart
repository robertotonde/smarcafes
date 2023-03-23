class OrderModel {
  String productName;
  String productDescription;
  String productImage;
  int estimatedDelivery;
  int productPrice;
  int quantity;
  String orderStatus;
  String userName;
  String email;
  String phoneNumber;
  String college;
  String location;
  DateTime dateTime;
  String orderStatusDescription;
  String reference;
  bool hasPaid;

  OrderModel(
      {required this.productDescription,
      required this.productImage,
      required this.estimatedDelivery,
      required this.productPrice,
      required this.quantity,
      required this.orderStatus,
      required this.email,
      required this.phoneNumber,
      required this.college,
      required this.location,
      required this.userName,
      required this.dateTime,
      required this.orderStatusDescription,
      required this.hasPaid,
      required this.reference,
      required this.productName});

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        productDescription: map['productDescription'] ?? '',
        productImage: map['productImage'] ?? '',
        productName: map['productName'] ?? '',
        productPrice: map['productPrice'] ?? 0,
        quantity: map['quantity'] ?? 1,
        orderStatus: map['orderStatus'] ?? 'Order Received',
        estimatedDelivery: map['estimatedDelivery'] ?? 5,
        email: map['email'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        userName: map['userName'] ?? '',
        location: map['location'] ?? '',
        orderStatusDescription: map['orderStatusDescription'] ??
            'Your order has been receieved successfully and our team is working on preparing it 👫',
        college: map['college'] ?? '',
        reference: map['reference'] ?? '',
        hasPaid: map['hasPaid'] ?? false,
        dateTime: map['dateTime'].toDate() ?? '');
  }
  Map<String, dynamic> toJson() => {
        'productDescription': productDescription,
        'orderStatus': orderStatus,
        'orderStatusDescription': orderStatusDescription,
        'productImage': productImage,
        'productPrice': productPrice,
        'quantity': quantity,
        'productName': productName,
        'estimatedDelivery': estimatedDelivery,
        'email': email,
        'phoneNumber': phoneNumber,
        'location': location,
        'userName': userName,
        'college': college,
        'dateTime': dateTime,
        'hasPaid': hasPaid,
        'reference': reference,
      };
}



// ORDER RECEIVED
// ORDER COMFIRMED
// ORDER DELIVERING
// ORDER DELIVERED
// ORDER CANCELLED