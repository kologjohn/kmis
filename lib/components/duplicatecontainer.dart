import 'package:flutter/material.dart';

class DuplicateContainer extends StatelessWidget {
  final String heading;
  final String number;
  final String value;
  final double containerwidth;

  const DuplicateContainer({
    super.key,
    required this.heading,
    required this.number,
    required this.value,
    required this.containerwidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerwidth,
      height: 250,
      decoration: BoxDecoration(
        color: Color(0xFF1C1D2A),
        boxShadow: [
          BoxShadow(offset: Offset(0.5, 0.5), spreadRadius: 1, blurRadius: 0.5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heading, style: TextStyle(fontSize: 18)),
            Center(
              child: Text(
                number,
                style: TextStyle(fontSize: 70, fontWeight: FontWeight.w700),
              ),
            ),
            Center(child: Text(value, style: TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }
}
