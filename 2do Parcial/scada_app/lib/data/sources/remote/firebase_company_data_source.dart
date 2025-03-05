import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/company_model.dart';

class FirebaseCompanyDataSource {

  final FirebaseFirestore _firestore;

  FirebaseCompanyDataSource(this._firestore);

  Future<CompanyModel?> getCompanyById(int idComp) async {

    try {
      final querySnapshot = await _firestore
        .collection('company')
        .where('idComp', isEqualTo: idComp)
        .get();
      
      if (querySnapshot.docs.isEmpty) {return null;}

      final compDoc = querySnapshot.docs.first
        as DocumentSnapshot<Map<String, dynamic>>;

      final myComp = CompanyModel.fromFirestore(compDoc, null);

      return myComp;

    }catch(e) {
      debugPrint("Error in company $e");
      return null;
    }
  }


}