import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

@Injectable()
class HelloContext {
  String name;
}

main() {
  applicationFactory()
      ..rootContextType(HelloContext)
      ..run();
}
