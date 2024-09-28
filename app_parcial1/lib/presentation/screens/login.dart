import 'package:app_parcial1/domain/repositories/users_repository.dart';
import 'package:app_parcial1/theme/providers/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:app_parcial1/domain/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';




import '../../domain/models/machine.dart';






// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Final es siempre constante en toda la ejecucion
  // Constante es solo en tiempo de compilacion
  String parameter = "";
  

  // BORRAR
  late final Future<List<Machine>> machinesFuture;



  List<User> users = usersList;

  

  // Final nos dice que no podemos cambiar la referencia a esta variable
  final TextEditingController _inputEmail = TextEditingController(text: "elian@gmail.com");
  final TextEditingController _inputPass = TextEditingController(text: "pass");



  /// ACA FALTA AGREGAR COMPROBACION DE QUE SE ESCRIBIO EL @
  /// AUTOCOMPLETADO DE MAIL
  /// VALIDACION DE DATOS
  /// EN CASO DE QUE SEAN ERRONEOS PINTAR LA CASILLA DE ROJO



  @override
  Widget build(BuildContext context) {

    // BORRAR
    //machinesFuture = LocalMachinesRepository().getMachines();
    //print(machinesFuture);
    
    final textStyle = Theme.of(context).textTheme;

    return _LoginView(textStyle: textStyle, inputEmail: _inputEmail, inputPass: _inputPass, users: users);
  }
}



Future<String> getString() {
  return Future.delayed(const Duration(seconds: 2), () {
    return "Hola mundo";
  });
}



class _LoginView extends ConsumerWidget {
  _LoginView({
    super.key,
    required this.textStyle,
    required TextEditingController inputEmail,
    required TextEditingController inputPass,
    required this.users,
  }) : _inputEmail = inputEmail, _inputPass = inputPass;

  final TextTheme textStyle;
  final TextEditingController _inputEmail;
  final TextEditingController _inputPass;
  final List<User> users;

  

  //appTheme.getTheme()


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appTheme = ref.watch(themeNotifierProvider);


    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: Scaffold(
        backgroundColor:(appTheme.isLigthMode()) ? Colors.white : Colors.black,
        /*appBar: AppBar(
          title: const Text("Pantalla de login"),
        ),*/
      
        // SingleChildScrollView necesario para no taparse
        // En la escritura cuando se abre el teclado
        body: SingleChildScrollView(
          
          child: Container(
            // Necesario para que el contenedor ocupe toda la pantalla
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                
                colors: (appTheme.isLigthMode()) ? (<Color>[
                  Color(0xff41C9E2),
                  Color(0xffACE2E1),
                  Color(0xffffffff),
                ]) // Gradient from https://learnui.design/tools/gradient-generator.html
                : (
                <Color>[
                  Color(0xff450f29),
                  Color(0xff1b1320),
                  Color(0xff16131e),
                ]),

                tileMode: TileMode.mirror,
              ),
            ),
            child: Padding (
              padding: const EdgeInsets.all(20.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  //const Icon(Icons.account_circle, size: 150.0,),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Icon(Icons.account_circle, size: 130.0, color: (appTheme.isLigthMode()) ? Colors.cyan[50] : Colors.cyan[800],),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text("Inicio de sesion", style: textStyle.titleLarge,),
                  ),
          
          
          
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                    child: TextFormField(

                      style: TextStyle(color: (appTheme.isLigthMode()) ? Colors.black : Colors.white),

                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.lightBlueAccent,
                      //onEditingComplete: ()=> TextInput.finishAutofillContext(),
                      
                      decoration: InputDecoration( 
                        filled: true,
                        fillColor: (appTheme.isLigthMode()) ? Colors.white : Colors.blueGrey[900],  
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ), 
                        suffixIcon: const Icon(Icons.email, color: Colors.blue),
                        //icon: Icon(Icons.email,color: Colors.blue,),
                        hintText: "Escribe tu email",
                        hintStyle: const TextStyle(color: Colors.lightBlueAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 40, 172, 161), width: 2.0), // Borde gris cuando está en foco
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                        //border: OutlineInputBorder(
                        //  borderRadius: BorderRadius.circular(10),
                        //),
                      
          
                      onChanged: (value){
                        //user.username=value;
                      },
                      
                      validator: (String? value) {
                        return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                      },
      
          
                      
                  
                    
                      
                      controller: _inputEmail,
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
                    child: TextField(
      
                      style: TextStyle(color: (appTheme.isLigthMode()) ? Colors.black : Colors.white),
                      
                      keyboardType: TextInputType.visiblePassword,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.lightBlueAccent,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      //onEditingComplete: ()=> TextInput.finishAutofillContext(),
                      decoration: InputDecoration( 
                        filled: true,
                        fillColor: (appTheme.isLigthMode()) ? Colors.white : Colors.grey[900], 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ), 
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.password_rounded, color: Colors.blue),
                          onPressed: () {
                            // Aca se puede agregar la accion de que se oculte el texto
                          },
                        ),
                        
                        hintText: "Escribe tu contraseña",
                        //hintStyle: const TextStyle(color: Colors.lightBlueAccent),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color:  Color.fromARGB(255, 40, 172, 161), width: 2.0), // Borde gris cuando está en foco
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
      
                      controller: _inputPass,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: SizedBox(
                      width: 150.0,
                      child: FilledButton(
                        
                        /*
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(Color(0xffff0660)),
                          textStyle: WidgetStatePropertyAll(
      TextStyle(fontSize: 24), // Cambia el tamaño de la fuente aquí
    ),
                        ),*/
                        style: FilledButton.styleFrom(
                          //textStyle: TextStyle(fontSize: 20), // Cambia el tamaño de la fuente
                          backgroundColor: (appTheme.isLigthMode()) ? Colors.blue : const Color(0xffff0660),       // Cambia el color de fondo
                        ),

                        onPressed: () {
                            
                          
                          /*
                          User user = User(
                            id: '1',
                            name: "Elian",
                            email: "gmail.com",
                            password: "pass",
                            age: 30,
                          );
                          
                          debugPrint(user.greet());
                          */
                            
                          // Una forma 
                          //context.push('/home/${parameter}');
                          if(_inputEmail.text.isEmpty & _inputPass.text.isEmpty) {
                            const snackBar = SnackBar(
                              content: Text('Campos vacios'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
                            
                          if(_inputEmail.text.isEmpty) {
                            const snackBar = SnackBar(
                              content: Text('Campo Email vacio'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
                            
                          if(_inputPass.text.isEmpty) {
                            const snackBar = SnackBar(
                              content: Text('Campo Pass vacio'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
      
                          User? user = users.firstWhereOrNull((elem) => elem.email == _inputEmail.text);
                          
                          if(user == null) {
                            const snackBar = SnackBar(
                              content: Text('Email erroneo'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
      
                          if(user.password == _inputPass.text) {
                            ref.read(userDataProvider.notifier).ingresoDeUsuario(user);
                            context.replace('/machineTypes');
                          }else {
                            const snackBar = SnackBar(
                              content: Text('Email erroneo'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
      
      
                          /*
                          bool elementoEncontrado = false;
                          users.forEach((elemt) {
                            if(elemt.checkEmail(_inputEmail.text)) {
                              elementoEncontrado = true;
                            }
                          });
                          if(elementoEncontrado == false) {
                            
                          }
                          
                          users.forEach((elemt) {
                            if(elemt.checkPass(_inputPass.text)) {
                              context.replace('/machine', extra: elemt);
                              elementoEncontrado = true;
                            }
                          });
                          if(elementoEncontrado == false) {
                            const snackBar = SnackBar(
                              content: Text('Email erroneo'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
                          */
                            
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}