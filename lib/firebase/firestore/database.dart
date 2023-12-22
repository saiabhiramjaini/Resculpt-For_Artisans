import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseFunctions {
  Future<void> addProductDetails(
    String title,
    String description,
    String material,
    int quantity,
    String quality,
    double length,
    double breadth,
    double height,
    String colour,
    String city,
    double price,
  ) async {
    await FirebaseFirestore.instance.collection('products').add({
      "title": title,
      "description": description,
      "material": material,
      "quantity": quantity,
      "quality": quality,
      "length": length,
      "breadth": breadth,
      "height": height,
      "colour": colour,
      "city": city,
      "timeStamp": Timestamp.now()
    });
  }

  Future<Stream<QuerySnapshot>> getProducts() async {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllExceptZero() async {
    return FirebaseFirestore.instance
        .collection('products')
        .where("quantity", isEqualTo: 0)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getProductsCategoryWise(String category) async {
    return FirebaseFirestore.instance
        .collection('products')
        .where('material', isEqualTo: category)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> userProducts() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    return FirebaseFirestore.instance
        .collection('products')
        .where("email", isEqualTo: email)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getProductsInLocation(String city) async {
    return FirebaseFirestore.instance
        .collection('products')
        .where("city", isEqualTo: city)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getFulfilledRequirements() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    return FirebaseFirestore.instance
        .collection('products')
        .where("email", isEqualTo: email)
        .where("quantity", isEqualTo: 0)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getInnovations() async {
    return FirebaseFirestore.instance.collection('innovations').snapshots();
  }
}
