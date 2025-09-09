import 'package:ksoftsms/controller/myprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HourMinutes extends StatelessWidget {
  final double cwidth;
  final String topcollector;

  const HourMinutes(
      {super.key, required this.cwidth, required this.topcollector});

  @override
  Widget build(BuildContext context) {
    return Consumer<Myprovider>(
      builder: (context, value, child) {
        return Container(
          width: cwidth,
          height: 250,
          decoration: BoxDecoration(
            color: Color(0xFF1C1D2A),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.5, 0.5), spreadRadius: 1, blurRadius: 1),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Evicted', style: TextStyle(fontSize: 15)),
                Text(topcollector.toUpperCase(), style: TextStyle(fontSize: 15,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: 50),
                Center(
                  child: Text('${value.evictedCount}/${value.totalcontestants}', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        );
      },);
  }
}