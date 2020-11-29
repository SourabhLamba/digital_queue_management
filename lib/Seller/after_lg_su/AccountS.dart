import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
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
              backgroundColor: Colors.blueAccent[700],
              title: Text("Account"),
            ),
            body: _result != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: SingleChildScrollView(
                      child: Form(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.width * 0.6,
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
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return SpinKitThreeBounce(
                                          color: Colors.black38,
                                          size: 16,
                                        );
                                      },
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              padding: EdgeInsets.only(top: 3, left: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 50,
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
                                  showToast('Data Updated');
                                },
                                color: Colors.blueAccent[700],
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          )

                        ],
                      )),
                    ),
                  )
                : Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue[900],
                    ),
                  ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitPouringHourglass(
                    color: Colors.blue[900],
                  ),
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
    await Permission.photos.request();
    var permissionState = await Permission.photos.status;
    if (permissionState.isGranted) {
      //Select Image
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image != null) {
        var croppedImage = await ImageCropper.cropImage(
            aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
            sourcePath: image.path,
            compressQuality: 70,
            maxHeight: 700,
            maxWidth: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.blue[700],
              toolbarWidgetColor: Colors.white,
              toolbarTitle: "Cropper",
              statusBarColor: Colors.blue[900],
              backgroundColor: Colors.white,
            ));
        if (croppedImage != null) {
          //Up load to firebase

          Navigator.pop(context);
          setState(() {
            isUploading = true;
          });
          var snapShot = await FirebaseStorage.instance
              .ref()
              .child('Seller/${userId.getAt(0)}')
              .putFile(croppedImage)
              .onComplete;

          var downloadUrl = await snapShot.ref.getDownloadURL();
          ShopInfoCrud()
              .upDateShopData(userId.getAt(0), {'shopPhoto': downloadUrl});
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) {
            return HomeS();
          }));
          Navigator.push(context, MaterialPageRoute(builder: (builder) {
            return AccountS();
          }));
        } else
          showToast("No Path");
      }
    } else {
      showToast("Grant Permission");
    }
  }

  upLoadImageFromCamera() async {
    await Permission.camera.request();

    var image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image != null) {
      var croppedImage = await ImageCropper.cropImage(
          aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
          sourcePath: image.path,
          compressQuality: 70,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.blue[700],
            toolbarTitle: "Cropper",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.blue[900],
            backgroundColor: Colors.white,
          ));
      if (croppedImage != null) {
        //Up load to firebase

        Navigator.pop(context);
        setState(() {
          isUploading = true;
        });
        var ref =
            FirebaseStorage.instance.ref().child('Seller/${userId.getAt(0)}');
        var task = ref.putFile(croppedImage);
        var taskSnapshot = await task.onComplete;
        ShopInfoCrud().upDateShopData(
            userId.getAt(0), {'shopPhoto': taskSnapshot.ref.getDownloadURL()});
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) {
          return HomeS();
        }));
        Navigator.push(context, MaterialPageRoute(builder: (builder) {
          return AccountS();
        }));
      } else
        showToast("No Path");
    } else
      showToast("Grant Permission");
  }

  showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
