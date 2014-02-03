library examples;

import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:intl/intl.dart';
import './backend-app.dart';

@MirrorsUsed(targets: const[
  'examples',
  'backendapp'
], override: '*')
import 'dart:mirrors';

// Hello example ///////////////////////////////////////////////////////////////

// This example requires no code besides the import above and the main() below.

// Todo example ////////////////////////////////////////////////////////////////

@NgController(
    selector: '[todo-list]',
    publishAs: 'TodoCtrl')
class TodoController {

  List<Todo> todos;
  String todoText;

  TodoController() {
    todos = [
      new Todo('learn angular', true),
      new Todo('build an angular app', false)
    ];
  }

  void addTodo() {
    todos.add(new Todo(todoText, false));
    todoText = '';
  }

  int remaining() {
    var count = 0;
    for (var i = 0; i < todos.length; i++) {
      count += todos[i].done ? 0 : 1;
    }
    return count;
  }

  void archive() {
    var oldTodos = todos;
    todos = [];
    for (var i = 0; i < oldTodos.length; i++) {
      if (!oldTodos[i].done)
        todos.add(oldTodos[i]);
    }
  }
}

class Todo {
  String text;
  bool done;

  Todo(this.text, this.done);
}

class TodoModule extends Module {
  TodoModule() {
    type(TodoController);
  }
}
 
// Tabs example ////////////////////////////////////////////////////////////////

@NgComponent(
    selector: 'tabs',
    templateUrl: 'tabs.html',
    cssUrl: 'tabs.css',
    publishAs: 'tabs',
    visibility: NgDirective.DIRECT_CHILDREN_VISIBILITY
)
class TabsComponent {
  List<PaneComponent> panes = [];

  void select(var pane) {
    for (var i = 0; i < panes.length; i++) {
      this.panes[i].selected = false;
    }
    pane.selected = true;
  }

  void addPane(PaneComponent pane) {
    if (this.panes.length == 0) {
      this.select(pane);
    }
    this.panes.add(pane);
  }
}

@NgComponent(
    selector: 'pane',
    templateUrl: 'pane.html',
    cssUrl: 'pane.css',
    applyAuthorStyles: true,
    publishAs: 'pane',
    map: const {'title' : '@'}
)
class PaneComponent {
  String title = '';
  bool selected = false;

  PaneComponent(TabsComponent tabs) {
    tabs.addPane(this);
  }
}

@NgController(
    selector: '[beer-counter]',
    publishAs: 'beerCounter')
class BeerCounter {
  List<int> beerCounts = [0, 1, 2, 3, 4, 5, 6];
  Function getMessage;

  BeerCounter() {
    if (Intl.defaultLocale.toString() == 'sk_SK') {
      this.getMessage = (beer_count) => Intl.plural(
          beer_count,
          zero: '\u017Eiadne pivo',
          one: '$beer_count pivo',
          few: '$beer_count piv\u00E1',
          other: '$beer_count p\u00EDv');
    } else {
      this.getMessage = (beer_count) => Intl.plural(
          beer_count,
          zero: 'no beers',
          one: '$beer_count beer',
          few: '$beer_count beers',
          other: '$beer_count beers');
    }
  }

}

class TabsModule extends Module {
  TabsModule() {
    type(TabsComponent);
    type(PaneComponent);
    type(BeerCounter);
  }
}

// Forms and Backend example ////////////////////////////////////////////////////////////////


@NgController(
    selector: '[classlist-controller]',
    publishAs: 'ctrl'
)
class ClasslistController {
  List<String> students = [
      {'name': 'Jack Aubrey', 'selected': true},
      {'name': 'Clarissa Oakes', 'selected': true},
      {'name': 'Stephen Maturin', 'selected': false}
  ];

  List<String> get selectedStudents {
    return students.where((student) => student['selected']).toList();
  }
}



// Example entry point /////////////////////////////////////////////////////////

main() {
  ngBootstrap(selector: '#hello-app');
  ngBootstrap(module: new TodoModule(), selector: '#todo-app');
  ngBootstrap(module: new BackendAppModule(), selector: '#backend-app' );
}
