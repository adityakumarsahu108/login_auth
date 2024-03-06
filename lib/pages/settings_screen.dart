import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String userEmail;
  final String userID;

  const SettingsScreen(
      {required this.userEmail, Key? key, required this.userID})
      : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ageController = TextEditingController();

  Future updateData(String firstName, String lastName, int age) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Update Firestore with additional user information
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'first name': firstName,
        'last name': lastName,
        'age': age,
      });
      print(user?.uid);

      // Reload the user to get the updated information
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future updateUserData() async {
    updateData(
      _firstnameController.text.trim(),
      _lastnameController.text.trim(),
      int.parse(
        _ageController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update User Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Email: ${widget.userEmail}'),
            const SizedBox(height: 16),
            TextField(
              controller: _firstnameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: updateUserData,
              child: const Text('Update Data'),
            ),
          ],
        ),
      ),
    );
  }
}
