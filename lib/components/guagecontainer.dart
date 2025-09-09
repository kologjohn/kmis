import 'package:flutter/material.dart';

import 'chart1.dart';

class GaugeContainer extends StatelessWidget {
  final double cwidth;
  final double reader;
  final double totalval;
  const GaugeContainer({super.key, required this.cwidth, required this.reader, required this.totalval});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      // constraints: BoxConstraints(
      //   maxWidth:
      //       MediaQuery.of(context).size.width < 600 ? double.infinity : 375,
      // ),
      width: cwidth,
      height: 250,
      decoration: BoxDecoration(
        color: Color(0xFF1C1D2A),
        boxShadow: [
          BoxShadow(offset: Offset(0.5, 0.5), spreadRadius: 1, blurRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Results Progress',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Container(
                  color: Colors.white12,
                  child: Text(
                    '7 days',
                    style: TextStyle(fontSize: 10, color: Colors.white30),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Score',
              style: TextStyle(fontSize: 15, color: Colors.white30),
            ),
            SizedBox(height: 50),
            ResponseTimeGauge(value: totalval, reader: reader,),
          ],
        ),
      ),
    );
  }
}
