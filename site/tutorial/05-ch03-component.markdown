---
layout: tutorial
title: More on Components
previous: 04-ch02-component.html
next: 06-ch04-directive.html
---

# {{page.title}}

<p>In the last chapter, we created a basic Recipe Book app. In this
chapter, we will add to the app by creating a feature that will allow
users to rate each recipe.</p>

<hr />

<h3 id="what-you-will-learn">What you will learn</h3>
<p>Previously, you learned about how to create a basic Angular component.
In this chapter, we will dive deeper into components and their features.</p>

<hr class="spacer" />

<h3 id="running-the-sample-app">Running the sample app</h3>
<p>The code for this chapter is in the
<em><a href="https://github.com/angular/angular.dart.tutorial/tree/master/Chapter_03">
  Chapter_03</a></em> directory of the
<a href="https://github.com/angular/angular.dart.tutorial/archive/master.zip">
  angular.dart.tutorial download</a>.
View it in Dart Editor by using
<strong>File &gt; Open Existing Folder...</strong> to open the
<strong>Chapter_03</strong> directory. </p>

<p>Now run the app. In Dart Editor’s Files view, select
<strong>Chapter_03/web/index.html</strong>, right-click, and choose
<strong>Run in Dartium</strong>.</p>

<p>You’ll notice that the rating, which used to be displayed as a boring
number, has now become a not-so-boring cluster of stars. Play around
with the star ratings by changing the rating on each recipe. Click any
of the recipes to display its details, and notice there is also a star
rating component in the recipe details section. Change the recipe rating
in the details section; the rating in the recipe list section also
changes.</p>

<!--
PENDING: We should add screenshots here.
![TEXT GOES HERE](img/ch03-1.png) &nbsp; &nbsp; &nbsp; ![TEXT GOES HERE](img/ch03-2.png)
-->

<hr class="spacer" />

<h3 id="angular-components">Angular components</h3>
<p>The rating feature is an Angular component, implemented using the
<a href="https://docs.angulardart.org/#angular-core-annotation.Component">
  Component</a> annotation. Components are lightweight, reusable,
self-contained UI components that have a single specific purpose. The
rating component is a great example of a small, simple, re-usable
component. It can be used anywhere in your app as many times as you
want. Nothing about the rating component is intrinsically tied to our
Recipe Book. We could use this component in any app to rate anything.</p>

<hr class="spacer" />

<h4 id="using-components-from-your-app">Using components from your app</h4>
<p>Using a component from your app is simple. Just create an HTML element
with the name of the component, and pass any required properties in as
HTML attributes. Here is how our Recipe Book app uses the rating
component.</p>

<script type="template/code">
<rating max-rating="5" rating="selectedRecipe.rating"></rating>
</script>

<hr class="spacer" />

<h4 id="creating-components">Declaring components</h4>
<p>As seen in the previous chapter, the <code>@Component</code> is used to
declare a component:</p>

<script type="template/code">
@Component(
    selector: 'rating',
    templateUrl: 'rating.html',
    cssUrl: 'rating.css')
class RatingComponent {...}
</script>

<p>The <code>selector</code>, <code>templateUrl</code> and <code>cssUrl</code>
options have been explained in the previous chapter. There are a few more
that can be used.</p>

<h5 id="use-shadow-dom"><code>useShadowDom</code></h5>
By default the component template is inserted into a shadow root node - the
shadow host being the DOM node triggering the component directive.
<code>useShadowDom</code> can be set to false to prevent the usage of shadow DOM
for this component. In such a case the shadow DOM behavior is emulated so that
the features stay the same.

<h5 id="map"><code>map</code></h5>
It can be used to described the bindings for the component. Later in this chapter
fields annotations will be used to the bindings. Those are two ways to describe
your bindings - some might find annotations more expressive.

<hr class="spacer" />

<h4 id="defining-attributes">Defining attributes</h4>

<p>Recall how our Recipe Book app uses the rating component:</p>

<script type="template/code">
<rating max-rating="5" rating="selectedRecipe.rating"></rating>
</script>

<p>To specify which HTML attributes correspond to which properties of the
component, the <code>RatingComponent</code> class uses annotations like the
following:</p>

<script type="template/code">
  @NgTwoWay('rating')
  int rating;

  @NgAttr('max-rating')
  set maxRating(String value) {...}
</script>

<p>The argument to the annotation specifies the HTML attribute name—for
example, “rating” or “max-rating”. Following HTML rules, the attribute
name is case insensitive, with dashes to separate words.</p>

<p>Which annotation you should use depends on how you want the attribute
to be evaluated:</p>

<dl>
<dt> <a href="https://docs.angulardart.org/#angular-core-annotation.NgAttr">NgAttr</a> </dt>
  <dd>
    <p>Sets the property to the value of the attribute, interpolating
      if it contains “{% raw %}{{}}{% endraw %}”. Our example had this:
      <code>max-rating="5"</code>. You could also get the value from the
      model by doing something like
      <code>max-rating="{% raw %}{{someProperty}}{% endraw %}"</code>.</p>

    <p>
      <code>NgAttr</code> attributes are unidirectional. A copy of the attribute is
      passed to the component, and each instance of the component has
      its own copy. The component can change its local value of the
      property without changing the value outside the component.</p>
  </dd>

<dt>
  <a href="https://docs.angulardart.org/#angular-core-annotation.NgOneWay">
    NgOneWay</a></dt>

<dd>
  <p>Evaluates the attribute's value as an expression and passes the
    result to the component. You can use any valid expression—for
    example, <code>"foo + bar"</code> would pass the result of
    <code>foo + bar</code> to the component.</p>

  <p><code>NgOneWay</code> attributes are unidirectional. The component's property
    changes if the expression's value changes, but changing the
    component's property has no effect outside the component.</p>
</dd>

<dt>
  <a href="https://docs.angulardart.org/#angular-core-annotation.NgTwoWay">
    NgTwoWay</a></dt>

<dd>
  <p>Evaluates the expression, passes the result to the component, and
    keeps the expression and property value in sync. Our example set an
    <code>NgTwoWay</code> attribute using this code:
    <code>rating="selectedRecipe.rating"</code></p>

  <p><code>NgTwoWay</code> is bidirectional. When a component changes the value of an
    NgTwoWay-annotated property, the value outside of the component
    changes, as well. In this way, components can change model objects
    in your app. In our example, the rating component changes the rating
    on your RecipeBook’s model objects.</p>
</dd>
</dl>

<hr class="spacer" />

<h4 id="how-components-work">How components work?</h4>

<p>Components inner structure of components are isolated from their surroundings
and can be thought of as black boxes.</p>

<p>Components create their own scope hierarchy that is invisible from the
outside world. They don’t have direct access to the app’s scope, nor
does the app have direct access to a component’s scope.</p>

<p>Components isolate their views from their surroundings by creating a
<a href="http://www.w3.org/TR/shadow-dom/">shadow DOM</a>. Using a shadow
DOM allows components to be used anywhere without suffering from things
like CSS name collisions.</p>

<hr class="spacer" />

<h3 id="angular-features">Angular features</h3>
<p>This chapter introduced you to two more built-in Angular directives:
<code>ng-if</code> and <code>ng-class</code>.</p>

<h4 id="ng-if">
<a href="https://docs.angulardart.org/#angular-directive.NgIf">
  <code>ng-if</code></a></h4>
<p>The <code>ng-if</code> directive allows you to evaluate sections of the
DOM conditionally. The <code>ng-if</code> directive takes an expression.
If the expression is false, then the portion of the DOM underneath the
if is removed. <code>ng-if</code> does not change the visibility of the
DOM element. It removes it.</p>

<h4 id="ng-class">
<a href="https://docs.angulardart.org/#angular-directive.NgClass">
  <code>ng-class</code></a></h4>
<p>The <code>ng-class</code> directive allows you to set CSS classes on an
element dynamically using an expression that evaluates to the classes to
be added.</p>
