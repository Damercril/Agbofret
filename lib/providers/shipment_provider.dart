import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShipmentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _shipments = [];

  List<Map<String, dynamic>> get shipments => _shipments;

  Future<void> fetchMyShipments(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('shipments')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _shipments = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> createShipment(Map<String, dynamic> shipmentData) async {
    try {
      await _firestore.collection('shipments').add({
        ...shipmentData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateShipment(String shipmentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('shipments').doc(shipmentId).update(data);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
}
