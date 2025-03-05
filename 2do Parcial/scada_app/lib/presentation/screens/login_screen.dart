import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scada_app/presentation/utils/base_screen_state.dart';

import '../../core/providers/providers.dart';
import '../widgets/my_snackbar_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();



  @override
  void dispose() {
    super.dispose();
    
    _emailController.dispose();
    _passwordController.dispose();
  }


  @override
  void initState() {
    super.initState();

    

    WidgetsBinding.instance.addPostFrameCallback((_)  {

      ref.read(loginProvider.notifier).isUserLogin();

    });
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
                    'assets/images/login_image.jpg',
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
                    
                    const SizedBox(height: 40),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
              
              
                    // Campo de email
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter email';
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
                    const SizedBox(height: 30),
              
              
                    // Campo de password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Enter password';
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
                    const SizedBox(height: 85),
              
              
              
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
                            if(ref.watch(loginProvider).screenState == BaseScreenState.loading) {
                              null;
                            }else {
                              ref.watch(loginProvider.notifier).login(_emailController.text, _passwordController.text);
                              
                            }
                          }
                        },
                        child: Builder(builder: (context) {
                          final provider = ref.watch(loginProvider);
              
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
                              
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if(ref.watch(loginProvider).loginSuccess) {
                                  if(ref.watch(loginProvider).createAccount) {
                                    context.replace("/createAccount");
                                  }else {
                                    context.replace("/machineTypes");
                                  }
                                }
                              });
                              
                              return const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              );
                            case BaseScreenState.error:

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final scaffoldMessenger = ScaffoldMessenger.of(context);

                                scaffoldMessenger.clearSnackBars();
                                String mesj = "Error! ${provider.error}";

                                scaffoldMessenger.showSnackBar(mySnackbar(mesj));
                              });

                              return const Text(
                                'Continue',
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