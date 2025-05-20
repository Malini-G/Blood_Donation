import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'donor_page.dart';
import 'blood_bank_page.dart';
import 'general_info_page.dart';
import 'Progress_Page.dart'; // Make sure this filename and class name matches

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = 'User';
  String bloodGroup = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
      bloodGroup = prefs.getString('bloodGroup') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Welcome, $userName',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GeneralInfoPage()),
            );
          } else if (label == 'Events') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProgressPage(), // ✅ FIXED
              ),
            );
          }
          // Add Profile Settings logic if needed
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
