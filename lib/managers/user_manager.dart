import 'package:intl/intl.dart';
import 'package:trabajo_practico/business/field.dart';
import 'package:trabajo_practico/business/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserManager {
  static final UserManager _userManager = UserManager._internal();
  static User? userLogged;
  static DateTime selectedDate = DateTime.now();
  
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
      if (!response.body.isEmpty) {
        return User.fromJson(jsonDecode(response.body));
      }
      else {
        throw Exception('Cotraseña incorrecta');
      }
    } else {
      throw Exception('Fallo al cargar usuario');
    }
  }

  Future<bool> addUser(String username, String password, String firstname, String lastname) async {
    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/add_user.php?username=$username&password=$password&firstname=$firstname&lastname=$lastname"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty;
    } else {
      throw Exception('Fallo al cargar usuario');
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
      throw Exception('Fallo al cargar cancha');
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
      throw Exception('Fallo al cargar horario');
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
      throw Exception('Fallo al eliminar cancha');
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
      throw Exception('Fallo al eliminar horario');
    }
  }

  Future<bool> reserveSchedule(int fieldNumber, int scheduleNumber, String? user) async {
    if (user == null)
    {
      user == "";
    }

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String date = dateFormat.format(UserManager.selectedDate);

    final response = await http.post(
      Uri.parse("http://alfredo.xn--via-8ma.net/api/reserve_schedule.php?fieldNumber=$fieldNumber&scheduleNumber=$scheduleNumber&user=$user&date=$date"),
      headers: {
          'Content-Type': 'application/json' // 'application/x-www-form-urlencoded' or whatever you need
      },
    );

    if (response.statusCode == 200) {
      return response.body.isEmpty;
    } else {
      throw Exception('Fallo al reservar horario');
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
      throw Exception('Fallo al cargar cancha');
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
      throw Exception('Fallo al cargar cancha');
    }
  }

  static final UserManager _instance = UserManager._internal();

  static UserManager get instance => _instance;

  UserManager._internal();
}