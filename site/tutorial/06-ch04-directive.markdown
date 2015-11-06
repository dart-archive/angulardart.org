---
layout: tutorial
title: Creating a Custom Decorator
previous: 05-ch03-component.html
next: 07-ch05-filter-service.html
---

# {{page.title}}


<p>In previous chapters, you learned how to create custom controllers. We will
now learn how to add behavior to any element, using <em>decorators</em>
(<a href="https://docs.angulardart.org/#angular/angular-core-annotation.Decorator">
  Decorator</a>).</p>

<hr />

<p>Decorators offer a way to define behavior that can be triggered using
CSS selectors—most commonly, element attributes. Each element can have
multiple decorators, just as it can have multiple HTML attributes. If
you are familiar with the
<a href="http://en.wikipedia.org/wiki/Decorator_pattern">
  decorator design pattern</a>, then you can think of a decorator as an
<em>HTML element decorator</em>.</p>

<p>This chapter defines a decorator called <em>tooltip</em>. HTML code can
use the tooltip decorator in a span or any other element:</p>

<script type="template/code">
<span tooltip="tooltipForRecipe(recipe)">
  ...
</span>
</script>

<hr class="spacer" />

<h3 id="running-the-sample-app">Running the sample app</h3>
<p>The code for this chapter is in the
<em><a href="https://github.com/angular/angular.dart.tutorial/tree/master/Chapter_04">
  Chapter_04</a> </em> directory of the
<a href="https://github.com/angular/angular.dart.tutorial/archive/master.zip">
  angular.dart.tutorial download</a>. View it in Dart Editor by using
<strong>File &gt; Open Existing Folder...</strong> to open the
<strong>Chapter_04</strong> directory.</p>

<p>Now run the app. In Dart Editor’s Files view, select
<strong>Chapter_04/web/index.html</strong>, right-click, and choose
<strong>Run in Dartium</strong>.</p>

<p>See how mousing over any item in the recipe list brings up a tooltip
for that recipe.</p>

<hr class="spacer" />

<h3 id="custom-decorators">Custom decorators</h3>

<p>Implementing the tooltip required changing the code in the following
ways:</p>

<ul>
<li>Adding <a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_04/lib/tooltip/tooltip.dart">
  two classes</a>: Tooltip implements the decorator, and TooltipModel
  encapsulates its data.</li>
<li>Modifying the component (<a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_04/lib/component/recipe_book.dart">
  RecipeBookComponent</a>) so that it adds an image for each recipe and
  creates tooltip models.</li>
<li>Modifying
  <a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_04/web/main.dart">
    web/main.dart</a> to register the <code>Tooltip</code> type.</li>
<li>Modifying
  <a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_04/lib/component/recipe_book.html">
    lib/component/recipe_book.html</a> to use the tooltip decorator.</li>
</ul>

<hr class="spacer" />

<h3 id="implementing-a-decorator">Implementing a decorator</h3>

<p>The <code>@Decorator</code> annotation declares the decorator, and
the <code>@NgOneWay</code> annotation describes its bindings:</p>

<script type="template/code">
...
import 'package:angular/angular.dart';

@Decorator(selector: '[tooltip]')
class Tooltip {
  final dom.Element element;

  @NgOneWay('tooltip')
  TooltipModel displayModel;
  ...
  Tooltip(this.element) {
    ...
  }
  ...
}
</script>

<p>The <strong>selector</strong> argument to the Decorator constructor
specifies when a <code>Tooltip</code> object should be instantiated: whenever an
element has an attribute named “tooltip”. The <code>@NgOneWay</code>
annotation specifies that the value of the tooltip attribute is bound to
the <code>displayModel</code> property in the <code>Tooltip</code> class.</p>

<p>Consider the following HTML:</p>

<script type="template/code">
<span tooltip="tooltipForRecipe(recipe)">
</script>

<p>Along with the preceding Dart code, this HTML tells AngularDart to
create a <code>Tooltip</code> object and sets its <code>displayModel</code>
property to the value returned by <code>tooltipForRecipe(recipe)</code>. The
<code>Tooltip</code> constructor is passed a single argument, an Element
representing the <code>&lt;span&gt;</code>.</p>

<p>In general, when you want to implement a decorator as an attribute that
takes a value, do it like this:</p>

<script type="template/code">
@Decorator(selector: '[attributeName]')
class MyDecorator {
  @NgOneWay('attributeName')
  Model model;
  ...
  MyDecorator(/* Optional arguments */) {
    ...
  }
  ...
}
</script>

<p>AngularDart’s dependency injection system calls the constructor,
supplying context-specific objects for whatever arguments the
constructor declares.</p>

<p>Back to the Tooltip implementation, most of its code is devoted to
creating a <code>&lt;div&gt;</code> and children to display the tooltip,
and then appending the <code>&lt;div&gt;</code> to the DOM. Here’s the
code that creates and appends the <code>&lt;div&gt;</code>
(<code>tooltipElem</code>) whenever the user mouses over an element that
has a tooltip:</p>

<script type="template/code">
import 'dart:html' as dom;
...
// In an onMouseEnter handler:
tooltipElem = new dom.DivElement();

// ...Create children using info from displayModel...
// ...Add the children to the <div>...
// ...Style the <div>...

dom.document.body.append(tooltipElem);
</script>

<p><strong>Important:</strong> Because Angular expects to have full
control of the DOM, be careful if you dynamically create HTML
elements.</p>

<p>Here are the rules for manipulating DOM elements in decorators:</p>

<ul>
<li>If changing the DOM structure (adding/removing/moving nodes), do so
  only <em>outside</em> of the decorator’s constructor. (Modifying node
  properties, on the other hand, is OK inside the constructor or at any
  other time.)</li>
<li>Don’t destroy elements that AngularDart is managing.</li>
</ul>

<p>In this case, adding the tooltip’s <code>&lt;div&gt;</code> element is
OK because the new element (1) is appended to the
<code>&lt;body&gt;</code> and (2) is added outside the constructor.</p>

<p>You can see all the code to create, position, and destroy tooltips in
<a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_04/lib/tooltip/tooltip.dart">
lib/tooltip/tooltip.dart</a>.</p>

<p>The implementation of the <code>TooltipModel</code> class is trivial.
The class just encapsulates data that the tooltip needs:</p>

<script type="template/code">
class TooltipModel {
  final String imgUrl;
  final String text;
  final int imgWidth;

  TooltipModel(this.imgUrl, this.text, this.imgWidth);
}
</script>

<hr class="spacer" />

<h3 id="modifying-the-component-to-provide-the-model">Modifying the
component to provide the model</h3>

<p>Remember that we want the HTML to be able to use a tooltip decorator
like this:</p>

<script type="template/code">
<span tooltip="tooltipForRecipe(recipe)">
</script>

<p>That means the enclosing component needs to implement
<code>tooltipForRecipe(Recipe)</code>. The tooltip decorator expects a
<code>TooltipModel argument</code>, so that’s the type that
<code>tooltipForRecipe()</code> returns.</p>

<script type="template/code">
class RecipeBookComponent {
  ...
  static final tooltip = new Expando<TooltipModel>();
  TooltipModel tooltipForRecipe(Recipe recipe) {
    if (tooltip[recipe] == null) {
      tooltip[recipe] = new TooltipModel(recipe.imgUrl,
          "I don't have a picture of these recipes, "
          "so here's one of my cat instead!",
          80);
    }
    return tooltip[recipe]; // recipe.tooltip
}
</script>

<p>The use of <a href="https://api.dartlang.org/dart_core/Expando.html">
Expando</a> is an implementation detail. An <code>Expando</code>
is just a way to associate a property (in this case, a TooltipModel)
with an existing object (a recipe). Instead of an Expando, you could use a <a href="https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart-core.Map">
<code>Map</code></a>.</p>

<p>The other changes to
<a href="https://github.com/angular/angular.dart.tutorial/blob/master/Chapter_04/lib/component/recipe_book.dart">
lib/recipe_book.dart</a>
include adding an <code>imgUrl</code> field to the Recipe class.</p>

<hr class="spacer" />

<h3 id="table-angular-annotations">Table: Angular annotations</h3>
<p>The Recipe Book app now uses all both of Angular’s annotation classes.
The following table summarizes how you typically use these annotations,
and whether they create a new scope.</p>

<table>
<tr>
  <th>Annotation</th> <th>Usual usage</th> <th>New scope?</th>
</tr>
<tr>
  <td><code>@Decorator</code></td>
  <td> <b>Decorator</b> that adds to existing elements
    <p>
      Examples: tooltip, ng-class
    </p>
    <p>
      Decorators add to existing elements.
      A single element can have multiple decorators.
    </p>
  </td>
  <td> No </td>
</tr>
<tr>
  <td><code>@Component</code></td>
  <td> <b>Custom elements</b>
    <p>
      Example: rating
    </p>
    <p>
      Although custom elements can contain other elements,
      custom elements (unlike decorators) can’t be combined into
      a single element.
    </p>
  </td>
  <td> Yes (special).
    Uses shadow DOM;
    creates an isolate scope with no automatic access to
    the parent scope.
  </td>
</tr>
</table>
