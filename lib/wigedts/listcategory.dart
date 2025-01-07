import 'package:flutter/material.dart';
import '../screens/productcategory_screen.dart';
import '../../service/model/category.dart';

class ListCategory extends StatelessWidget {
  final Category category;

  const ListCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductByCategoryScreen(
              category: category.name,
            ),
          ),
        );
      },
      child: Container(
        margin:  EdgeInsets.all(8),
        width: 70,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // Membungkus Column dengan SingleChildScrollView
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, color: const Color(0xFF2C7C7D), size: 30),
              const SizedBox(height: 1),
              Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
