import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ordertakingapp/Area/Area.dart';
import 'package:ordertakingapp/Signup.dart';

class Login extends StatefulWidget {
  static final routename = 'Login';
  bool _isObscure = true;
  bool isChecked = false;
  bool _isButtonDisabled = true;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  CheckDisableButton() {
    print(widget.email.text);
    if (widget.email.text.isNotEmpty && widget.password.text.isNotEmpty) {
      setState(() {
        widget._isButtonDisabled = false;
      });
    } else {
      widget._isButtonDisabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xff212121),
      ),
      body: Form(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/Background.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.dstATop),
            )),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 80),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        'Login to your Account',
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        style: TextStyle(
                            color: Color(0xff212121),
                            fontWeight: FontWeight.w600),
                        controller: widget.email,
                        onChanged: CheckDisableButton(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xfff29F05), width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.email_rounded)),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Color(0xff9E9E9E)),
                          filled: true,
                          fillColor: Color(0xffFAFAFA),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        style: TextStyle(
                            color: Color(0xff212121),
                            fontWeight: FontWeight.w600),
                        controller: widget.password,
                        obscureText: widget._isObscure,
                        onChanged: CheckDisableButton(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xfff29F05), width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Password',
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.lock_rounded)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget._isObscure = !widget._isObscure;
                                });
                              },
                              icon: Icon(Icons.remove_red_eye_rounded)),
                          hintStyle: TextStyle(color: Color(0xff9E9E9E)),
                          filled: true,
                          fillColor: Color(0xffFAFAFA),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Color(0xfff29F05)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        value: widget.isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            widget.isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      child: Container(
                        child: ElevatedButton(
                          child: Text('Sign in',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          onPressed: () {
                            widget._isButtonDisabled
                                ? null
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Areas(),
                                    ),
                                  );
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              )),
                              backgroundColor: widget._isButtonDisabled
                                  ? MaterialStateProperty.all(Color(0xffD8D8D8))
                                  : MaterialStateProperty.all(
                                      Color(0xfff29F05)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20))),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(
                  //     child: TextButton(
                  //         onPressed: () {},
                  //         child: Text(
                  //           'Forgot the password?',
                  //           style: TextStyle(
                  //               color: Color(0xfff29F05),
                  //               fontWeight: FontWeight.w600),
                  //         )),
                  //   ),
                  // ),
                  // Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 8.0, vertical: 10),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           'Dont have an account?',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //         TextButton(
                  //             onPressed: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => Signup(),
                  //                 ),
                  //               );
                  //             },
                  //             child: Text(
                  //               'Sign up',
                  //               style: TextStyle(
                  //                   color: Color(0xfff29F05),
                  //                   fontWeight: FontWeight.w600),
                  //             ))
                  //       ],
                  //     )),
                ],
              ),
            )),
      ),
    );
  }
}
