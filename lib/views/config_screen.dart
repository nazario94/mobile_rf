import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool isScreenAwake = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Configuration')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Prevent Screen Sleep'),
            value: isScreenAwake,
            onChanged: (bool value) {
              setState(() {
                isScreenAwake = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Send data online
            },
            child: const Text('Send Data Online'),
          ),
          ElevatedButton(
            onPressed: () {
              // Stop recording in the local database
            },
            child: const Text('Stop Recording'),
          ),
        ],
      ),
    );
  }
}
