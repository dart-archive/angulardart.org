---
layout: tutorial
title: Creating Views
previous: 07-ch05-filter-service.html
next: 09-ch07-deploying-your-app.html
---

# {{page.title}}

<p>In this chapter, we will examine how to use routing to create different
views in our app. We will also clean up our app a bit by moving
functionality out of our ever-growing <strong>main.dart</strong>,
<strong>recipe_book.dart</strong>, and <strong>index.html</strong> files
into more appropriate locations. Lastly, we will create a more
sophisticated query service  that shows you a little bit more about
Futures. When you are finished, you will be able to create views within
your app that are bookmarkable. You will also have a deeper
understanding of how to write robust application code so that it works
well in the asynchronous world of modern web apps.</p>

<hr />

<h3 id="running-the-sample-app">Running the sample app</h3>
<p>The code for this chapter is in the
<em><a href="https://github.com/angular/angular.dart.tutorial/tree/master/Chapter_06">
  Chapter_06</a></em> directory of the
  <a href="https://github.com/angular/angular.dart.tutorial/archive/master.zip">
    angular.dart.tutorial download</a>.

View it in Dart Editor by using
<strong>File &gt; Open Existing Folder...</strong> to open the
<strong>Chapter_06</strong> directory. </p>

<p>Now run the app. In Dart Editor’s Files view, select
<strong>Chapter_06/web/index.html</strong>, right-click, and choose
<strong>Run in Dartium</strong>.</p>

<p>Click a recipe to view it. The first thing you’ll notice is some new
buttons: in addition to viewing a recipe, you now have buttons to add
and edit recipes as well. Notice how the URL changes to reflect your
specific view when you navigate from recipe to recipe. Notice also that
the back button now works as you would expect.</p>

<hr class="spacer" />

<h3 id="application-structure-and-organization">
Application structure and organization</h3>
<p>Before we dive into routing and views, take a look at the app&rsquo;s
<code>lib</code> folder. The <code>formatter</code> subdirectory is joined
by new subdirectories named <code>component</code>, <code>routing</code>,
and <code>service</code>. As an app grows in size, it can be useful to
organize its source files by function and place them into appropriate
subdirectories like these. We will cover the content of each new
subdirectory as we make our way through the remainder of this
chapter.</p>

<hr class="spacer" />

<h3 id="encapsulating-view-logic-into-components">
Encapsulating view logic into components</h3>
<p>An important refactoring of <strong>main.dart</strong> and
<strong>index.html</strong> that we have performed is to move some of
the view logic into the following components:</p>

<ul>
<li><code>SearchRecipeComponent</code>, responsible for  searching
  recipes (by means of  formatters)</li>
<li><code>ViewRecipeComponent</code>, responsible for presenting a
  recipe&rsquo;s details</li>
</ul>

<p>These components are good examples of encapsulating view-specific
functionality. The <code>RatingComponent</code>, which we introduced in
Chapter 3, is different in that it is truly generic and can be used
anywhere. For this reason, we left it in its own separate subdirectory
(<code>rating</code>). Our two new components aren’t generic. They
contain logic that is specific to the view they control and so they live
in the <code>view</code> directory.</p>

<div class="row">
<div class="col-md-6">
  <h3>index.html (previous Chapter)</h3>

<script type="template/code">
<body recipe-book ng-cloak>
  ...
  <h3>Recipe List</h3>

  <div id="filters">
    <div>
      <label for="name-filter">Filter ... </label>
      <input id="name-filter" type="text"
             ng-model="ctrl.nameFilterString">
    </div>
    <div>
      Filter recipes by category:
      <span ng-repeat="category in ctrl.categories">
        <label>
          <input type="checkbox"
           ng-model="ctrl.categoryFilterMap[category]">
              {{category}}
        </label>
      </span>
    </div>
    <input type="button" value="Clear Filters"
        ng-click="ctrl.clearFilters()">
  </div>

  <div id="recipe-list">...</div>

  <div id="recipe-details">
    <h3>Recipe Details</h3>
    ...
  </div>
</div>
</script>

</div><!-- /.col-md-6 -->

<div class="col-md-6">
  <h3>index.html (revisited)</h3>

<script type="template/code">
<body recipe-book ng-cloak> ...
  <h3>Recipe List</h3> ...
    <search-recipe
        name-filter-string="ctrl.nameFilter"
        category-filter-map="ctrl.categoryFilterMap">
    </search-recipe> ...
    <div id="recipe-list">...</div> ...
  <section id="details">
    <ng-view></ng-view>
  </section>
</div>
</script>

<h3>search_recipe_component.html</h3>

<script type="template/code">
<div id="filters">
  <div>
    <label for="name-filter">Filter ...</label>
    <input id="name-filter" type="text"
           ng-model="cmp.nameFilterString">
  </div>
  <div>
    Filter recipes by category:
    <span ng-repeat="category in cmp.categories">
      <label>
        <input type="checkbox" ... >{{category}}
      </label>
    </span>
  </div>
  <input type="button" value="Clear Filters"...>
</div>
</script>

</div><!-- /.col-md-6 -->
</div><!-- /.rows -->

<div class="clearfix"></div>

<p>&nbsp;</p>

<p>Let’s look at <code>SearchRecipeComponent</code> and the HTML that goes
with it. The component has two attribute fields that should look
familiar: <code>nameFilterString</code> and
<code>categoryFilterMap</code>. The component contains just enough logic
to be able to control the portion of the view responsible for searching
and filtering. Note that both fields are declared as bidirectional. The
component needs the &ldquo;return&rdquo; direction  because its
<code>clearFilter()</code> method updates the search filters by
resetting these two attributes.</p>

<p>Now our app’s main <strong>index.html</strong> file is a lot simpler
(see the table above). Instead of containing all of the markup to set up
the search and filter views, it now just contains the a reference to the
component. The details of the view elements are hidden away in the
<code>SearchRecipeComponent</code>’s HTML template (shown as the lower
right excerpt in the table above).</p>

<script type="template/code">
@Component(
    selector: 'search-recipe',
    templateUrl: 'packages/angular_dart_demo/component/search_recipe_component.html',
    publishAs: 'cmp')
class SearchRecipeComponent {
  Map<String, bool> _categoryFilterMap;
  List<String> _categories;

  @NgTwoWay('name-filter-string')
  String nameFilterString = "";

  @NgTwoWay('category-filter-map')
  Map<String, bool> get categoryFilterMap => _categoryFilterMap;
  void set categoryFilterMap(values) {
    _categoryFilterMap = values;
    _categories = categoryFilterMap.keys.toList();
  }

  List<String> get categories => _categories;

  void clearFilters() {
    _categoryFilterMap.keys.forEach((f) => _categoryFilterMap[f] = false);
    nameFilterString = "";
  }
}
</script>

<hr class="spacer" />

<h3 id="using-routing-to-create-views">Using routing to create views</h3>
<p>In earlier versions of our app, we had only one view. No matter what
you did in the app, the URL never changed to reflect what you were
doing. This is generally undesirable and user unfriendly. If one of our
users found a recipe they liked, they had no way of bookmarking it for
later. Using routing to create views lets us address this problem.
Routing makes it easier to build large single-page applications. It lets
you map the browser address bar to the semantic structure of your
application, and keeps them in sync.</p>

<hr class="spacer" />

<h4 id="configuring-the-router">Configuring the router</h4>
<p>Let’s look at <strong>recipe_book_router.dart</strong>. There we define
all of our app’s routes and map them to views. To take advantage of
routing, just create a function that implements the
<a href="https://docs.angulardart.org/#angular-routing.RouteInitializerFn">
  <code>RouteInitializerFn</code></a> typedef. Angular will look for a
<code>RouteInitializerFn</code> when it instantiates the
router and will use it to configure the routes.
<code>RouteInitializerFn</code> takes two parameters, a <a href="https://docs.angulardart.org/#route-client.Router">
<code>Router</code></a>, and a
<a href="https://docs.angulardart.org/#angular-routing.RouteViewFactory">
  <code>RouteViewFactory</code></a>, both of which are created by the
routing framework for you.</p>

<script type="template/code">
recipeBookRouteInitializer(Router router, RouteViewFactory views) {
  // ...
}
</script>

<p>All you need to do to set up routing is to implement a function,
and then make the <code>RouteInitializerFn</code> available in the
your app’s module configuration:</p>

<script type="template/code">
value(RouteInitializerFn, recipeBookRouteInitializer);
</script>

<p>You configure the router by calling <code>RouteViewFactory.configure()</code>
where you pass a <code>Map</code> of your routes. Keys of that map are route
names, and values are <code>NgRouteCfg</code> objects that can be constructed
using the provided  <code>ngRoute()</code> function. Here is a simple route
configuration.</p>

<script type="template/code">
void recipeBookRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
    'add': ngRoute(
        path: '/add',
        view: 'view/addRecipe.html'),
    'recipe': ngRoute(
        path: '/recipe/:recipeId',
        mount: // ...
  });
}
</script>

<p>Let’s examine the call to <code>ngRoute</code>, and all of its parameters
in detail:</p>

<h5 id="path"><code>path</code></h5>
<p>Is the URL pattern that maps to this route. More than one route can
match a given pattern, so patterns should go from more specific to more
general. (Hint: if your routes are misbehaving, this is probably the
place to start looking for misconfiguration). If you find that you need
to debug your routing configuration, import Dart’s logging library and
add this magic to your <code>main()</code>:</p>

<script type="template/code">
Logger.root.level = Level.FINEST;
Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
</script>

<h5 id="view"><code>view</code></h5>
<p>URL of the template to be loaded into <code>ng-view</code> when the route
is entered.</p>

<h5 id="enter"><code>enter</code></h5>
<p>A <code>RouteEnterEventHandler</code></a> that tells the router what to do when
the route is entered.</p>

<h5 id="enter"><code>preEnter</code></h5>
<p>A <code>RoutePreEnterEventHandler</code></a> that's invoked before the route
is entered and before previous routes are left. The <code>RoutePreEnterEvent</code>
is vetoable, so it can prevent current navigation. It can be used for route
parameter validation, security and other purposes where you might want to
prevent the route from being entered.</p>

<h5 id="leave"><code>leave</code></h5>
<p>A <code>RouteLeaveEventHandler</code> that tells the router what to do when
the route is left. You can use this for a number of purposes. For
example, you can determine if a view is leavable, and what to do if it
shouldn’t be left (for example, if there are unsaved changes on a view,
you might want to prevent the route from leaving, or warn the user that
their changes will be lost).</p>

<h5 id="defaultroute"><code>defaultRoute</code></h5>
<p>Specifies whether this route is the default route.</p>

<hr class="spacer" />

<h4 id="routes-can-do-more-than-just-load-a-view">Routes can do more than
just load a view</h4>
<p>The configuration below is an example of a more complex
<code>enter</code> handler. It uses  <code>defaultRoute</code> and a
special <code>RouteEnterEventHandler</code> to redirect users to something
sane in the event that they entered an invalid URL. In our case, it
routes them back to the “view recipe” view. The
<code>replace: true</code> causes the invalid route to be removed from
the history, so going back doesn’t cause your users to go through an
invalid route.</p>

<script type="template/code">
'view_default': ngRoute(
    defaultRoute: true,
    enter: (RouteEnterEvent e) =>
        router.go('view', {},
            startingFrom: router.root.findRoute('recipe'),
            replace: true))
</script>

<hr class="spacer" />

<h4 id="routes-are-hierarchical">Routes are hierarchical</h4>
<p>The <code>mount</code> parameter allows you to define nested routes.
The URL for each nested route is created by appending it’s path to its
ancestors’ paths. Here is an example of nested paths in our app:</p>

<script type="template/code">
'recipe': ngRoute(
    path: '/recipe/:recipeId',
    mount: {
      'view': ngRoute(
          path: '/view',
          view: 'view/viewRecipe.html'),
      // ...
    })
</script>

<p>Our app’s nested paths are a little more complicated, because they also
add a parameter to the path. In the example above, the all the routes
underneath the recipe subtree require a <code>recipeId</code>
parameter.</p>

<p>Here is how our routing configuration will build the paths we’ve
defined:</p>

<script type="template/code">
...#
...#/add
...#/recipe/6/view
...#/recipe/6/edit
</script>

<hr class="spacer" />

<h4 id="connecting-a-route-to-a-view">Connecting a route to a view</h4>
<p>Now let’s look at the how the routes and views are connected in our
app. There are two pieces involved: the router configuration, and the
<code>ng-view</code> directive. Open up the <strong>index.html</strong>
file and look at the details section. It contains only an
<code>ng-view</code> directive.</p>

<script type="template/code">
<section id="details">
    <ng-view></ng-view>
</section>
</script>

<p>The <code>ng-view</code> directive causes the rendered template of the
current route to be included into the layout where the
<code>ng-view</code> appears. Whenever the current route changes, the
<code>ng-view</code> changes the view.</p>

<p>Next we’ll look at how to make the route parameters available inside
our <code>ViewRecipeComponent</code>.</p>

<p>We’ve added a parameter for the
<a href="https://docs.angulardart.org/#angular-routing.RouteProvider">
  <code>RouteProvider</code></a> to its constructor, which we use to
extract the parameters for the current route. In our case, we extract
the <code>recipeId</code> to look up the recipe being viewed:</p>

<script type="template/code">
ViewRecipeComponent(RouteProvider routeProvider) {
  _recipeId = routeProvider.parameters['recipeId'];
}
</script>

<hr class="spacer" />

<h3 id="more-on-futures">More on Futures</h3>
<p>In this version of our app, we also separated the query layer from our
<code>RecipeBookController</code> by creating a
<code>QueryService</code>. The <code>QueryService</code> does basically
the same thing the old <code>_loadData</code> method did, but with a few
enhancements.</p>

<p><img src="img/ch06-1-QueryServiceOutline.png" alt="QueryService public API outline" /></p>

<p>First, it provides getters for common queries. Notice that these
getters don’t return concrete objects. They return
<a href="https://api.dartlang.org/docs/channels/stable/latest/dart_async/Future.html">
  Future</a>s. Our application code still has to plan for the possibility
that the service will be slow, so our app’s <code>_loadData</code>
method isn’t too different from the last version. It still determines if
the data is loaded and sets appropriate view messages. It just delegates
to the <code>QueryService</code> to do the actual query and JSON
mapping.</p>

<p>Second, we’ve built some caching into the <code>QueryService</code>.
This (overly simplistic) cache determines if the data has already been
loaded, and if so, serves it from the cache. The service guarantees that
data is loaded by using Future chaining. Let’s look at the
<code>QueryService</code> constructor:</p>

<script type="template/code">
@NgInjectableService()
QueryService(Http this._http) {
  _loaded = Future.wait([_loadRecipes(), _loadCategories()]);
}
</script>

<p>It wraps the calls to <code>_loadRecipes</code> and
<code>_loadCategories</code> in a call to
<a href="https://api.dartlang.org/docs/channels/stable/latest/dart_async/Future.html#wait">
  <code>Future.wait</code></a>. <code>Future.wait</code> also returns a
<code>Future</code> which completes only when all the Futures in the
list complete.
The <code>@NgInjectableService</code> annotation
publishes the class as a service.
</p>

<p>The getters in the service (<code>getRecipeById</code>,
<code>getAllRecipes</code>, and <code>getAllCategories</code>) first
check to see if the cache has finished  loading. If not, it returns a
<code>Future</code> that will wait until <code>_loaded</code> is
complete. If the cache has been populated, it still returns a
<code>Future</code> &mdash; a new <code>Future</code> with the value of
the cached data.</p>

<p>Here’s an example:</p>

<script type="template/code">
Future<Recipe> getRecipeById(String id) {
  return _recipesCache == null
      ? _loaded.then((_) => _recipesCache[id])
      : new Future.value(_recipesCache[id]);
}
</script>

<hr class="spacer" />

<h3 id="now-its-your-turn">Now it's your turn</h3>

<p>The app features presented in this chapter make use of stubs for
adding and editing recipes.  The exercises below suggest that you
progressively replace the stubs with full implementations. For the first
two exercises, don’t worry about saving changes back to the mock data
store (i.e., the recipe JSON file); instead, just hold changes in the
model
property <span class="prettyprint"><code>_recipesCache</code></span>. The
last exercise explores writing to the mock data store.</p>

<ol>
<li>Add support for recipe editing. Doing so will require that you
create a view component for editing a recipe. You might want to first
allow editing of the recipe title only, and then progressively support
editing of the remaining recipe properties.</li>

<li>Replace the add recipe stub by a real implementation.</li>

<li>Once you have completed the previous exercises, add support for
writing new and edited recipes back to the
server-side <strong>recipe.json</strong> file, which is acting as a
mock data store. Do so by adding appropriate method(s) to
the <code>QueryService</code>. Since the web browser integrated with
the Dart Editor does not support saving resources, you will need to
test your solution to this exercise using the custom server provided
in the <code>bin</code> directory of this Chapter’s sources.
Launch this custom server like any other
Dart command-line program. The server listens on port 3031 for PUT
requests, but otherwise acts like a typical HTTP server dispatching
static content from the app’s web folder. To run your app on this
server use the following
URL: <a href="http://127.0.0.1:3031/index.html">http://127.0.0.1:3031/index.html</a>.</li>
</ol>
<hr class="spacer" />
<h4 id="extra-credit">Extra challenge</h4>
<p>Try to use the router <code>leave()</code> callback to prevent a user
from leaving a page with unsaved edits.</p>
