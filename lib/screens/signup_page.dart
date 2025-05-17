import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Make sure this import is correct

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
    String name = firstNameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String address = addressController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      // Show error message if passwords don't match
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
      // Validate all fields
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
        // Show success message and navigate to login or dashboard
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Signup successful!")));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Show error message if signup failed
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (error) {
      // Handle any errors from the backend
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
