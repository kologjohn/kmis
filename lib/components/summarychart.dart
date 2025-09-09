import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SummaryDonutChart extends StatelessWidget {
  final double cwidth;
  const SummaryDonutChart({super.key, required this.cwidth});

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
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judging Progress', style: TextStyle(fontSize: 15)),
              Center(
                child: CircularPercentIndicator(
                  radius: 70.0,
                  lineWidth: 10.0,
                  percent: 0.7,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey.shade900,
                  progressColor: Colors.blueAccent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "70%",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "of 100%",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade900),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SummaryItem(label: "Cal", value: "305"),
                    SummaryItem(label: "Steps", value: "10983"),
                    SummaryItem(label: "Distance", value: "7km"),
                    SummaryItem(label: "Sleep", value: "7hr"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const SummaryItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 10)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
