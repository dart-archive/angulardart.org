---
layout: demo
title: AngularDart Demo
---

<h1 id="the-basics">The Basics</h1>
<div class="row example">
  <div class="col-md-8 app-source" app-source="hello.html hello.dart"
       annotate="hello.annotation"></div>
  <hr class="spacer" />
  <div class="col-md-4">
    <span hint></span>
    <span class="pull-right" js-fiddle="hello.html"
          style="display: none;"></span>
    <div class="tabs-spacer"></div>
    <div class="well" ng-non-bindable>
      <div class="angular-dart-example" id="hello-app">
        <label>Name:</label>
        <input type="text" ng-model="yourName"
               placeholder="Enter a name here">
        <hr>
        <h1 ng-cloak>Hello {% raw %}{{yourName}}{% endraw %}!</h1>
      </div>
    </div>
  </div>
</div>

<hr class="shield" />

<h1 id="add-some-control">Structure Your Code</h1>
<div class="row">
  <div class="col-md-4">
    <h3>Data Binding</h3>
    <p>
      Data binding automatically updates the view whenever the model
      changes, and updates the model whenever the view changes.
      Eliminate DOM manipulation from your list of worries. Awesome!
    </p>
  </div>
  <div class="col-md-4">
    <h3>No more boilerplate</h3>
    <p>
      In AngularDart, you express application
      behavior in a clean readable form without the usual boilerplate of
      updating the DOM, registering callbacks, or watching model changes.
    </p>
  </div>
  <div class="col-md-4">
    <h3>Models</h3>
    <p>
      Models are just plain Dart classes. There is no need to inherit from
      proprietary types, or to wrap the model in accessor methods. Code is
      easy to test, maintain, and reuse.
    </p>
  </div>
</div>

<hr class="spacer" />

<div class=" row example">
  <div class="col-md-8 app-source" app-source="todo.html todo.dart todo.css"
       annotate="todo.annotation"></div>
  <hr class="spacer" />
  <div class="col-md-4">
    <span hint></span>
    <span class="pull-right" js-fiddle="todo.html todo.dart todo.css"
          style="display: none;"></span>
    <div class="tabs-spacer"></div>
    <div class="well" ng-non-bindable>
      <h2>Todo</h2>
      <div class="angular-dart-example" todo-list id="todo-app" ng-cloak>
        <span>{% raw %}{{remaining}}{% endraw %} of {% raw %}{{todos.length}}{% endraw %} remaining</span>
        [ <a href="" ng-click="archive()">archive</a> ]
        <ul class="unstyled">
          <li ng-repeat="todo in todos">
            <input type="checkbox" ng-model="todo.done">
            <span class="done-{% raw %}{{todo.done}}{% endraw %}">{% raw %}{{todo.text}}{% endraw %}</span>
          </li>
        </ul>
        <form ng-submit="addTodo()">
          <input type="text" ng-model="todoText"  size="30"
                 placeholder="add new todo here">
          <input class="btn btn-primary btn-small" type="submit" value="add">
        </form>
      </div>
    </div>
  </div>
</div>

<div class="modal hide fade" style="display: none;" id="videoModal">
  <div class="modal-header">
    <a class="close" data-dismiss="modal">×</a>
    <h3>Build Single-Page Apps</h3>
  </div>
  <div class="modal-body">
  </div>
</div>

<hr class="shield" />

<h1 id="wire-up-a-backend">Wire up a Backend</h1>
<div class="row">
  <div class="col-md-4">
    <h3>Deep Linking</h3>
    <p>
      A deep link reflects where the user is in the app, this is useful so
      users can bookmark and email links to locations within apps. Round
      trip apps get this automatically, but AJAX apps by their nature do
      not. AngularDart combines the benefits of deep linking with desktop
      app-like behavior.
    </p>
  </div>
  <div class="col-md-4">
    <h3>Form Validation</h3>
    <p>
      Use built-in validators and avoid imperative code. Write less, go
      have beer sooner.
    </p>
  </div>
  <div class="col-md-4">
    <h3>Connect to RESTful Services</h3>
    <p>
      Dart's high-level implementation of HttpRequest makes server
      communication easy. With AngularDart, you also get testability,
      interceptors, and mocks for the HttpRequest object. Effortlessly
      build data transformations right into your HTTP stack.
    </p>
  </div>
</div>

<hr class="spacer" />

<div class="row example">
<div class="col-md-8 app-source"
     app-source="index.html backend.dart list.html new.html"></div>
<hr class="spacer" />
<div class="col-md-4">
  <span hint></span>
  <span class="pull-right"  resource="resource" module="classlist"></span>
  <div class="tabs-spacer"></div>
  <div class="well" ng-non-bindable>
    <h2>Backend App</h2>
    <div class="angular-dart-example" id="backend-app">
<nav>
<a href="/demo/">Home</a>
<a href="/demo/new">New Entry</a>
</nav>
<ng-view></ng-view>
      </div>
    </div>
  </div>
</div>

  <hr class="shield" />

  <h1 id="create-components">Embrace the Modern Web</h1>
<div class="row">
<div class="col-md-4">
  <h3>Modern Web Standards</h3>
  <p>
      AngularDart components are built with the Shadow DOM for real
      encapsulation of styles and structure. Encapsulate views,
      behaviors, and actions within reusable, nestable components.
  </p>
</div>
<div class="col-md-4">
  <h3>It's Just HTML</h3>
  <p>
    Add behavior to HTML elements. Create and use custom attributes and
    elements for code that's easy to understand at a glance.
  </p>
</div>
<div class="col-md-4"> &nbsp; </div>
</div>

<!--<div class="row example">TODO: Add code for example illustrating component use?</div>-->

<hr class="shield" />

<h1 id="embed-and-inject">Design Scalable Apps</h1>
<div class="row">
  <div class="col-md-4">
    <h3>Injectable</h3>
    <p>
      Write single-purpose components and services, and use Dependency
      Injection to wire up your app. Apps are more testable; components
      are more reusable.
    </p>
  </div>
  <div class="col-md-4">
    <h3>Testable</h3>
    <p>
      Single-purpose components and Dependency Injection make applications
      easy to test. Unit tests are built into the framework.
    </p>
  </div>
  <div class="col-md-4">
    <h3>Reusable</h3>
    <p>
      Develop a large application without large application pain. Easily
      share components and code using Dart's package manager.
    </p>
  </div>
</div>
