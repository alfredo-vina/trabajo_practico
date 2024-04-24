import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trabajo_practico/business/field.dart';
import 'package:trabajo_practico/managers/user_manager.dart';

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