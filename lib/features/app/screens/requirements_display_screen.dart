import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/widgets/payment.dart';

class RequirementsDisplayScreen extends StatefulWidget {
  const RequirementsDisplayScreen({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.dimensions,
    required this.colour,
    required this.category,
    required this.quantity,
    required this.price,
  });
  final String image;
  final String name;
  final String description;
  final List<dynamic> dimensions;
  final String colour;
  final String category;
  final int quantity;
  final double price;
  @override
  State<RequirementsDisplayScreen> createState() =>
      _RequirementsDisplayScreenState();
}

class _RequirementsDisplayScreenState extends State<RequirementsDisplayScreen> {
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
                fit: BoxFit.cover,
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
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: _showImageDialog, // Show enlarged image on tap
              child: Container(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.image,
                      width: 320,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(widget.name,
                    style: TextStyleWidget.headLineTextFieldStyle()),
                const Spacer(),
                const Icon(
                  Icons.currency_rupee,
                ),
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
            SizedBox(
              width: 350,
              child: Text(
                widget.description,
                style: TextStyleWidget.lightHeadingTextFieldStyle(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.dimensions.isEmpty
                  ? [
                      Row(
                        children: [
                          Text(
                            'Dimensions: ',
                            style: TextStyleWidget.semiBoldTextFieldStyle(),
                          ),
                          Text(
                            'NE',
                            style: TextStyleWidget.lightHeadingTextFieldStyle(),
                          ),
                        ],
                      ),
                    ]
                  : List.generate(
                      widget.dimensions.length,
                      (index) {
                        final dimension = widget.dimensions[index];
                        final dimensionName = dimension['fieldName'];
                        final dimensionValue = dimension['fieldValue'];

                        return Row(
                          children: [
                            Text(
                              'Dimensions',
                              style: TextStyleWidget.semiBoldTextFieldStyle(),
                            ),
                            Text(
                              '$dimensionName:',
                              style: TextStyleWidget.semiBoldTextFieldStyle(),
                            ),
                            Text(
                              '$dimensionValue cm',
                              style:
                                  TextStyleWidget.lightHeadingTextFieldStyle(),
                            ),
                          ],
                        );
                      },
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
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PaymentScreen(
                      amount: widget.price,
                      title: 'Resculpt',
                    );
                  }));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: const Text("pay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
