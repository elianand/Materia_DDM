import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/machine_model.dart';

class FirebaseMachineDataSource {

  final FirebaseFirestore _firestore;
  final FirebaseStorage _firestorange;

  FirebaseMachineDataSource(this._firestore, this._firestorange);


  Future<void> updateMachine(MachineModel machine) async {

    try {    
      final querySnapshot = await _firestore
        .collection("machine")
        .where("id", isEqualTo: machine.id)
        .get();

      if (querySnapshot.docs.isEmpty) {return;}

      final machineDoc = querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>;

      await machineDoc.reference.update(machine.toFirestore());
    }catch(e) {
      debugPrint("Error in firestore machineDataSource");
      return;
    }
  }


  Future<void> deleteMachineImageWithPath(String path) async {

    try {
      final imageRef = _firestorange.ref().child(path);
      await imageRef.delete();
    }catch(e) {
      debugPrint("Error in firestore machineDataSource");
      return;
    }
  }

  Future<Map<String, String>> setImageToMachineWithId(int machineId, XFile image) async {
    
    try {
      final storageRef =  _firestorange.ref();
      final imagePath = "images/machine_${machineId}_${DateTime.now()}.png";
      final imagesRef = storageRef.child(imagePath);

      await imagesRef.putFile(File(image.path));

      final downloadURL = await imagesRef.getDownloadURL();

      return {
        "imagePath" : imagePath,
        "downloadURL" : downloadURL,
      };

    }catch(e) {
      debugPrint("Error in firestore machineDataSource");
      return {};
    }
  }


  Future<List<MachineModel>?> getMachinesByIdComp(int idComp) async {
    
    try{

      final querySnapshot = await _firestore
        .collection('machine')
        .where('idComp', isEqualTo: idComp)
        .get();


      if (querySnapshot.docs.isEmpty) {return null;}
      

      final machineList = querySnapshot.docs.map((doc) {
        return MachineModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null);
      }).toList();
          
      return machineList;
      
    }catch(e) {
      debugPrint("Error in firestore machineDataSource");
      return null;
    }
  }
}