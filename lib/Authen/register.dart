import 'dart:io';
import 'package:cam_data/Authen/authen_Class.dart';
import 'package:cam_data/Authen/signIn.dart';
import 'package:cam_data/Net/setUser.dart';
import 'package:cam_data/Screens/homesreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _cpassword = TextEditingController();
  TextEditingController _password = TextEditingController();
  File? _image;
  final _picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isHiden = true;
  void _showPass() {
    setState(() {
      _isHiden = !_isHiden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: isLoading == false
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPickerImage,
                        SizedBox(height: 10),
                        TextFormField(
                          autofocus: false,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter user name' : null,
                          controller: _username,
                          decoration: InputDecoration(
                            hintText: 'User Name',
                            focusColor: Colors.green,
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                              ? 'Enter more than 6 charactor'
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
                        TextFormField(
                          validator: (value) =>
                              _password.text != _cpassword.text
                                  ? 'Password not match'
                                  : null,
                          controller: _cpassword,
                          decoration: InputDecoration(
                            hintText: 'Comfirm Password',
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
                                  .createAccount(
                                      email: _email.text.trim(),
                                      password: _password.text.trim())
                                  .then((value) {
                                if (value == "Account created") {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  userSetup(_username.text, _image,_email.text);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                      (route) => false);
                                } else {
                                  setState(() {
                                    isLoading = false;
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
                          child: Text('Sign Up'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Ready have account ?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignIn()),
                                    (route) => false);
                              },
                              child: Text('Sign In'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
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
            )),
    );
  }

  Future<void> _fromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _fromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _fromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _fromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  get _buildPickerImage {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Colors.red,
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        ),
      ),
    );
  }
}
