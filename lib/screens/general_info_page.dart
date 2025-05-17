import 'package:flutter/material.dart';

class GeneralInfoPage extends StatelessWidget {
  const GeneralInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("General Information"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSection(
              title: 'Who Can Donate Blood?',
              content:
                  'Anyone who is healthy and meets the following criteria can donate blood:\n'
                  '1. Age: Between 17 and 65 years old.\n'
                  '2. Weight: At least 110 pounds (50kg).\n'
                  '3. Healthy: Must be in good health and free from infections.\n'
                  '4. No high-risk behavior: Should not have engaged in risky sexual behavior or shared needles.\n'
                  '5. Interval: You must wait at least 56 days before donating again.\n',
            ),
            _buildSection(
              title: 'Pros of Blood Donation:',
              content:
                  '1. Saves Lives: Each donation can save up to 3 lives.\n'
                  '2. Health Benefits: Donating blood can help reduce iron levels and reduce the risk of heart disease.\n'
                  '3. Emotional Satisfaction: Blood donors experience emotional satisfaction from knowing they have helped others.\n'
                  '4. Helps in Medical Treatments: Donated blood is crucial for surgeries, trauma patients, cancer patients, and more.\n',
            ),
            _buildSection(
              title: 'Who Should Not Donate Blood?',
              content:
                  'You should not donate blood if:\n'
                  '1. You are feeling unwell or sick, such as with a cold, flu, or any infections.\n'
                  '2. You are pregnant or have recently given birth.\n'
                  '3. You have consumed alcohol or drugs in the last 24 hours.\n'
                  '4. You have high-risk behaviors, such as intravenous drug use or multiple sexual partners.\n'
                  '5. You are underweight or have certain medical conditions that prevent donation (check with your doctor).\n',
            ),
            _buildSection(
              title: 'Precautions After Donating Blood:',
              content:
                  '1. Rest for a few minutes after donation to avoid dizziness.\n'
                  '2. Drink plenty of water and have a light snack.\n'
                  '3. Avoid strenuous activity or heavy lifting for 24 hours.\n'
                  '4. Do not consume alcohol immediately after donation.\n',
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each section with ExpansionTile
  Widget _buildSection({required String title, required String content}) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(content, style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
