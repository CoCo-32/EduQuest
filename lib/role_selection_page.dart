import 'package:flutter/material.dart';
import 'user_login_page.dart';
import 'admin_login_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Role'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserLoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('User'),
              ),
              SizedBox(height: 20),
              Divider(
                height: 30,
                thickness: 2,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Admin'),
              ),
              // Add more role selection buttons as needed
            ],
          ),
        ),
      ),
    );
  }
}
