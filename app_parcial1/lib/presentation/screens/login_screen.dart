import 'package:app_parcial1/config/app_theme.dart';
import 'package:app_parcial1/providers/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/login_input_widget.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  
  late final Future userListOk;



  @override
  void initState() {
    super.initState();
    
    userListOk = ref.read(userDataProvider.notifier).getUsersListReady();
  }



  @override
  Widget build(BuildContext context) {
    
    final appTheme = ref.watch(themeNotifierProvider);
    final textStyle = Theme.of(context).textTheme;

    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: Scaffold(
        backgroundColor:(appTheme.isLigthMode()) ? Colors.white : Colors.black,
      
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
                  const Color(0xff41C9E2),
                  const Color(0xffACE2E1),
                  const Color(0xffffffff),
                ]) // Gradient from https://learnui.design/tools/gradient-generator.html
                : (
                <Color>[
                  const Color(0xff450f29),
                  const Color(0xff1b1320),
                  const Color(0xff16131e),
                ]),

                tileMode: TileMode.mirror,
              ),
            ),
            child: FutureBuilder(

              future: userListOk,

              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // Aca vamos a preguntamos si podemos hacer el autologin, esto
                // significa que las credenciales concuerdan
                final bool loginOk = ref.read(userDataProvider.notifier).isAutoLoginOk();

                if(loginOk) {
                  if(mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.replace('/machineTypes');
                    });
                  }
                }
                
                return LoginView(appTheme: appTheme, textStyle: textStyle/*, users: userList*/);
              }
            ),
          ),
        ),
      ),
    );
  }
}



class LoginView extends ConsumerStatefulWidget {
  const LoginView({
    super.key,
    required this.appTheme,
    required this.textStyle,
  });

  final AppTheme appTheme;
  final TextTheme textStyle;

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {


  final TextEditingController _inputEmail = TextEditingController(text: "");
  final TextEditingController _inputPass = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          
          children: [
            
            // Icono de inicio de seccion
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Icon(Icons.account_circle, size: 130.0, color: (widget.appTheme.isLigthMode()) ? Colors.cyan[50] : Colors.cyan[800],),
            ),

            // Texto de inicio de sesion
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text("Login", style: widget.textStyle.titleLarge,),
            ),
                
                
            // InputField del username
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              child: UsernameInputField(controller: _inputEmail),
            ),
            
            // InputField del password
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              child: PasswordInputField(controller: _inputPass),
            ),
            
            // Boton de inicio de session
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: SizedBox(
                width: 150.0,
                child: FilledButton(

                  style: FilledButton.styleFrom(
                    backgroundColor: (widget.appTheme.isLigthMode()) ? Colors.blue : const Color(0xffff0660),       // Cambia el color de fondo
                  ),
            
                  onPressed: () async {
                      
                    if (_formKey.currentState?.validate() ?? false) {
                      // Si el formulario es valido
                      if(ref.read(userDataProvider.notifier).attempLogin(_inputEmail.text, _inputPass.text, true)) {
                        // Si es verdadero el login es correcto
                      if(mounted) {
                        context.replace('/machineTypes');
                      }

                      await ref.read(userDataProvider.notifier).saveCredentials();
                      
                      }else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Incorrect username or password ')),
                        );
                      }
                    }
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
    );
  }
}


