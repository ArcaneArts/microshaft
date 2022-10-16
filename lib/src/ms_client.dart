import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:microshaft/microshaft.dart';
import 'package:microshaft/src/model/in_auth_xl.dart';
import 'package:microshaft/src/model/in_auth_xsts.dart';
import 'package:microshaft/src/model/in_mojang.dart';
import 'package:microshaft/src/model/in_device_code.dart';
import 'package:microshaft/src/model/in_device_error.dart';
import 'package:microshaft/src/model/in_device_success.dart';
import 'package:microshaft/src/model/out_auth_xl.dart';
import 'package:microshaft/src/model/out_auth_xl_properties.dart';
import 'package:microshaft/src/model/out_auth_xsts.dart';
import 'package:microshaft/src/model/out_auth_xsts_properties.dart';
import 'package:microshaft/src/model/out_mojang.dart';
import 'package:microshaft/src/model/shafted.dart';

const String _clientID = "cf95d5d7-7830-4ad4-a70e-d54e50e80b40";

class MicroshaftClient {
  final String clientId;
  final MicroshaftStorage storage;

  MicroshaftClient({required this.storage, this.clientId = _clientID});

  Future<Shafted> authenticate(CodeDisplayer displayer) async {
    storage.update();
    Shafted s = Shafted();
    String authToken = await storage.compute("auth.token", () async {
      InDeviceSuccess s = (await _Net.authenticate(displayer, clientId))!;
      storage.setExpiring("auth.token", s.expiresInSeconds!);
      return s.accessToken!;
    });
    s.microsoftAccessToken = authToken;
    String xblToken = await storage.compute("auth.xbltoken", () async {
      InAuthXL s = await _Net.authenticateXBL(authToken);
      storage.setExpiring(
          "auth.xbltoken", int.tryParse(storage.get("auth.token.expires")!)!);
      return s.token!;
    });
    s.xblToken = xblToken;
    String xstsToken = await storage.compute("auth.xststoken", () async {
      InAuthXSTS s = await _Net.authenticateXSTS(xblToken, bedrock: false);
      storage.setExpiring(
          "auth.xststoken", int.tryParse(storage.get("auth.token.expires")!)!);
      storage.set("auth.uhs", s.getUserHash()!);
      return s.token!;
    });
    s.xstsToken = xstsToken;
    s.userHash = storage.get("auth.uhs")!;

    String mojangToken = await storage.compute("auth.mojangtoken", () async {
      InMojang im = await _Net.authenticateMojang(
          xstsToken: xstsToken, userHash: storage.get("auth.uhs")!);
      storage.setExpiring("auth.mojangtoken", im.expiresIn!);
      storage.set("mojang.username", im.username!);
      return im.accessToken!;
    });
    s.mojangToken = mojangToken;
    s.username = storage.get("mojang.username");

    return s;
  }
}

class FileStorage extends MemoryStorage {
  String? _path;

  FileStorage._();

  static FileStorage load(String path) {
    FileStorage f = FileStorage._();
    f._path = path;
    File(path).readAsStringSync().split("\n").forEach((element) {
      if (element.contains("=")) {
        List<String> ff = element.split("=");
        f.set(ff[0], ff[1]);
      }
    });

    return f;
  }

  @override
  Future<void> flush() => File(_path!).writeAsString(
      _storage.entries.map((e) => "${e.key}=${e.value}").join("\n"));
}

class MemoryStorage extends MicroshaftStorage {
  final Map<String, String> _storage = {};

  @override
  String? get(String key, [String? or]) => _storage[key] ?? or;

  @override
  void set(String key, String value) => _storage[key] = value;

  @override
  bool containsKey(String key) => _storage.containsKey(key);

  @override
  Future<void> flush() async {
    // We don't do that here
  }

  @override
  List<String> keys() => _storage.keys.toList(growable: false);

  @override
  void remove(String key) => _storage.remove(key);
}

class ExpiringToken {}

typedef Computer = Future<String> Function();

abstract class MicroshaftStorage {
  String? get(String key, [String? or]);

  void set(String key, String value);

  Future<String> compute(String key, Computer computer,
      {bool save = true}) async {
    if (containsKey(key)) {
      return Future.value(get(key)!);
    }

    String s = await computer();

    if (save) {
      set(key, s);
    }

    return s;
  }

  List<String> keys();

  bool containsKey(String key);

  void remove(String key);

  void setExpiring(String key, int secondsUntil) => set(
      "$key.expires",
      (DateTime.now().millisecondsSinceEpoch + (secondsUntil * 1000))
          .toString());

  void update() {
    for (String i in keys().toList(growable: false)) {
      if (i.endsWith(".expires")) {
        continue;
      }

      if (containsKey("$i.expires")) {
        int? on = int.tryParse(get("$i.expires")!);

        if (on != null &&
            on > 0 &&
            DateTime.now().millisecondsSinceEpoch > on) {
          remove(i);
          remove("$i.expires");
        }
      }
    }
  }

  Future<void> flush();
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

  static Future<InMojang> authenticateMojang(
          {required String userHash, required String xstsToken}) =>
      http
          .post(
              Uri.parse(
                  'https://api.minecraftservices.com/authentication/login_with_xbox'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              },
              body: jsonEncode(
                  OutMojang(identityToken: "XBL3.0 x=$userHash;$xstsToken")))
          .then((value) => InMojang.fromJson(jsonDecode(value.body)));

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
