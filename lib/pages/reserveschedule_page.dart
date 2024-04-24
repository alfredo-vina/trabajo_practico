import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:trabajo_practico/business/field.dart';
import 'package:trabajo_practico/business/schedule.dart';
import 'package:trabajo_practico/business/user.dart';
import 'package:trabajo_practico/managers/user_manager.dart';

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
        ),
      body: 
      Column (
        children: [
          DropdownDatePicker(
            locale: "en",
            dateformatorder: OrderFormat.DMY, // default is myd
            isDropdownHideUnderline: true, // optional
            isFormValidator: true, // optional
            startYear: 1900, // optional
            width: 10, // optional
            selectedDay: _selectedDay, // optional
            selectedMonth: _selectedMonth, // optional
            selectedYear: _selectedYear, // optional
            onChangedDay: (value) {
              setState(() {
                _selectedDay = int.parse(value!);
                UserManager.selectedDate = DateTime(_selectedYear as int, _selectedMonth as int, _selectedDay as int);
                print('onChangedDay: $value');
                field.schedules.clear();
              });
              initializeSelection();
            },
            onChangedMonth: (value) {
              setState(() {
                _selectedMonth = int.parse(value!);
                UserManager.selectedDate = DateTime(_selectedYear as int, _selectedMonth as int, _selectedDay as int);
                print('onChangedMonth: $value');
                field.schedules.clear();
              });
              initializeSelection();
            },
            onChangedYear: (value) {
              setState(() {
                _selectedYear = int.parse(value!);
                UserManager.selectedDate = DateTime(_selectedYear as int, _selectedMonth as int, _selectedDay as int);
                print('onChangedYear: $value');
                field.schedules.clear();
              });
              initializeSelection();
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
                  
                  Map bookings = (schedule["bookings"].length == 0) ? Map() : schedule["bookings"] as Map;

                  return (UserManager.userLogged?.role == "admin") ? Dismissible(
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
                    )
                    :
                    ReserveScheduleListTile(field:field, schedule: Schedule(number: schedule["number"], text: schedule["text"], bookings:bookings ));
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              ),
           ]),
        ],
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
                  widget.schedule.user = username;
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