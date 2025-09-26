import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AttendanceTracking extends StatelessWidget {
  final double cwidth;
  const AttendanceTracking({super.key, required this.cwidth});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          final isWide = constraints.maxWidth > 400;
          final chartHeight = isWide ? 80.0 : 60.0;
          final fontSize = isWide ? 16.0 : 14.0;
          final innerPadding = isWide ? 16.0 : 12.0;

          return Container(
            width: 300,
            padding: EdgeInsets.all(innerPadding),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendance Tracking",
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(innerPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Attendance",
                          style: TextStyle(
                              fontSize: fontSize - 2,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: chartHeight,
                        child: Row(
                          children: [
                            // Mini line chart
                            Expanded(
                              flex: 2,
                              child: LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: 4,
                                  minY: 0,
                                  maxY: 5,
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      isCurved: true,
                                      color: Colors.teal,
                                      barWidth: isWide ? 3 : 2,
                                      dotData: FlDotData(show: false),
                                      spots: const [
                                        FlSpot(0, 2),
                                        FlSpot(1, 3),
                                        FlSpot(2, 2.5),
                                        FlSpot(3, 3.5),
                                        FlSpot(4, 4),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: isWide ? 20 : 12),
                            // Mini bar chart
                            Expanded(
                              flex: 1,
                              child: BarChart(
                                BarChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                        SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: [
                                    BarChartGroupData(x: 0, barRods: [
                                      BarChartRodData(
                                        toY: 2,
                                        color: Colors.teal,
                                        width: isWide ? 8 : 6,
                                        borderRadius: BorderRadius.circular(2),
                                      )
                                    ]),
                                    BarChartGroupData(x: 1, barRods: [
                                      BarChartRodData(
                                        toY: 3,
                                        color: Colors.teal,
                                        width: isWide ? 8 : 6,
                                        borderRadius: BorderRadius.circular(2),
                                      )
                                    ]),
                                    BarChartGroupData(x: 2, barRods: [
                                      BarChartRodData(
                                        toY: 4,
                                        color: Colors.teal,
                                        width: isWide ? 8 : 6,
                                        borderRadius: BorderRadius.circular(2),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
