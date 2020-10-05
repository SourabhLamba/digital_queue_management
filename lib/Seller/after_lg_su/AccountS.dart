import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:digi_queue/Seller/after_lg_su/HomeS.dart';
import 'package:digi_queue/Seller/after_lg_su/shopInfoCrud.dart';

class AccountS extends StatefulWidget {
  @override
  _AccountSState createState() => _AccountSState();
}

class _AccountSState extends State<AccountS> {
  String _shopName, _shopAddress, _shopDescription, _shopPhoneno, _shopPhoto;
  DocumentSnapshot _result;
  Box<String> userId;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    userId = Hive.box<String>('userId');
    ShopInfoCrud().getShop(userId.getAt(0)).then((result) {
      setState(() {
        _result = result;
        _shopName = _result['shopName'].toString();
        _shopAddress = _result['shopAddress'].toString();
        _shopDescription = _result['shopDescription'].toString();
        _shopPhoneno = _result['shopPhoneNo'].toString();
        _shopPhoto = _result['shopPhoto'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isUploading == false
        ? Scaffold(
            appBar: AppBar(
              title: Text("Account"),
            ),
            body: _result != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: SingleChildScrollView(
                      child: Form(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Colors.grey,
                            height: MediaQuery.of(context).size.height / 5,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: FlatButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()));
                              },
                              child: _shopPhoto.isEmpty
                                  ? Icon(
                                      Icons.account_box,
                                      size: 90,
                                      color: Colors.black,
                                    )
                                  : Image(
                                      image: NetworkImage(_shopPhoto),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: _shopName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Shop Name",
                            ),
                            onChanged: (value) => _shopName = value,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            maxLines: 2,
                            initialValue: _shopAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Shop Address",
                            ),
                            onChanged: (value) => _shopAddress = value,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            maxLines: 8,
                            initialValue: _shopDescription,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Shop Description",
                            ),
                            onChanged: (value) => _shopDescription = value,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            initialValue: _shopPhoneno,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Shop Phone No.",
                            ),
                            onChanged: (value) => _shopPhoneno = value,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                              child: Text("Save"),
                              onPressed: () {
                                var shopData = {
                                  'userId': userId.getAt(0),
                                  'shopName': _shopName,
                                  'shopAddress': _shopAddress,
                                  'shopDescription': _shopDescription,
                                  'shopPhoneNo': _shopPhoneno,
                                  'shopPhoto': _shopPhoto
                                };
                                ShopInfoCrud()
                                    .upDateShopData(userId.getAt(0), shopData);
                                Navigator.pop(context);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return HomeS();
                                }));
                              })
                        ],
                      )),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ))
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Uploading\nPlease Wait",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text("Choose shop picture"),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  upLoadImageFromCamera();
                },
              ),
              IconButton(
                iconSize: 40,
                icon: Icon(Icons.image),
                onPressed: () {
                  upLoadImageFromGallery();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  upLoadImageFromGallery() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    await Permission.photos.request();
    var permissionState = await Permission.photos.status;
    if (permissionState.isGranted) {
      //Select Image

      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null) {
        //Up load to firebase
        Navigator.pop(context);
        setState(() {
          isUploading = true;
        });
        var snapShot = await _storage
            .ref()
            .child('Seller/${userId.getAt(0)}')
            .putFile(file)
            .onComplete;

        var downloadUrl = await snapShot.ref.getDownloadURL();
        ShopInfoCrud()
            .upDateShopData(userId.getAt(0), {'shopPhoto': downloadUrl});
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) {
          return AccountS();
        }));
      } else
        print("NO path");
    } else {
      print("Grant Permission");
    }
  }

  upLoadImageFromCamera() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    await Permission.camera.request();
    var permissionState = await Permission.camera.status;
    if (permissionState.isGranted) {
      //Select Image

      image = await _picker.getImage(source: ImageSource.camera);
      var file = File(image.path);

      if (image != null) {
        //Up load to firebase
        var snapShot = await _storage
            .ref()
            .child('Seller/${userId.getAt(0)}')
            .putFile(file)
            .onComplete;
        ShopInfoCrud().upDateShopData(
            userId.getAt(0), {'shopPhoto': snapShot.ref.getDownloadURL()});
      } else
        print("NO path");
    } else {
      print("Grant Permission");
    }
  }
}
