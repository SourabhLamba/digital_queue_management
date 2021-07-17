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

import 'CustomerInfoCrud.dart';
import 'home_screen_customer.dart';
import '../widgets/show_toast.dart';

class AccountCustomer extends StatefulWidget {
  @override
  _AccountCustomerState createState() => _AccountCustomerState();
}

DocumentSnapshot _result;

class _AccountCustomerState extends State<AccountCustomer> {
  String _customerName, _customerPhoneNo, _customerPhoto, _customerAddress;

  Box<String> userId;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    userId = Hive.box<String>('userId');
    CustomerInfoCrud().getCustomer(userId.getAt(0)).then((result) {
      setState(() {
        _result = result;
        _customerName = _result['customerName'].toString();
        _customerPhoneNo = _result['customerPhoneNo'].toString();
        _customerPhoto = _result['customerPhoto'].toString();
        _customerAddress = _result['cutomerAddress'].toString();
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
          backgroundColor: Colors.deepPurpleAccent[400],
          title: Text("Account"),
        ),
        body: _result == null
            ? Center(
                child: SpinKitFadingCircle(
                  color: Colors.deepPurpleAccent[700],
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
          Text("Choose picture"),
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
              context: context,
              builder: ((builder) => bottomSheet()),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.width * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            child: _customerPhoto == 'null'
                ? Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.grey,
                  )
                : Image(
                    image: NetworkImage(_customerPhoto),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null)
                        return child;
                      else
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
          initialValue: _customerName,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Customer Name",
          ),
          onChanged: (value) => _customerName = value,
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          maxLines: 2,
          initialValue: _customerAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Customer Address",
          ),
          onChanged: (value) => _customerAddress = value,
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          initialValue: _customerPhoneNo,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Customer Phone No.",
          ),
          onChanged: (value) => _customerPhoneNo = value,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: BlueCustomButton(
            labelText: 'Save',
            onPressed: () {
              var customerData = {
                'userId': userId.getAt(0),
                'customerName': _customerName,
                'cutomerAddress': _customerAddress,
                'customerPhoneNo': _customerPhoneNo,
                'customerPhoto': _customerPhoto
              };
              CustomerInfoCrud()
                  .upDateCustomerData(userId.getAt(0), customerData);
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (builder) {
                return HomeScreenCustomer();
              }));
              showToast('Data Updated');
            },
          ),
        )
      ],
    ));
  }

  upLoadImageFromGallery() async {
    await Permission.photos.request();
    var permissionState = await Permission.photos.status;
    if (permissionState.isGranted) {
      //Select Image
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image != null) {
        var croppedImage = await cropImage(image.path, 1, 1);
        if (croppedImage != null) {
          //Up load to firebase

          Navigator.pop(context);
          setState(() {
            isUploading = true;
          });
          var snapShot = await FirebaseStorage.instance
              .ref()
              .child('Customer/${userId.getAt(0)}')
              .putFile(croppedImage)
              .onComplete;

          var downloadUrl = await snapShot.ref.getDownloadURL();
          CustomerInfoCrud().upDateCustomerData(
              userId.getAt(0), {'customerPhoto': downloadUrl});
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
      var croppedImage = await cropImage(image.path, 1, 1);

      if (croppedImage != null) {
        //Up load to firebase

        Navigator.pop(context);
        setState(() {
          isUploading = true;
        });
        var snapShot = await FirebaseStorage.instance
            .ref()
            .child('Customer/${userId.getAt(0)}')
            .putFile(croppedImage)
            .onComplete;

        var downloadUrl = await snapShot.ref.getDownloadURL();
        CustomerInfoCrud().upDateCustomerData(
            userId.getAt(0), {'customerPhoto': downloadUrl});
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
      ),
    );
  }
}
