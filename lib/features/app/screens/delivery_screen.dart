import 'package:flutter/material.dart';
import 'package:round2/constants/styles/text_widget.dart';
import 'package:round2/features/app/widgets/bottom_nav.dart';
import 'package:round2/features/app/widgets/my_timeline_tile.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});
  @override
  State<DeliveryScreen> createState() {
    return _DeliveryScreenState();
  }
}

class _DeliveryScreenState extends State<DeliveryScreen> {
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
          "Order",
          style: TextStyleWidget.headLineTextFieldStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView(
          children: [
            MyTimeLineTile(
              isFirst: true,
              isLast: false,
              isPast: true,
              eventCard: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text("Order Received",
                    style: TextStyleWidget.semiBoldTextFieldStyle()),
              ),
            ),
            const MyTimeLineTile(
              isFirst: false,
              isLast: false,
              isPast: true,
              eventCard: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  "Order Shipped",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            MyTimeLineTile(
              isFirst: false,
              isLast: true,
              isPast: false,
              eventCard: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text("Order Delivered",
                    style: TextStyleWidget.semiBoldTextFieldStyle()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1.0, right: 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  const Text(
                    'Your Order Will Be Delivered in 3-5 Days',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const BottomNav();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
