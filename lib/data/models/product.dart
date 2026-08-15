class Product {
  final int id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: json['price'] as num,
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: json['rating'] != null ? Rating.fromJson(json['rating'] as Map<String, dynamic>) : null,
    );
  }

  Product copyWith({
    int? id,
    String? title,
    num? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating?.toJson(),
    };
  }
}

class Rating {
  final num rate;
  final num count;

  const Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'] as num,
      count: json['count'] as num,
    );
  }

  Rating copyWith({num? rate, num? count}) {
    return Rating(
      rate: rate ?? this.rate,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}
