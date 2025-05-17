import 'package:flutter/material.dart';
import '../data/signup_data_store.dart';

class Donor {
  final String name, phone, location, bloodGroup, dob;

  Donor({
    required this.name,
    required this.phone,
    required this.location,
    required this.bloodGroup,
    required this.dob,
  });

  @override
  bool operator ==(Object other) =>
      other is Donor &&
      name == other.name &&
      phone == other.phone &&
      bloodGroup == other.bloodGroup;

  @override
  int get hashCode => name.hashCode ^ phone.hashCode ^ bloodGroup.hashCode;
}

class DonorPage extends StatefulWidget {
  const DonorPage({super.key});

  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  List<Donor> donors = [];
  String selectedBloodGroup = 'All';

  List<Donor> get filteredDonors =>
      selectedBloodGroup == 'All'
          ? donors
          : donors.where((d) => d.bloodGroup == selectedBloodGroup).toList();

  void _showBecomeDonorDialog() {
    final signupData = SignupDataStore.signupData;

    if (signupData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please sign up first!")));
      return;
    }

    final newDonor = Donor(
      name: signupData['name'],
      phone: signupData['phone'],
      location: signupData['address'],
      bloodGroup: signupData['blood'],
      dob: signupData['dob'],
    );

    if (donors.contains(newDonor)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This donor is already added.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Become a Donor?"),
            content: const Text("Use your signup info to become a donor?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    donors.add(newDonor);
                    selectedBloodGroup = newDonor.bloodGroup;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Page"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedBloodGroup,
              isExpanded: true,
              items:
                  ['All', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                      .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                      .toList(),
              onChanged: (value) => setState(() => selectedBloodGroup = value!),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  filteredDonors.isEmpty
                      ? const Center(child: Text("No donors yet."))
                      : ListView.builder(
                        itemCount: filteredDonors.length,
                        itemBuilder: (_, index) {
                          final donor = filteredDonors[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            child: ListTile(
                              title: Text(donor.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Blood Group: ${donor.bloodGroup}"),
                                  Text("Phone: ${donor.phone}"),
                                  Text("Location: ${donor.location}"),
                                  Text("DOB: ${donor.dob}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBecomeDonorDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}
