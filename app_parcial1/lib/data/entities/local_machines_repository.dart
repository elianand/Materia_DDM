import '../../domain/models/machine.dart';
import '../../domain/repositories/machines_repository.dart';
import '../../main.dart';
import 'machines_dao.dart';

class LocalMachinesRepository implements MachinesRepository {
  
  final MachinesDao _machinesDao = database.machinesDao;

  @override
  Future<List<Machine>> getMachines() {
    return _machinesDao.findAllMachines();
  }

  @override
  Future<List<InjectionMolding>> getInjMoldMachines() {
    return _machinesDao.findAllInjMoldMachines();
  }

  @override
  Future<List<Crusher>> getCrusherMachines() {
    return _machinesDao.findAllCrusherMachines();
  }




  @override
  Future<Machine?> getMachineById(int id) {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        return _machinesDao.findMachineById(id);
      },
    );
  }

  @override
  Future<InjectionMolding?> getInyectMoldMachineById(int id) {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        return _machinesDao.findInyectMoldMachineById(id);
      },
    );
  }

  @override
  Future<Crusher?> getCrusherMachineById(int id) {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        return _machinesDao.findCrusherMachineById(id);
      },
    );
  }





  @override
  Future<List<Machine>?> getMachinesByIdComp(int idComp) {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        return _machinesDao.findMachinesByIdComp(idComp);
      },
    );
  }

  @override
  Future<List<Machine>> getMachineByIdCompAndIdType(int idComp, int idType) {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        return _machinesDao.findMachineByIdCompAndIdType(idComp, idType);
      },
    );
  }

  @override
  Future<List<InjectionMolding>> getInyectMoldMachineByIdComp(int idComp) {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        return _machinesDao.findInyectMoldMachineByIdComp(idComp);
      },
    );
  }

  @override
  Future<List<Crusher>> getCrusherMachineByIdComp(int idComp) {
    return Future.delayed(
      const Duration(seconds: 2), () async {
        return _machinesDao.findCrusherMachineByIdComp(idComp);
      },
    );
  }


  @override
  Future<List<int>> getAllMachineIds() {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        return _machinesDao.findAllMachineIds();
      },
    );
  }
  



  @override
  Future<void> insertMachine(Machine machine) {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        return _machinesDao.insertMachine(machine);
      },
    );
  }

  @override
  Future<void> updateMachine(Machine machine) async {
    return _machinesDao.updateMachine(machine);
  }

  @override
  Future<void> updateInyectMoldMachine(InjectionMolding machine) async {
    return _machinesDao.updateInyectMoldMachine(machine);
  }

  @override
  Future<void> updateCrusherMachine(Crusher machine) async {
    return _machinesDao.updateCrusherMachine(machine);
  }


  @override
  Future<void> insertInjMoldMachine(InjectionMolding machine) {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        return _machinesDao.insertInjMoldMachine(machine);
      },
    );
  }

  @override
  Future<void> insertCrusherMachine(Crusher machine) {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        return _machinesDao.insertCrusherMachine(machine);
      },
    );
  }



  @override
  Future<void> deleteMachine(int id) {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        return _machinesDao.deleteMachine(id);
      },
    );
  }

  @override
  Future<void> deleteInjMoldMachine(int id) {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        return _machinesDao.deleteInjMoldMachine(id);
      },
    );
  }

  @override
  Future<void> deleteCrusherMachine(int id) {
    return Future.delayed(
      const Duration(seconds: 1), () async {
        return _machinesDao.deleteCrusherMachine(id);
      },
    );
  }

}
