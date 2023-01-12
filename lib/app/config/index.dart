import 'package:bebes/app/config/env.dart';

class ConfigService {
  static renderServerImageUrl(String name) {
    return "${Env.serverUrl}/images/$name";
  }
}
