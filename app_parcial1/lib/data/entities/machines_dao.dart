import 'package:floor/floor.dart';

import '../../domain/models/machine.dart';


@dao
abstract class MachinesDao {
  
  
  @Query('SELECT * FROM Machine')
  Future<List<Machine>> findAllMachines();

  @Query('SELECT * FROM InjectionMolding')
  Future<List<InjectionMolding>> findAllInjMoldMachines();

  @Query('SELECT * FROM Crusher')
  Future<List<Crusher>> findAllCrusherMachines();





  @Query('SELECT * FROM Machine WHERE id = :id')
  Future<Machine?> findMachineById(int id);

  @Query('SELECT * FROM InjectionMolding WHERE id = :id')
  Future<InjectionMolding?> findInyectMoldMachineById(int id);

  @Query('SELECT * FROM Crusher WHERE id = :id')
  Future<Crusher?> findCrusherMachineById(int id);







  @Query('SELECT * FROM Machine WHERE idComp = :idComp')
  Future<List<Machine>?> findMachinesByIdComp(int idComp);

  @Query('SELECT * FROM Machine WHERE idComp = :idComp and idType = :idType')
  Future<List<Machine>> findMachineByIdCompAndIdType(int idComp, int idType);


  
  @Query('SELECT i.* FROM InjectionMolding i INNER JOIN Machine m ON m.id = i.id WHERE m.idType = 1 AND m.idComp = :idComp')
  Future<List<InjectionMolding>> findInyectMoldMachineByIdComp(int idComp);

  @Query('SELECT c.* FROM Crusher c INNER JOIN Machine m ON m.id = c.id WHERE m.idType = 2 AND m.idComp = :idComp')
  Future<List<Crusher>> findCrusherMachineByIdComp(int idComp);
  

  @Query('SELECT id FROM Machine')
  Future<List<int>> findAllMachineIds();




  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMachine(Machine machine);

  //@Insert(onConflict: OnConflictStrategy.ignore)
  //Future<void> insertMovieGenres(List<MovieToGenre> movieGenres);

  @Query('DELETE FROM Machine WHERE id = :id')
  Future<void> deleteMachine(int id);

  @Query('DELETE FROM InjectionMolding WHERE id = :id')
  Future<void> deleteInjMoldMachine(int id);

  @Query('DELETE FROM Crusher WHERE id = :id')
  Future<void> deleteCrusherMachine(int id);



  @update
  Future<void> updateMachine(Machine machine);

  //@Query('SELECT * FROM Genre')
  //Future<List<Genre>> getGenres();


  @insert
  Future<void> insertInjMoldMachine(InjectionMolding machine);

  @insert
  Future<void> insertCrusherMachine(Crusher machine);



  @Query('UPDATE InjectionMolding SET temp = :temp, pressure = :pressure, produced = :produced WHERE id = :id')
  Future<void> updateInyectMoldMachineById(int id, int temp, int pressure, int produced);

  @Query('UPDATE Crusher SET active = :active WHERE id = :id')
  Future<void> updateCrusherMachineById(int id, int active);

  

  @update
  Future<void> updateInyectMoldMachine(InjectionMolding machine);

  @update
  Future<void> updateCrusherMachine(Crusher machine);
}
