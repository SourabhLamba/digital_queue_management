import 'package:digi_queue/Customer/after_lg_su/CustomerInfoCrud.dart';
import 'package:digi_queue/Customer/after_lg_su/shopDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

bool isLoading = true, showResult = false;
var result;
TextEditingController searchController = TextEditingController();
String searchWord;
List<int> searchedSellerList = List<int>();

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
    CustomerInfoCrud().getSellerForSearch().then((_result) {
      setState(() {
        result = _result;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text("Search"),
          centerTitle: true,
        ),
        body: !isLoading
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15.0),
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchWord = value;
                          });
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                searchedSellerList.clear();
                                showResult = false;
                                searchSeller(searchWord);
                              }),
                          hintText: 'Search here!',
                          hintStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                    showResult
                        ? Container(
                            height:
                                MediaQuery.of(context).size.height * (14 / 15),
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: searchedSellerList.length,
                              itemBuilder: (builder, index) {
                                return FlatButton(
                                  padding:
                                      EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
                                  onPressed: () {
                                    if (result.documents[index].data['isOpen']
                                            .toString() ==
                                        'false') {
                                      Fluttertoast.showToast(
                                        msg: 'Shop is Closed',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    } else {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                        return ShopDetail(
                                            uid:
                                                result.documents[searchedSellerList[index]].data['userId']
                                                    .toString(),
                                            name: result
                                                .documents[
                                                    searchedSellerList[index]]
                                                .data['shopName']
                                                .toString(),
                                            address: result
                                                .documents[
                                                    searchedSellerList[index]]
                                                .data['shopAddress']
                                                .toString(),
                                            description: result
                                                .documents[
                                                    searchedSellerList[index]]
                                                .data['shopDescription']
                                                .toString(),
                                            photo: result
                                                .documents[searchedSellerList[index]]
                                                .data['shopPhoto']
                                                .toString(),
                                            phoneNo: result.documents[searchedSellerList[index]].data['shopPhoneNo'].toString());
                                      }));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[200],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 2 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              9,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.network(
                                            result
                                                .documents[
                                                    searchedSellerList[index]]
                                                .data['shopPhoto']
                                                .toString(),
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return SpinKitThreeBounce(
                                                color: Colors.black38,
                                                size: 16,
                                              );
                                            },
                                          ),
                                        ),
                                        Text(
                                          result
                                              .documents[
                                                  searchedSellerList[index]]
                                              .data['shopName']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Text(result
                                            .documents[
                                                searchedSellerList[index]]
                                            .data['shopAddress']
                                            .toString()),
                                        result
                                                    .documents[
                                                        searchedSellerList[
                                                            index]]
                                                    .data['isOpen']
                                                    .toString() ==
                                                'true'
                                            ? Text(
                                                "Open",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              )
                                            : Text(
                                                "Closed",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Icon(
                                Icons.search,
                                size: 80,
                                color: Colors.black12,
                              ),
                            ),
                          ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  void searchSeller(String searchWord) {
    for (int i = 0; i < result.documents.length; i++) {
      if (result.documents[i].data['shopName']
              .toString()
              .contains(searchWord) ||
          result.documents[i].data['shopAddress']
              .toString()
              .contains(searchWord)) {
        searchedSellerList.add(i);
      }
    }
    if (searchedSellerList.isNotEmpty) {
      setState(() {
        showResult = true;
      });
    }
  }
}
