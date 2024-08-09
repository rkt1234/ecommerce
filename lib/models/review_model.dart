class ReviewModel {
  final String review;
  final int productId;
  final int customerId;

  ReviewModel(this.review, this.productId, this.customerId) {

  }

   Map<String, dynamic> toJson() {
    Map<String, dynamic> userObject = {
      'review': review,
      'customerId': customerId,
      'productId': productId
    };
    return userObject;
  }
}
