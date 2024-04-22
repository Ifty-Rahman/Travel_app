import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_agency/data/constants.dart';
import 'package:travel_agency/pages/packages.dart';

class CountryListPage extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  List<String> countries = []; // List to store country names
  Map<String, String> countryImages = {}; // Map to store country images

  @override
  void initState() {
    super.initState();
    getCountries(); // Fetch countries when the widget is initialized
  }

  Future<void> getCountries() async {
    try {
      // Fetch countries from the "packages" collection
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("packages").get();

      // Extract country names and image URLs from the snapshot
      snapshot.docs.forEach((doc) {
        String country = doc["country"];
        // Check if the document contains the "country_image" field
        if (doc.data().containsKey("country_image")) {
          String countryImage = doc["country_image"];
          countryImages[country] = countryImage;
        } else {
          // Skip this document and continue to the next one
          return;
        }
      });

      // Remove duplicates
      Set<String> uniqueCountryNames = countryImages.keys.toSet();

      setState(() {
        countries = uniqueCountryNames.toList();
      });
    } catch (error) {
      print("Error fetching countries: $error");
    }
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
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  final imageUrl = countryImages[country];
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
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
                              builder: (context) =>
                                  PackagePage(selectedCountry: country),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Image (conditional rendering)
                            imageUrl != null
                                ? Ink.image(
                                    image: NetworkImage(imageUrl),
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Ink.image(
                                    image:
                                        AssetImage('assets/images/country.jpg'),
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                            // Semi-transparent overlay
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.4), // Adjust opacity as needed
                              ),
                            ),
                            // Text
                            ListTile(
                              title: Center(
                                child: Text(
                                  country,
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
