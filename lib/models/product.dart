enum Category { coffee, nonCoffee }

extension CategoryExtension on Category {
  static Category fromString(String category) {
    switch (category.toLowerCase()) {
      case 'coffee':
        return Category.coffee;
      case 'noncoffee':
        return Category.nonCoffee;
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }
}

class Product {
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.imagePath,
    this.description,
    this.isRecommended = false,
  });

  int id;
  String title;
  int price;
  Category category;
  String imagePath;
  String? description;
  bool isRecommended;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        title: json['title'],
        imagePath: json['imagePath'],
        price: json['price'], // Ensure the price is a double
        category: CategoryExtension.fromString(json['category']),
        description: json['description'],
        isRecommended: json['isRecommended']);
  }
}

// List<Product> data = [
//   Product(
//       id: 1,
//       title: "Latte",
//       price: 120,
//       category: Category.coffee,
//       imagePath: 'assets/images/latte.png',
//       description:
//           "Creamy espresso blended with steamed milk, creating a smooth, rich flavor with a delicate layer of foam. Perfect for a cozy morning or midday pick-me-up.",
//       isRecommended: true),
//   Product(
//       id: 2,
//       title: "Choco Shake",
//       price: 150,
//       category: Category.nonCoffee,
//       imagePath: 'assets/images/chocolate-drink.png',
//       description:
//           "Decadent, creamy chocolate blended into a velvety shake. Sweet, indulgent, and refreshing, it’s the ultimate treat for chocolate lovers craving a delightful dessert drink.",
//       isRecommended: true),
//   Product(
//       id: 3,
//       title: "Tea Cup",
//       price: 80,
//       category: Category.nonCoffee,
//       imagePath: 'assets/images/tea-cup.png',
//       description:
//           "A warm, comforting cup of aromatic tea, steeped to perfection. Delicate flavors and soothing essence, ideal for moments of relaxation or a refreshing energy boost",
//       isRecommended: true),
//   Product(
//       id: 4,
//       title: "Hot Cocoa",
//       price: 75,
//       category: Category.nonCoffee,
//       imagePath: 'assets/images/hot-cocoa.png',
//       description:
//           "Rich, chocolatey warmth in every sip. Topped with whipped cream or marshmallows, this comforting drink is the ultimate treat on a chilly day.",
//       isRecommended: true),
//   Product(
//       id: 5,
//       title: "Milk Shake",
//       price: 165,
//       category: Category.nonCoffee,
//       imagePath: 'assets/images/milkshake.png',
//       description:
//           "Cool, creamy delight with your favorite flavors blended into a frothy, irresistible shake. Sweet and refreshing, it’s a timeless treat for any occasion.",
//       isRecommended: true),
// ];
