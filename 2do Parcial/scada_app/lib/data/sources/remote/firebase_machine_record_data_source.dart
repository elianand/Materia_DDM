import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/machine_model.dart';
import '../../models/machine_record_model.dart';

class FirebaseMachineRecordDataSource {

  final FirebaseFirestore _firestore;

  FirebaseMachineRecordDataSource(this._firestore);

  Future<MachineStatusE?> getLastStatusByMachineId(int machineId) async {

    try {
      final querySnapshot = await _firestore
        .collection('records')
        .where('idMachine', isEqualTo: machineId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

      if(querySnapshot.docs.isEmpty) {return null;}

      final recordDoc = querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>;

      final myRecord = MachineRecordModel.fromFirestore(recordDoc, null);

      return myRecord.getStatus(); 
    }catch(e) {
      debugPrint("Error in firestore machineRecordDataSource");
      return null;
    }
  }


  Future<List<MachineRecordModel>?> getMachineRecords(int machineId, Timestamp startTime, Timestamp endTime) async {
    
    try {
      final querySnapshot = await _firestore
        .collection('records')
        .where('idMachine', isEqualTo: machineId)
        .where('timestamp', isGreaterThanOrEqualTo: startTime)
        .where('timestamp', isLessThanOrEqualTo: endTime)
        .get();

      if(querySnapshot.docs.isEmpty) {return null;}

      return querySnapshot.docs.map((doc) {
        return MachineRecordModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null);
      }).toList();
    }catch(e) {
      debugPrint("Error in firestore machineRecordDataSource");
      return null;
    }
  }
}