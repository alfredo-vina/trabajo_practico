import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:trabajo_practico/managers/user_manager.dart';
import 'package:trabajo_practico/pages/listsoccerfield_page.dart';
import 'package:trabajo_practico/pages/reservefield_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loginVisible = true;
  double _opacityLogin = 1;
  double _opacitySignup = 0;

  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

@override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
  
@override
Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: (_loginVisible) ? 
      SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: 
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: 
            AnimatedOpacity(
              opacity: _opacityLogin,
              duration: const Duration(seconds: 1),
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Usuario"),
                        validator: (value) {
                          
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su nombre de usuario';
                            }
                            return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Contraseña"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              UserManager.instance.loginUser(usernameController.text, passwordController.text).then((user) => 
                              {
                                UserManager.userLogged = user, 
                                if (user.role == "admin") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ListSoccerFieldPage())
                                  )
                                }
                                else 
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ReserveFieldPage()),
                                  )
                                }
                              });
                            } 
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill input')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.onSecondary,
                            
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          child: const Text('Ingresar'),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ) :
      SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: 
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: 
            AnimatedOpacity(
              opacity: _opacitySignup,
              duration: const Duration(seconds: 1),
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Usuario"),
                        validator: (value) {
                          
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su nombre de usuario';
                            }
                            return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: firstnameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Nombre"),
                        validator: (value) {
                          
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su nombre';
                            }
                            return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: lastnameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Apellido"),
                        validator: (value) {
                          
                          if (value == null || value.isEmpty) {
                            return 'Igrese su apellido';
                            }
                            return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Contraseña"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              UserManager.instance.addUser(usernameController.text, passwordController.text, firstnameController.text, lastnameController.text).then((fields) => 
                              {
                                setState((){
                                  _loginVisible = true;
                                  _opacityLogin = 1;
                                  _opacitySignup = 0;
                                })   
                              });
                            } 
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill input')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.onSecondary,
                            
                            textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          child: const Text('Registrar'),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        onPressed: () {
          setState((){
            _opacityLogin = 0;
            _opacitySignup = 0;
          });
          Timer t = Timer(
          Duration(seconds:1),(){
            setState((){
              _loginVisible = !_loginVisible;
              if (_loginVisible)
              {
                _opacityLogin = 1;
                _opacitySignup = 0;
              }
              else 
              {
                _opacityLogin = 0;
                _opacitySignup = 1;
              }
            });
          });
        },
        tooltip: 'Registrarse',
        child: (_loginVisible) ? const Icon(Icons.app_registration) : const Icon(Icons.login_rounded),
      ),
    );
  }
}