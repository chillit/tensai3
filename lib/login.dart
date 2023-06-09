import 'package:flutter/material.dart';
import 'package:tensai3/needs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void signUserIn() async {
    try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text);}on FirebaseAuthException{

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Добро пожаловать!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: email,
                hintText: 'Username',
                obscureText: false, needToValidate: true,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: password,
                hintText: 'Password',
                obscureText: true, needToValidate: true,
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 25),

              // sign in button
              MyButton1(
                onTap: signUserIn,
                isActive: true,
                text: 'Войти',
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}