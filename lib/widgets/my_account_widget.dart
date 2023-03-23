import 'package:cached_network_image/cached_network_image.dart';
import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/screens/authentication/login_page.dart';
import 'package:smartcafes/screens/homepage.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/change_name_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccountWidget extends StatelessWidget {
  const MyAccountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white.withOpacity(0.2),
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? userStatus = snapshot.data;
              if (userStatus == null) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )),
                    child: Text(
                      "Login To View Cart",
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipOval(
                              child: Icon(
                            FontAwesomeIcons.user,
                            size: 100,
                            color: Colors.grey,
                          )),
                        ),
                        Row(
                          children: [
                            Text(
                              Provider.of<AuthenticationService>(context)
                                  .getCurrentUname(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.tealAccent),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.pen,
                                size: 15,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ChangeName()),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.tealAccent),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        ListTile(
                          leading: const Icon(Icons.share, color: Colors.white),
                          title: const Text("Share with Friends",
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            Share.share(
                                'Check out Chuo Mall and order your favorite products and get free delivery all around your college/university. Pay via Cash  or Mobile Money(TIGO PESA AIRTEL MONEY, HALOPESA, MPESSA). Products such as books,pens, condoms,food and drinks. https://play.google.com/store/apps/details?id=com.dev.gen.smartcafes');
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        ListTile(
                            leading: const Icon(Icons.rate_review,
                                color: Colors.white),
                            title: const Text("Rate us on play store :)",
                                style: TextStyle(color: Colors.white)),
                            onTap: () async {
                              var url =
                                  'https://play.google.com/store/apps/details?id=com.dev.gen.smartcafes';
                              if (await canLaunch(url)) {
                                await launch(url);
                              }
                            }),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.telegram,
                              color: Colors.white),
                          title: const Text("Customer Support Telegram",
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            var url = 'https://t.me/smartcafes';

                            void _launchURL() async {
                              if (!await launch(url))
                                throw 'Could not launch $url';
                            }

                            _launchURL();
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.whatsapp,
                              color: Colors.white),
                          title: const Text("Customer Support Whatsapp",
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            var url = 'https://wa.me/+255621251541';
                            void _launchURL() async {
                              if (!await launch(url))
                                throw 'Could not launch $url';
                            }

                            _launchURL();
                          },
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.instagram,
                              color: Colors.white),
                          title: const Text("Follow Us On Instagram",
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            var url = 'https://www.instagram.com/smartcafes/';
                            void _launchURL() async {
                              if (!await launch(url))
                                throw 'Could not launch $url';
                            }

                            _launchURL();
                          },
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.twitter,
                              color: Colors.white),
                          title: const Text("Follow Us On Twitter",
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            var url = 'https://twitter.com/smartcafes';
                            void _launchURL() async {
                              if (!await launch(url))
                                throw 'Could not launch $url';
                            }

                            _launchURL();
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()));
                          },
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0.0,
                            child: ListTile(
                                title: Text(
                                  'Home',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: grey6),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.greenAccent,
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Provider.of<AuthenticationService>(context)
                                .signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()));
                          },
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0.0,
                            child: ListTile(
                                title: Text(
                                  'SignOut',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: grey6),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.greenAccent,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
