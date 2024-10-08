import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user.dart';
import '../../providers/general_provider.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  UserDetailsScreenState createState() => UserDetailsScreenState();
}

class UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  
  late final User user;

  @override
  void initState() {
    super.initState();
    
    user = ref.read(userDataProvider);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                user.name[0],
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),
            ),

            // Espacio entre avatar y la info
            const SizedBox(height: 40), 

            // Información del usuario centrada horizontalmente
            _buildUserInfo('ID User:', user.idUser.toString()),
            _buildUserInfo('ID Company:', user.idComp.toString()),
            _buildUserInfo('Name:', user.name),
            _buildUserInfo('Email:', user.email),
            _buildUserInfo('Password:', user.password),
            _buildUserInfo('Age:', user.age?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}


Widget _buildUserInfo(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}