import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/shared_service.dart'; // Make sure this path is correct

class Donor {
  final String name, phone, location, bloodGroup, dob;

  Donor({
    required this.name,
    required this.phone,
    required this.location,
    required this.bloodGroup,
    required this.dob,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      name: json['name'],
      phone: json['phone'],
      location: json['address'],
      bloodGroup: json['blood_group'],
      dob: json['dob'],
    );
  }

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

  final String backendUrl =
      'http://localhost:5000'; // Use your IP if running on a real device

  List<Donor> get filteredDonors =>
      selectedBloodGroup == 'All'
          ? donors
          : donors.where((d) => d.bloodGroup == selectedBloodGroup).toList();

  @override
  void initState() {
    super.initState();
    fetchDonors();
  }

  Future<void> fetchDonors() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/donors'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final loadedDonors = data.map((json) => Donor.fromJson(json)).toList();

        print("Fetched ${loadedDonors.length} donors");
        loadedDonors.forEach(
          (d) => print("Donor: ${d.name}, Blood: ${d.bloodGroup}"),
        );

        setState(() {
          donors = loadedDonors;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load donors: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching donors: $e')));
    }
  }

  Future<void> becomeDonor() async {
    final signupData = await SharedService.getUserData();
    print("📋 Loaded signup data: $signupData");

    final hasEmptyField = signupData.values.any(
      (value) => value == null || value.trim().isEmpty,
    );
    if (signupData.isEmpty || hasEmptyField) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete your sign-up first!")),
      );
      return;
    }

    final email = signupData['email'] ?? '';
    if (email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email not found. Please sign up again.")),
      );
      return;
    }

    final newDonor = Donor(
      name: signupData['name'] ?? '',
      phone: signupData['phone'] ?? '',
      location: signupData['address'] ?? '',
      bloodGroup: signupData['bloodGroup'] ?? '',
      dob: signupData['dob'] ?? '',
    );

    if (donors.contains(newDonor)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This donor is already added.")),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            content: const Text("Add yourself as a donor?"),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Become a Donor"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/user/become-donor'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        await fetchDonors();
        setState(() {
          selectedBloodGroup = newDonor.bloodGroup;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("You are now a donor!")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error connecting to server: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final donorsToShow = filteredDonors;

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
            donorsToShow.isEmpty
                ? const Expanded(child: Center(child: Text("No donors yet.")))
                : Expanded(
                  child: ListView.builder(
                    itemCount: donorsToShow.length,
                    itemBuilder: (_, index) {
                      final donor = donorsToShow[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  donor.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Blood Group: ${donor.bloodGroup}"),
                                Text("Phone: ${donor.phone}"),
                                Text("Location: ${donor.location}"),
                                Text("DOB: ${donor.dob}"),
                              ],
                            ),
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
        onPressed: becomeDonor,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}
