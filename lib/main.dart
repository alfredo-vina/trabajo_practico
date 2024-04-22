import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

Future<User> fetchUser(String username, String password) async {
final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/login.php?username=$username&password=$password"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}

class User {
  final String username;
  final String role;
  final String firstname;
  final String lastname;

  const User({
    required this.username,
    required this.role,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'username': String username,
        'role': String role,
        'firstname': String firstname,
        'lastname': String lastname,
      } =>
        User(
          username: username,
          role: role,
          firstname: firstname,
          lastname: lastname,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Sistema de Reserva'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email"),
                  validator: (value) {
                    
                    if (value == null || value.isEmpty) {
                      return 'Enter your email please';
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
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password please';
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
                        fetchUser(emailController.text, passwordController.text).then((user) => {
                          if (user.role == "admin") {
                            /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SoccerFieldPage(title: "Administrar"))
                            )
                            */
                          }
                          else 
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SoccerReserveFieldPage()),
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
                    child: const Text('Login'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SoccerReserveFieldPage extends StatelessWidget {
  const SoccerReserveFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Canchas'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}