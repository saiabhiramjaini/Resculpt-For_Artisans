import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/widgets/loading.dart';
import 'package:round2/features/app/widgets/payment.dart';
import 'package:round2/firebase/firestore/database.dart';

class RequirementFulfilledScreen extends StatefulWidget {
  const RequirementFulfilledScreen({super.key});

  @override
  State<RequirementFulfilledScreen> createState() =>
      _RequirementFulfilledScreenState();
}

class _RequirementFulfilledScreenState
    extends State<RequirementFulfilledScreen> {
  Stream? itemStream;

  String uname = '';

  onTheLoad() async {
    itemStream = await DatabaseFunctions().getFulfilledRequirements();
    retrieveUname();
  }

  Future<void> retrieveUname() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    try {
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (userDocs.docs.isNotEmpty) {
        String retrievedUname = userDocs.docs[0]['uname'];

        setState(() {
          uname = retrievedUname;
        });
      }
    } catch (e) {
      //print("Error retrieving data: $e");
    }
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Widget allItemsVertically() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.6,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: itemStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return const Center(child: Text('No items available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    ds['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds['title'],
                                      style:
                                          TextStyleWidget.boldTextFieldStyle(),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Text(
                                        ds['description'],
                                        style: TextStyleWidget
                                            .lightTextFieldStyle(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Price : ",
                                          style: TextStyleWidget
                                              .semiBoldTextFieldStyle(),
                                        ),
                                        Text(
                                          ds['price'].toString(),
                                          style: TextStyleWidget
                                              .lightHeadingTextFieldStyle(),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 50),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PaymentScreen(
                                              amount: ds['price'],
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
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
      body: allItemsVertically(),
    );
  }
}
