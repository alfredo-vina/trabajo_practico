import 'dart:async';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:trabajo_practico/business/field.dart';
import 'package:trabajo_practico/business/user.dart';
import 'package:trabajo_practico/managers/user_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:intl/date_symbol_data_local.dart'; // for other locales

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class Schedule {
  final int number;
  final String text;
  final Map bookings;

  String? get user
  {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(UserManager.selectedDate);

    Map map = bookings;
    String? user = (map.containsKey(formattedDate)) ? map[formattedDate] : "";

    return user == null ? "" : user;
  }

  set user(String ?user) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(UserManager.selectedDate);

    this.bookings[formattedDate] = user;
  }

  Schedule({
    required this.number,
    required this.text,
    required this.bookings,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'number': int number,
        'text': String text,
        'bookings': Map bookings,
      } =>
        Schedule(
          number: number,
          text: text,
          bookings: bookings,
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          onPrimary: Colors.white,
          primary: Color.fromARGB(255, 13, 122, 70)
          ),
          
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.aBeeZee(
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
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
          iconTheme: IconThemeData(
            color: Colors.white, 
          ),
          title:  Text(
            "Administrar Canchas",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          
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
                leading:  Image.asset('assets/field.png'),
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.arrow_forward_ios), 
                  ],
                ),
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

  int? _selectedDay = 1;
  int? _selectedMonth = 1;
  int? _selectedYear = 2023;

  @override
  void initState() {
    super.initState();
    _selectedDay = UserManager.selectedDate.day;
    _selectedMonth = UserManager.selectedDate.month;
    _selectedYear = UserManager.selectedDate.year;

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
        iconTheme: IconThemeData(
          color: Colors.white, 
        ),
        title:  Text(
          "Horarios - Cancha ${field.number}",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: Column (
        children: [
          DropdownDatePicker(
            locale: "en",
            dateformatorder: OrderFormat.DMY, // default is myd
            // inputDecoration: InputDecoration(
            //     enabledBorder: const OutlineInputBorder(
            //       borderSide: BorderSide(color: Colors.grey, width: 1.0),
            //     ),
            //     helperText: '',
            //     contentPadding: const EdgeInsets.all(8),
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10))), // optional
            isDropdownHideUnderline: true, // optional
            isFormValidator: true, // optional
            startYear: 1900, // optional
            width: 10, // optional
            selectedDay: _selectedDay, // optional
            selectedMonth: _selectedMonth, // optional
            selectedYear: _selectedYear, // optional
            onChangedDay: (value) {
              _selectedDay = int.parse(value!);
              UserManager.selectedDate = DateTime(_selectedYear as int, _selectedMonth as int, _selectedDay as int);
              print('onChangedDay: $value');
            },
            onChangedMonth: (value) {
              _selectedMonth = int.parse(value!);
              UserManager.selectedDate = DateTime(_selectedYear as int, _selectedMonth as int, _selectedDay as int);
              print('onChangedMonth: $value');
            },
            onChangedYear: (value) {
              _selectedYear = int.parse(value!);
              UserManager.selectedDate = DateTime(_selectedYear as int, _selectedMonth as int, _selectedDay as int);
              print('onChangedYear: $value');
            },
          ),
          Column (
            children: [
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: field.schedules.length,
                itemBuilder: (BuildContext context, int index) {
                  final schedule = field.schedules[index];
                  final key = ValueKey<int>(schedule["number"]);
                  String reservedBy = "Libre";
                  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                  String formattedDate = dateFormat.format(UserManager.selectedDate);

                  Map map = (schedule["bookings"].length == 0) ? new Map() : schedule["bookings"] as Map;
                  String user = (map.containsKey(formattedDate)) ? map[formattedDate] : "";
                  // ignore: unnecessary_null_comparison
                  if ((user != null) && !(user.isEmpty)) 
                  {
                    reservedBy = 'Reservada por ${user}';
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
                        'Horario ${schedule["text"]}',
                      ),
                      subtitle: Text('$reservedBy', textAlign: TextAlign.left),
                    )
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
           ]),
        ],
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
          iconTheme: IconThemeData(
            color: Colors.white, 
          ),
          title:  Text(
            'Reservar Canchas',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
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
          iconTheme: IconThemeData(
            color: Colors.white, 
          ),
          title:  Text(
            "Horarios - Cancha ${field.number}",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: field.schedules.length,
        itemBuilder: (BuildContext context, int index) {
          final schedule = field.schedules[index];
          final key = ValueKey<int>(schedule["number"]);
          
          Map bookings = (schedule["bookings"].length == 0) ? Map() : schedule["bookings"] as Map;

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
          child: ReserveScheduleListTile(field:field, schedule: Schedule(number: schedule["number"], text: schedule["text"], bookings:bookings )),
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

      tileColor: isReserved?Colors.lightGreen[200]:Colors.white,
      title: Text('Horario ${widget.schedule.text}'),
      subtitle: Text(
        isReserved || !canReserve ? "Reservada" : 'Libre',
      ),
     
      trailing: Switch(value: isReserved , onChanged: (canReserve) ? toggleSwitch : null, activeColor: Colors.black, activeThumbImage: Image.asset('assets/ball.png').image, inactiveThumbImage: Image.asset('assets/ball.png').image)
    );
  }
}