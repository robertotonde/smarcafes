import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/screens/homepage.dart';

import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/input_field_widget.dart';
import 'package:smartcafes/widgets/label_widget.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final _nameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String username =
        Provider.of<AuthenticationService>(context).getCurrentUname();

    return Scaffold(
      backgroundColor: backColor,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Center(
              child: Text(
                "Edit Profile",
                style: GoogleFonts.urbanist(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.06),
          const LabelWidget(
            labelText: "Name",
          ),
          SizedBox(height: size.height * 0.01),
          InputFieldWidget(
            obscureText: false,
            onChanged: (value) {
              // ignore: unnecessary_null_comparison
              if (value == null) {
              } else {
                setState(() {
                  username = value;
                });
              }
            },
            onSaved: (value) {
              if (value == null) {
              } else {
                setState(() {
                  username = value;
                });
              }
            },
            controller: _nameController,
            hintText: username,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Provider.of<AuthenticationService>(context, listen: false)
                    .changeUsername(name: _nameController.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Name Updated Successfully",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              child: isLoading == true
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      "Update Address",
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    // ignore: deprecated_member_use
                    Theme.of(context).accentColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ))),
    );
  }
}
