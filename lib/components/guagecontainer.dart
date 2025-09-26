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
      width: cwidth,
      height: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('School Finance Information', style: TextStyle(fontSize: 18, color: Color(0xFF00496d))),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF047cff).withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                value: 30,
                                backgroundColor: Color(0xFF047cff).withOpacity(0.2),
                                color: Color(0xFF047cff),
                                strokeWidth: 6,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("20,000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("Total Expected Fees", style: TextStyle(fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF00b478).withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                value: 13000/20000,
                                backgroundColor: Color(0xFF00b478).withOpacity(0.2),
                                color: Color(0xFF00b478),
                                strokeWidth: 6,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text("13,000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            Text("Total Fees Received", style: TextStyle(fontSize: 12),)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFe42557).withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            value: 7000/20000,
                            backgroundColor: Color(0xFFe42557).withOpacity(0.2),
                            color: Color(0xFFe42557),
                            strokeWidth: 7,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("7,000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text("Outstanding balances", style: TextStyle(fontSize: 12),)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
