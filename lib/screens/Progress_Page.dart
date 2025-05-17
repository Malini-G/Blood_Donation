import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressPage extends StatelessWidget {
  final List<Map<String, String>> donorsData;

  const ProgressPage({super.key, required this.donorsData});

  @override
  Widget build(BuildContext context) {
    // Count the number of donors for each blood group
    Map<String, int> bloodGroupCount = {};
    for (var donor in donorsData) {
      String bloodGroup = donor['bloodGroup'] ?? 'Unknown';
      if (bloodGroupCount.containsKey(bloodGroup)) {
        bloodGroupCount[bloodGroup] = bloodGroupCount[bloodGroup]! + 1;
      } else {
        bloodGroupCount[bloodGroup] = 1;
      }
    }

    // Calculate the total number of donors
    int totalDonors = donorsData.length;

    // Prepare data for PieChart
    List<PieChartSectionData> pieSections =
        bloodGroupCount.entries.map((entry) {
          String bloodGroup = entry.key;
          int count = entry.value;
          double percentage = totalDonors > 0 ? (count / totalDonors) * 100 : 0;

          return PieChartSectionData(
            value: percentage,
            color: _getBloodGroupColor(bloodGroup),
            title: '$bloodGroup\n${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Group Progress"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Percentage of Donors by Blood Group",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PieChart(
                PieChartData(
                  sections: pieSections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Assign a color for each blood group
  Color _getBloodGroupColor(String bloodGroup) {
    switch (bloodGroup) {
      case 'A+':
        return Colors.red;
      case 'A-':
        return Colors.blue;
      case 'B+':
        return Colors.green;
      case 'B-':
        return Colors.orange;
      case 'AB+':
        return Colors.purple;
      case 'AB-':
        return Colors.yellow;
      case 'O+':
        return Colors.teal;
      case 'O-':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
