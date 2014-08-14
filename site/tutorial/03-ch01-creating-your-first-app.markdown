---
layout: tutorial
title: Creating Your First Angular App
previous: 02-welcome-to-angular.html
next: 04-ch02-controller.html
---

# {{page.title}}


<p>In this chapter, you’ll use a “Hello World” app to learn about the
basic structure of an AngularDart app, how to bind a model to your
view, and how to use a couple of built-in Angular directives.</p>

<hr />

<h3 id="running-the-sample-app">Running the sample app</h3>
<p>The code for this chapter is in the <em>
<a href="https://github.com/angular/angular.dart.tutorial/tree/master/Chapter_01">Chapter_01</a></em>
  directory of the
<a href="https://github.com/angular/angular.dart.tutorial/archive/master.zip">
  angular.dart.tutorial download</a>.

View it in Dart Editor by using
<strong>File &gt; Open Existing Folder...</strong> to open the
<strong>Chapter_01</strong> directory.</p>

<p>Now run the app. In Dart Editor’s Files view, select
<strong>Chapter_01/web/index.html</strong>, right-click, and choose
<strong>Run in Dartium</strong>.</p>

<p><strong>Note:</strong> Although AngularDart apps can run in any modern
browser, we recommend using Dartium, for now.
<a href="09-ch07-deploying-your-app.html">Later</a> you’ll learn how to
generate tree-shaken, minified JavaScript that can run in any modern
browser.</p>

<p>Dartium launches, displaying the app. As you type in the field, the
letters you type appear in the title.</p>

<p><img src="img/ch01-1.png" alt="Dartium running the Hello World app" />
<img src="img/ch01-2.png" alt="Hello World app with text" /></p>

<table>
<tbody>
  <tr>
    <td>
      <strong>Note:</strong>
      You might notice <em>{% raw %}{{name}}{% endraw %}</em>
      appearing and then disappearing when the app first starts. Don’t
      worry, <a href="07-ch05-filter-service.html">later</a> you’ll
      learn how to use <code>ng-cloak</code> to hide uncompiled DOM
      values.
    </td>
  </tr>
</tbody>
</table>

<hr class="spacer" />

<h3 id="making-angular-libraries-available-to-your-app">Making Angular
libraries available to your app</h3>

<p>Dart makes dependencies available to the application through the
<strong>pubspec.yaml</strong> file. Here’s the minimal pubspec.yaml
file for this sample:</p>

<script type="template/code">
name: angular_dart_demo
version: 0.0.2
dependencies:
  angular: 0.13.0
transformers:
- angular
</script>

<p>To use AngularDart in any app, include <code>angular</code> as
a dependency.
Also include the <code>angular</code> transformer,
which will be necessary later,
when you convert your app to JavaScript
(as described in
<a href="09-ch07-deploying-your-app.html">Deploying Your App</a>). 
</p>

<p>Dart Editor automatically downloads the packages your app depends on,
along with any packages that they, in turn, depend on. If this download
fails or you like using the command line, you can explicitly install
packages. From Dart Editor, you can use <strong>Tools &gt; Pub Get</strong>.
From the command line (in the root directory of your app, assuming the
Dart SDK is in your path), you can run <code>pub get</code>.</p>

<hr class="spacer" />

<h3 id="the-apps-code">The app’s code</h3>

<p>Two files contain the app’s code:</p>

<dl>
<dt>
  <a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_01/web/index.html">
    index.html</a>
</dt>
<dd>
  <p>Defines the app’s UI and includes the app’s script.</p></dd>
  <dt>
    <a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_01/web/main.dart">
    main.dart</a>
  </dt>
  <dd>
    <p>Defines a main() function that initializes and starts the app.</p>
</dd>
</dl>

<p>Both files are in a directory that’s named <strong>web</strong>, in
accordance with
<a href="http://pub.dartlang.org/doc/package-layout.html">pub package
  layout conventions</a>.</p>

<p>First, let’s look at <strong>index.html</strong>. Notice the addition
of the <code>ng-app</code> directive to the <code>&lt;html&gt;</code>
element:</p>

<script type="template/code">
<html ng-app>
</script>

<p>The <code>ng-app</code> directive tells Angular which element is the
root element of the application. Anything inside of this element is
part of the page template managed by Angular. Unless you have a reason
for Angular to manage only part of the app, we recommend putting the
<code>ng-app</code> directive on the <code>&lt;html&gt;</code> element
because it is the outermost tag. This is also the default behavior
when no <code>ng-app</code> directive is found on the page.</p>

<p>Next, let’s look at the two script tags in the HTML &lt;head&gt;.</p>
<!-- Can not use a script tag here because of nested script tags -->
<pre class="prettyprint">
&lt;script src="packages/web_components/platform.js"&gt;&lt;/script&gt;
&lt;script src="packages/web_components/dart_support.js"&gt;&lt;/script&gt;
</pre>

These two script tag turns on the Shadow DOM (a new web platform feature)
for older browsers.

<p>Next, let’s look at the two script tags at the end.</p>

<!-- Can not use a script tag here because of nested script tags -->
<pre class="prettyprint">
&lt;script type="application/dart" src="main.dart"&gt;&lt;/script&gt;
&lt;script type="text/javascript" src="packages/browser/dart.js"&gt;&lt;/script&gt;
</pre>

<p>This code should be familiar if you’ve ever written a Dart web app.
The first script tag specifies the Dart file that
contains the main() function of your app. The last one runs a script,
<code>dart.js</code>, that determines whether the browser is capable of
running Dart code natively. If so, it runs Dart. If not, it runs
compiled JavaScript. It then registers a callback to be executed by the
browser when the containing HTML page is fully loaded.</p>

<p>Once the page is loaded, Angular looks for the <code>ng-app</code>
directive. If Angular finds the directive, it bootstraps the application
with the root of the application DOM being the element on which the
<code>ng-app</code> directive was defined.</p>

<p>Now let’s look at <strong>main.dart</strong>:</p>

<script type="template/code">
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

void main() {
  applicationFactory().run();
}
</script>

<p>That code is minimal because our app is so simple. The only thing we
see is some code that imports Angular and starts your app.
</p>

<p>Once an Angular application starts up, it’s ready to respond to incoming
browser events that might change the model (such as mouse clicks, key
presses, or incoming HTTP responses). If changes are detected, Angular
reflects them in the view by updating all of the affected bindings.</p>

<hr class="spacer" />

<h3 id="how-angular-does-mvc">How Angular does MVC</h3>
<p>The previous chapter introduced the principles of MVC. Let’s go into a
little more detail about how Angular expresses MVC concepts.</p>

<h4 id="view">View</h4>
<p>In Angular, the view is a projection of the model through the HTML
template. This means that whenever the model changes, Angular updates
the HTML template to reflect those changes.</p>

<h4 id="model">Model</h4>
<p>In our Hello World example, the “name” property is the model. It
appears in two places in the view: where it’s set (in the input element)
and where it’s displayed (in the curly braces, or “mustache”).</p>

<script type="template/code">
<h3>Hello {% raw %}{{name}}{% endraw %}!</h3>
Name: <input type="text" ng-model="name">
</script>

<p>The term <em>scope</em> means the portion of the model that you want to
expose to a view. We’ll go into more detail about scopes in later
chapters. For now, just go with the definition of “The model is the
scope.”</p>

<h4 id="controller">Controller</h4>
<p>A really simple Angular app like this one doesn’t need a controller.
Real apps, however, have controllers. The next chapter dives into
controllers.</p>

<hr class="spacer" />

<h3 id="mustache-syntax-interpolation-and-angular-expressions">Mustache
syntax (interpolation) and Angular expressions</h3>
<p>Angular uses double curly braces <code>{% raw %}{{ ... }}{% endraw %}</code> to contain
Angular expressions. Anything inside the braces is evaluated as a
Dart-like expression. The braces tell Angular to evaluate the expression
and put the result into the DOM. Expressions are “Dart-like” because the
allowed expression syntax is not strictly Dart. Angular expressions
differ from Dart in the following ways:</p>

<ul>
<li>No control flow statements are allowed (no ifs or loops, for
  example).</li>
<li>Dereferencing chained objects is forgiving. For example, foo.bar.baz
  doesn’t blow up if one of the objects along the chain is null.</li>
</ul>

<p>Here’s an example of a simple expression:</p>
<script type="template/code">
{% raw %}{{ 1 + 2 }}{% endraw %}
</script>

<p>Here’s another:</p>
<script type="template/code">
{% raw %}{{ 'foo' + 'bar'}}{% endraw %}
</script>

<p>These expressions would display as <strong>3</strong> and
<strong>foobar</strong>, respectively.</p>

<hr class="spacer" />

<h3 id="mustache-syntax-and-data-binding-in-hello-world">Mustache syntax
and data binding in Hello World</h3>

<p>Here’s how the Hello World app uses the mustache syntax to bind to
the model (“name”) and display the model in the view.</p>

<script type="template/code">
<h3>Hello {% raw %}{{name}}{% endraw %}!</h3>
Name: <input type="text" ng-model="name">
</script>

<p>Notice that the input element has the
<a href="https://docs.angulardart.org/#angular-directive.NgModel">
  <code>ng-model</code></a>
directive, which looks like an HTML attribute. The following chapters
go into more detail about directives. For now, just be aware that
Angular has a construct called directives that extend HTML syntax and
can control the view.</p>

<p>The ng-model directive binds the input’s value attribute to the
property “name” in the current scope. First, Angular checks whether
the property exists in the scope. If it does exist, Angular sets its
value. If not, Angular creates the property in the scope and then sets
the value from the input.</p>

<p>The view displays the value of the model object using the Angular
expression <code>{% raw %}{{name}}{% endraw %}</code>. Notice how the view updates in real
time whenever the model changes. This is called <em>two-way data
binding</em>. Angular listens for changes to the model and updates
the view to reflect those changes.</p>
