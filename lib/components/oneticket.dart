import 'package:ksoftsms/controller/myprovider.dart';
import 'package:ksoftsms/controller/statsprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneTicket extends StatelessWidget {
  final double cwidth;
  final String totalvotes;
  const OneTicket({super.key, required this.cwidth, required this.totalvotes});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsProvider>(
      builder: (BuildContext context,  value, Widget? child) {
        return  Container(
          // constraints: BoxConstraints(
          //   maxWidth:
          //       MediaQuery.of(context).size.width < 600 ? double.infinity : 375,
          // ),
          width: cwidth,
          height: 400,
          decoration: BoxDecoration(
            color: Color(0xFFffffff),
            // boxShadow: [
            //   BoxShadow(offset: Offset(0.5, 0.5), spreadRadius: 1, blurRadius: 1),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Season Total Votes ', style: TextStyle(fontSize: 15, color: Color(0xFF00273a))),
                SizedBox(height: 100.0),
                Center(
                  child: Text(totalvotes,
                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.w700, color: Color(0xFFdc3545)),
                  ),
                ),
                Center(
                  child: Text(
                    '%',
                    style: TextStyle(fontSize: 20, color: Colors.white30),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
