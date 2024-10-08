import "package:floor/floor.dart";


enum MachinesEnum {injectionMolding, crusher}

@entity
class Machine {

  @primaryKey
  final int id;

  final int idType;
  final int idComp;
  String? brand;
  String? description;
  String? posterUrl;


  Machine({
    required this.id,
    required this.idType,
    required this.idComp,
    this.brand,
    this.description,
    this.posterUrl
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      idType: json['idType'],
      idComp: json['idComp'],
    );
  }
}

@entity
class InjectionMolding{
  
  @primaryKey
  final int id;

  final String brand;
  final String description;
  final String? posterUrl;
  final int temp;
  final int pressure;
  final int produced;
  
  InjectionMolding({
    required this.id,
    required this.brand, 
    required this.description,
    this.posterUrl,

    required this.temp,
    required this.pressure, 
    required this.produced,
  });


  factory InjectionMolding.fromJson(Map<String, dynamic> json) {
    return InjectionMolding(
      id: json['id'],
      brand: json['brand'],
      description: json['description'],
      temp: json['temp'],
      pressure: json['pressure'],
      posterUrl: json['posterUrl'],
      produced: 0,      
    );
  }
}

@Entity(tableName: 'Crusher')
class Crusher{
  
  @primaryKey
  final int id;

  
  final String brand;
  final String description;
  final String? posterUrl;
  final int speed;
  final int capacity;
  final int active;
  
  Crusher({
    required this.id,
    required this.brand, 
    required this.description,
    this.posterUrl,
    required this.speed,
    required this.capacity,
    required this.active, 
  });

  bool isActive() {
    return active == 1 ? true : false;
  }


  factory Crusher.fromJson(Map<String, dynamic> json) {
    return Crusher(
      id: json['id'],
      brand: json['brand'],
      description: json['description'],
      speed: json['speed'],
      capacity: json['capacity'],
      posterUrl: json['posterUrl'],
      active: 0,
    );
  }
}

