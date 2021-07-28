import 'package:cam_data/Authen/authen_Class.dart';
import 'package:cam_data/Authen/register.dart';
import 'package:cam_data/Screens/homesreen.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isHiden = true;
  bool _isLoading = false;
  void _showPass() {
    setState(() {
      _isHiden = !_isHiden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sing In'),
        centerTitle: true,
      ),
      body: _isLoading == false
          ? Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        autofocus: false,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter email' : null,
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          focusColor: Colors.green,
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (value) => value!.length < 6
                            ? 'Password should be more than 6 charactor'
                            : null,
                        controller: _password,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: InkWell(
                            onTap: _showPass,
                            child: _isHiden
                                ? Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  )
                                : Icon(Icons.visibility),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        obscureText: _isHiden,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            AuthClass()
                                .signIN(
                                    email: _email.text.trim(),
                                    password: _password.text.trim())
                                .then((value) {
                              if (value == "Welcome") {
                                setState(() {
                                  _isLoading = true;
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value)));
                              }
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 50,
                        minWidth: MediaQuery.of(context).size.width / 2,
                        color: Colors.green,
                        child: Text('Sign In'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t hav an account ?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()),
                                  (route) => false);
                            },
                            child: Text('Register now'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
