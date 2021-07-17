import 'package:cloud_firestore/cloud_firestore.dart';

class ShopInfoCrud {
  createShop(id, shopData) {
    Firestore.instance
        .collection('seller')
        .document(id)
        .setData(shopData)
        .catchError((e) => print(e));
  }

  getShop(id) async {
    return await Firestore.instance.collection('seller').document(id).get();
  }

  upDateShopData(id, upDateData) {
    Firestore.instance
        .collection('seller')
        .document(id)
        .updateData(upDateData)
        .catchError((e) => print(e));
  }

  updateTimeLine(id, upLoadData) {
    Firestore.instance
        .collection('seller')
        .document(id)
        .collection('timeLine')
        .document(id)
        .updateData(upLoadData)
        .catchError((e) => print(e));
  }

  createTimeLines(id, info) {
    Firestore.instance
        .collection('seller')
        .document(id)
        .collection('timeLine')
        .document(id)
        .setData(info)
        .catchError((e) => print(e));
  }

  getTimeLIne(id) async {
    return Firestore.instance
        .collection('seller')
        .document(id)
        .collection('timeLine')
        .snapshots();
  }

  getCustomerInfo(id, userId) {
    return Firestore.instance.collection('customer').document(userId).get();
  }
}
