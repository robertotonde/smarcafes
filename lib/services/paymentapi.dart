import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentApi {
  void addPayment(String amount, String customer_name, String email,
      String number_used, String channel) async {
    var headers = {
      'Authorization': 'Bearer sk_pgeTQfyYKNNgCh',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://api.shoket.co/v1/charge/'));
    request.body = json.encode({
      "amount": amount,
      "customer_name": customer_name,
      "email": email,
      "number_used": number_used,
      "channel": channel
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
