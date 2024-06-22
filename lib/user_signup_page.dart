import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_login_page.dart';

class UserSignUpPage extends StatefulWidget {
  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Optionally update the user's display name
        await userCredential.user!.updateDisplayName(username);

        // Navigate to login page after successful sign up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLoginPage()),
        );
      } catch (e) {
        // Handle sign up errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign up: $e'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  // You can add more complex email validation if needed
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  // You can add more complex password validation if needed
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
