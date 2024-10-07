import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user.dart';
import '../../theme/providers/general_provider.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
    
  const UserDetailsScreen({Key? key});

  //const MachinesScreen({Key? key, this.user}) : super(key: key);


  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  
  late final User user;

  @override
  void initState() {
    super.initState();
    
    //machinesFuture = JsonMachinesRepository().getMachines();  // Base de datos no relacional
    
    user = ref.read(userDataProvider);
  }

  //const _UserDetailsScreenState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Avatar con la inicial del nombre
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Text(
                user.name[0], // Letra inicial del nombre
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40), // Espacio entre avatar y la info
            // Información del usuario centrada horizontalmente
            _buildUserInfo('ID User:', user.idUser.toString()),
            _buildUserInfo('ID Company:', user.idComp.toString()),
            _buildUserInfo('Name:', user.name),
            _buildUserInfo('Email:', user.email),
            _buildUserInfo('Password:', user.password), // Mostrar password no recomendado
            _buildUserInfo('Age:', user.age?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}

// Método helper para mostrar la información del usuario centrada
Widget _buildUserInfo(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centrar horizontalmente
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8), // Espacio entre el título y el valor
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}