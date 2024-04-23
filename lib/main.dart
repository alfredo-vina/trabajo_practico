import 'dart:async';

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

  Future<bool> removeField(int fieldNumber) async {
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/remove_field.php?fieldNumber=$fieldNumber"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty;
    } else {
      throw Exception('Failed to remove field');
    }
  }

  Future<bool> removeSchedule(int fieldNumber, int scheduleNumber) async {
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/remove_schedule.php?fieldNumber=$fieldNumber&scheduleNumber=$scheduleNumber"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty;
    } else {
      throw Exception('Failed to remove schedule');
    }
  }

  Future<bool> reserveSchedule(int fieldNumber, int scheduleNumber, String? user) async {
    if (user == null)
    {
      user == "";
    }
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/reserve_schedule.php?fieldNumber=$fieldNumber&scheduleNumber=$scheduleNumber&user=$user"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty;
    } else {
      throw Exception('Failed to reserve schedule');
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

  Future<Field> fieldByNumber(int fieldNumber) async {
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/field_by_number.php?fieldNumber=$fieldNumber"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {    
      return Field.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load field');
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
  String? user;

  Schedule({
    required this.number,
    required this.text,
    this.user,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'number': int number,
        'text': String text,
        'user': String? user,
      } =>
        Schedule(
          number: number,
          text: text,
          user: user,
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
  bool _loginVisible = true;
  double _opacityLogin = 1;
  double _opacitySignup = 0;

  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: "RobotoMono")
        ),
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
                              UserManager._internal().loginUser(usernameController.text, passwordController.text).then((user) => 
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
                          child: const Text('Ingresarr'),
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
                            // if (_formKey.currentState!.validate()) {
                            //   UserManager._internal().loginUser(usernameController.text, passwordController.text).then((user) => 
                            //   {
                            //     UserManager.userLogged = user, 
                            //     if (user.role == "admin") {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(builder: (context) => const ListSoccerFieldPage())
                            //       )
                            //     }
                            //     else 
                            //     {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(builder: (context) => const ReserveFieldPage()),
                            //       )
                            //     }
                            //   });
                            // } 
                            // else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Please fill input')),
                            //   );
                            // }
                          },
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
        onPressed: () {
          // Call setState. This tells Flutter to rebuild the
          // UI with the changes.
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

class ListSoccerFieldPage extends StatefulWidget {
  const ListSoccerFieldPage({super.key});

  @override
  State<ListSoccerFieldPage> createState() => _ListSoccerFieldPageState();
}

class _ListSoccerFieldPageState extends State<ListSoccerFieldPage> {
  late List<Field> _fields;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _fields = <Field>[];

    UserManager._internal().fields().then((fields) => 
    {
      setState(() {
        _fields = fields;
      })
    });
  }

  @override
  void dispose() {
    _fields.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Administrar Canchas'),
          actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  UserManager._internal().addField().then((fields) => 
                  {
                    setState(() { 
                    _fields = fields;
                    })
                  });
                }
              )
          ],
        ),
        body: ListBuilder(
                fields: _fields,
                onSelectItem: (int index) {
                  Field field = _fields[index];
                  Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SoccerFieldScheduleListPage(field:field))
                            );
                },
              ));
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    super.key,
    required this.fields,
    required this.onSelectItem,
  });

  final List<Field> fields;
  final ValueChanged<int>? onSelectItem;


  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.fields.length,
        itemBuilder: (BuildContext context, int index) {
          final field = widget.fields[index];
          final key = ValueKey<int>(field.number);
          return GestureDetector(
            onTap: () {
              widget.onSelectItem!(index);
            },
            child: Dismissible(
              background: Container(
                color: Colors.red,
              ),
              key: key,
              
              onDismissed: (DismissDirection direction) {
                UserManager._internal().removeField(field.number).then((result) => 
                {
                  if (result) {
                    setState(() {
                      widget.fields.removeAt(index);
                    })
                  }
                });
              },
              child: ListTile(
                title: Text('cancha ${field.number}'),
              ),
            )
          );
      }
        );
  }
}

class SoccerFieldScheduleListPage extends StatefulWidget {
  const SoccerFieldScheduleListPage({super.key, required this.field});

  final Field field;

  @override
  // ignore: no_logic_in_create_state
  State<SoccerFieldScheduleListPage> createState() => _SoccerFieldScheduleListPageState(field: field);
}

class _SoccerFieldScheduleListPageState extends State<SoccerFieldScheduleListPage> {
  _SoccerFieldScheduleListPageState({required this.field});

  late Field field;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    UserManager._internal().fieldByNumber(field.number).then((loadField) => 
    {
      setState(() {
        field.schedules.clear();
        for (var eachSchedule in loadField.schedules) {
          field.schedules.add(eachSchedule);
        }
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horarios - Cancha ${field.number}"),
        actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  UserManager._internal().addScheduleForField(field.number).then((resultField) => 
                  {
                    setState(() {
                      field = resultField;
                    })
                  });
                }
              )
          ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: field.schedules.length,
        itemBuilder: (BuildContext context, int index) {
          final schedule = field.schedules[index];
          final key = ValueKey<int>(schedule["number"]);
          String reservedBy = "- Libre";
          if (!(schedule["user"].isEmpty)) 
          {
             reservedBy = '- Reservada por ${schedule["user"]}';
          }
          return Dismissible(
          background: Container(
            color: Colors.red,
          ),
          key: key,
          onDismissed: (DismissDirection direction) {
            UserManager._internal().removeSchedule(field.number, schedule["number"]).then((result) => 
            {
              if (result) {
                setState(() {
                  field.schedules.removeAt(index);
                })
              }
            });
          },
          child: ListTile(
            title: Text(
              'Horario ${schedule["text"]} ${reservedBy}',
            ),
          ),
        );
    }
  )
    );
  }
}

class ReserveFieldPage extends StatefulWidget {
  const ReserveFieldPage({super.key});

  @override
  State<ReserveFieldPage> createState() => _ReserveFieldPageState();
}

class _ReserveFieldPageState extends State<ReserveFieldPage> {
  late List<Field> _fields;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _fields = <Field>[];

    UserManager._internal().fields().then((fields) => 
    {
      setState(() {
        _fields = fields;
      })
    });
  }

  @override
  void dispose() {
    _fields.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reservar Canchas'),
        ),
        body: ListBuilder(
                fields: _fields,
                onSelectItem: (int index) {
                  Field field = _fields[index];
                  Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReserveSchedulePage(field:field))
                            );
                },
              ));
  }
}

class ReserveSchedulePage extends StatefulWidget {
  const ReserveSchedulePage({super.key, required this.field});

  final Field field;

  @override
  // ignore: no_logic_in_create_state
  State<ReserveSchedulePage> createState() => _ReserveSchedulePageState(field: field);

}

class _ReserveSchedulePageState extends State<ReserveSchedulePage> {
  _ReserveSchedulePageState({required this.field});

  late Field field;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    UserManager._internal().fieldByNumber(field.number).then((loadField) => 
    {
      setState(() {
        field.schedules.clear();
        for (var eachSchedule in loadField.schedules) {
          field.schedules.add(eachSchedule);
        }
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horarios - Cancha ${field.number}"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: field.schedules.length,
        itemBuilder: (BuildContext context, int index) {
          final schedule = field.schedules[index];
          final key = ValueKey<int>(schedule["number"]);
          return Dismissible(
          background: Container(
            color: Colors.red,
          ),
          key: key,
          onDismissed: (DismissDirection direction) {
            UserManager._internal().removeSchedule(field.number, schedule["number"]).then((result) => 
            {
              if (result) {
                setState(() {
                  field.schedules.removeAt(index);
                })
              }
            });
          },
          child: ReserveScheduleListTile(field:field, schedule: Schedule(number: schedule["number"], text: schedule["text"], user: schedule["user"])),
        );
    }
  )
    );
  }
}

class ReserveScheduleListTile extends StatefulWidget {
  final Field field;
  final Schedule schedule;
  const ReserveScheduleListTile({ Key? key, required this.field, required this.schedule }) : super(key: key);

  @override
  State<ReserveScheduleListTile> createState() => _ReserveScheduleListTileState();
}

class _ReserveScheduleListTileState extends State<ReserveScheduleListTile> {
  bool isReserved = false;

  @override
  void initState() {
    super.initState();
    
    User? user = UserManager.userLogged;
    isReserved = widget.schedule.user == user?.username;
  }

  void toggleSwitch(bool value){
    setState(() {
      User? user = UserManager.userLogged;
      String? username = (!isReserved) ? user?.username : "";
      UserManager._internal().reserveSchedule(widget.field.number, widget.schedule.number, username).then((result) => 
      {
        if (result) {
          setState(() {
            isReserved=!isReserved;
            // updating object 
            widget.schedule.user = username;
            widget.field.schedules.forEach((schedule) { 
              if (schedule["number"] == widget.schedule.number) {
                schedule["user"] = username;
              }
            });
          })
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(

      tileColor: isReserved?Colors.lightBlue[200]:Colors.white,
      title: Text('Horario ${widget.schedule.text}'),
      subtitle: Text(
        isReserved ? "Reservada" : 'Libre',
      ),
     
      trailing: Switch(value: isReserved , onChanged: toggleSwitch,activeColor: Colors.black)
    );
  }
}