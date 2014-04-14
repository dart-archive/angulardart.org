import 'package:angular/angular.dart';
import 'package:angular/angular_dynamic.dart';
import 'package:angular/routing/module.dart';
import 'package:firebase/firebase.dart';
import 'package:angularfire/angularfire.dart';
 
class BackendAppModule extends Module {
  BackendAppModule() {
    type(SystemPanelCtrl);
    type(NewEntryFormCtrl);
    type(FirebaseResultsAdapter);
    value(RouteInitializerFn, backendAppRouteInit);
  }
}
 
void backendAppRouteInit(Router router, ViewFactory view) {
  router.root
      ..addRoute(
          name: 'new',
          path: '/demo/new',
          enter: view('./new.html'))
      ..addRoute(
          defaultRoute: true,
          name: 'demohome',
          path: '/demo/',
          enter: view('./list.html'));
}
 
@NgInjectableService()
class FirebaseResultsAdapter {
  static const String BASE = 'https://angular-dart-homepage.firebaseio.com/';
  AngularFire _results;
 
  FirebaseResultsAdapter() {
    Firebase fb = new Firebase(BASE);
    _results = new AngularFire(fb);
  }
 
  AngularFire get results =>  _results;
}
 
@NgController(
  selector: '[system-panel]',
  publishAs: 'panel')
class SystemPanelCtrl {
  final Scope scope;
  bool filterOn = false;
  List results;
 
  SystemPanelCtrl(RouteProvider routeProvider, this.scope,
                  FirebaseResultsAdapter adapter) {
    Map params = routeProvider.parameters;
    results = adapter.results.values;
  }
}
 
class SystemEntry {
  static Map<String, String> statusValues() => const {
    "functional"    : "Operations Normal!",
    "unpredictable" : "Runs OK ... Sometimes",
    "crashing"      : "Ughh? What's going on?",
    "offline"       : "Nope. It's not responding"
  };
 
  static Map<String, String> topicValues() => const {
    "webserver" : "Webserver",
    "db"        : "Database Engine",
    "billing"   : "Billing System",
    "coffee"    : "Coffee Machine"
  };
 
  String statusKey, topicKey, status, topic;
 
  SystemEntry(this.topicKey, this.statusKey) {
    topic  = SystemEntry.topicValues()[topicKey];
    status = SystemEntry.statusValues()[statusKey];
  }
 
  Map<String, String> export() => {
    'topicKey': topicKey,
    'topic': topic,
    'statusKey': statusKey,
    'status': status
  };
}
 
@NgController(
  selector: '[entry-form-ctrl]',
  publishAs: 'form')
class NewEntryFormCtrl {
  final Scope _scope;
  final NgForm _form;
  final Router _router;
 
  AngularFire _results;
  String topicKey;
  String statusKey;
  List statuses;
  List topics;
 
  NewEntryFormCtrl(this._router, this._scope, this._form,
                   FirebaseResultsAdapter adapter) {
    topics   = formatAsOptions(SystemEntry.topicValues());
    statuses = formatAsOptions(SystemEntry.statusValues());
    _results = adapter.results;
  }
 
  List formatAsOptions(Map items) {
    var options = [];
    items.forEach((value, title) {
      options.add({
        'value' : value,
        'title' : title
      });
    });
    return options;
  }
 
  submit() {
    SystemEntry entry = new SystemEntry(topicKey, statusKey);
    print(entry.export());
    _results.add(entry.export());
    _router.gotoUrl('home');
  }
}

main() {
  dynamicApplication()
      .addModule(new BackendAppModule())
      .run();
}