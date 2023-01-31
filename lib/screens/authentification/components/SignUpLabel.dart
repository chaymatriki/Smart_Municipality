import 'package:flutter/material.dart';

import '../sign_up.dart';

class SignUpLabel extends StatefulWidget {
  const SignUpLabel({
    Key key,
  }) : super(key: key);

  @override
  State<SignUpLabel> createState() => _SignUpLabelState();
}

class _SignUpLabelState extends State<SignUpLabel> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
