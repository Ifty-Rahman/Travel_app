import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_agency/data/constants.dart';
import 'package:travel_agency/pages/packages.dart';
import 'package:lottie/lottie.dart';

class CountryListPage extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  List<String> countries = []; // List to store country names

  @override
  void initState() {
    super.initState();
    getCountries(); // Fetch countries when the widget is initialized
  }

  Future<void> getCountries() async {
    // Fetch countries from the "packages" collection
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("packages").get();

    // Extract country names from the snapshot
    List<String> countryNames = [];
    snapshot.docs.forEach((doc) {
      countryNames.add(doc["country"]);
    });

    // Remove duplicates
    Set<String> uniqueCountryNames = countryNames.toSet();

    setState(() {
      countries = uniqueCountryNames.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Countries",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Lottie.network(
                "https://lottie.host/53f607a7-fadb-41df-a7b3-87974a98ca2f/QxyJ73amz1.json",
                width: 180,
                height: 180,
                repeat: false,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10,
                      ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigate to PackagePage with the selected country
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackagePage(
                                selectedCountry: countries[index],
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Image
                            Ink.image(
                              image: NetworkImage("https://images.pexels.com/photos/1119972/pexels-photo-1119972.jpeg?cs=srgb&dl=pexels-jplenio-1119972.jpg&fm=jpg"),
                              height: 150,
                              fit: BoxFit.cover,
                              ),
                            // Semi-transparent overlay
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4), // Adjust opacity as needed
                              ),
                            ),
                            // Text
                            ListTile(
                              title: Center(
                                child: Text(
                                  countries[index],
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                  ),
                                ),
                              ),
                            ),
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
    );
  }
}
