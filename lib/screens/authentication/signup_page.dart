import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/screens/authentication/login_page.dart';
import 'package:smartcafes/screens/homepage.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/input_field_widget.dart';
import 'package:smartcafes/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isPassword = true;
  bool isLoading = false;
  bool isHidden = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordComfirmController =
      TextEditingController();
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
                    "SIGN UP",
                    style: GoogleFonts.urbanist(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              const LabelWidget(
                labelText: "Username",
              ),
              SizedBox(height: size.height * 0.01),
              InputFieldWidget(
                obscureText: false,
                controller: _nameController,
                hintText: "Username",
              ),
              SizedBox(height: size.height * 0.02),
              const LabelWidget(
                labelText: "Email",
              ),
              SizedBox(height: size.height * 0.01),
              InputFieldWidget(
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                hintText: "Enter Your Email",
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
                hintText: "password",
              ),
              SizedBox(height: size.height * 0.02),
              const LabelWidget(
                labelText: "Verify Password",
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
                controller: _passwordComfirmController,
                hintText: "comfirm password",
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                height: size.height * 0.05,
                width: size.width,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: isLoading == true
                      ? null
                      : () async {
                          if (_passwordController.text !=
                              _passwordComfirmController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Password Didn't match",
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ));
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            final result = await context
                                .read<AuthenticationService>()
                                .registerUsingEmailPassword(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordComfirmController.text,
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
                            if (result == "SignedUp") {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyHomePage()));
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading == true
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          "Create Account",
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
              SizedBox(height: size.height * 0.02),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: ' ',
                        children: [
                          TextSpan(
                              text: 'Already have an Account? ',
                              style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: white)),
                          TextSpan(
                              text: ' SignIn',
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
