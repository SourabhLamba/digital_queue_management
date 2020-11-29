import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digi_queue/Seller/after_lg_su/AccountS.dart';
import 'package:digi_queue/Seller/after_lg_su/TimeLineS.dart';
import 'package:digi_queue/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

Widget drawerS(context, String shopName, String shopEmail, String shopPhoto) {
  return Drawer(
    elevation: 1.5,
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.blueAccent[700]),
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 100,
                  width: 100,
                  child: shopPhoto == null
                      ? CircleAvatar(
                          backgroundColor: Colors.blue[900],
                          radius: 40,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(shopPhoto),
                          radius: 40,
                          backgroundColor: Colors.blue[900],
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  shopName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  shopEmail,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.account_circle,
            color: Colors.blue[900],
          ),
          title: Text("Account"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AccountS();
            }));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.alarm_add,
            color: Colors.blue[900],
          ),
          title: Text("Time Line"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) {
              return TimeLineS();
            }));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.adjust,
            color: Colors.blue[900],
          ),
          title: Text("Contact Us"),
          onTap: () {
            _sendEmail(
                "mailto:rajsingharia.1234@gmail.com?subject=Qigi Queue App&body=",
                context);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.blue[900],
          ),
          title: Text("Log Out"),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HPage();
            }));
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: Image.asset('assets/images/logo.jpg'),
              title: Text("V 1.0.0"),
              subtitle: Text("Made in India"),
            ),
          ),
        )
      ],
    ),
  );
}

Future<void> _sendEmail(String command, context) async {
  if (await canLaunch(command)) {
    await launch(
      command,
    );
  } else {
    Fluttertoast.showToast(
      msg: "Unable To Send Email",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
