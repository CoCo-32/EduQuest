import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'user_signup_page.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle login button press
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Perform login action
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Navigate to home page if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } catch (e) {
        // Handle login errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserSignUpPage()),
                  );
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
