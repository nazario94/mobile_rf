import 'package:flutter/material.dart';
import '../services/data_collector.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RF Drive Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await DataCollector.collectData();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Data Collected"))
                );
              },
              child: const Text('Collect Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              },
              child: const Text('View Map'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/charts');
              },
              child: const Text('View Charts'),
            ),
          ],
        ),
      ),
    );
  }
}
