import 'package:digi_queue/Customer/after_lg_su/Account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

Widget drawer(context, customerName, customerEmail, customerPhoto) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(customerName),
          accountEmail: Text(customerEmail),
          currentAccountPicture: customerPhoto.isEmpty
              ? CircleAvatar(
                  backgroundColor: Colors.amber,
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(customerPhoto),
                ),
          onDetailsPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (builder) => Account())),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text("Account"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Account();
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
