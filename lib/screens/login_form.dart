import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:rfr_cookbook/styles.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  
  String? _email;
  String? _password;

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
          builder: (context) => _renderForm(context),
        ),
      ),
    );
  }

  Widget _renderForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'email'),
            validator: (value) => EmailValidator.validate(value!) ? null : 'Please enter a valid email.',
            onSaved: (value) => setState(() => _email = value!),
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password.';
              }
            },
            onSaved: (value) => setState(() => _password = value!),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: ElevatedButton(
              style: Styles.buttonStyle,
              child: Text('Login', style: Styles.buttonText),
              onPressed: () async {
                final form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  await _signIn()
                      ? _successfulSignIn(context)
                      : _invalidCredentialsSnackbar(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: _email!,
          password: _password!
        );
      return userCredential.user != null;
    } on FirebaseAuthException {
      return false;
    }
  }

  void _successfulSignIn(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(
          content: Text('Logged in as administrator.', textAlign: TextAlign.center)
        )
      );
  }

  void _invalidCredentialsSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context)
      .showSnackBar(
        const SnackBar(
          content: Text('Invalid credientails.', textAlign: TextAlign.center)
        )
      );
  }
}