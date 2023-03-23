import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcafes/authentication/authentication.dart';
import 'package:smartcafes/models/delivery_address.dart';
import 'package:smartcafes/provider/delivery_address.dart';
import 'package:smartcafes/screens/homepage.dart';
import 'package:smartcafes/utls/constants.dart';
import 'package:smartcafes/widgets/input_field_widget.dart';
import 'package:smartcafes/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  String locationResult = "Magufuli BlockA";

  String collegeResult = "UDSM";

  bool isLoading = false;

  final List<Map<String, dynamic>> _udsmLocationResults = [
    {
      'value': 'Magufuli BlockA',
      'label': 'Magufuli BlockB',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18),
    },
    {
      'value': 'Magufuli BlockA',
      'label': 'Magufuli BlockB',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18),
    },
    {
      'value': 'Magufuli BlockC',
      'label': 'Magufuli BlockC',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18),
    },
    {
      'value': 'Magufuli BlockD',
      'label': 'Magufuli BlockD',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18),
    },
    {
      'value': 'Magufuli BlockE',
      'label': 'Magufuli BlockE',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18),
    },
    {
      'value': 'Magufuli BlockF',
      'label': 'Magufuli BlockF',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18),
    },
    {
      'value': 'Hall1',
      'label': 'Hall1',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18),
    },
    {
      'value': 'Hall2',
      'label': 'Hall2',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
    {
      'value': 'Hall3',
      'label': 'Hall3',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
    {
      'value': 'Hall4',
      'label': 'Hall4',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
    {
      'value': 'Hall5',
      'label': 'Hall5',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
    {
      'value': 'Hall6',
      'label': 'Hall6',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
    {
      'value': 'Hall7',
      'label': 'Hall7',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
    {
      'value': 'Utawala',
      'label': 'Utawala',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
  ];

  final List<Map<String, dynamic>> _collegeResults = [
    {
      'value': 'UDSM',
      'label': 'UDSM',
      // 'icon': Icon(Icons.stop),
      'textStyle': const TextStyle(color: Colors.teal, fontSize: 18)
    },
  ];
  String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String userName =
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
                "Add Delivery Address",
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
            keyboardType: TextInputType.name,
            controller: _nameController,
            hintText: "Name",
          ),
          SizedBox(height: size.height * 0.03),
          const LabelWidget(
            labelText: "Phone Number",
          ),
          SizedBox(height: size.height * 0.01),
          InputFieldWidget(
            obscureText: false,
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            hintText: "phone number",
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SelectFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                labelText: "College",
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: white.withOpacity(0.6),
                ),
                labelStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
              type: SelectFormFieldType.dropdown, // or can be dialog
              initialValue: 'DIT',
              // icon: Icon(Icons.money),
              labelText: 'College',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: white.withOpacity(0.6),
              ),
              items: _collegeResults,
              onChanged: (val) {
                setState(() {
                  collegeResult = val;
                });
              },

              onSaved: (value) {
                if (value == null) {
                } else {
                  setState(() {
                    collegeResult = value;
                  });
                }
              },
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SelectFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                labelText: "Location",
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: white.withOpacity(0.6),
                ),
                labelStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ),
              ),
              type: SelectFormFieldType.dropdown, // or can be dialog
              initialValue: 'Vimbweta DH',
              // icon: Icon(Icons.money),
              labelText: 'Location',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: white.withOpacity(0.6),
              ),
              items: _udsmLocationResults,
              onChanged: (val) {
                setState(() {
                  locationResult = val;
                });
              },

              onSaved: (value) {
                if (value == null) {
                } else {
                  setState(() {
                    locationResult = value;
                  });
                }
              },
            ),
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(height: size.height * 0.03),
          SizedBox(height: size.height * 0.03),
          Center(
            child: ElevatedButton(
              onPressed: isLoading == true
                  ? null
                  : () async {
                      if (_phoneController.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Phone Number is required not filled",
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                            ),
                          ),
                        ));
                      }

                      if (_nameController.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Name is required not filled",
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
                          isLoading == true;
                        });
                        final addAddress = Provider.of<DeliveryAddress>(context,
                            listen: false);
                        await addAddress.addDeliveryAddress(
                            DeliveryAddressModel(
                                email: userEmail,
                                phoneNumber: _phoneController.text,
                                college: collegeResult,
                                location: locationResult,
                                userName: _nameController.text));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Address Added Successfully",
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
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()),
                        );
                      }
                    },
              child: isLoading == true
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      "Add Address",
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
