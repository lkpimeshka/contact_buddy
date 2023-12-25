import 'dart:convert';

import '../model/contact_model.dart';
import 'package:http/http.dart' as http;

Future<ContactModel> fetchContactDetails() async {
  final response = await http.get(Uri.parse(
      'https://run.mocky.io/v3/4ff191af-358d-427c-bc71-5e6031817dec'));

  if (response.statusCode == 200) {
    return ContactModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
