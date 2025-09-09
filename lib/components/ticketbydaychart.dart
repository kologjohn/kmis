import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TicketsByDayChart extends StatelessWidget {
  final double cwidth;
  const TicketsByDayChart({super.key, required this.cwidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cwidth,
      height: 250,
      decoration: BoxDecoration(
        color: Color(0xFF1C1D2A),
        boxShadow: [
          BoxShadow(offset: Offset(0.5, 0.5), spreadRadius: 1, blurRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score Sheet Performance',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 150,
              width: 650,
              child: LineChart(
                LineChartData(
                  backgroundColor: Color(0xFF1C1D2A),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) {
                          final days = [
                            '08/13',
                            '08/14',
                            '08/15',
                            '08/16',
                            '08/17',
                            '08/18',
                            '08/19',
                            '08/20',
                          ];
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: TextStyle(color: Colors.white54, fontSize: 10),
                        ),
                        interval: 2,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.lightBlueAccent,
                      dotData: FlDotData(show: true),
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 2),
                        FlSpot(3, 3),
                        FlSpot(4, 0),
                        FlSpot(5, 0),
                        FlSpot(6, 4),
                        FlSpot(7, 6),
                      ],
                    ),
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.purpleAccent,
                      dotData: FlDotData(show: true),
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2),
                        FlSpot(4, 1),
                        FlSpot(5, 1),
                        FlSpot(6, 6),
                        FlSpot(7, 3),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LegendDot(color: Colors.lightBlueAccent, label: 'Created'),
                SizedBox(width: 20),
                LegendDot(color: Colors.purpleAccent, label: 'Solved'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
