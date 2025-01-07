import 'package:flutter/material.dart';
import '../screens/detail_product.dart';
import '../service/model/product.dart';

class CardProduct extends StatefulWidget {
  final Product product;

  const CardProduct({super.key, required this.product});

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduct(
              idProduct: widget.product.id,
              product: widget.product,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "http://127.0.0.1:8000/storage/${widget.product.imageUri}",
                width: 300,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: Container(
                      width: 5,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.item.length > 9
                              ? widget.product.item.substring(0, 10) + "..."
                              : widget.product.item,
                          style: const TextStyle(
                            fontFamily: 'Rewals',
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.product.category,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
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