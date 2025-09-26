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
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF047cff).withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            //Icon(Icons.circle_outlined, size: 50,),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    value: 30,
                                    backgroundColor: Color(0xFF047cff).withOpacity(0.2),
                                    color: Color(0xFF047cff),
                                    strokeWidth: 7,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("20,000", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                Text("Total Expected Fees", style: TextStyle(fontSize: 12),)
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
                        child: Row(
                          children: [
                            //Icon(Icons.circle_outlined, size: 50,),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    value: 13000/20000,
                                    backgroundColor: Color(0xFF00b478).withOpacity(0.2),
                                    color: Color(0xFF00b478),
                                    strokeWidth: 7,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("20,000", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                                Text("Total Fees Received", style: TextStyle(fontSize: 12),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFe42557).withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                        SizedBox(height: 10),
                        Text("20,000", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                        Text("Outstanding", style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ),
                )
              ],
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Container(
            //       height: 120,
            //       width: 150,
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(
            //               color: Colors.black12
            //           ),
            //           borderRadius: BorderRadius.all(Radius.circular(6))
            //       ),
            //       child: Center(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(Icons.people_alt, color: Color(0xFF00b377), size: 40),
            //             Text("Total Students", style: TextStyle(fontSize: 13),),
            //             Text("1,200", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
            //           ],
            //         ),
            //       ),
            //     ),
            //     Container(
            //       height: 120,
            //       width: 150,
            //       decoration: BoxDecoration(
            //           color: Color(0xFFe1fef3),
            //           borderRadius: BorderRadius.all(Radius.circular(6))
            //       ),
            //       child: Center(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Text(
            //               "Male vs Female",
            //               style: TextStyle(fontSize: 13),
            //             ),
            //             //const SizedBox(height: 10),
            //             SizedBox(
            //               height: 60,
            //               child: PieChart(
            //                 PieChartData(
            //                   sectionsSpace: 1,
            //                   centerSpaceRadius: 0,
            //                   sections: [
            //                     PieChartSectionData(
            //                       value: male.toDouble(),
            //                       color: Color(0xFF00b377),
            //                       title: male.toString(),
            //                       radius: 30,
            //                       titleStyle: const TextStyle(
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.bold,
            //                           color: Colors.white),
            //                     ),
            //                     PieChartSectionData(
            //                       value: female.toDouble(),
            //                       color: Color(0xFF00d7c4),
            //                       title: female.toString(),
            //                       radius: 20,
            //                       titleStyle: const TextStyle(
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.bold,
            //                           color: Colors.white),
            //                     ),
            //                   ],
            //                 ),
            //                 swapAnimationDuration: const Duration(milliseconds: 1200),
            //                 swapAnimationCurve: Curves.easeOutCubic,
            //               ),
            //             ),
            //             SizedBox(height: 12),
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Row(
            //                   children: [
            //                     Container(
            //                       width: 12,
            //                       height: 12,
            //                       decoration: BoxDecoration(color: Color(0xFF00b377), shape: BoxShape.circle),
            //                     ),
            //                     const SizedBox(width: 6),
            //                     Text(
            //                       "Male",
            //                       style: const TextStyle(fontSize: 12),
            //                     ),
            //                   ],
            //                 ),
            //                 SizedBox(width: 10),
            //                 Row(
            //                   children: [
            //                     Container(
            //                       width: 12,
            //                       height: 12,
            //                       decoration: BoxDecoration(color: Color(0xFF00d7c4), shape: BoxShape.circle),
            //                     ),
            //                     const SizedBox(width: 6),
            //                     Text(
            //                       "Female",
            //                       style: const TextStyle(fontSize: 12),
            //                     ),
            //                   ],
            //                 )
            //               ],
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Text(topcollector.toUpperCase(), style: TextStyle(fontSize: 15,
            //     color: Colors.green,
            //     fontWeight: FontWeight.bold),),
            // SizedBox(height: 50),
            // Center(
            //   child: Text('${0}/${0}', style: TextStyle(
            //       fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFfb7d5b))),
            // ),
          ],
        ),
      ),
    );
  }
}
