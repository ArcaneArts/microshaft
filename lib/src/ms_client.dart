import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:microshaft/src/model/in_auth_xl.dart';
import 'package:microshaft/src/model/in_auth_xsts.dart';
import 'package:microshaft/src/model/ms/in_device_code.dart';
import 'package:microshaft/src/model/ms/in_device_error.dart';
import 'package:microshaft/src/model/ms/in_device_success.dart';
import 'package:microshaft/src/model/out_auth_xl.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';
import 'package:microshaft/src/model/out_auth_xsts.dart';
import 'package:microshaft/src/model/out_auth_xsts_properties.dart';

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
      print("<Waiting ${interval.inSeconds} Seconds>");
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

  static Future<InAuthXL> authenticateXBL(String accessToken) => http
      .post(Uri.parse('https://user.auth.xboxlive.com/user/authenticate'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode(OutAuthXL(
                  tokenType: "JWT",
                  relyingParty: "http://auth.xboxlive.com",
                  properties: OutAuthXLProperties(
                      siteName: "user.auth.xboxlive.com",
                      authMethod: "RPS",
                      rpsTicket: "d=$accessToken"))
              .toJson()))
      .then((value) => InAuthXL.fromJson(jsonDecode(value.body)));

  static Future<InAuthXSTS> authenticateXSTS(String xblToken,
          {bool bedrock = false}) =>
      http
          .post(Uri.parse('https://xsts.auth.xboxlive.com/xsts/authorize'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              },
              body: jsonEncode(OutAuthXSTS(
                  tokenType: "JWT",
                  properties: OutAuthXSTSProperties(
                      sandboxId: "RETAIL", userTokens: [xblToken]),
                  relyingParty: bedrock
                      ? "https://pocket.realms.minecraft.net/"
                      : "rp://api.minecraftservices.com/")))
          .then((value) {
        Map<String, dynamic> map = jsonDecode(value.body);

        if (map.containsKey("XErr")) {
          if (map["XErr"] == "2148916233") {
            print(
                "Error: ${map["XErr"]}: The account doesn't have an Xbox account. Once they sign up for one (or login through minecraft.net to create one) then they can proceed with the login. This shouldn't happen with accounts that have purchased Minecraft with a Microsoft account, as they would've already gone through that Xbox signup process.");
          } else if (map["XErr"] == "2148916235") {
            print(
                "Error: ${map["XErr"]}: The account is from a country where Xbox Live is not available/banned");
          } else if (map["XErr"] == "2148916236") {
            print(
                "Error: ${map["XErr"]}: The account needs adult verification on Xbox page. (South Korea)");
          } else if (map["XErr"] == "2148916237") {
            print(
                "Error: ${map["XErr"]}: The account needs adult verification on Xbox page. (South Korea)");
          } else if (map["XErr"] == "2148916238") {
            print(
                "Error: ${map["XErr"]}: The account is a child (under 18) and cannot proceed unless the account is added to a Family by an adult. This only seems to occur when using a custom Microsoft Azure application. When using the Minecraft launchers client id, this doesn't trigger.");
          } else {
            print(
                "Error: ${map["XErr"]} Unknown Error... Google it idk. We cant help you.");
          }
        }

        return value;
      }).then((value) => InAuthXSTS.fromJson(jsonDecode(value.body)));

  /// Either InDeviceSuccess or InDeviceError
  static Future<dynamic> pollAuthCode(InDeviceCode code, String clientId) =>
      http
          .post(
              Uri.parse(
                  'https://login.microsoftonline.com/consumers/oauth2/v2.0/token'),
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
            'https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: "client_id=$clientId&scope=XboxLive.signin",
      )
      .then((value) => InDeviceCode.fromJson(jsonDecode(value.body)));
}
