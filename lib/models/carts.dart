enum Sweetness {
  zeroPercent(title: "0 %"),
  fiftyPercent(title: "50 %"),
  hundredPercent(title: "100 %");

  const Sweetness({required this.title});
  final String title;

  static Sweetness fromString(String? value) {
    switch (value) {
      case 'zeroPercent':
        return Sweetness.zeroPercent;
      case 'fiftyPercent':
        return Sweetness.fiftyPercent;
      case 'hundredPercent':
        return Sweetness.hundredPercent;
      default:
        return Sweetness.hundredPercent; // Default value
    }
  }
}

class Carts {
  Carts({
    required this.id,
    required this.productId,
    required this.amount,
    required this.productData,
    required this.sweetness,
  });

  final int id;
  final int productId;
  final ProductData productData;
  final int amount;
  final Sweetness sweetness;

  factory Carts.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];

    final productData = ProductData(
      productName: productJson['title'],
      price: productJson['price'],
      productImage: productJson['imagePath'],
    );

    return Carts(
      id: json['id'],
      productId: json['productId'],
      productData: productData,
      amount: json['amount'],
      sweetness: Sweetness.fromString(json['sweetness']),
    );
  }
}

class ProductData {
  final String productName;
  final String productImage;
  final int price;

  ProductData({
    required this.productName,
    required this.productImage,
    required this.price,
  });
}

List<Carts> cartItems = [];
