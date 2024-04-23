import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trabajo_practico/business/field.dart';
import 'package:trabajo_practico/business/user.dart';
import 'package:trabajo_practico/managers/user_manager.dart';

void main() {
  runApp(const MyApp());
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

    UserManager.instance.fields().then((fields) => 
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
                  UserManager.instance.addField().then((fields) => 
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
                UserManager.instance.removeField(field.number).then((result) => 
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
    UserManager.instance.fieldByNumber(field.number).then((loadField) => 
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
                  UserManager.instance.addScheduleForField(field.number).then((resultField) => 
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
            UserManager.instance.removeSchedule(field.number, schedule["number"]).then((result) => 
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
              'Horario ${schedule["text"]} $reservedBy',
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

    UserManager.instance.fields().then((fields) => 
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
    UserManager.instance.fieldByNumber(field.number).then((loadField) => 
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
            UserManager.instance.removeSchedule(field.number, schedule["number"]).then((result) => 
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
  bool canReserve = false;

  @override
  void initState() {
    super.initState();
    
    User? user = UserManager.userLogged;
    isReserved = widget.schedule.user == user?.username;
    canReserve = widget.schedule.user == "" || widget.schedule.user == user?.username;
  }

  void toggleSwitch(bool value){
    setState(() {
      User? user = UserManager.userLogged;
      String? username = (!isReserved) ? user?.username : "";
      UserManager.instance.reserveSchedule(widget.field.number, widget.schedule.number, username).then((result) => 
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
        isReserved || !canReserve ? "Reservada" : 'Libre',
      ),
     
      trailing: Switch(value: isReserved , onChanged: (canReserve) ? toggleSwitch : null, activeColor: Colors.black)
    );
  }
}