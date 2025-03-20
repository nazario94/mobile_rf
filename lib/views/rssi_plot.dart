import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RssiPlotScreen extends StatefulWidget {
  final List<double> rssiValues; // Pass RSSI values from the CellInfo screen

  const RssiPlotScreen({super.key, required this.rssiValues});

  @override
  _RssiPlotScreenState createState() => _RssiPlotScreenState();
}

class _RssiPlotScreenState extends State<RssiPlotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSSI Plot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}'); // X-axis labels (time or index)
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()} dBm'); // Y-axis labels (RSSI values)
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: widget.rssiValues
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                    .toList(),
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}