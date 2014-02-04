library backendapp;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';
import 'package:firebase/firebase.dart';
import 'package:angularfire/angularfire.dart';
import 'dart:html';

class BackendAppModule extends Module {
  BackendAppModule() {
    type(SystemPanelCtrl);
    type(NewEntryFormCtrl);
    type(FirebaseResultsAdapter);
    type(RouteInitializer, implementedBy: BackendAppRouter);
  }
}

class BackendAppRouter implements RouteInitializer {
  void init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
        name: 'new',
        path: '/demo/new',
        enter: view('./new.html')
      )
      ..addRoute(
        defaultRoute: true,
        name: 'demohome',
        path: '/demo/',
        enter: view('./list.html')
    );
  }
}

@NgInjectableService()
class FirebaseResultsAdapter {
  static const String BASE = 'https://angular-dart-homepage.firebaseio.com/';
  Firebase fb = new Firebase(BASE);

  FirebaseAdapter _results;

  FirebaseResultsAdapter(): _results = new AngularFire(fb);

  FirebaseAdapter get results =>  _results;
}

@NgController(
  selector: '[system-panel]',
  publishAs: 'panel')
class SystemPanelCtrl {
  final Scope scope;
  bool filterOn = false;
  FirebaseAdapter results;

  SystemPanelCtrl(RouteProvider routeProvider, this.scope, FirebaseResultsAdapter adapter) {
    Map params = routeProvider.parameters;
    results = adapter.results.values;
  }
}

class SystemEntry {
  static Map<String, String> statusValues() => {
    "functional"    : "Operations Normal!",
    "unpredictable" : "Runs OK ... Sometimes",
    "crashing"      : "Ughh? What's going on?",
    "offline"       : "Nope. It's not responding"
  };

  static Map<String, String> topicValues() => {
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

  export() => {
    'topicKey' : this.topicKey,
    'topic' : this.topic,
    'statusKey' : this.statusKey,
    'status' : this.status
  };
}

@NgController(
  selector: '[entry-form-ctrl]',
  publishAs: 'form')
class NewEntryFormCtrl {

  final Scope _scope;
  final NgForm _form;
  final Router _router;

  FirebaseAdapter _results;
  String topicKey;
  String statusKey;
  String statuses;
  String topics;

  NewEntryFormCtrl(this._router, this._scope, this._form, FirebaseResultsAdapter adapter) {
    topics   = this.formatAsOptions(SystemEntry.topicValues());
    statuses = this.formatAsOptions(SystemEntry.statusValues());
    _results = adapter.results;
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
    SystemEntry entry = new SystemEntry(topicKey, statusKey);
    print(entry.export());
    this._results.add(entry.export());
    this._router.gotoUrl('home');
  }
}
