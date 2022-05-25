import 'package:http/http.dart' as http;

setupDB() async {
  await http.get(Uri.parse(
      'https://project-manager-front-test.herokuapp.com/api/v1/users/test/setup'));
}
