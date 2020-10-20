import 'package:chat_app/models/db_model.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/auth_manage.dart';
import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', phone = '', password = '',inputError='';
  final AuthService _auth = AuthService();
  Color nameIcon = Colors.grey,
      phoneIcon = Colors.grey,
      passwordIcon = Colors.grey;

  @override
  Widget build(BuildContext context) {
    MySizes mSizes = new MySizes(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 10,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'Create new account',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 1.0),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(35.0)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 25.0,
                        color: nameIcon,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (val) => val.isEmpty ? null : null,
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your name...',
                            labelStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 0, bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(35.0)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 25.0,
                        color: phoneIcon,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (val) => val.isEmpty ? null : null,
                          onChanged: (val) {
                            setState(() {
                              phone = val;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your phone...',
                            labelStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(35.0)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.vpn_key,
                        size: 25.0,
                        color: passwordIcon,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (val) => val.isEmpty ? null : null,
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your password...',
                            labelStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(inputError,style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w500),),
              ],
            ),
          ),
          Flexible(
            flex: 6,
            child: Wrap(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (name.isEmpty || phone.isEmpty || password.isEmpty || password.length<6) {

                      if(name.isEmpty){
                        setState(() {
                          nameIcon = Colors.redAccent;
                          inputError = 'Please enter a valid Name';
                        });
                      }else if (phone.isEmpty){
                        setState(() {
                          nameIcon = Colors.grey;
                          phoneIcon = Colors.redAccent;
                          inputError = 'Please enter a valid phone';
                        });
                      }else if (password.isEmpty){
                        setState(() {
                          phoneIcon = Colors.grey;
                          passwordIcon = Colors.redAccent;
                          inputError = 'Please enter a valid password';
                        });
                      }else if (password.length<6){
                        setState(() {
                          passwordIcon = Colors.redAccent;
                          inputError = 'Password must be at least 6 letters';
                        });
                      }

                    } else {
                      User newUser = new User(
                          name: name, phone: phone, password: password,logo: 'https://firebasestorage.googleapis.com/v0/b/fluffy-chats.appspot.com/o/images%2Fplaceholder.png?alt=media&token=f71c5f05-3d77-4fee-a337-14227af786f6',status: false);

                      dynamic result =
                          await _auth.registerWithEmailAndPassword(newUser);
                      if (result == null) {
                        setState(() {
                          String error = 'Error occured';
                          print(error);
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<AuthManage>(context, listen: false)
                        .toggleLogin(context, mSizes);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    margin: EdgeInsets.only(bottom: 10.0),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2.0)),
                    child: Text(
                      'Back to login',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
