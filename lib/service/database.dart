import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserOrder(
    Map<String, dynamic> userInfoMap,
    String id,
    String orderid,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Order")
        .doc(orderid)
        .set(userInfoMap);
  }

  Future addAdminOrder(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Order")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getAdminOrders() async {
    return await FirebaseFirestore.instance.collection("Order").snapshots();
  }

  Future updateAdminTracker(String id, int updatedtracker) async {
    return await FirebaseFirestore.instance.collection("Order").doc(id).update({
      "Tracker": updatedtracker,
    });
  }

  Future updateUserTracker(
    String id,
    int updatedtracker,
    String orderid,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Order")
        .doc(orderid)
        .update({"Tracker": updatedtracker});
  }

  Future<Stream<QuerySnapshot>> getUserOrders(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Order")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future<Stream<QuerySnapshot>> getUserPastOrders(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Order")
        .where("Tracker", isEqualTo: 4)
        .snapshots();
  }

  Future deleteuser(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }
}
