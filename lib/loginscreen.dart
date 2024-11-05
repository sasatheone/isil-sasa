import 'package:flutter/material.dart';

import 'package:isil_flutter_sasa/logingoogleutils.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'package:isil_flutter_sasa/managementpersonscreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final TextEditingController _textControllerUser = TextEditingController();
  final TextEditingController _textControllerPassword = TextEditingController();

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ISIL',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                  image: NetworkImage(
                      'https://e7.pngegg.com/pngimages/459/80/png-clipart-computer-icons-employee-employees-icon-blue-text.png')),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _textControllerUser,
                decoration: const InputDecoration(
                    labelText: 'Ingresa tu nombre',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                controller: _textControllerPassword,
                decoration: const InputDecoration(
                    labelText: 'Ingrese Password',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagementPersonScreen()));
                  },
                  child: const Text('Aceptar..'),
                ),
              ),
              Center(
                child: SignInButton(
                  Buttons.google,
                  onPressed: () {
                    LoginGoogleUtils().signInWithGoogle().then((user) {
                      if (user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManagementPersonScreen()));
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
