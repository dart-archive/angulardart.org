library examples;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import './backend-app.dart';


// Hello example ///////////////////////////////////////////////////////////////

@Injectable()
class HelloContext {
  String name;
}

// Todo example ////////////////////////////////////////////////////////////////

@Injectable()
class TodoContext {
  List<TodoItem> todos;
  String todoText;

  TodoContext() {
    todos = [
        new TodoItem('learn angular', true),
        new TodoItem('build an angular app', false)
    ];
  }

  void addTodo() {
    todos.add(new TodoItem(todoText, false));
    todoText = '';
  }

  int get remaining => todos.where((todo) => !todo.done).length;

  void archive() {
    var oldTodos = todos;
    todos = [];
    for (var i = 0; i < oldTodos.length; i++) {
      if (!oldTodos[i].done)
        todos.add(oldTodos[i]);
    }
  }
}

class TodoItem {
  String text;
  bool done;

  TodoItem(this.text, this.done);
}

// Example entry point /////////////////////////////////////////////////////////

main() {
  // Hello World app
  applicationFactory()
      ..selector('#hello-app')
      ..rootContextType(HelloContext)
      ..run();

  // Todo app
  applicationFactory()
      ..selector('#todo-app')
      ..rootContextType(TodoContext)
      ..run();

  // Backend app
//  ngBootstrap(module: new BackendAppModule(), selector: '#backend-app' );

}
