import 'package:flutter/material.dart';
import 'package:trabajo_practico/business/field.dart';
import 'package:trabajo_practico/managers/user_manager.dart';

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
            child: 
              (UserManager.userLogged?.role == "admin") ? 
              Dismissible(
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
            :
            ListTile(
                title: Text('cancha ${field.number}'),
                leading:  Image.asset('assets/field.png'),
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.arrow_forward_ios), 
                  ],
                ),
              )
          );
        }
      );
  }
}