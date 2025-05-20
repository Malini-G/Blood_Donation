import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/shared_service.dart'; // Import shared service

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? gender;
  String? bloodGroup;
  DateTime? birthDate;

  Future<void> signup() async {
    String name = firstNameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String address = addressController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        gender == null ||
        bloodGroup == null ||
        birthDate == null ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out all fields!")),
      );
      return;
    }

    final dob = "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}";

    try {
      final result = await AuthService.signup(
        name,
        phone,
        email,
        address,
        gender!,
        bloodGroup!,
        dob,
        password,
      );

      if (result['message'] == 'Signup successful') {
        // Save to shared preferences
        await SharedService.saveUserData(
          name: name,
          phone: phone,
          email: email,
          address: address,
          gender: gender!,
          bloodGroup: bloodGroup!,
          dob: dob,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Signup successful!")));

        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: gender,
              hint: const Text("Gender"),
              onChanged: (val) => setState(() => gender = val),
              items:
                  ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: bloodGroup,
              hint: const Text("Blood Group"),
              onChanged: (val) => setState(() => bloodGroup = val),
              items:
                  ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                      .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                      .toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  birthDate == null
                      ? "Select DOB"
                      : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => birthDate = picked);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: signup,
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
