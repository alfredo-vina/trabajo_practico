import 'package:flutter/material.dart';
import 'package:trabajo_practico/business/field.dart';
import 'package:trabajo_practico/components/listbuilder.dart';
import 'package:trabajo_practico/managers/user_manager.dart';
import 'package:trabajo_practico/pages/reserveschedule_page.dart';

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