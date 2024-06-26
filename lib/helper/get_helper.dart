import 'package:get_storage/get_storage.dart';

class GetHelper {
  static const String accessToken = 'access-token';

  static final box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static String getAccessToken() => box.read(accessToken) ?? '';
  static void setAccessToken(String value) => box.write(accessToken, value);
}
