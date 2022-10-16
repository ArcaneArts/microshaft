import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:microshaft/src/model/in_device_code.dart';
import 'package:microshaft/src/model/in_device_error.dart';
import 'package:microshaft/src/model/in_device_success.dart';

const String _clientID = "cf95d5d7-7830-4ad4-a70e-d54e50e80b40";

class MicroshaftClient {
  final String clientId;
  final MicroshaftStorage storage;

  MicroshaftClient({required this.storage, this.clientId = _clientID});

  Future<InDeviceSuccess?> authenticate(CodeDisplayer displayer) =>
      _Net.authenticate(displayer, clientId);
}

class MemoryStorage extends MicroshaftStorage {
  final Map<String, String> _storage = {};

  @override
  String? get(String key, [String? or]) => _storage[key] ?? or;

  @override
  void set(String key, String value) => _storage[key] = value;
}

abstract class MicroshaftStorage {
  String? get(String key, [String? or]);

  void set(String key, String value);
}

typedef CodeDisplayer = void Function(String url, String code);

class _Net {
  static Future<InDeviceSuccess?> authenticate(
      CodeDisplayer displayer, String clientId) async {
    final InDeviceCode code = await getAuthCode(clientId);
    displayer(code.verificationUri!, code.userCode!);
    final Duration interval = Duration(seconds: code.intervalSeconds ?? 5);
    bool done = false;
    while (!done) {
      print("<Waiting $interval Seconds>");
      await Future.delayed(interval);

      try {
        dynamic result = await pollAuthCode(code, clientId);

        if (result is InDeviceSuccess) {
          return result;
        }

        if (result is InDeviceError) {
          if (result.error! == "authorization_pending") {
            continue;
          } else {
            print(result.toJson().toString());
          }
        }

        print("Not pending broken...");
        break;
      } catch (e, es) {
        print(e);
        print(es);
      }
    }

    return null;
  }

  // Either InDeviceSuccess or InDeviceError
  static Future<dynamic> pollAuthCode(InDeviceCode code, String clientId) =>
      http
          .post(
              Uri.parse(
                  'https://login.microsoftonline.com/common/oauth2/v2.0/token'),
              headers: <String, String>{
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body:
                  "grant_type=urn:ietf:params:oauth:grant-type:device_code&client_id=$clientId&device_code=${code.deviceCode!}")
          .then((value) {
        if ((jsonDecode(value.body) as Map<String, dynamic>)
            .containsKey("error")) {
          return InDeviceError.fromJson(jsonDecode(value.body));
        }

        print("Success? ${value.body}");
        return InDeviceSuccess.fromJson(jsonDecode(value.body));
      });

  static Future<InDeviceCode> getAuthCode(String clientId) => http
      .post(
        Uri.parse(
            'https://login.microsoftonline.com/common/oauth2/v2.0/devicecode'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: "client_id=$clientId&scope=XboxLive.signin%20offline_access",
      )
      .then((value) => InDeviceCode.fromJson(jsonDecode(value.body)));
}
