import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/widgets/bottom_nav.dart';
import 'package:round2/features/app/widgets/loading.dart';
import 'package:round2/firebase/firestore/database.dart';

class UploadRequirement extends StatefulWidget {
  const UploadRequirement({super.key});

  @override
  State<UploadRequirement> createState() => _UploadRequirementState();
}

class _UploadRequirementState extends State<UploadRequirement> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _breadthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _colourController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String? email = FirebaseAuth.instance.currentUser!.email;

  int dropdownCounter = 0;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool uploading = false;
  User? user = FirebaseAuth.instance.currentUser;
  String? value;
  final List<String> materialItems = [
    "Plastic",
    "Glass",
    "Fabric",
    "Wood",
    "Metal",
    "Paper",
    "others",
  ];
  final List<String> selectedUnits = [];

  String city = "";
  Stream? itemsStream;

  @override
  void initState() {
    super.initState();
    _initializeItemsStream();
  }

  void _initializeItemsStream() async {
    String c = await _requestLocationPermission();
    // print(c);
    itemsStream = await DatabaseFunctions().getProductsInLocation(c);
  }

  Future<String> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        city = placemark.locality ?? "";
      } else {
        //error
      }
    } catch (e) {
      //print("Error: $e");
    }
    return city;
  }

  Future<String> _requestLocationPermission() async {
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    String c = await _getCurrentLocation();
    return c;
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    } else {
      // User canceled image selection, handle accordingly
    }
  }

  Future getImageFromCamera() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    } else {
      // User canceled image selection, handle accordingly
    }
  }

  String randomAlphaNumeric(int length) {
    const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(
        length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _heightController.dispose();
    _colourController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void clearImage() {
    setState(() {
      selectedImage = null;
    });
  }

  Future<void> uploadItem() async {
    if (selectedImage != null &&
        _titleController.text.trim() != "" &&
        _descriptionController.text.trim() != "" &&
        _quantityController.text.trim() != "" &&
        _priceController.text.trim() != "") {
      setState(() {
        uploading = true; // Start uploading
      });
      try {
        String addId = randomAlphaNumeric(10);
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("wasteImages").child(addId);
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

        var downloadUrl = await (await task).ref.getDownloadURL();
        double price = double.tryParse(_priceController.text.trim()) ?? 0.0;
        int quantity = int.parse(_quantityController.text.trim());

        if (quantity <= 0) {
          throw "Quantity must be greater than zero.";
        }

        await FirebaseFirestore.instance.collection("products").add(
          {
            "title": _titleController.text.trim(),
            "image": downloadUrl,
            "description": _descriptionController.text.trim(),
            "material": value,
            "quantity": quantity,
            "colour": _colourController.text.trim(),
            "city": city,
            "price": price,
            'email': email,
            "timeStamp": Timestamp.now()
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product Uploaded Successfully"),
          ),
        );
      } catch (e) {
        print(e);
        String errorMessage = "Failed to upload product";
        if (e is String) {
          errorMessage = e;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      } finally {
        setState(() {
          uploading = false; // Stop uploading
        });
      }
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const BottomNav();
                },
              ),
            );
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Requirements Form",
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
                "Upload photo for reference*",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  if (selectedImage != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                            width: 400,
                            height: 400,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // If no image is selected, allow the user to choose one
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImage();
                                },
                                child: const Text(
                                  'Choose from Gallery',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  getImageFromCamera();
                                },
                                child: const Text('Take a Photo',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: Center(
                  child: selectedImage != null
                      ? Container(
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
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Material(
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
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Enter Product details :",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Product Name*",
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
                  controller: _titleController,
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
                height: 20.0,
              ),
              Text(
                "Product Description*",
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
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: materialItems
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
                    hint: const Text("Select Material"),
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
                height: 10.0,
              ),
              Text(
                "Product Quantity (in kgs)*",
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
                    hintText: "Enter product quantity",
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
                "Product Colour",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _colourController,
                  decoration: InputDecoration(
                    hintText: "Enter Product Colour",
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
                "Product Price (per kg)*",
                style: TextStyleWidget.semiBoldTextFieldStyle(),
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
                    hintText: "Enter Product price",
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
              Center(
                child: uploading
                    ? const Loading()
                    : ElevatedButton(
                        onPressed: () {
                          uploadItem();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
