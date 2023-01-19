import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const apiKey = 'AIzaSyA55XNNYtjVERQOSSpQbgINFXlIL4PZnuI';

class AuthProvider extends ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _timer;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null)
      return _token;
    else
      return null;
  }

  String get userId {
    return _userId;
  }

  bool get isAuthenticate {
    if (token != null && _expiryDate != null && _userId != null)
      return true;
    else
      return false;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.tryParse(responseData['expiresIn'])));

      _autoLogOut();
      notifyListeners();

      final sharedPreferences = await SharedPreferences.getInstance();
      final decodeData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });

      sharedPreferences.setString('userData', decodeData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
    await _authenticate(email, password, url);
  }

  Future<void> signIn(String email, String password) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
    await _authenticate(email, password, url);
  }

  void manuallyLogOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userData');
    notifyListeners();
  }

  void _autoLogOut() {
    if (_timer != null) {
      _timer.cancel();
    }
    final _timeToExpire = _expiryDate.difference(DateTime.now());
    _timer = Timer(_timeToExpire, manuallyLogOut);
  }

  Future<bool> isLoggedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey('userData')) {
      return false;
    }
      var userData = {};
       userData = json.decode(sharedPreferences.get('userData'))
          as Map<String, dynamic>;
      final expiryDate = DateTime.parse(userData['expiryDate']);
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
        _token = userData['token'];
        _userId = userData['userId'];
        _expiryDate = expiryDate;
        notifyListeners();
        _autoLogOut();
        return true;
    }
  }
