import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'package:firebase/firebase.dart';
import 'package:angularfire/angularfire.dart';

class BackendAppModule extends Module {
  BackendAppModule() {
    type(SystemPanelCtrl);
    type(NewEntryFormCtrl);
    type(FirebaseResultsAdapter);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
    type(RouteInitializer, implementedBy: BackendAppRouter);
  }
}

class BackendAppRouter implements RouteInitializer {
  void init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          defaultRoute: true,
          name: 'home',
          enter: view('./list.html')
        )
      ..addRoute(
          name: 'new',
          path: '/new',
          enter: view('./new.html')
        );
  }
}

@NgInjectableService()
class FirebaseResultsAdapter {
  static const String BASE = 'https://angular-dart-homepage.firebaseio.com/';
  Firebase fb = new Firebase(BASE);

  FirebaseAdapter _results;

  FirebaseResultsAdapter() {
    this._results = new AngularFire().create(fb);
  }

  getResults() {
    return _results;
  }
}

@NgController(
  selector: '[system-panel]',
  publishAs: 'panel'
)
class SystemPanelCtrl {
  Scope scope;
  bool filterOn = false;
  FirebaseAdapter results;

  SystemPanelCtrl(RouteProvider routeProvider, Scope this.scope, FirebaseResultsAdapter adapter) {
    Map params = routeProvider.parameters;
    this.results = adapter.getResults().values;
  }
}

class SystemEntry {
  static statusValues() {
    return {
      "functional"    : "Operations Normal!",
      "unpredictable" : "Runs OK ... Sometimes",
      "crashing"      : "Ughh? What's going on?",
      "offline"       : "Nope. It's not responding"
    };
  }

  static topicValues() {
    return {
      "webserver" : "Webserver",
      "db"        : "Database Engine",
      "billing"   : "Billing System",
      "coffee"    : "Coffee Machine"
    };
  }

  String statusKey, topicKey, status, topic;

  SystemEntry(String this.topicKey, String this.statusKey) {
    this.topic  = SystemEntry.topicValues()[this.topicKey];
    this.status = SystemEntry.statusValues()[this.statusKey];
  }

  export() {
    return {
      'topicKey' : this.topicKey,
      'topic' : this.topic,
      'statusKey' : this.statusKey,
      'status' : this.status
    };
  }
}

@NgController(
  selector: '[entry-form-ctrl]',
  publishAs: 'form'
)
class NewEntryFormCtrl {

  Scope _scope;
  NgForm _form;
  Router _router;

  FirebaseAdapter _results;
  String topicKey;
  String statusKey;

  String statuses;
  String topics;

  NewEntryFormCtrl(Router this._router, Scope this._scope, NgForm this._form, FirebaseResultsAdapter adapter) {
    this.topics   = this.formatAsOptions(SystemEntry.topicValues());
    this.statuses = this.formatAsOptions(SystemEntry.statusValues());
    this._results = adapter.getResults();
  }

  formatAsOptions(Map items) {
    List options = [];
    items.forEach((value, title) {
      options.add({
        'value' : value,
        'title' : title
      });
    });
    return options;
  }

  submit() {
    SystemEntry entry = new SystemEntry(this.topicKey, this.statusKey);
    print(entry.export());
    this._results.add(entry.export());
    this._router.gotoUrl('home');
  }
}
