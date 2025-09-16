import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ksoftsms/controller/statsprovider.dart';

class PriorityDonutChart extends StatelessWidget {
  final double cwidth;
  const PriorityDonutChart({super.key, required this.cwidth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Show placeholder container while waiting for data
          return Container(
            width: cwidth,
            height: 250,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              // boxShadow: const [
              //   BoxShadow(
              //       offset: Offset(0.5, 0.5), spreadRadius: 1, blurRadius: 1),
              // ],
            ),
            child: const Center(
              child: Text(
                "Loading Contestant Data...",
                style: TextStyle(color: Color(0xFF00273a), fontSize: 14),
              ),
            ),
          );
        }

        final dataMap = snapshot.data!;
        final total = dataMap.values.fold<int>(0, (a, b) => a + b);

        // Fixed colors: Red, Yellow, Green
        final List<Color> fixedColors = [
          Colors.red,
          Colors.yellow,
          Colors.green,
        ];

        int colorIndex = 0;
        final List<_PriorityData> data = dataMap.entries.map((e) {
          final color = fixedColors[colorIndex % fixedColors.length];
          colorIndex++;
          return _PriorityData(e.key, e.value, color);
        }).toList();

        return Container(
          width: cwidth,
          height: 250,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1D2A),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0.5, 0.5), spreadRadius: 1, blurRadius: 1),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0),
                child: Text(
                  'Contestants by Level',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SfCircularChart(
                            margin: EdgeInsets.zero,
                            legend: Legend(isVisible: false),
                            series: <DoughnutSeries<_PriorityData, String>>[
                              DoughnutSeries<_PriorityData, String>(
                                dataSource: data,
                                xValueMapper: (_PriorityData d, _) => d.label,
                                yValueMapper: (_PriorityData d, _) => d.value,
                                pointColorMapper: (_PriorityData d, _) =>
                                d.color,
                                radius: '60%',
                                innerRadius: '80%',
                              ),
                            ],
                          ),
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.map((item) {
                          return Padding(
                            padding:  EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: item.color,
                                    shape: BoxShape.rectangle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                FittedBox(
                                  child: Text(
                                    item.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    item.value.toString(),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriorityData {
  final String label;
  final int value;
  final Color color;

  _PriorityData(this.label, this.value, this.color);
}
