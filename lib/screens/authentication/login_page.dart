import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/screens/authentication/forgot_password.dart';
import 'package:smartcafes/screens/authentication/signup_page.dart';
import 'package:smartcafes/screens/homepage.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/input_field_widget.dart';
import 'package:smartcafes/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool isHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                    "SIGN IN",
                    style: GoogleFonts.urbanist(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.06),
              SizedBox(height: size.height * 0.02),
              const LabelWidget(
                labelText: "Email",
              ),
              SizedBox(height: size.height * 0.01),
              InputFieldWidget(
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                hintText: "Your Email",
              ),
              SizedBox(height: size.height * 0.02),
              const LabelWidget(
                labelText: "Password",
              ),
              SizedBox(height: size.height * 0.01),
              InputFieldWidget(
                  obscureText: isHidden,
                  icon: IconButton(
                      icon: Icon(
                        isHidden == false
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isHidden ^= true;
                          //print("Icon button pressed! state: $_passwordVisible"); //Confirmed that the _passwordVisible is toggled each time the button is pressed.
                        });
                      }),
                  controller: _passwordController,
                  hintText: "Your password"),
              SizedBox(height: size.height * 0.06),
              Container(
                height: size.height * 0.05,
                width: size.width,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: isLoading == true
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          final result = await context
                              .read<AuthenticationService>()
                              .signInUsingEmailPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              result,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                              ),
                            ),
                          ));
                          if (result == "SignedIn") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                  child: isLoading == true
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          "SignIn",
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
              SizedBox(height: size.height * 0.03),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: ' ',
                        children: [
                          TextSpan(
                              text: 'Dont have an Account? ',
                              style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: white)),
                          TextSpan(
                              text: ' SignUp',
                              style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: ' ',
                        children: [
                          TextSpan(
                              text: 'Forgot your password? ',
                              style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: white)),
                          TextSpan(
                              text: ' Reset ',
                              style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: white)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
