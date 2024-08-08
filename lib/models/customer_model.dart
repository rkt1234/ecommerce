class CustomerModel {
  late String customerName;
  late String password;
  late String email;
  late String address = "";


  CustomerModel(
      {required this.customerName,
      required this.password,
      required this.email,
      required this.address});

  Map<String, String> toJsonRegister() {
    Map<String, String> userObject = {
      'customerName': customerName,
      'password': password,
      'email': email,
      'address': address
    };
    return userObject;
  }}