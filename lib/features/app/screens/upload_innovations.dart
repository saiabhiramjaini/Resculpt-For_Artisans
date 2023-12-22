import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:round2/constants/styles/text_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool uploading = false;

  String? value;
  final List<String> items = [
    "Plastic",
    "Glass",
    "Fabric",
    "Wood",
    "Cardboard",
    "Metal",
    "Others",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  String randomAlphaNumeric(int length) {
    const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(
        length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  uploadItem() async {
    if (selectedImage != null &&
        _nameController.text.trim() != "" &&
        _descriptionController.text.trim() != "" &&
        _quantityController.text.trim() != "" &&
        _priceController.text.trim() != "") {
      setState(() {
        uploading = true; // Start uploading
      });
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("innovationImages").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();

      // Convert price and quantity to double
      double price = double.tryParse(_priceController.text.trim()) ?? 0.0;
      double quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;

      // Get current timestamp

      await FirebaseFirestore.instance.collection("innovations").add(
        {
          "image": downloadUrl,
          "name": _nameController.text.trim(),
          "description": _descriptionController.text.trim(),
          "price": price,
          "quantity": quantity,
          "category": value, // Assuming value is the selected category
          "timestamp": FieldValue.serverTimestamp(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product Uploaded Successfully at Market place"),
        ),
      );
    } else {
      // Display a message indicating which input is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all the required fields."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Product",
          style: TextStyleWidget.headLineTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Product details",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Product Name",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter product name",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Product Description",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Enter Product Description",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Product Price",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: "Enter Product Price",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Product Quantity",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    hintText: "Enter Product Quantity",
                    hintStyle: TextStyleWidget.lightTextFieldStyle(),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Product Category",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style:
                                  TextStyleWidget.subHeadLineTextFieldStyle(),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    uploadItem();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    fixedSize: const Size(150, 50),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
