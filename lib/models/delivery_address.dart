class DeliveryAddressModel {
  String userName;
  String email;
  String phoneNumber;
  String college;
  String location;
  DeliveryAddressModel(
      {required this.email,
      required this.phoneNumber,
      required this.college,
      required this.location,
      required this.userName});

  factory DeliveryAddressModel.fromMap(Map<String, dynamic> map) {
    return DeliveryAddressModel(
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      userName: map['userName'] ?? '',
      location: map['location'] ?? '',
      college: map['college'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        'email': email,
        'phoneNumber': phoneNumber,
        'location': location,
        'userName': userName,
        'college': college,
      };
}
