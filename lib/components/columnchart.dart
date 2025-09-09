import 'package:ksoftsms/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ColumnChart extends StatefulWidget {
  final double cwidth;
  const ColumnChart({super.key, required this.cwidth});

  @override
  State<ColumnChart> createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('votesSummary').where('region', isEqualTo: 'Northern')
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: widget.cwidth,
            height: 400,
            color: const Color(0xFF1C1D2A),
            //child: const Center(child: ShimmerPage()),
          );
        }

        final docs = snapshot.data!.docs;
        final regions = docs.map((doc) => doc['region'] as String? ?? 'Unknown').toList();
        final values = docs.map((doc) => (doc['total'] as int?)?.toDouble() ?? 0.0).toList();
        final List<Color> barColors = List.generate(
          regions.length,
          (_) => Colors.blue,
        );

        return Container(
          width: widget.cwidth,
          height: 400,
          decoration: const BoxDecoration(
            color: Color(0xFF1C1D2A),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.5, 0.5),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Votes By Region',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      maxY: (values.isNotEmpty
                          ? (values.reduce((a, b) => a > b ? a : b) + 2)
                          : 8),
                      minY: 0,
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          axisNameWidget: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Votes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          axisNameSize: 32,
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final idx = value.toInt();
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  idx >= 0 && idx < regions.length
                                      ? regions[idx]
                                      : '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barGroups: List.generate(regions.length, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: values[index],
                              width: 30,
                              color: barColors[index],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                    ),
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
