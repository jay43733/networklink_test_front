enum Sweetness {
  zeroPercent(title: "0 %"),
  fiftyPercent(title: "50 %"),
  hundredPercent(title: "100 %");

  const Sweetness({required this.title});
  final String title;
}

class Carts {
  static int _lastId = 0;

  Carts(
      {required this.productId,
      required this.productName,
      required this.productImage,
      required this.price,
      required this.amount,
      required this.sweetness})
      : id = _generateId();

  final int id;
  int productId;
  String productName;
  String productImage;
  int price;
  int amount;
  Sweetness sweetness;

  static int _generateId() {
    return ++_lastId;
  }
}

List<Carts> cartItems = [];
