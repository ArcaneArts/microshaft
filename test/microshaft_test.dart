import 'package:microshaft/microshaft.dart';
import 'package:microshaft/src/ms_client.dart';
import 'package:test/test.dart';

void main() async {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      MicroshaftClient client =
          MicroshaftClient(storage: FileStorage.load("tokens.txt"));
      await client.authenticate((url, code) {
        print("Go to $url");
        print("Enter: $code");
      }).then((value) => print(value.toJson().toString()));
    });
  }, timeout: Timeout(Duration(minutes: 5)));
}
