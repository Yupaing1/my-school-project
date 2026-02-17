import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/screens/admin.dart';
import 'package:education_app/screens/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("အကောင့်ဝင်ပါ")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("သင်ကြားရေး App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          // Loading အဆင့်
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // data ရလာရင်
          final doc = snapshot.data;
          if (doc == null || !doc.exists) {
            return const Center(child: Text("မင်း အကောင့်အချက်အလက် မရှိသေးပါ"));
          }

          final data = doc.data() as Map<String, dynamic>;
          final role = (data['role'] as String?)?.toLowerCase() ?? 'normal';

          if (role == 'admin') {
            return const Admin();
          } else {
            return Student();
          }
        },
      ),
    );
  }
}
