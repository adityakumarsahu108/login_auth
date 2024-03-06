import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_auth/read%20data/get_user_name.dart';

class UpdateUserDataDialog extends StatefulWidget {
  final String? currentUserDocId;
  const UpdateUserDataDialog({super.key, this.currentUserDocId});

  @override
  UpdateUserDataDialogState createState() => UpdateUserDataDialogState();
}

class UpdateUserDataDialogState extends State<UpdateUserDataDialog> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Update User Data',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple),
      ),
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: Colors.deepPurple,
              controller: _firstnameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              cursorColor: Colors.deepPurple,
              controller: _lastnameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              cursorColor: Colors.deepPurple,
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
        TextButton(
          onPressed: () async {
            // Perform the update with the entered values
            String firstName = _firstnameController.text.trim();
            String lastName = _lastnameController.text.trim();
            int age = int.tryParse(_ageController.text.trim()) ?? 0;

            // Add your Firestore update logic here with the entered values

            // Check if the user is authenticated
            if (FirebaseAuth.instance.currentUser != null) {
              User? user = FirebaseAuth.instance.currentUser;

              try {
                // Update Firestore with additional user information
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentUserDocId)
                    .update({
                  'first name': firstName,
                  'last name': lastName,
                  'age': age,
                });
                await user?.reload();

                // Close the dialog
                Navigator.pop(context);
              } catch (e) {
                print('Error updating user: $e');
              }
            }
          },
          child: const Text(
            'Update',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot<Map<String, dynamic>>> userStream;

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  void showUpdateDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateUserDataDialog(currentUserDocId: documentId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            user.email!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: const Icon(Icons.logout),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<DocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              String documentId = documents[index].id;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    showUpdateDialog(context, documentId);
                  },
                  title: GetUserName(documentId: documentId),
                  tileColor: Colors.grey[300],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
