




import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../theme/providers/general_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Necesario para manejar archivos de imagen
//import 'package:path_provider/path_provider.dart'; // Para obtener el directorio local
import 'package:path/path.dart'; // Para manejar rutas de archivos


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
  String? _imagePath;
  File? _imageFile; // Imagen seleccionada
  
  // Características específicas
  int? _temp;
  int? _pressure;
  int? _speed;
  int? _capacity;


  final ImagePicker _picker = ImagePicker();


  Future<void> _pickImage() async {
    
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      
      _imageFile = File(pickedFile.path);
      String? imagePath = await _saveImageToLocalDirectory(_imageFile!);
      
      setState(() {
        _imagePath = imagePath;
      });

      // Aca vamos a esperar a que se guarda la imagen en el directorio local
    }
  }

  Future<String?> _saveImageToLocalDirectory(File imageFile) async {
    try {

      // Aca vamos a obtener el directorio local donde se guardaran los archivos
      final directory = await getApplicationDocumentsDirectory();

      final imageName = basename(imageFile.path);

      final imageFolderPath = '${directory.path}/assets/images';
      final imagePath = '$imageFolderPath/$imageName';

      // Crear una subcarpeta llamada 'images' dentro del directorio de la app
      final imageDirectory = Directory(imageFolderPath);
      if (!await imageDirectory.exists()) {
        await imageDirectory.create(recursive: true);
      }

      //_imagePath = imagePath;

      // Copiamos la imagen seleccionada al directorio local
      await imageFile.copy(imagePath);

      log('Imagen guardada en: $imagePath');


      // Esta es la ruta absoluta
      return imagePath;
    } catch (e) {
      log('Error al guardar la imagen: $e');
      return null;
    }
  }

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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                
                const SizedBox(height: 10),

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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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


                const SizedBox(height: 30),


                // Marca
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Brand'),
                  onSaved: (value) => _brand = value,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter brand' : null,
                ),
                
                const SizedBox(height: 30),

                // Descripción
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter description'
                      : null,
                ),

                const SizedBox(height: 30),


                // Botón para seleccionar imagen                 
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                
                const SizedBox(width: 16),
                if (_imageFile != null)
                  const Text(
                    'Image Selected',
                    style: TextStyle(color: Colors.green),
                  )
                else
                  const Text(
                    'No Image Selected',
                    style: TextStyle(color: Colors.red),
                  ),


                const SizedBox(height: 16),

                // Vista previa de la imagen seleccionada
                if (_imageFile != null) 
                  Center(
                    
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: /*Image.file(
                        _imageFile!,
                        height: 150,
                      ),*/
                      Image.file(
                        File(_imagePath ?? ""), 
                        height: 200,
                        
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        
                          return Image.asset(
                            "assets/images/Type_NotFound.webp",
                            height: 200,
                            //color: Colors.red,
                          );
                        },
                      )
                    ),
                  ),




                const SizedBox(height: 30),

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
                                ref.read(machinesDataProvider.notifier).insertInjMoldMachine(idType, _brand!, _description!, _temp!, _pressure!, _imagePath);
                              } else if (_machineType == 'Crusher') {
                                idType = 2;
                                ref.read(machinesDataProvider.notifier).insertCrusherMachine(idType, _brand!, _description!, _capacity!, _speed!, _imagePath);
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
              
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

}