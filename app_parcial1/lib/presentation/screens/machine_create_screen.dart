import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/providers/general_provider.dart';

class CreateMachineScreen extends ConsumerStatefulWidget {
  const CreateMachineScreen({super.key});

  @override
  _CreateMachineScreenState createState() => _CreateMachineScreenState();
}

class _CreateMachineScreenState extends ConsumerState<CreateMachineScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _machineType; // Puede ser "Injection Molding" o "Crusher"
  String? _brand;
  String? _description;
  
  // Características específicas
  int? _temp;
  int? _pressure;
  int? _speed;
  int? _capacity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Machine'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.replace('/machineTypes');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Tipo de máquina
                const Text('Select the machine type:'),
                DropdownButtonFormField<String>(
                  value: _machineType,
                  hint: const Text('Machine type'),
                  onChanged: (value) {
                    setState(() {
                      _machineType = value;
                    });
                  },
                  items: ['Injection Molding', 'Crusher']
                      .map((elem) => DropdownMenuItem(
                            value: elem,
                            child: Text(elem),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Please, select the type' : null,
                ),
                const SizedBox(height: 16),

                // Marca
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Brand'),
                  onSaved: (value) => _brand = value,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter brand' : null,
                ),
                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter description'
                      : null,
                ),
                const SizedBox(height: 16),

                // Características según el tipo de máquina
                if (_machineType == 'Injection Molding') ...[
                  // Para inyección
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Temperature [°C]'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _temp = int.tryParse(value!),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Enter temperature';
                      }
                      if(int.tryParse(value) == null){
                        return 'Enter a number';
                      }
                      return null; 
                    }
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Pressure [bar]'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _pressure = int.tryParse(value!),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Enter pressure';
                      }
                      if(int.tryParse(value) == null){
                        return 'Enter a number';
                      }
                      return null; 
                    }
                  ),
                ] else if (_machineType == 'Crusher') ...[
                  // Para trituradora
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Speed [RPM]'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _speed = int.tryParse(value!),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Enter speed';
                      }
                      if(int.tryParse(value) == null){
                        return 'Enter a number';
                      }
                      return null; 
                    }
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Capacity [kg]'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _capacity = int.tryParse(value!),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Enter capacity';
                      }
                      if(int.tryParse(value) == null){
                        return 'Enter a number';
                      }
                      return null; 
                    }
                  ),
                ],

                const SizedBox(height: 16),

                // Botón de guardar
                Center(
                  child: Builder(builder: (context) {
                    final machinesProvider = ref.watch(machinesDataProvider);
                  
                    switch(machinesProvider.requestState) {
                      case ProviderState.loading:
                  
                        return IgnorePointer(
                          ignoring: true,
                          child: ElevatedButton(
                          
                            onPressed: () {},
                          
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Save new machine'),
                                SizedBox(width: 10),  // Añade espacio entre el texto y el indicador
                                SizedBox(
                                  height: 20,  // Ajusta el tamaño del CircularProgressIndicator
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ] 
                            ),
                          ),
                        );
                      case ProviderState.success || ProviderState.idle:
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                  
                              int idType = 0;
                              
                              
                              if (_machineType == 'Injection Molding') {
                                idType = 1;
                                ref.read(machinesDataProvider.notifier).insertInjMoldMachine(idType, _brand!, _description!, _temp!, _pressure!);
                              } else if (_machineType == 'Crusher') {
                                idType = 2;
                                ref.read(machinesDataProvider.notifier).insertCrusherMachine(idType, _brand!, _description!, _capacity!, _speed!);
                              }
                  
                              
                            }
                          },
                          child: const Text('Save new machine'),
                        );
                      case ProviderState.error:
                        return ElevatedButton(
                          onPressed: () {},

                          child: const Text('Error'),
                        );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}