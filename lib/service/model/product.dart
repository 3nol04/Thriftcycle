import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String item;
  final String description;
  final String phoneNumber;
  final String imageUri;
  final String address;
  final String category;
  final String uploadBy;
  bool isFavorite;

  Product({
    required this.id,
    required this.item,
    required this.description,
    required this.phoneNumber,
    required this.imageUri,
    required this.address,
    required this.category,
    required this.uploadBy,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      item: json['item_name'],
      description: json['item_description'],
      phoneNumber: json['phone_number'],
      imageUri: json['image_url'],
      address: json['address'],
      category: json['category'],
      uploadBy: json['uploaded_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item,
      'description': description,
      'phoneNumber': phoneNumber,
      'imageUri': imageUri,
      'address': address,
      'category': category,
      'uploadBy': uploadBy,
    };
  }

  static Future<List<Product>> fetchProducts() async {
    //gunakan url dari server misal menggunak android studio emulator gunakan ip 10.0.2.2
    //conto: "http://10.0.2.2:8000/storage/${widget.product.imageUri}"
    //jika menggunakan device fisik gunakan ip sesuai dengan ip yang digunakan
    //contoh: "http://127.0.0.1:8000/storage/${widget.product.imageUri}"
    const url = 'https://api-db-beta.vercel.app/api/api/items';
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['success'] == true) {
      final List<dynamic> productsJson = data['data'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }


  static Future<Product> getProduct(int productId) async {
    final url = 'https://api-db-beta.vercel.app/api/api/items/$productId';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (data['success'] == true) {
      return Product.fromJson(data['data']); // Konversi Map ke Product
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  
}
