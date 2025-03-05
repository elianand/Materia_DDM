import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import '../../core/providers/providers.dart';
import '../utils/base_screen_state.dart';


class UserDetailsScreen extends ConsumerStatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  UserDetailsScreenState createState() => UserDetailsScreenState();
}

class UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {

  @override
  void initState() {
    super.initState();

    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      ref.read(userDetailProvider.notifier).getUser();
      
    });
  }


  @override
  Widget build(BuildContext context) {

    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();
    

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Builder(builder: (context) {
        final userProvider = ref.watch(userDetailProvider);

        switch(userProvider.screenState) {
          case BaseScreenState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case BaseScreenState.idle:
            final user = userProvider.userModel;
            return userScreenWidget(context, isThemeLight, user);
          case BaseScreenState.error:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      }),
      
      
      
    );
  }

  Widget userScreenWidget(BuildContext context, bool isThemeLight, UserModel? user) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Perfil
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueAccent,
              child: Text(
                user?.name[0].toUpperCase() ?? "N",
                
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
            ),


            SizedBox(height: 10),
            Text(
              '${user?.name} ${user?.lastname}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Text(
              '@${user?.username}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            
            SizedBox(height: 20),
            // Información del usuario
            _buildInfoTile(
              context,
              icon: Icons.email,
              label: 'Email',
              value: user?.email ?? "NaN",
            ),
            _buildInfoTile(
              context,
              icon: Icons.person,
              label: 'Username',
              value: user?.username ?? "NaN",
            ),
            _buildInfoTile(
              context,
              icon: Icons.flag,
              label: 'Country',
              value: user?.country ?? "NaN",
            ),
            
            _buildInfoTile(
              context,
              icon: Icons.phone,
              label: 'Phone number',
              value: user?.phoneNum ?? "NaN",
            ),

            SizedBox(height: 20),

             // Sección de Nivel de Acceso
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: isThemeLight? Colors.blueAccent.withOpacity(0.1) : Colors.greenAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock, 
                    color: isThemeLight? Colors.blueAccent : Colors.greenAccent,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Access level: ${user?.getAccessLevelStr() ?? "No especificado"}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isThemeLight? Colors.blueAccent : Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildInfoTile(BuildContext context, {required IconData icon, required String label, required String value, bool isDropdown = false}) {
    
    final isThemeLight = ref.watch(themeNotifierProvider).isLigthMode();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(label),
        subtitle: Text(value),
        trailing: isDropdown ? Icon(Icons.arrow_drop_down) : null,
        tileColor: isThemeLight? Colors.grey.shade300 : Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
