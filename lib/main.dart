import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class UserManager {
  static final UserManager _userManager = UserManager._internal();
  static User? userLogged;
  
  factory UserManager() {
    return _userManager;
  }

  Future<User> loginUser(String username, String password) async {
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

  Future<List<Field>> addField() async {
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/add_field.php"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);      
      return List<Field>.from(l.map((model)=> Field.fromJson(model)));
    } else {
      throw Exception('Failed to load user');
    }
  }

Future<Field> addScheduleForField(int fieldNumber) async {
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/add_schedule.php?fieldNumber=$fieldNumber"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      return Field.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Field>> fields() async {
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/fields.php"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);      
      return List<Field>.from(l.map((model)=> Field.fromJson(model)));
    } else {
      throw Exception('Failed to load user');
    }
  }

  UserManager._internal();
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

class Field {
  final int number;
  final List schedules;

  const Field({
    required this.number,
    required this.schedules,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'number': int number,
        'schedules': List schedules,
      } =>
        Field(
          number: number,
          schedules: schedules,
        ),
      _ => throw const FormatException('Failed to load field.'),
    };
  }
}

class Schedule {
  final int number;
  final String text;

  const Schedule({
    required this.number,
    required this.text,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'number': int number,
        'text': String text,
      } =>
        Schedule(
          number: number,
          text: text,
        ),
      _ => throw const FormatException('Failed to load schedule.'),
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                        UserManager._internal().loginUser(emailController.text, passwordController.text).then((user) => 
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

class ListSoccerFieldPage extends StatefulWidget {
  const ListSoccerFieldPage({super.key});

  @override
  ListSoccerFieldPageState createState() => ListSoccerFieldPageState();
}

class ListSoccerFieldPageState extends State<ListSoccerFieldPage> {
  late List<Field> _selected;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    //_selected = List<Field>.filled(1, Field(number: 1, schedules: <int>[]), growable: true);
    _selected = <Field>[];

    UserManager._internal().fields().then((fields) => 
    {
      setState(() {
        _selected = fields;
      })
    });
  }

  @override
  void dispose() {
    _selected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Administrar Canchas',
          ),
          actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  UserManager._internal().addField().then((fields) => 
                  {
                    setState(() { 
                    _selected = fields;
                    })
                  });
                }
              )
          ],
        ),
        body: ListBuilder(
                isSelectionMode: false,
                selectedList: _selected,
                onSelectionChange: (int index) {
                  Field field = _selected[index];
                  //String texto = index.toString();
                  Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SoccerFieldScheduleListPage(fieldNumber:field.number, schedules: field.schedules))
                            );
                },
              ));
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final List<Field> selectedList;
  final ValueChanged<int>? onSelectionChange;


  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectedList.length,
        itemBuilder: (_, int index) {
          return ListTile(
              onTap: () {
                if (!widget.isSelectionMode) {
                  setState(() {
                    //widget.selectedList[index] = true;
                  });
                  widget.onSelectionChange!(index);
                }
              },
              trailing: const SizedBox.shrink(),
              title: Text('cancha ${index + 1}'));
        });
  }
}

class SoccerFieldScheduleListPage extends StatelessWidget {
  final int fieldNumber;
  final List schedules;

  const SoccerFieldScheduleListPage({required this.fieldNumber, required this.schedules, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horarios - Cancha $fieldNumber"),
        actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  UserManager._internal().addScheduleForField(fieldNumber).then((field) => 
                  {
                    print(field.number)
                    //this.schedules = field.schedules;
                  });
                }
              )
          ],
      ),
      body: ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: schedules.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: Colors.white,
        child: Center(child: Text('Horario ${schedules[index]["text"]}')),
      );
    }
  )
    );
  }
}

class SoccerFieldPage extends StatelessWidget {
  const SoccerFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Reservas'),
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