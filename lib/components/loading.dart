import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 6, // number of shimmer placeholders
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.blueGrey,
            highlightColor: Colors.white10,
            child: ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
              ),
              title: Container(
                height: 12,
                width: double.infinity,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 5),
              ),
              subtitle: Container(
                height: 12,
                width: 150,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 5),
              ),
            ),
          );
        },
      ),
    );
  }
}
