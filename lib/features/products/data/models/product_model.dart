class ProductModel {
  final String id;
  final String name;
  final String title;
  final double price;
  final double discountPrice;
  final String description;
  final String image;
  final String category;
  final String brand;
  final int stock;
  final String status;
  final VendorModel? vendor;

  ProductModel({
    required this.id,
    required this.name,
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.description,
    required this.image,
    required this.category,
    required this.brand,
    required this.stock,
    required this.status,
    this.vendor,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: (json['discountPrice'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      stock: json['stock'] ?? 0,
      status: json['status'] ?? 'Draft',
      vendor: json['user'] != null ? VendorModel.fromJson(json['user']) : null,
    );
  }
}

class VendorModel {
  final String id;
  final String name;
  final String email;
  final String? mobile;
  final String? shopName;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.shopName,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'],
      shopName: json['shopName'],
    );
  }
}
