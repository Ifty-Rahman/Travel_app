import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency/data/constants.dart';
import 'package:travel_agency/pages/drawer.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final currentuser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        backgroundColor: kBackgroundColor,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          CircleAvatar(
            radius: 80, // Adjust the radius as needed
            backgroundColor: Colors
                .grey, // You can set a background color if the image is loading or null
            child: ClipOval(
              child: Image.network(
                "https://i.ibb.co/vcDP98m/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg",
                fit: BoxFit
                    .cover, // Ensure the image covers the entire circular area
                width: 160,
                height: 160,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_a_photo_rounded),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            currentuser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
