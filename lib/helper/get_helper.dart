import 'package:get_storage/get_storage.dart';

class GetHelper {
  static const String accessToken = 'access-token';
  static const String hostValue='host-value';
  static const String portNumber='port-number';

  static final box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static String getAccessToken() => box.read(accessToken) ?? '';
  static void setAccessToken(String value) => box.write(accessToken, value);

  static String getHost()=> box.read(hostValue)??'';
  static void setHost(String value)=> box.write(hostValue, value);

  static String getPort()=>box.read(portNumber);
  static void setPort(String value)=>box.write(portNumber, value);
}
