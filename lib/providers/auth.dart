import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
   String? _token;
   DateTime? _expiryDate;
   String? _userId;


  bool get isAuth{
    return _token != null;

  }

  String? get userId{
    return _userId;
  }

  String? get getToken{
    if(_token != null && _expiryDate != null && _expiryDate!.isAfter(DateTime.now())){
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        Uri.parse(('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBUxK9i2hIAL1Ip16P7TZUoaPNLIn694i4'));
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["error"] != null) {
        //print(responseData['error']['message']);
        throw HttpExceptions(responseData['error']['message']);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData["expiresIn"])));
      notifyListeners();


    } catch (error) {
      throw error;

    }

  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');

  }

  void logout(){
    _expiryDate = null;
    _userId=null;
    _token=null;

    notifyListeners();
  }

}
