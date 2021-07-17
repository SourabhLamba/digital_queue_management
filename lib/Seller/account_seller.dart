import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_queue/widgets/blue_custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'home_screen_seller.dart';
import 'shopInfoCrud.dart';
import '../widgets/show_toast.dart';

class AccountSeller extends StatefulWidget {
  @override
  _AccountSellerState createState() => _AccountSellerState();
}

DocumentSnapshot _result;

class _AccountSellerState extends State<AccountSeller> {
  String _shopName, _shopAddress, _shopDescription, _shopPhoneno, _shopPhoto;
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
    return ModalProgressHUD(
      inAsyncCall: isUploading,
      opacity: 0.6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          title: Text("Account Details"),
        ),
        body: _result == null
            ? Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue[900],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: SingleChildScrollView(
                  child: detailsForm(),
                ),
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
          Text("Select shop image"),
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
              ),
            ],
          )
        ],
      ),
    );
  }

  detailsForm() {
    return Form(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((builder) => bottomSheet()));
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black45,
              )),
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width * 0.9,
              child: _shopPhoto == 'null'
                  ? Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    )
                  : Image(
                      image: NetworkImage(_shopPhoto),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
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
            child: BlueCustomButton(
              labelText: 'Save',
              onPressed: () {
                var shopData = {
                  'userId': userId.getAt(0),
                  'shopName': _shopName,
                  'shopAddress': _shopAddress,
                  'shopDescription': _shopDescription,
                  'shopPhoneNo': _shopPhoneno,
                  'shopPhoto': _shopPhoto
                };
                ShopInfoCrud().upDateShopData(
                  userId.getAt(0),
                  shopData,
                );
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (builder) => HomeScreenSeller()),
                );
                showToast('Data Updated.');
              },
            ),
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
        var croppedImage = await cropImage(image.path, 4, 3);

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
        } else
          showToast("No Image provided");
      }
    } else {
      showToast("Please Grant Permission");
    }
  }

  upLoadImageFromCamera() async {
    await Permission.camera.request();

    var image = await ImagePicker().getImage(source: ImageSource.camera);

    if (image != null) {
      var croppedImage = await cropImage(image.path, 4, 3);

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
      } else
        showToast("No Path");
    } else
      showToast("Grant Permission");
  }

  cropImage(String imagePath, int x, int y) {
    ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
        sourcePath: imagePath,
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
  }
}
