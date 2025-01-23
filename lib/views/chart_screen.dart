import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import '../services/signal_strength.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final List<FlSpot> _spots = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start periodic updates for signal strength
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateSignalStrength();
    });
  }

  Future<void> _updateSignalStrength() async {
    final signalStrength = await SignalStrength.getSignalStrength();
    if (signalStrength != null) {
      setState(() {
        // Add new signal strength data as a point in _spots
        _spots.add(FlSpot(_spots.length.toDouble(), signalStrength.toDouble()));
        // Maintain a fixed number of points (e.g., last 20 data points)
        if (_spots.length > 20) {
          _spots.removeAt(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signal Strength Over Time')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(LineChartData(
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _spots,
              isCurved: true,
              barWidth: 4,
              dotData: FlDotData(show: false),
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
              color: Colors.blue,
            ),
          ],
        )),
      ),
    );
  }
}
