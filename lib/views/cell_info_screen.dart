import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/cell_info_channel.dart';
import 'package:permission_handler/permission_handler.dart';

class CellInfoView extends StatefulWidget {

  @override
  _CellInfoViewState createState() => _CellInfoViewState();
}

class _CellInfoViewState extends State<CellInfoView> {
  static const platform = MethodChannel('com.example.mobile/network');
  List<Map<String, dynamic>> networkData = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getCellInfo();
  }

  Future<void> getCellInfo() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      fetchNetworkData();
    } else {
      setState(() => errorMessage = "Permission denied");
    }
  }

  Future<void> fetchNetworkData() async {
    setState(() => isLoading = true);
    try {
      final String result = await platform.invokeMethod('fetchNetworkData');
      print("Result================================: $result");
      if (result != "No cell info available") {
        List<dynamic> data = jsonDecode(result);
        print("Data================================: $data");
        setState(() => networkData = List<Map<String, dynamic>>.from(data));
      } else {
        setState(() => errorMessage = "No network data found");
      }
    } on PlatformException catch (e) {
      setState(() => errorMessage = "Error: ${e.message}");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Info"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty

          ? Center(child: Text(errorMessage))
            : ListView.builder(
        itemCount: networkData.length,
        itemBuilder: (context, index) {
          final cell = networkData[index];
          print("Cell================================: $cell");
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone_android),
                    title: const Text("Type"),
                    subtitle: Text("${cell['Type']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.perm_identity),
                    title: const Text("CID"),
                    subtitle: Text("${cell['CID']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text("LAC"),
                    subtitle: Text("${cell['LAC']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Network ISO"),
                    subtitle: Text("${cell['networkIso']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sim_card),
                    title: const Text("MCC"),
                    subtitle: Text("${cell['MCC']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sim_card_alert),
                    title: const Text("MNC"),
                    subtitle: Text("${cell['MNC']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.network_cell),
                    title: const Text("Band GSM Name"),
                    subtitle: Text("${cell['bandGSMName']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.arrow_downward),
                    title: const Text("Downlink UARFCN"),
                    subtitle: Text("${cell['downlinkUarfcn']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.confirmation_number),
                    title: const Text("Cell Number"),
                    subtitle: Text("${cell['cellNumber']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4),
                    title: const Text("RSSI"),
                    subtitle: Text("${cell['RSSI']}"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}