import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_agency/data/constants.dart';
import 'package:travel_agency/data/get_data.dart';
import 'package:travel_agency/pages/drawer.dart';
import 'package:travel_agency/pages/booking.dart'; // Import the BookingPage

class PackagePage extends StatefulWidget {
  final String selectedCountry;

  const PackagePage({Key? key, required this.selectedCountry})
      : super(key: key);

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  List<String> docIDs = [];
  bool isLoading = true; // Add a boolean to track loading state

  @override
  void initState() {
    super.initState();
    getdocID(); // Call getdocID function when the widget is initialized
  }

  Future<void> getdocID() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("packages")
        .where("country", isEqualTo: widget.selectedCountry)
        .get();

    final uniqueDocIDs = <String>{};

    snapshot.docs.forEach((document) {
      uniqueDocIDs.add(document.reference.id);
    });

    setState(() {
      docIDs = uniqueDocIDs.toList();
      isLoading = false; // Set loading state to false after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Packages",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_3.jpeg',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ), // Change this to display user's picture
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              );
            },
          ),
        ],
      ),
      endDrawer: AppDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Lottie.network(
                "https://lottie.host/41b32cb9-74c8-47b7-998e-1584275fbf72/5U7mmUlFVa.json",
                width: 230,
                height: 230,
                repeat: false,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "        CHOOSE\n YOUR PACKAGE!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Show a loading indicator while data is being fetched
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(15),
                              elevation: 5,
                              child: ListTile(
                                onTap: () async {
                                  // Retrieve package details from Firestore
                                  DocumentSnapshot packageSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection("packages")
                                          .doc(docIDs[
                                              index]) // Assuming docIDs contains document IDs of packages
                                          .get();

                                  // Extract package name and price
                                  String packageName = packageSnapshot[
                                      'package']; // Replace 'packageName' with actual field name
                                  String packagePrice = packageSnapshot['price']
                                      .toString(); // Convert to String

                                  // Navigate to BookingPage with package, price, and country
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingPage(
                                        country: widget.selectedCountry,
                                        package: packageName,
                                        price: packagePrice,
                                      ),
                                    ),
                                  );
                                },
                                title:
                                    GetPackageData(documentId: docIDs[index]),
                                tileColor: kSecondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
