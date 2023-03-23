import 'package:http/http.dart' as http;
import 'dart:convert';

Future sendEmail({
  required String userName,
  required String userEmail,
  required String college,
  required String location,
  required String userPhone,
  required String uID,
  required String provider,
}) async {
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  const serviceId = 'service_dr1tncg';
  const templateId = 'template_bb25bnf';
  const userId = '6L6ha8KGmzxW7l5Hq';

  await http.post(url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'username': userName,
          'college': college,
          'location': location,
          'uID': uID,
          'provider': provider,
          'user_email': userEmail,
          'user_phone': userPhone
        }
      }));
}
