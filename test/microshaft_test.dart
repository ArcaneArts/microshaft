import 'package:microshaft/microshaft.dart';
import 'package:microshaft/src/ms_client.dart';
import 'package:test/test.dart';

void main() async {
  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      MicroshaftClient client = MicroshaftClient(storage: MemoryStorage());
      await client.authenticate((url, code) {
        print("Go to $url");
        print("Enter Code: $code");
      }).then((value) {
        if (value != null) {
          print("Credentials: ${value.toJson()}");
        } else {
          print("Authentication Failure");
        }
      });
    });
  }, timeout: Timeout(Duration(minutes: 5)));
}
