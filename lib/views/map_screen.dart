import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef RssiData = ({double time, int rssi});

class RssiChartScreen extends StatefulWidget {
  const RssiChartScreen({super.key});

  @override
  _RssiChartScreenState createState() => _RssiChartScreenState();
}

class _RssiChartScreenState extends State<RssiChartScreen> {
  final List<RssiData> _rssiValues = [];
  late Timer _timer;
  double _timeElapsed = 0;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startFetchingRssi();
  }

  void _startFetchingRssi() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final String result = await const MethodChannel('com.example.mobile/network')
            .invokeMethod('fetchNetworkData');
        print("Result: $result");

        final List<dynamic> jsonData = jsonDecode(result);

        if (jsonData.isNotEmpty) {
          setState(() {
            for (var entry in jsonData) {
              if (entry is Map<String, dynamic> && entry.containsKey('RSSI')) {
                final int rssi = int.tryParse(entry['RSSI'].toString()) ?? -100;
                print("RSSI Value: $rssi");
                _rssiValues.add((time: _timeElapsed, rssi: rssi));
                _timeElapsed += 1;
              }
            }
            if (_rssiValues.length > 50) _rssiValues.removeAt(0);
          });
        } else {
          setState(() => errorMessage = "Invalid data format");
        }
      } on PlatformException catch (e) {
        setState(() => errorMessage = "Error: ${e.message}");
      } on FormatException {
        setState(() => errorMessage = "JSON parsing error");
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSSI Over Time')),
      body: errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : CustomPaint(
        size: Size.infinite,
        painter: RssiPainter(_rssiValues),
      ),
    );
  }
}

class RssiPainter extends CustomPainter {
  final List<RssiData> rssiValues;

  RssiPainter(this.rssiValues);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final Paint textPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final Paint pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double padding = 40;
    final double width = size.width - padding * 2;
    final double height = size.height - padding * 2;

    canvas.drawLine(Offset(padding, padding), Offset(padding, height + padding), axisPaint);
    canvas.drawLine(Offset(padding, height + padding), Offset(width + padding, height + padding), axisPaint);

    if (rssiValues.isEmpty) return;

    final double maxTime = rssiValues.last.time;
    final double minRssi = -130;
    final double maxRssi = -70;

    for (double rssi = minRssi; rssi <= maxRssi; rssi += 10) {
      double y = height + padding - ((rssi - minRssi) / (maxRssi - minRssi)) * height;

      textPainter.text = TextSpan(
        text: rssi.toStringAsFixed(0),
        style: const TextStyle(color: Colors.black, fontSize: 12),
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));

      canvas.drawLine(Offset(padding - 5, y), Offset(padding, y), axisPaint);
    }

    for (double time = 0; time <= maxTime; time += 10) {
      double x = padding + (time / maxTime) * width;

      textPainter.text = TextSpan(
        text: time.toStringAsFixed(0),
        style: const TextStyle(color: Colors.black, fontSize: 12),
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, height + padding + 5));

      canvas.drawLine(Offset(x, height + padding), Offset(x, height + padding + 5), axisPaint);
    }

    final points = rssiValues.map((data) {
      double x = padding + (data.time / maxTime) * width;
      double y = height + padding - ((data.rssi - minRssi) / (maxRssi - minRssi)) * height;
      return Offset(x, y);
    }).toList();

    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    for (var point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
