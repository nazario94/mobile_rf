import 'package:flutter/material.dart';
import 'cell_info_screen.dart';
import 'data_visualization_screen.dart';
import 'chart_screen.dart';
import 'rf_parameters_screen.dart';
import 'signal_strength_screen.dart';
import 'map_screen.dart';
import 'config_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile RF Drive Test Dashboard'),
        backgroundColor: Colors.indigo
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2, // Adjust aspect ratio for more space
        children: [
          _buildDashboardItem(context, 'RF Parameters', Icons.network_check, RFParametersScreen()),
          _buildDashboardItem(context, 'Signal Strength', Icons.signal_cellular_alt, SignalStrengthScreen()),
          _buildDashboardItem(context, 'RSSI Heatmap', Icons.map, const MapScreen()),
          _buildDashboardItem(context, 'Cellular Data', Icons.cell_tower, const CellInfoView()),
          _buildDashboardItem(context, 'App Config', Icons.settings, const ConfigScreen()),
          _buildDashboardItem(context, 'Chart Screen', Icons.chat, const ChartScreen())
        ],
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Card(
        elevation: 4, // Add elevation
        margin: const EdgeInsets.all(24.0), // Increase padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Open Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}