import 'package:cam_data/Authen/authen_Class.dart';
import 'package:cam_data/Authen/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appbar"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              AuthClass().signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                  (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .where('uid', isEqualTo: firebaseUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return ListView(
              children: documents
                  .map(
                    (doc) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        CircleAvatar(
                          radius: 53,
                          backgroundColor: Colors.red,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              doc['url'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          doc['displayName'],
                          style: TextStyle(fontSize: 30),
                        ),
                        // Text(
                        //   doc['email'],
                        //   style: TextStyle(fontSize: 30),
                        // )
                      ],
                    ),
                  )
                  .toList(),
            );
          } else if (snapshot.hasData) {
            return Text('error');
          } else {
            return Center(
              child: Text(
                'Loading...',
              ),
            );
          }
        },
      ),
    );
  }
}
