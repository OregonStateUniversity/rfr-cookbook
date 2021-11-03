import 'package:flutter/material.dart';
import 'models/user.dart';
import 'styles.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login', style: Styles.navBarTitle),
        backgroundColor: Styles.navBarColor
        ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email.';
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password.';
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: ElevatedButton(
                    style: Styles.buttonStyle,
                    child: Text('Login', style: Styles.buttonText),
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}