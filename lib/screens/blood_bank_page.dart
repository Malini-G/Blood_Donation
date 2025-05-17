import 'package:flutter/material.dart';

class BloodBankPage extends StatelessWidget {
  const BloodBankPage({super.key});

  final List<Map<String, String>> bloodBanks = const [
    {
      'name': 'Chennai Blood Bank',
      'address': '123 Main Street, Chennai',
      'nearby': 'Near Anna Nagar',
      'phone': '9876543210',
    },
    {
      'name': 'Coimbatore Blood Center',
      'address': '456 Gandhi Rd, Coimbatore',
      'nearby': 'Near Peelamedu',
      'phone': '8765432109',
    },
    {
      'name': 'Madurai Blood Bank',
      'address': '789 Anna Nagar, Madurai',
      'nearby': 'Near Meenakshi Temple',
      'phone': '7654321098',
    },
    {
      'name': 'Trichy Blood Center',
      'address': '12 Thillai Nagar, Trichy',
      'nearby': 'Near Rock Fort',
      'phone': '6543210987',
    },
    {
      'name': 'Salem Blood Bank',
      'address': '34 Cherry Rd, Salem',
      'nearby': 'Near Salem Junction',
      'phone': '5432109876',
    },
    {
      'name': 'Erode Blood Bank',
      'address': '90 Bus Stand Rd, Erode',
      'nearby': 'Near Erode Railway Station',
      'phone': '4321098765',
    },
    // Add more as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Banks in Tamil Nadu"),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: bloodBanks.length,
        itemBuilder: (context, index) {
          final bank = bloodBanks[index];
          return GestureDetector(
            onTap: () {
              // Show dialog with additional information
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(bank['name']!),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address: ${bank['address']}'),
                          const SizedBox(height: 8),
                          Text('Nearby: ${bank['nearby']}'),
                          const SizedBox(height: 8),
                          Text('Phone: ${bank['phone']}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(
                  Icons.local_hospital,
                  color: Colors.red,
                  size: 40,
                ),
                title: Text(
                  bank['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(bank['address']!),
              ),
            ),
          );
        },
      ),
    );
  }
}
