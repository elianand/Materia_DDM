import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scada_app/presentation/utils/base_screen_state.dart';

import '../../core/providers/providers.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatePasswordController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();



  @override
  void dispose() {
    super.dispose();
    
    _nameController.dispose();
    _usernameController.dispose();
    _lastnameController.dispose();
    _countryController.dispose();
    _phoneNumController.dispose();
    _ageController.dispose();
    _repeatePasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // Imagen 
            Center(
              child: SizedBox(
                width: 400,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/conectivity.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),


            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    
                    const SizedBox(height: 20),
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),


                    // Campo de name
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter your name';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),


                    // Campo de last name
                    TextFormField(
                      controller: _lastnameController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter your last name';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Last name',
                        hintText: 'Enter your last name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Campo de username 
                    TextFormField(
                      controller: _usernameController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter your username';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
              
              
                    // Campo de email
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter your email';
                        }
                        if(!value.contains("@")){
                          return 'Invalid email';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email account',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),


                    // Campo de country
                    TextFormField(
                      controller: _countryController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter your country';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Country',
                        hintText: 'Enter your country',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),


                    // Campo de phone
                    TextFormField(
                      controller: _phoneNumController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter your phone number';
                        }
                        if(int.tryParse(value) == null){
                          return 'Enter a number';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone num',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Campo de age
                    TextFormField(
                      controller: _ageController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter your age';
                        }
                        if(int.tryParse(value) == null){
                          return 'Enter a number';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Age',
                        hintText: 'Enter your age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
              
              
                    // Campo de password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter password';
                        }
                        if(value.length < 6){
                          return 'Password must be at least 6 characters';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          // Cambiar el valor de _isObscure al presionar el ícono
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      
                    ),
                    const SizedBox(height: 15),


                     // Campo de repeate password
                    TextFormField(
                      controller: _repeatePasswordController,
                      obscureText: true,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter password';
                        }
                        if(value != _passwordController.text){
                          return 'Password do not match';
                        }
                        return null; 
                      },
                      decoration: InputDecoration(
                        labelText: 'Repeate password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      
                    ),
                    const SizedBox(height: 60),
              
              
              
                    // Botón de continuar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: () {
                          
                          if (_formKey.currentState!.validate()) {
                            if(ref.watch(createAccountProvider).screenState == BaseScreenState.loading) {
                              null;
                            }else {
                              ref.watch(createAccountProvider.notifier).createAccount(
                                _nameController.text,
                                _usernameController.text,
                                _lastnameController.text,
                                _countryController.text,
                                _phoneNumController.text,
                                _ageController.text,
                                _emailController.text,
                                _passwordController.text,
                                );
                              
                            }
                          }
                        },
                        child: Builder(builder: (context) {
                          final provider = ref.watch(createAccountProvider);
              
                          switch(provider.screenState) {
                            case BaseScreenState.loading:
                              return SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              );
                            case BaseScreenState.idle:
                              if(ref.watch(createAccountProvider).accountCreated) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  context.replace("/machineTypes");
                                });
                              }
                              return const Text(
                                'Create account',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              );
                            case BaseScreenState.error:

                              
                              WidgetsBinding.instance.addPostFrameCallback((_)  {
                                
                                final scaffoldMessenger = ScaffoldMessenger.of(context);

                                scaffoldMessenger.clearSnackBars();

                                // Muestra el nuevo snackbar
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Machine created!'),
                                    duration: Duration(seconds: 2), // Duración de 2 segundos
                                    behavior: SnackBarBehavior.floating, // Permite que el snackbar "flote" en lugar de anclarse
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16), // Bordes redondeados
                                    ),
                                    backgroundColor: Colors.black.withOpacity(0.9), // Fondo oscuro (puedes ajustarlo)
                                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 10), // Separación de 10 del fondo
                                  ),
                                );

                              });
                              

                              
                              return const Text(
                                'Error',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              );
                            
                          }
                        }),
                      ),
                    ),
              
              
                    const SizedBox(height: 40),
              
              
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}