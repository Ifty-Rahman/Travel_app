import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency/data/constants.dart';

class GetPackageData extends StatelessWidget {
  final String documentId;

  GetPackageData({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference packages =
        FirebaseFirestore.instance.collection("packages");

    return FutureBuilder<DocumentSnapshot>(
      future: packages.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "${data["package"]} \nPrice: ${data["price"]}tk per person",
              style: TextStyle(
                  color: kTextColor, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          );
        }
        return Text("Loading..");
      },
    );
  }
}
