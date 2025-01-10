import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thriftcycle/service/model/product.dart';
import 'package:thriftcycle/wigedts/searchwiget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";

  /// ✅ Update search results based on item name
  Future<List<Product>> searchProducts(String query) async {
    final String url = 'https://api-db-beta.vercel.app/api/api/items';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final List<dynamic> productsJson = data['data'];
        final filteredProducts = productsJson.where((product) {
          final itemName = product['item_name']?.toString().toLowerCase() ?? '';
          return itemName.contains(query.toLowerCase());
        }).toList();
        return filteredProducts.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          children: [
            // ✅ Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: "Search for items...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (searchQuery.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "What do you want to look for?",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            if (searchQuery.isNotEmpty)
              FutureBuilder<List<Product>>(
                future: searchProducts(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Harap periksa koneksi internet"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final items = snapshot.data!;
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final product = items[index];
                          return SearchWidget(products: product);
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
