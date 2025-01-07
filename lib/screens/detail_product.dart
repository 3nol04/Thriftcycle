import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thriftcycle/wigedts/detaiview.dart';
import '../service/model/product.dart';

class DetailProduct extends StatefulWidget {
  final int idProduct;
  const DetailProduct({super.key, required this.idProduct, required Product product});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

 Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'favorite_${widget.idProduct}';
    setState(() {
      isFavorite = prefs.getBool(key) ?? false;
    });
  }

  

Future<void> _toggleFavorite() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = 'favorite_${widget.idProduct}';

  setState(() {
    isFavorite = !isFavorite;
  });

  // Simpan status favorit ke SharedPreferences
  await prefs.setBool(key, isFavorite);

  // Jika produk tidak lagi favorit, hapus dari daftar favorit SharedPreferences
  if (!isFavorite) {
    // Hapus produk dari SharedPreferences jika tidak difavoritkan
    prefs.remove(key);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<Product>(
          future: Product.getProduct(widget.idProduct),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi kesalahan: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final product = snapshot.data!;
              return Hero( tag: product.id, child: Detailview(product: product));
            } else {
              return const Center(
                child: Text('Data tidak ditemukan.'),
              );
            }
          },
        ),
      ),
    );
  }
}