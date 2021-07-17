import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account_seller.dart';
import 'shop_timeline.dart';
import '../select_user_screen.dart';
import '../widgets/show_toast.dart';

Widget drawerSeller(
    context, String shopName, String shopEmail, String shopPhoto) {
  return Drawer(
    elevation: 1.5,
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blueAccent[700]),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 100,
                width: 100,
                child: shopPhoto == 'null'
                    ? CircleAvatar(
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        backgroundColor: Colors.blueGrey[300],
                        radius: 40,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(shopPhoto),
                        radius: 40,
                      ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                shopName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
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
        ListTile(
          leading: Icon(
            Icons.account_circle,
            color: Colors.blue[900],
          ),
          title: Text("Account"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AccountSeller();
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
                "mailto:s.gupta1242@gmail.com?subject=Qigi Queue App&body=",
                context);
          },
        ),
        Divider(),
        CustomListTile(
          tileIcon: Icons.exit_to_app,
          tileLabel: 'Log Out',
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SelectUserScreen();
                },
              ),
            );
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
    showToast("Unable to send E-Mail.");
  }
}

class CustomListTile extends StatelessWidget {
  final String tileLabel;
  final IconData tileIcon;
  final Function onTap;
  CustomListTile({this.tileIcon, this.tileLabel, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        tileIcon,
        color: Colors.blue[900],
      ),
      title: Text(tileLabel),
      onTap: onTap,
    );
  }
}
