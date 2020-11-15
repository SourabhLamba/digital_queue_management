import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_queue/Customer/after_lg_su/CustomerInfoCrud.dart';
import 'package:digi_queue/Customer/after_lg_su/Home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _customerName, _customerPhoneNo, _customerPhoto, _customerAddress;
  DocumentSnapshot _result;
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
    return isUploading == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent,
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
                            height: 10,
                          ),
                          Container(
                            color: Colors.grey,
                            height: MediaQuery.of(context).size.width * 0.8,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: FlatButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()));
                              },
                              child: _customerPhoto == null
                                  ? Icon(
                                      Icons.account_box,
                                      size: 90,
                                      color: Colors.black,
                                    )
                                  : Image(
                                      image: NetworkImage(_customerPhoto),
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
                          RaisedButton(
                              child: Text("Save"),
                              onPressed: () {
                                var customerData = {
                                  'userId': userId.getAt(0),
                                  'customerName': _customerName,
                                  'cutomerAddress': _customerAddress,
                                  'customerPhoneNo': _customerPhoneNo,
                                  'customerPhoto': _customerPhoto
                                };
                                CustomerInfoCrud().upDateCustomerData(
                                    userId.getAt(0), customerData);
                                Navigator.pop(context);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return Home();
                                }));
                                showToast('Data Updated');
                              })
                        ],
                      )),
                    ),
                  )
                : Center(
                    child: SpinKitFadingCircle(
                      color: Colors.deepPurpleAccent[700],
                    ),
                  ))
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitPouringHourglass(
                    color: Colors.deepPurpleAccent[700],
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

  upLoadImageFromGallery() async {
    await Permission.photos.request();
    var permissionState = await Permission.photos.status;
    if (permissionState.isGranted) {
      //Select Image
      var image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image != null) {
        var croppedImage = await ImageCropper.cropImage(
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            sourcePath: image.path,
            compressQuality: 70,
            maxHeight: 700,
            maxWidth: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepPurple[700],
              toolbarWidgetColor: Colors.white,
              toolbarTitle: "Cropper",
              statusBarColor: Colors.deepPurple[900],
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
              .child('Customer/${userId.getAt(0)}')
              .putFile(croppedImage)
              .onComplete;

          var downloadUrl = await snapShot.ref.getDownloadURL();
          CustomerInfoCrud().upDateCustomerData(
              userId.getAt(0), {'customerPhoto': downloadUrl});
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) {
            return Home();
          }));
          Navigator.push(context, MaterialPageRoute(builder: (builder) {
            return Account();
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
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          sourcePath: image.path,
          compressQuality: 70,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepPurple[700],
            toolbarTitle: "Cropper",
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.deepPurple[900],
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
            .child('Customer/${userId.getAt(0)}')
            .putFile(croppedImage)
            .onComplete;

        var downloadUrl = await snapShot.ref.getDownloadURL();
        CustomerInfoCrud().upDateCustomerData(
            userId.getAt(0), {'customerPhoto': downloadUrl});
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) {
          return Home();
        }));
        Navigator.push(context, MaterialPageRoute(builder: (builder) {
          return Account();
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
