---
layout: tutorial
title: Building Something More than Hello World
previous: 03-ch01-creating-your-first-app.html
next: 05-ch03-component.html
---

# {{page.title}}

<p>In the previous chapter, we showed you how to build a “Hello World”
app. Now let’s do something more interesting. Let’s build a Recipe Book
app.</p>

<hr />

<h3 id="what-you-will-learn">What you will learn</h3>
<p>In this tutorial, you will learn how to implement an
<em>Angular component</em>. You will also
learn more about the <em>model</em>, which Angular calls the
<em>scope</em>.</p>

<p>When you’re finished, you will be able to write your own custom
component and use it to control the view. You will understand how to
create data in the model, expose it through the component, and access
it from the view.</p>

<hr class="spacer" />

<h3 id="running-the-sample-app">Running the sample app</h3>
<p>The code for this chapter is in the
<em><a href="https://github.com/angular/angular.dart.tutorial/tree/master/Chapter_02">
  Chapter_02</a></em> directory of the
<a href="https://github.com/angular/angular.dart.tutorial/archive/master.zip">
  angular.dart.tutorial download</a>.
View it in Dart Editor by using <strong>File &gt; Open Existing Folder...</strong>
to open the <strong>Chapter_02</strong> directory. </p>

<p>Now run the app. In Dart Editor’s Files view, select
<strong>Chapter_02/web/index.html</strong>, right-click, and choose
<strong>Run in Dartium</strong>.</p>

<p>Dartium launches, displaying the first version of the Recipe Book app.
Play with the app a bit by clicking on each recipe and watching it
display in the view.</p>

<p><img src="img/ch02-1.png" alt="Dartium running the first Recipe Book app" />
<img src="img/ch02-2.png" alt="Recipe Book with a recipe selected" /></p>

<hr class="spacer" />

<h3 id="understanding-scopes">Understanding scopes</h3>
<p>In previous chapter, we alluded to the scope and provided a partial
definition. In this chapter, we provide a more complete picture of
scopes in Angular.</p>

<p>A <strong>scope</strong> in Angular is an execution context, and is
similar to the idea of a scope or block in conventional programming
languages. There isn’t just one scope in an Angular app. At any given
moment, there is a hierarchy of scopes that roughly mimics the DOM’s
structure. The <code>ng-app</code> directive declares the boundary of
the root scope. Angular elements within the <code>ng-app</code> can
create their own scopes called child scopes. Child scopes implicitly
inherit the properties of their parents, but the properties defined in a
child scope are not visible to the parent scope, nor to sibling
scopes.</p>

<p>The diagram below shows how some relevant portions of the HTML template
map to the Model/Scope, and how it’s represented in the view.</p>

<p><img src="img/scope_diagram.png" alt="scopes" /></p>

<aside class="alert alert-info">
<b>Note:</b>
While this tutorial often refers to the scope as being the context to simplify
things, the execution context is actually held by the <code>context</code> property
of the scope.
</aside>

<h3 id="understanding-the-model">Understanding the model</h3>
<p>In the previous chapter, we gave a simplified definition of the model
(i.e., the model <em>is</em> the scope). In this chapter, we will give a
more accurate definition. The app <strong>model</strong> is defined as
any property, function, or object that is reachable from an app
scope.</p>

<p>There are several ways that model properties, functions, or objects can
be created in a scope. In the previous example, we showed you how to
create and use a model property directly in the view, with code patterns
like this:</p>

<script type="template/code">
<input type="text" ng-model="name">
</script>

<p>Because the application from the previous chapter was very simple, there
was no need to create a component, and the properties were accessed on the
root context (the instance of the <code>Greeter</code> class).</p>

<hr class="spacer" />

<h3 id="understanding-controller">Understanding <code>@Component</code></h3>
<p>To create a component, you only need to add a <code>@Component</code>
annotation on a component class. Before the application can use it, it
needs to be registered in the DI container.</p>

<p>In the Recipe Book example, we see this annotation on the
<code>RecipeBookComponent</code> class:</p>

<script type="template/code">
@Component(
    selector: 'recipe-book',
    templateUrl: 'recipe_book.html')
class RecipeBookComponent {...}
</script>

<p>This annotation tells Angular that the class
<code>RecipeBookComponent</code> is an Angular component. When the
compiler encounters an element that matches the component's <code>selector</code>
in the DOM, it instantiates the component class.</p>

<p>Components are configured by setting properties on the annotation.
Here we describe the most common properties.</p>

<h5 id="selector"><code>selector</code></h5>
<p>The required <code>selector</code> field defines the CSS selector that
will trigger the controller. It can be any valid CSS selector which does
not cross element boundaries. A good practice is that the selectors for
components are element names, as an HTML element can be associated with only
one component.</p>

<h5 id="templateurl-and-cssurl"><code>templateUrl</code> and
<code>cssUrl</code></h5>
<p>Since components are self contained, they need to know what HTML
template and CSS to use for their view. Components do not use the HTML
of your app. They have their own.</p>

<h5 id="template"><code>template</code></h5>
<p>When the template for the component is light, <code>template</code> allows
defining it inline instead of referring to an external file.</p>

<p>Here we also see how to tell the Angular bootstrapping code about our
custom types. Angular uses dependency injection to instantiate the
application classes you create. Inside the
<code>addModule()</code></a> method, a new
<a href="https://docs.angulardart.org/#angular/di.Module"><code>Module</code></a>
is created. This module provides all of Angular’s
built-in services and directives. Your app’s module is added to the
list of modules that Angular loads.</p>

<script type="template/code">
class MyAppModule extends Module {
  MyAppModule() {
    bind(RecipeBookComponent);
  }
}

main() {
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}
</script>

<p>Including your component class in the module allows Angular to
instantiate the component we just created.</p>

<p>From the view, we can use the component by adding an element which
will trigger the CSS selector declared on the component:</p>

<script type="template/code">
<recipe-book></recipe-book>
</script>

<p>Any expressions inside the component template are evaluated against
an instance of the component (the context is the instance of the component).</p>

<hr class="spacer" />

<h3 id="angular-features">Angular features</h3>
<p>In this chapter, we introduced you to two more built-in Angular
directives: <code>ng-repeat</code> and <code>ng-click</code>.</p>

<h4 id="ng-repeat">
<code>ng-repeat</code></h4>
<p>Now that you have a better understanding of scopes, let’s elaborate on
them further by describing what’s going on behind the scenes with the
<code>ng-repeat</code> tag.</p>

<script type="template/code">
<ul>
  <li class="pointer"
      ng-repeat="recipe in recipes"
      ng-click="selectRecipe(recipe)">
    {% raw %}{{recipe.name}}{% endraw %}
  </li>
</ul>
</script>

<p>The <code>ng-repeat</code> directive on the li element causes Angular
to iterate over the model (the <code>recipes</code> property of
RecipeBookComponent), and clone the li in the compiled DOM for each
recipe in the list. Each li is created with its own scope and its own
instance of the recipe property. If the model changes (for example, if a
recipe is added to or deleted from the model), the
<code>ng-repeat</code> directive re-evaluates the model and updates the view
automatically.</p>

<h4 id="ng-click"><code>ng-click</code></h4>
<p><code>ng-click</code> is a built-in Angular directive that allows you
to specify custom behavior when any element is clicked. In our example,
it invokes the <code>selectRecipe()</code> method on the component,
passing it the recipe property from the view.</p>
