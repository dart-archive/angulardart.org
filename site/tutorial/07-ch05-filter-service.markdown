---
layout: tutorial
title: Introducing Formatters and Services
previous: 06-ch04-directive.html
next: 08-ch06-view.html
---

# {{page.title}}


<p>In this chapter, we will add two features to our app. First, we will
get the recipe data from a service instead of hardcoding mock data into
the app. Second, we will look at another handy tool in Angular’s toolbox:
formatters. When you’re finished, you will be able to use built-in
 formatters as well as create your own custom formatters. You will also be
 able to read data from a server-side service like a real app.</p>

<hr />

<h3 id="running-the-sample-app">Running the sample app</h3>
<p>The code for this chapter is in the
<em><a href="https://github.com/angular/angular.dart.tutorial/tree/master/Chapter_05">
    Chapter_05</a></em> directory of the
    <a href="https://github.com/angular/angular.dart.tutorial/archive/master.zip">
    angular.dart.tutorial download</a>.
View it in Dart Editor by using
<strong>File &gt; Open Existing Folder...</strong> to open the
<strong>Chapter_05</strong> directory.</p>

<p>Now run the app. In Dart Editor’s Files view, select
<strong>Chapter_05/web/index.html</strong>, right-click, and choose
<strong>Run in Dartium</strong>.</p>

<p>Notice the text box and checkboxes at the top of the app. You can use
these inputs to control which recipes are shown in the list. Start
typing into the text box and watch the list of visible recipes shrink
to match your search criteria. Next, limit your results further by
checking a few categories to limit to. Try using both filters together
by typing in a search criteria and also limiting based on category.
Lastly, clear the filters by pressing the “Clear Filters” button, and
watch all the recipes reappear.</p>

<hr class="spacer" />

<h3 id="introducing-formatters">Introducing formatters</h3>
<p>Formatters let you change how your model data is displayed in the view
without changing the model data itself. They do things like allow you to
show parts of the model data, or display data in a particular format.
You can also use Angular’s custom formatters feature to create your own
formatters to do anything you want.</p>

<hr class="spacer" />

<h4 id="built-in-formatters">Built-in formatters</h4>
<p>Angular has some built-in formatters that provide handy functionality.</p>

<p>These are pretty self explanatory. <a href="https://docs.angulardart.org/#angular-formatter.Currency"><code>Currency</code></a>
formats numbers like money. <a href="https://docs.angulardart.org/#angular-formatter.Date"><code>Date</code></a> formats dates.
<a href="https://docs.angulardart.org/#angular-formatter.Uppercase"><code>Uppercase</code></a> and <a href="https://docs.angulardart.org/#angular-formatter.Lowercase"><code>Lowercase</code></a> do
what you would expect. <a href="https://docs.angulardart.org/#angular-formatter.LimitTo"><code>LimitTo</code></a> limits the number
of results for a list model object that will appear in the view.</p>

<p>In our app, we use the
<a href="https://docs.angulardart.org/#angular-formatter.Filter">
<code>Filter</code></a> class. Like the <code>LimitTo</code> formatter,
<code>Filter</code> also limits the number of list model
objects that will appear in the view. It chooses which items to display
based on whether they satisfy the filter criteria.</p>

<p>Here is how we use the <code>Filter</code> object.</p>

<p>First, we create a text input box and bind it through
<code>ng-model</code> to a property called <code>nameFilterString</code>.
As the user types into the text input box, it updates the model object’s
<code>nameFilterString</code> property.</p>

<script type="template/code">
<input id="name-formatter" type="text"
       ng-model="ctrl.nameFilterString">
</script>

<p>Next, we pipe the <code>ng-repeat</code> criteria through the formatter,
and tell the Filter formatter (published as <code>filter</code>)
to use <code>ctrl.nameFilterString</code> as the
property to filter against.</p>

<script type="template/code">
<ul>
    <li class="pointer"
        ng-repeat="recipe in ctrl.recipes | filter:{name:ctrl.nameFilterString}">
    ...
    </li>
</ul>
</script>

<p>Lastly, we create a property on our <code>RecipeBookController</code>
to store the <code>nameFilterString</code> property for the input.</p>

<script type="template/code">
String nameFilterString = "";
</script>

<p>That’s all you need to start filtering your results.</p>

<hr class="spacer" />

<h4 id="custom-formatter">Custom formatters</h4>
<p>Built-in formatters are nice, but what if you want to do something more
specific. In our app, we also want to be able to reduce the number of
recipes shown, to those in a particular category. For this, we write a
custom formatter called <code>CategoryFilter</code>.</p>

<p>A custom formatter in Angular is simply a Dart class that declares a
<code>call</code> method with at least one argument:</p>

<script type="template/code">
call(valueToFormat, optArg1, ..., optArgN);
</script>

<p>The first argument is the incoming model object to be formatted; in our
case, it will be the recipe list. The remaining (0 or more) optional
arguments (named <code>optArg</code> above)  serve as input from the
view, and they will be applied in some way to the
<code>valueToFormat</code> to perform the formatting. In our case, as
will be explained below, we need only one optional parameter to let us
weed out recipes from the incoming list that we don’t want to
display.</p>

<p>The <code>call</code> method should return the formatted value. In our
case, it is a new recipe list that is a subset of the incoming recipe
list.</p>

<p>Here is our call method from <code>CategoryFilter</code>:</p>

<script type="template/code">
  List call(recipeList, filterMap) {
    if (recipeList is Iterable && filterMap is Map) {
      // If there is nothing checked, treat it as "everything is checked"
      bool nothingChecked = filterMap.values.every((isChecked) => !isChecked);
      return nothingChecked
          ? recipeList.toList()
          : recipeList.where((i) => filterMap[i.category] == true).toList();
    }
    return const [];
  }
</script>

<p>The <code>filterMap</code> parameter deserves some further explanation.
It’s the data that comes in off of the checkbox inputs. We will talk a
little bit more about how checkboxes work in Angular in the next
section.</p>

<p>Next, annotate the class to publish it as a formatter:

<script type="template/code">
@Formatter(name: 'categoryfilter')
class CategoryFilter { ... }
</script>

      <p>Add the new class to the bootstrapping code:</p>

<script type="template/code">
class MyAppModule extends Module {
  MyAppModule() {
    ...
    type(CategoryFilter)
    ...
  }
}
</script>

<p>and then use it from the view:</p>

<script type="template/code">
<div>
    <label>Filter recipes by category
        <span ng-repeat="category in ctrl.categories">
          <label>
            <input type="checkbox"
                   ng-model="ctrl.categoryFilterMap[category]">{% raw %}{{category}}{% endraw %}
          </label>
        </span>
    </label>
</div>
</script>

<p>Our view creates a checkbox input and label for each category. Angular
stores each checkbox value as a boolean - true if checked, or false if
not checked.</p>

<p>To create the checkboxes, we added a new piece of data to our app - a
list of categories. We use the <code>ng-repeat</code> directive to
iterate through the list and create a checkbox and label for each
category. Inputs in Angular are bound to a model object with the
<code>ng-model</code> directive. Here, we bind to a map called
<code>categoryFilterMap</code>. The map’s keys are the category names,
and the values are true or false depending on whether or not they’re
checked.</p>

<p>Next, we plug the custom formatter in the same way we would plug in a built-in formatter:</p>

<script type="template/code">
<li class="pointer"
    ng-repeat="recipe in ctrl.recipes | categoryfilter:ctrl.categoryFilterMap">
</script>

<hr class="spacer" />
<h4 id="formatter-chaining">Formatter chaining</h4>
<p>Our app uses a feature called formatter chaining to apply more than one
formatter to the same view element. Below, we see the
<code>ng-repeat</code> directive has three formatters separated by pipes.
This is how Angular applies multiple formatters to a single
<code>ng-repeat</code>.</p>

<script type="template/code">
<li class="pointer"
    ng-repeat="recipe in ctrl.recipes | orderBy:'name' | filter:{name:ctrl.nameFilterString} | categoryfilter:ctrl.categoryFilterMap">
</script>


<hr class="spacer" />
<h3 id="introducing-the-httphttpciangularjsorgviewdartjobangulardart-masterjavadocangularcoredomhttphtml-service">
Introducing the Http service</h3>

<p>Our last example had the data hard coded in the app. In reality, you’d
request data from a server. Angular provides a built-in
service called the
<code><a href="https://docs.angulardart.org/#angular-core.Http">Http</a></code>
Service that handles making HTTP
requests to the server. First let’s look at the two new files we’ve
added to the project: <strong>recipes.json</strong> and
<strong>categories.json</strong>. These contain data that’s been
serialized as a JSON string. We will use the <code>Http</code> service
to make an HTTP request to the web server to fetch this data. Let’s look
at how to do this.</p>

<p>First, we declare a property on the <code>RecipeBookController</code>
class. Ours is called <code>_http</code>. The <code>Http</code> service
is part of the core Angular package, so you don’t need to import
anything new. Next, look at the <code>RecipeBookController</code>’s
constructor. We’ve added a parameter and assigned it to the
<code>_http</code> property. Angular instantiates the
<code>RecipeBookController</code> class using
<a href="http://en.wikipedia.org/wiki/Dependency_injection">
  Dependency Injection</a>. In the main method, you set up the injector
with your app’s module where you included the code to construct a
<code>RecipeBookController</code>. The call to
<code>addModule()</code> includes the <code>AngularModule</code>,
which contains injection rules for all of Angular’s core features,
including the <code>Http</code> service.</p>

<script type="template/code">
class RecipeBookController {
  final Http _http;
  ...
  RecipeBookController(this._http) {
    _loadData();
  }
  ...
}
</script>

<script type="template/code">
class MyAppModule extends Module {
  MyAppModule() {
    ...
    type(RecipeBookController);
    ...
  }
}

void main() {
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}
</script>

<p>Next, let’s look at how to use the
Http service to fetch
data from the server. Look at the changes we made to the
<code>_loadData</code> method. Here is the new code:</p>

<script type="template/code">
void _loadData() {
  recipesLoaded = false;
  ...
  _http.get('recipes.json')
    .then((HttpResponse response) {
      recipes = response.data.map((d) => new Recipe.fromJson(d)).toList();
      recipesLoaded = true;
    })
    .catchError((e) {
      recipesLoaded = false;
      message = ERROR_MESSAGE;
    });
  ...
}
</script>

<p>Let’s look more closely at the call to the <code>Http</code> service:</p>

<script type="template/code">
_http.get(URL)
  .then((value) {
    // use value
  })
  .catchError((e) {
    // handle error
  });
</script>

<p>The <code>Http</code> <code>get</code> method returns a
<a href="http://api.dartlang.org/docs/releases/latest/dart_async/Future.html">
  Dart Future</a>. A Future is the promise of a value sometime in the future.
It is at the core of
<a href="https://www.dartlang.org/docs/dart-up-and-running/contents/ch03.html#ch03-asynchronous-programming">
  asynchronous programming in Dart</a>. In its simplest form, the
<code>then()</code> method  takes a single function argument. This
function is invoked when the Future completes with a value (i.e.,
successfully), and is used to process the value returned from the
Future. The <code>catchError()</code> method also takes a function
argument. This function  will be invoked if an error is emitted by the
Future.</p>

<p>The important thing to understand from this example is that Futures are
asynchronous. Your app code will proceed while the data is loading from
the server side. If you are connecting to a very slow service, it is
possible that the app will finish loading before the data has been
returned. The view should be prepared for this. In our case, we need two
pieces of data before the app is useful:</p>

<script type="template/code">
List categories = [];
List<Recipe> recipes = [];
</script>

<p>Until the future has returned, your recipe book contains an empty list
of recipes and an empty list of categories. Any part of your view that
uses or displays recipes or categories will see an empty list. If you
don’t want empty spots displaying on the app, you can surround portions
of your view with statements that display a “Loading...” message until
the data is ready.</p>

<p>In our app, we keep track of the load state for recipes and
categories, and conditionally display a “Loading...” message or the
whole app view. While we could use <code>ng-if</code> to implement the
conditional display logic, let&rsquo;s use an <code>ng-switch</code>
directive instead.</p>

<script type="template/code">
<body recipe-book ng-cloak>
  <div ng-switch="ctrl.recipesLoaded && ctrl.categoriesLoaded">
    <div ng-switch-when="false">
      {% raw %}{{ctrl.message}}{% endraw %}
    </div>
    <div ng-switch-when="true">
      <h3>Recipe List</h3>
      ...
    </div>
  </div>
</body>
</script>

<p>Note that we could replace one of the <code>ng-switch-when</code>
directives above by <code>ng-switch-default</code>. Also, loosely speaking,
expressions of most types are suitable as arguments to
an <code>ng-switch</code>, as long as switch case values can be assigned
to <code>ng-switch-when</code> attributes. For more
details, see the
<a href="http://ci.angularjs.org/view/Dart/job/angular.dart-master/javadoc/angular.directive/NgSwitchDirective.html">
<code>NgSwitchDirective</code> API documentation</a>.</p>

<p>You can see the “Loading...” feature work by simulating a really slow
loading data source. Put a breakpoint inside one of the <code>then()</code>
closures in the <code>_loadData</code> method and
load the app. Notice that while you’re stopped at the breakpoint, your
app shows the  “Loading...” message. Now get out of the breakpoint and
notice that your app’s real view pops into place. Also notice that we
changed the loaded state from false to true inside the asynchronous part
of <code>_loadData</code> (inside the <code>then()</code> call’s
argument). If we’d put it at the end of the <code>_loadData</code>
method outside of the asynchronous call, it would evaluate regardless of
the state of the Future.</p>

<hr class="spacer" />

<h3 id="angular-features">Angular features</h3>
<h4><a href="https://docs.angulardart.org/#angular-directive.NgCloak">
<code>ng-cloak</code></a></h4>
<p>You probably noticed that in previous examples, when you first loaded
your app, you briefly saw curly braces like <code>{% raw %}{{someVar}}{% endraw %}</code>
before your app “popped” into place, and the correct values appeared.
The <code>ng-cloak</code> directive combined with some CSS rules that
you add to your app’s main CSS file allow you to avoid this blink. The
blink happens between the time your HTML loads and Angular is
bootstrapped and has compiled the DOM and has substituted in the real
values for the uncompiled DOM values. While Angular is compiling the
DOM, you can hide the page (or sections of it) by using
<code>ng-cloak</code>:</p>

<script type="template/code">
<body class="ng-cloak">
</script>

<p>or</p>

<script type="template/code">
<body ng-cloak>
</script>

<p>The CSS rule causes the view to be hidden:</p>

<script type="template/code">
[ng-cloak], .ng-cloak {
   display: none !important;
}
</script>

<p>Once Angular is finished compiling the DOM, it secretly removes the
<code>ng-cloak</code> class or directive from the DOM and allows your
app to be visible.</p>

<p>The directive can be applied to the <code>&lt;body&gt;</code> element,
but the preferred usage is to apply multiple <code>ngCloak</code>
directives to small portions of the page to permit progressive rendering
of the browser view.</p>

<hr class="spacer" />

<h3 id="explore-more">Try it yourself</h3>
<p>Now it’s your turn. Here are a few ways in which you can extend the app
version described in this chapter.</p>

<ol>
<li>Write a simple <code>String</code> formatter to replace all the
  occurrences of “sugar” and “powdered sugar” by “maple syrup”, and
  apply it to both the ingredients and the recipe directions.
  <strong>Hint</strong>: Dart has a <code>String</code> function named
  <code>replaceAll()</code> that could be handy in this case.</li>
<li>Write a formatter to convert <em>degrees Fahrenheit</em> (F) into
  <em>degrees Celsius</em> (C) in the recipe directions. Round the
  resulting degrees Celsius to the nearest multiple of 5: e.g., 300
  degrees F would become  150 C. <strong>Hint</strong>: Dart
  <a href="https://api.dartlang.org/apidocs/channels/stable/#dart:core.RegExp">
    regular expressions</a> are likely to be useful.</li>
<li>Assume that you are cooking for a large party.
  Create a formatter that will multiply all the amounts in the recipes.
  <strong>Hint:</strong> You’ll have to change the recipe model to
  include a more full featured “Ingredient” field that contains an
  amount, and then possibly a unit, and finally, an item name. Next, add
  a “multiplier” input that will allow the user to double, triple, or
  quadruple the recipe. Lastly, write a custom formatter that multiplies
  each amount by the number specified in the multiplier input.
  <strong>Note</strong>: If your code fails with the error “5 $digest()
  iterations reached”, then read <a href="http://stackoverflow.com/questions/21322969/angulardart-custom-filter-call-method-required-to-be-idempotent">
    this explanation on StackOverflow</a>.
  Also note the suggested workaround of piping  ingredient values into a
  (custom) <code>toString()</code> formatter.</li>
<li>Finally, if you have not done so already, adapt your solutions to
the first two problems above so that application of each formatter is
controlled by a checkbox.</li>
</ol>
