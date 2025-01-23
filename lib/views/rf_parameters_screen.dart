import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/rf_parameters.dart';

class RFParametersScreen extends StatefulWidget {
  const RFParametersScreen({super.key});

  @override
  _RFParametersScreenState createState() => _RFParametersScreenState();
}

class _RFParametersScreenState extends State<RFParametersScreen> {
  static const platform = MethodChannel('com.example.mobile/cell_info');
  List<RFParameter> rfParameters = [];

  @override
  void initState() {
    super.initState();
    _getRFParameters();
  }

  Future<void> _getRFParameters() async {
    try {
      final Map<String, dynamic> result =
      await platform.invokeMethod('getCellInfo');
      // Assuming the native code returns a map with keys: 'cellId', 'signalStrength', 'networkType'
      setState(() {
        rfParameters = [
          RFParameter(name: 'Signal Strength', value: result['signalStrength']),
          RFParameter(name: 'Network Type', value: result['networkType']),
          RFParameter(name: 'Cell ID', value: result['cellId']),
        ];
      });
    } on PlatformException catch (e) {
      print("Failed to get RF parameters: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RF Parameters')),
      body: ListView.builder(
        itemCount: rfParameters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(rfParameters[index].name),
            subtitle: Text(rfParameters[index].value),
          );
        },
      ),
    );
  }
}
