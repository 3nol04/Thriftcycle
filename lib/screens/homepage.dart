import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thriftcycle/screens/search_screen.dart';
import '../wigedts/listcategory.dart';
import '../wigedts/cardproduct.dart';
import '../service/category.dart';
import '../service/model/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentUsername = 'user1234';
  File? profileImage;
  String productName = "Jersey Manchester United";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _saveProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUsername = prefs.getString('username') ?? 'user1234';
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        profileImage = File(imagePath);
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', currentUsername);
    if (profileImage != null) {
      await prefs.setString('profileImage', profileImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 43),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width*0.85 ,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Image(
                      image: AssetImage("image/logo.png"),
                      height: 60,
                      width: 60,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF2C7C7D),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor:
                                  const Color.fromARGB(255, 255, 255, 255)
                                      .withOpacity(0.9),
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 70,
                                            backgroundImage: profileImage == null
                                                ? const AssetImage(
                                                        "image/Profile_Default.png")
                                                    as ImageProvider
                                                : FileImage(profileImage!),
                                          ),
                                          const SizedBox(height: 30),
                                          Text(
                                            currentUsername,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchScreen(),
                                ));
                          },
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Search",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C7C7D),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Image(
                  image: AssetImage("image/Bar_information.png"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Category",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // TODO: List Category
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ListCategory(category: category);
                        //TODO : List Category
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Product",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //TODO : List Product
                  FutureBuilder<List<Product>>(
                    future: Product.fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Menunggu data dimuat
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("Harapkan periksa koneksi internet"));

                        /// Menampilkan error jika ada
                      } else if (snapshot.hasData) {
                        return SizedBox(
                          height: 400,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 0,
                              childAspectRatio: 0.95,
                            ),
                            itemBuilder: (context, index) {
                              final product = snapshot.data![
                                  index]; // Mengambil data produk dari snapshot
                              return CardProduct(
                                  product:
                                      product); // Mengoper data ke widget CardProduct
                            },
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text(
                                "No data available")); // Jika tidak ada data
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
