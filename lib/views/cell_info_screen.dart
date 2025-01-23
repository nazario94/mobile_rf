import 'package:flutter/material.dart';
import '../utils/cell_info_channel.dart';
import 'package:permission_handler/permission_handler.dart';

class CellInfoView extends StatefulWidget {
  const CellInfoView({super.key});

  @override
  _CellInfoViewState createState() => _CellInfoViewState();
}

class _CellInfoViewState extends State<CellInfoView> {
  List<Map<String, dynamic>>? cellInfo;

  @override
  void initState() {
    super.initState();
    _getCellInfo();
  }

  Future<void> _getCellInfo() async {
    await Permission.location.request();
    if (await Permission.location.isGranted) {
      cellInfo = await CellInfoChannel.getCellInfo();
      print(cellInfo); // Debugging line
      setState(() {}); // Update the UI
    } else {
      print("Location permission denied.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cell Info"),
        backgroundColor: Colors.blue, // Example color
      ),
      body: cellInfo == null
          ? const Center(child: CircularProgressIndicator())
          : cellInfo!.isEmpty
          ? const Center(child: Text("No cell info available"))
          : ListView.builder(
        itemCount: cellInfo!.length,
        itemBuilder: (context, index) {
          final cell = cellInfo![index];
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
                    subtitle: Text("${cell['type']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text("CGI"),
                    subtitle: Text("${cell['cgi']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.signal_cellular_alt),
                    title: const Text("PSC"),
                    subtitle: Text("${cell['psc']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.perm_identity),
                    title: const Text("CID"),
                    subtitle: Text("${cell['cid']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text("LAC"),
                    subtitle: Text("${cell['lac']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Network ISO"),
                    subtitle: Text("${cell['networkIso']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sim_card),
                    title: const Text("MCC"),
                    subtitle: Text("${cell['mcc']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sim_card_alert),
                    title: const Text("MNC"),
                    subtitle: Text("${cell['mnc']}"),
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
                    leading: const Icon(Icons.error_outline),
                    title: const Text("Bit Error Rate"),
                    subtitle: Text("${cell['bitErrorRate']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4),
                    title: const Text("RSSI"),
                    subtitle: Text("${cell['rssi']}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.numbers),
                    title: const Text("EC No"),
                    subtitle: Text("${cell['ecNo']}"),
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