import 'package:chat_app/services/auth_manage.dart';
import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String phone = '', password = '',inputError='';
  Color phoneIcon = Colors.grey,
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
            flex: 2,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
              Text('Login to continue',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 20.0,letterSpacing: 1.0),),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                margin: EdgeInsets.only(top: 20.0,bottom: 15.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(35.0)),
                child: Row(
                  children: [
                    Icon(Icons.phone,size:25.0 ,color: phoneIcon,),
                    SizedBox(width: 20.0,),
                    Expanded(
                      child: TextFormField(
                        validator: (val) => val.isEmpty ? null:null,
                        onChanged: (val) {
                          setState(() {
                            phone = val;
                          });
                        },keyboardType: TextInputType.number,
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
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(35.0)),
                child: Row(
                  children: [
                    Icon(Icons.vpn_key,size:25.0 ,color: passwordIcon,),
                    SizedBox(width: 20.0,),
                    Expanded(
                      child: TextFormField(
                        validator: (val) => val.isEmpty ? null:null,
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
            ],),
          ),
          Flexible(
            flex: 2,
            child: Wrap(
              children: [
              GestureDetector(
                onTap: () async {
                  if (phone.isEmpty || password.isEmpty) {

                    if(phone.isEmpty){
                      setState(() {
                        phoneIcon = Colors.redAccent;
                        inputError = 'Invalid phone number';
                      });
                    }else if (password.isEmpty){
                      setState(() {
                        phoneIcon = Colors.grey;
                        passwordIcon = Colors.redAccent;
                        inputError = 'Invalid Password';
                      });
                    }

                  } else {
                    phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                    dynamic result = await AuthService().signInWithEmailAndPassword('${phone}@unicorp.com', password);
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
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35.0),color: Theme.of(context).primaryColor),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<AuthManage>(context,listen: false).toggleRegister(context, mSizes);

                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  margin: EdgeInsets.only(bottom: 20.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35.0),border: Border.all(color: Theme.of(context).primaryColor,width: 2.0)),

                  child: Text(
                    'Create new account',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
                ),
              )
            ],),
          )
        ],
      ),
    );
  }
}
