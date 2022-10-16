import 'package:microshaft/microshaft.dart';
import 'package:microshaft/src/model/shafted.dart';

void main() {
  MicroshaftClient(storage: FileStorage.load("tokens.dat"))
      .authenticate((url, code) {
    print("Go to $url");
    print("Enter: $code");
  }).then((Shafted value) {
    // THE MOJANG TOKEN
    value.mojangToken;

    // THE USERNAME
    value.username;
  });
}
