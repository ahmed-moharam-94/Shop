import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/exceptions/http_exception.dart';
import 'package:shopapp2/providers/auth_provider.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Size> _heightAnimation;
  Animation<double> _fadeAnimation;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    // control duration and what appears in the screen
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // control dimensions and the animation curve
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(curve: Curves.linear, parent: _controller));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));

    _offsetAnimation = Tween<Offset>(begin: Offset(0, -4.0), end: Offset(0, 0))
        .animate(CurvedAnimation(curve: Curves.linear, parent: _controller));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<AuthProvider>(context, listen: false)
            .signIn(_authData['email'], _authData['password']);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      showAlertDialog(errorMessage(error.toString()));
    } catch (error) {
      showAlertDialog(errorMessage(error.toString()));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.SignUp,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.SignUp
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: () {
                          _submit();
                        },
                      ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(String errorMessage) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Error Message'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  })
            ],
          );
        });
  }

  String errorMessage(String error) {
    String errorMessage = 'Something Wrong Happend';
    if (error.toString().contains('EMAIL_EXISTS'))
      return errorMessage = 'This Email Aleardy Exists';
    else if (error.toString().contains('INVALID_EMAIL'))
      return errorMessage = 'Invalid Email';
    else if (error.toString().contains('INVALID_PASSWORD'))
      return errorMessage = 'INVALID PASSWORD';
    else if (error.toString().contains('EMAIL_NOT_FOUND'))
      return errorMessage = 'EMAIL NOT FOUND';
    else
      return errorMessage;
  }
}
