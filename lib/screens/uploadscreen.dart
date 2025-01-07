import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categories = [
    "otomotive",
    "clothes",
    "electronic",
    "stationary",
    "toys",
    "sports",
    "furniture",
  ];

  String? _selectedCategory;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadProduct() async {
    if (_image == null ||
        _productController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _selectedCategory == null ||
        _addressController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final uri = Uri.parse("http://127.0.0.1:8000/api/items");
    final request = http.MultipartRequest("POST", uri)
      ..fields['item_name'] = _productController.text
      ..fields['uploaded_by'] = _nameController.text
      ..fields['category'] = _selectedCategory!
      ..fields['address'] = _addressController.text
      ..fields['phone_number'] = _phoneNumberController.text
      ..fields['item_description'] = _descriptionController.text
      ..headers['Accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        _image!.path,
      ));

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Product uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      } else {
        print("Response body: ${responseData.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Harap isi nomor HP dengan benar 10-13 digit!",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to upload product: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _productController.clear();
      _nameController.clear();
      _addressController.clear();
      _phoneNumberController.clear();
      _descriptionController.clear();
      _selectedCategory = null;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Product"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image, size: 40),
                          Text("Upload Here"),
                          Text("Max 5MB"),
                          Text("Format jpg, jpeg, png"),
                        ],
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Detail Product",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTextField("Product Name", _productController),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdownField(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Product Description",
              _descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            const Text(
              "Personal Information",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            const SizedBox(height: 10),
            _buildTextField("Name", _nameController),
            const SizedBox(height: 10),
            _buildTextField("Address", _addressController,),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: Container(
                        width: 59,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:Center(
                          child: Text(
                            "+62",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 200,
                          height: 47,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8), 
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,top: 28),
                            child: TextField(
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 13,
                                  decoration: InputDecoration(
                                  hintText: "85123456789",
                                  labelStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.only(top: 2, bottom: 25),
              child: Center(
                child: SizedBox(
                  width: 170,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _uploadProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 35, 149, 151),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Upload Product",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.upload, color: Colors.white
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value),
          ),
        ),
      ],
    );
  }
}
