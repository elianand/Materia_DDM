import 'package:flutter/material.dart';

// INPUT DE USERNAME

class UsernameInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const UsernameInputField({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  UsernameInputFieldState createState() => UsernameInputFieldState();
}

class UsernameInputFieldState extends State<UsernameInputField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.lightBlueAccent,

      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.blueGrey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: const Icon(Icons.person, color: Colors.blue),
        label: Text("Username"),
        hintText: "Enter username",
        hintStyle: const TextStyle(color: Colors.lightBlueAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 40, 172, 161), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );
  }
}


// INPUT DE EMAIL
class EmailInputField extends StatefulWidget {
  final TextEditingController controller;


  const EmailInputField({
    super.key,
    required this.controller
  });

  @override
  EmailInputFieldState createState() => EmailInputFieldState();
}

class EmailInputFieldState extends State<EmailInputField> {


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.lightBlueAccent,

      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.blueGrey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: const Icon(Icons.email, color: Colors.blue),
        label: Text("Email"),
        hintText: "Enter email",
        hintStyle: const TextStyle(color: Colors.lightBlueAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 40, 172, 161), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please, enter email';
        } else if (!value.contains('@')) {
          return 'Email must contain @';
        }
        return null;
      },
    );
  }
}





// INPUT DE PASSWORD

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const PasswordInputField({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  PassInputFieldState createState() => PassInputFieldState();
}

class PassInputFieldState extends State<PasswordInputField> {
  
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,

      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.lightBlueAccent,

      obscureText: _isObscure,

      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.blueGrey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.blue,
          ),
          onPressed: () {
            // Cambiar el valor de _isObscure al presionar el ícono
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        label: Text("Password"),
        hintText: "Enter password",
        hintStyle: const TextStyle(color: Colors.lightBlueAccent),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 40, 172, 161), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please, enter password';
        }
        return null;
      },
    );
  }
}
