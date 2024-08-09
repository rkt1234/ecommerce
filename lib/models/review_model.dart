class ReviewModel {
  final String review;
  final int productId;
  final int customerId;
  final String customerName;

  ReviewModel(this.review, this.productId, this.customerId, this.customerName) {

  }

   Map<String, dynamic> toJson() {
    Map<String, dynamic> userObject = {
      'review': review,
      'customerId': customerId,
      'productId': productId,
      'customerName':customerName
    };
    return userObject;
  }
}
