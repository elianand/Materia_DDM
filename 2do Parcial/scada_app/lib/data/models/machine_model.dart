import 'package:cloud_firestore/cloud_firestore.dart';


enum MachinesTypeE {injectionMolding, crusher}
enum MachineStatusE {onState, offState, activeState, detachState}

class MachineModel {

  final int id;
  final MachinesTypeE idType;
  final int idComp;
  final String name;
  final String brand;
  final String description;
  String? imageUrl;
  String? imagePath;
  final int maxProduce;
  final int maxCapacity;
  final int maxPreassure;
  final int maxSpeed;
  bool attach;


  // --  Variables no constantes
  
  
  MachineStatusE? state;

  // Caracteristicas de Injection Mold
  double? prodPerHour;
  double? productivity;
  int? produced;
  int? stateTime;
  
  List<double> tempOverTimeX = [];
  List<double> tempOverTimeY = [];

  List<double> prodOverTimeX = [];
  List<double> prodOverTimeY = [];

  double? timeActive;
  double? timeOffline;
  double? timeOnline;

  double? porcActive;
  double? porcOffline;
  double? porcOnline;

  MachineModel({
    required this.id,
    required this.idType,
    required this.idComp,
    required this.name,
    required this.brand,
    required this.description,
    required this.maxProduce,
    required this.maxCapacity,
    required this.maxPreassure,
    required this.maxSpeed,
    required this.attach,
    this.imageUrl,
    this.imagePath,
  });

  String getStatus() {
    if(!attach) {
      return "Detach";
    }
    switch(state) {
      case MachineStatusE.offState:
        return "Offline";
      case MachineStatusE.onState: 
        return "Online";
      case MachineStatusE.activeState: 
        return "Active";
      case MachineStatusE.detachState: 
        return "Detach";
      default: 
        return "Offline";
    }
  }

  MachineStatusE? getStateE() {
    if(!attach) {
      return MachineStatusE.detachState;
    }else {
      return state;
    }
  }

  String getType() {
    switch(idType) {
      case MachinesTypeE.injectionMolding:
        return "Injection molding";
      case MachinesTypeE.crusher: 
        return "Crusher";
      default: 
        return "Unknown";
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'idType': switch(idType) {
        MachinesTypeE.injectionMolding => "injMold",
        MachinesTypeE.crusher => "crusher",
      },
      'idComp' : idComp,
      'name' : name,
      'brand' : brand,
      'desc' : description,
      'maxProduce' : maxProduce,
      'maxCapacity' : maxCapacity,
      'maxSpeed' : maxSpeed,
      'maxPreassure' : maxPreassure,
      if(imageUrl != null )'imageUrl' : imageUrl,
      if(imagePath != null )'imagePath' : imagePath,
      'attach' : attach,
    };
  }

  static MachineModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return MachineModel(
      id: data?['id'] ?? 0,
      idType: switch(data?['idType'] ?? "injMold") {
        "injMold" => MachinesTypeE.injectionMolding,
        "crusher" => MachinesTypeE.crusher,
        _  => MachinesTypeE.injectionMolding,
      },
      idComp: data?['idComp'] ?? 0,
      name: data?['name'] ?? "none",
      brand: data?['brand'] ?? "none",
      description: data?['desc'] ?? "none",
      maxProduce: data?['maxProduce'] ?? 0,
      maxCapacity: data?['maxCapacity'] ?? 0,
      maxSpeed: data?['maxSpeed'] ?? 0,
      maxPreassure: data?['maxPreassure'] ?? 0,
      attach: data?['attach'] ?? false,
      imageUrl: data?['imageUrl'] ?? "",
      imagePath: data?['imagePath'] ?? "",
    );
  }

}