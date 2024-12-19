class Orders {
  final int id;
  final int totalPrice;
  final int userId;

  Orders({
    required this.id,
    required this.totalPrice,
    required this.userId,
  });

  // Factory constructor for creating an Order instance from JSON
  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      id: json['id'],
      totalPrice: json['totalPrice'],
      userId: json['userId'],
    );
  }
}
