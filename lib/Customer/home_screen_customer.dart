import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';

import '../widgets/show_toast.dart';
import 'CustomerInfoCrud.dart';
import 'notification_screen.dart';
import 'search_shop.dart';
import 'drawer_customer.dart';
import 'shop_detail_screen.dart';

class HomeScreenCustomer extends StatefulWidget {
  @override
  _HomeScreenCustomerState createState() => _HomeScreenCustomerState();
}

String _customerName, _customerPhoto, _customerEmail;
bool isLoading = true, _isLoading1 = true;
var _sellersData;
Box<String> userId;

class _HomeScreenCustomerState extends State<HomeScreenCustomer> {
  @override
  void initState() {
    userId = Hive.box<String>("userId");
    super.initState();

    CustomerInfoCrud().getCustomer(userId.getAt(0)).then((result) {
      setState(() {
        _customerName = result['customerName'].toString();
        _customerPhoto = result['customerPhoto'].toString();
        _customerEmail = result['customerEmail'].toString();
        _isLoading1 = false;
      });
    });

    CustomerInfoCrud().getSellers().then((result) {
      setState(() {
        _sellersData = result;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading && !_isLoading1
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepPurpleAccent[400],
              child: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return SearchShop();
                }));
              },
            ),
            drawer: drawer(
              context,
              _customerName,
              _customerEmail,
              _customerPhoto,
            ),
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent[400],
              centerTitle: true,
              title: Text("Customer"),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (build) {
                      return NotificationScreen(
                          customerName: _customerName,
                          customerPhoto: _customerPhoto);
                    }));
                  },
                  icon: Icon(Icons.notifications),
                ),
              ],
            ),
            body: _sellersStream(),
          )
        : Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: Colors.deepPurple[700],
              ),
            ),
          );
  }

  Widget _sellersStream() {
    return StreamBuilder(
        stream: _sellersData,
        builder: (context, snapShot) {
          if (snapShot.data == null)
            return Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loading Available Sellers",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          return ListView.builder(
              itemCount: snapShot.data.documents.length,
              itemBuilder: (build, index) {
                var snapData = snapShot.data.documents[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
                  child: TextButton(
                    onPressed: () {
                      if (snapData.data['isOpen'].toString() == 'false') {
                        showToast('Shop is Closed');
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return ShopDetail(
                              uid: snapData.data['userId'].toString(),
                              name: snapData.data['shopName'].toString(),
                              address: snapData.data['shopAddress'].toString(),
                              description:
                                  snapData.data['shopDescription'].toString(),
                              photo: snapData.data['shopPhoto'].toString(),
                              phoneNo: snapData.data['shopPhoneNo'].toString());
                        }));
                      }
                    },
                    child: shopCard(snapData),
                  ),
                );
              });
        });
  }

  shopCard(var snapData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              snapData.data['shopPhoto'].toString(),
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SpinKitThreeBounce(
                  color: Colors.black38,
                  size: 16,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  snapData.data['shopName'].toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(
                  snapData.data['isOpen'].toString() == 'true'
                      ? "Open"
                      : "Close",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
