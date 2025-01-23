import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/rf_data.dart';

class DataVisualizationScreen extends StatelessWidget {
  final List<RFData> rfDataList;

  const DataVisualizationScreen({super.key, required this.rfDataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signal Strength Over Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: rfDataList.length.toDouble() - 1,
            minY: rfDataList.map((data) => data.rssi).reduce((a, b) => a < b ? a : b).toDouble() - 10,
            maxY: rfDataList.map((data) => data.rssi).reduce((a, b) => a > b ? a : b).toDouble() + 10,
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 10),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < rfDataList.length) {
                      // Format timestamp as HH:mm
                      String time = DateFormat.Hm().format(DateTime.parse(rfDataList[index].timestamp));
                      return Text(time, style: const TextStyle(fontSize: 10));
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 10,
              verticalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[300], strokeWidth: 1),
              getDrawingVerticalLine: (value) => FlLine(color: Colors.grey[300], strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: rfDataList.asMap().entries.map((entry) {
                  int index = entry.key;
                  RFData data = entry.value;
                  return FlSpot(index.toDouble(), data.rssi.toDouble());
                }).toList(),
                isCurved: true,
                barWidth: 4,
                color: Colors.blue,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.3),
                      Colors.blue.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
