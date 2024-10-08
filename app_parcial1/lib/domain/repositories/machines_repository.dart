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

  Future<void> updateInyectMoldMachine(InjectionMolding machine);
  Future<void> updateCrusherMachine(Crusher machine);

}