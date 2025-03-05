class MachineRecord {

  final int id;
  final int idMachine;
  final String timestamp;
  final String idEvent;
  final int? value;

  MachineRecord({
    required this.id,
    required this.idMachine,
    required this.timestamp,
    required this.idEvent,
    this.value,
  });

}