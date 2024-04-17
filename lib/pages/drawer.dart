import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_agency/data/add_data.dart';
import 'package:travel_agency/pages/countries.dart';
import 'package:travel_agency/pages/explore.dart';
import 'package:travel_agency/pages/profile.dart';
import 'package:travel_agency/pages/show_bookings.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfilePage();
                            },
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 50, // Adjust the size of the user image
                        backgroundImage:
                            AssetImage('assets/images/profile_3.jpeg'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Explore();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.black,
                      ),
                      title: Text(
                        "  Home",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CountryListPage();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.map,
                        color: Colors.black,
                      ),
                      title: Text(
                        "  Countries",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddDataPage();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.add_location,
                        color: Colors.black,
                      ),
                      title: Text(
                        "  Add Data",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ShowBookingsPage();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.airplane_ticket,
                        color: Colors.black,
                      ),
                      title: Text(
                        "  Bookings",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                    title: Text(
                      "  About",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 35, bottom: 35),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text(
                  "  Log Out",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

