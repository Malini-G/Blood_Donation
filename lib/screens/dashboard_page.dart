import 'package:flutter/material.dart';
import 'donor_page.dart';
import 'blood_bank_page.dart';
import 'general_info_page.dart';
import 'Progress_Page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Welcome, [UserName]',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildCard(context, Icons.local_hospital, 'Blood Bank'),
            _buildCard(context, Icons.event, 'Events'),
            _buildCard(context, Icons.bloodtype, 'Donors List'),
            _buildCard(context, Icons.info, 'General Info'),
            _buildCard(context, Icons.settings, 'Profile Settings'),
          ],
        ),
      ),
    );
  }

  // Function to build individual cards with context and label-based navigation
  Widget _buildCard(BuildContext context, IconData icon, String label) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: InkWell(
        onTap: () {
          if (label == 'Donors List') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DonorPage()),
            );
          } else if (label == 'Blood Bank') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BloodBankPage()),
            );
          } else if (label == 'General Info') {
            // Navigate to the General Info page when the General Info card is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GeneralInfoPage()),
            );
          } else if (label == 'Events') {
            // Navigate to the Progress Page with donors data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        ProgressPage(donorsData: []), // Pass donors data here
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.red),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
