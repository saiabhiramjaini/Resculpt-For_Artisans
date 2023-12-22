import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/screens/contributor_details_screen.dart';
import 'package:round2/features/app/widgets/bottom_nav.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.image,
    required this.name,
    required this.description,
    required this.colour,
    required this.category,
    required this.quantity,
    required this.price,
  }) : super(key: key);

  final String image;
  final String name;
  final String description;
  final String colour;
  final String category;
  final int quantity;
  final double price;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int count = 1;
  String? email = FirebaseAuth.instance.currentUser?.email;

  Future<void> _showImageDialog() async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Adjust the height as needed
            child: Center(
              child: Image.network(
                widget.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
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
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showImageDialog,
                  child: Container(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.image,
                          width: 320,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(widget.name,
                        style: TextStyleWidget.headLineTextFieldStyle()),
                    const Spacer(),
                    const Icon(Icons.currency_rupee),
                    Text(
                      widget.price.toString(),
                      style: TextStyleWidget.headLineTextFieldStyle(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Description : ",
                  style: TextStyleWidget.semiBoldTextFieldStyle(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  child: Text(
                    widget.description,
                    style: TextStyleWidget.lightHeadingTextFieldStyle(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Colour : ",
                      style: TextStyleWidget.semiBoldTextFieldStyle(),
                    ),
                    Text(
                      widget.colour,
                      style: TextStyleWidget.lightHeadingTextFieldStyle(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Item made of : ",
                      style: TextStyleWidget.semiBoldTextFieldStyle(),
                    ),
                    Text(
                      widget.category,
                      style: TextStyleWidget.lightHeadingTextFieldStyle(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      widget.quantity.toString(),
                      style: TextStyleWidget.semiBoldTextFieldStyle(),
                    ),
                    Text(
                      ' in kgs required',
                      style: TextStyleWidget.lightHeadingTextFieldStyle(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
            return ContributorDetailsScreen(
              description: widget.description,
            );
          })));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        child: const Text(
          'Want to Contribute?',
        ),
      ),
    );
  }
}
