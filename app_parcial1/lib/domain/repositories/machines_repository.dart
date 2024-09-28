import 'package:app_parcial1/domain/models/machine.dart';


//injectionMolding
//crusher
abstract class MachinesRepository {

  //Funciones generalmente para cargar la base de datos
  Future<List<Machine>> getMachines();
  Future<List<InjectionMolding>> getInjMoldMachines();
  Future<List<Crusher>> getCrusherMachines();

  Future<List<Machine>?> getMachinesByIdComp(int idComp);
  Future<List<InjectionMolding>> getInyectMoldMachineByIdComp(int idComp);
  Future<List<Crusher>> getCrusherMachineByIdComp(int idComp);
  Future<List<Machine>> getMachineByIdCompAndIdType(int idComp, int idType);

  Future<Machine?> getMachineById(int id);
  Future<InjectionMolding?> getInyectMoldMachineById(int id);
  Future<Crusher?> getCrusherMachineById(int id);

  Future<List<int>> getAllMachineIds();

  Future<void> insertMachine(Machine machine);
  Future<void> updateMachine(Machine machine);

  Future<void> deleteMachine(int id);
  Future<void> deleteInjMoldMachine(int id);
  Future<void> deleteCrusherMachine(int id);

  Future<void> insertInjMoldMachine(InjectionMolding machine);
  Future<void> insertCrusherMachine(Crusher machine);

  /*
  final machineList = [

    // Company 1
    InjectionMolding(
      id: 1,
      idType: MachinesEnum.injectionMolding,
      idComp: 1,
      brand: "Mitsubishi",
      description: 'Red, 500 Ton', 
      temp: 200, 
      pressure: 150,
      posterUrl: "assets/images/InjMoldMachine.webp"
    ),
    Crusher(
      id: 2,
      idType: MachinesEnum.crusher,
      idComp: 1,
      brand: "Angry Tooth",
      description: 'Old, 5000 rpm', 
      speed: 5000, 
      capacity: 1000

    ),
    InjectionMolding(
      id: 3,
      idType: MachinesEnum.injectionMolding,
      idComp: 1,
      brand: "Techmation",
      description: 'Green, 1500 Ton', 
      temp: 210, 
      pressure: 200
    ),
    InjectionMolding(
      id: 4,
      idType: MachinesEnum.injectionMolding,
      idComp: 1,
      brand: "Techmation",
      description: 'Grey, 400 Ton', 
      temp: 190, 
      pressure: 100
    ),


    // Company 2
    InjectionMolding(
      id: 5,
      idType: MachinesEnum.injectionMolding,
      idComp: 2,
      brand: "Rocem",
      description: 'Yellow, 600 Ton', 
      temp: 210, 
      pressure: 160
    ),
    Crusher(
      id: 6,
      idType: MachinesEnum.crusher,
      idComp: 2,
      brand: "Angry Tooth",
      description: 'New, 8000 rpm', 
      speed: 8000, 
      capacity: 2000
    ),
    InjectionMolding(
      id: 7,
      idType: MachinesEnum.injectionMolding,
      idComp: 2,
      brand: "Techmation",
      description: 'Black, 700 Ton', 
      temp: 220, 
      pressure: 220
    ),
    InjectionMolding(
      id: 8,
      idType: MachinesEnum.injectionMolding,
      idComp: 2,
      brand: "Techmation",
      description: 'Blue, 600 Ton', 
      temp: 160, 
      pressure: 150
    ),
  ];

  Future<List<Machine>> getMachinesByIdComp(int idComp) async{
    return await Future.delayed(const Duration(seconds: 5), () {
      return machineList;
    });
  }

  */
}