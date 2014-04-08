import 'package:angular/angular.dart';
import 'package:angular/angular_dynamic.dart';
 
/* Use the NgController annotation to indicate that this class is an
 * Angular Directive. The compiler will instantiate the directive if
 * it finds it in the DOM.
 *
 * The selector field defines the CSS selector that will trigger the
 * directive. It can be any valid CSS selector which does not cross
 * element boundaries.
 *
 * The publishAs field specifies that the directive instance should be
 * assigned to the current scope under the name specified.
 *
 * The directive's public fields are available for data binding from the view.
 * Similarly, the directive's public methods can be invoked from the view.
 */
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
 
main() {
  dynamicApplication()
      .addModule(new TodoModule())
      .run();
}
