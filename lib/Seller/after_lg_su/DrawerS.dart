import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digi_queue/Seller/after_lg_su/AccountS.dart';
import 'package:digi_queue/Seller/after_lg_su/TimeLineS.dart';
import 'package:digi_queue/main.dart';

Widget drawerS(context, String shopName, String shopEmail, String shopPhoto) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(shopName),
          accountEmail: Text(shopEmail),
          currentAccountPicture: shopPhoto.isEmpty
              ? CircleAvatar(
                  backgroundColor: Colors.amber,
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(shopPhoto),
                ),
          onDetailsPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AccountS())),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text("Account"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AccountS();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.add_shopping_cart),
          title: Text("Time Line"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return TimeLineS();
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Setting"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Log Out"),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HPage();
            }));
          },
        ),
      ],
    ),
  );
}
