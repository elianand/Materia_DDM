class Machine {

  final int id;
  final String idType;
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
  
  
  String? state;

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

  Machine({
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

}