import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerInfoCrud {
  createCustomer(id, customerData) {
    Firestore.instance
        .collection('customer')
        .document(id)
        .setData(customerData)
        .catchError((e) => print(e));
  }

  getCustomer(id) async {
    return await Firestore.instance.collection('customer').document(id).get();
  }

  upDateCustomerData(id, customerData) {
    Firestore.instance
        .collection('customer')
        .document(id)
        .updateData(customerData)
        .catchError((e) => print(e));
  }

  getSellers() async {
    return Firestore.instance.collection('seller').snapshots();
  }

  getSellerForSearch() async {
    return Firestore.instance.collection('seller').getDocuments();
  }

  getSellerTimeLine(uid) async {
    return Firestore.instance
        .collection('seller')
        .document(uid)
        .collection('timeLine')
        .snapshots();
  }

  getBookedOrNot(uid) async {
    return Firestore.instance
        .collection('seller')
        .document(uid)
        .collection('timeLine')
        .getDocuments();
  }

  bookingUpdateOnSellerSide(uid, bookTime) {
    Firestore.instance
        .collection('seller')
        .document(uid)
        .collection('timeLine')
        .document(uid)
        .updateData(bookTime)
        .catchError((e) => print(e));
  }

  addbooking(data, uid, seller) {
    Firestore.instance
        .collection('customer')
        .document(uid)
        .collection('bookings')
        .document(seller)
        .setData(data)
        .catchError((e) => print(e));
  }

  getBookings(uid) {
    return Firestore.instance
        .collection('customer')
        .document(uid)
        .collection('bookings')
        .getDocuments();
  }

  deleteBooking(uid, seller) {
    Firestore.instance
        .collection('customer')
        .document(uid)
        .collection('bookings')
        .document(seller)
        .delete();
  }
}
