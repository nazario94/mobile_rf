import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/signal_strength.dart';

class SignalStrengthScreen extends StatefulWidget {
  @override
  _SignalStrengthScreenState createState() => _SignalStrengthScreenState();
}

class _SignalStrengthScreenState extends State<SignalStrengthScreen> {
  final SignalStrengthService _signalService = SignalStrengthService();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  String _signalStrength = 'Unknown';
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged as Stream<ConnectivityResult>;
    _connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
      _updateSignalStrength();
    });
    _checkConnectivity(); // Initial connectivity check
    _updateSignalStrength(); // Initial signal strength check
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result as ConnectivityResult;
    });
  }

  Future<void> _updateSignalStrength() async {
    try {
      final signal = await _signalService.getSignalStrength();
      setState(() {
        _signalStrength = signal;
      });
    } catch (e) {
      setState(() {
        _signalStrength = 'Error retrieving signal strength';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network and Signal Strength'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Network Connectivity: $_connectivityResult'),
            SizedBox(height: 20),
            Text('Signal Strength: $_signalStrength'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _checkConnectivity();
                _updateSignalStrength();
              },
              child: Text('Check Connectivity and Signal Strength'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
