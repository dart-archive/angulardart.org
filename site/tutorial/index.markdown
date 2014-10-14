---
layout: tutorial
title: Welcome to the AngularDart Tutorial
next: 01-before-you-begin.html
---

# {{page.title}}

<hr>

<p>
  This tutorial introduces you to the important
  features and concepts of AngularDart by
  walking you through a recipe book example.
</p>

<p>
  Want to write some AngularDart code first?
  Try this:
  <a href="https://github.com/angular/ng-darrrt-codelab/blob/master/README.md#code-lab-angulardart"
  class="btn btn-primary">Code Lab: AngularDart</a>
</p>

<p>Also check out this
   <a href="https://github.com/nikgraf/exploring-angular.dart/blob/master/resources.md">list of resources</a>.</p>

<div class="alert alert-warning">
  <strong>This version of the tutorial uses AngularDart version 1.x</strong>
</div>

<table id="tutorial-toc">
  <thead>
    <tr>
      <th>Chapter</th>
      <th>Briefly</th>
      <th>Includes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="01-before-you-begin.html"><b>Before You Begin</b></a></td>
      <td>Prerequisites</td>
      <td>Links to downloads</td>
    </tr>
    <tr>
      <td><a href="02-welcome-to-angular.html">Welcome to Angular</a></td>
      <td>Overview</td>
      <td>Angular, MVC, AngularJS, API docs</td>
    </tr>
    <tr>
      <td><a href="03-ch01-creating-your-first-app.html">
          1. Creating Your First Angular app</a></td>
      <td>A “Hello World” app</td>
      <td>pubspec, <code>ng-app</code>, <code>applicationFactory()</code>,
          MVC, mustache
          syntax ( <code>{{...}}</code> ), Angular expressions, data
          binding (<code>ng-model</code>)</td>
    </tr>
    <tr>
      <td><a href="04-ch02-component.html">2. Something More than
          “Hello World”</a></td>
      <td>A Recipe Book app</td>
      <td>Scopes, models, controllers, <code>@Controller</code>,
          <code>type()</code>, <code>addModule()</code>,
          common properties (<code>selector</code>,
          <code>publishAs</code>), <code>ng-repeat</code>,
          <code>ng-click</code></td>
    </tr>
    <tr>
      <td><a href="05-ch03-component.html">3. Creating a Custom
          Component</a></td>
      <td>A rating component for Recipe Book</td>
      <td><code>@Component</code>, properties (<code>selector</code> &amp;
          <code>publishAs</code> again, <code>templateUrl</code>,
          <code>cssUrl</code>), <code>@NgAttr</code>, <code>@NgOneWay</code>, <code>@NgTwoWay</code>, component
          vs. controller, <code>ng-if</code>, <code>ng-class</code></td>
    </tr>
    <tr>
      <td><a href="06-ch04-directive.html">4. Creating a Custom
          Decorator</a></td>
      <td>Tooltips for Recipe Book</td>
      <td><code>@Decorator</code>, custom element attributes, DOM manipulation,
          table comparing <code>@Controller</code> &amp; <code>@Decorator</code> &amp;
          <code>@Component</code></td>
    </tr>
    <tr>
      <td><a href="07-ch05-filter-service.html">5. Introducing Formatters
            and Services</a></td>
      <td>Filtering recipes by category, fetching data</td>
      <td>Built-in and custom formatters, the <code>Http</code> service (to
          load JSON data asynchronously), displaying a “Loading...”
          message until data is
          loaded, <code>ng-switch</code>, <code>ng-cloak</code></td>
    </tr>
    <tr>
      <td><a href="08-ch06-view.html">6. Creating Views</a></td>
      <td>Reorganizing the app, customizing URLs</td>
      <td>App structure, view-specific components, changing the app URL,
          Router, RouteViewFactory, <code>addRoute()</code>,
          <code>ng-view</code></td>
    </tr>
    <tr>
      <td><a href="09-ch07-deploying-your-app.html">7. Deploying Your
          App</a></td>
      <td>Generating JavaScript</td>
      <td>Transformers, <code>pub serve</code>, <code>pub build</code>,
          minification, performance, code generation,
          cross-browser support</td>
    </tr>
  </tbody>
</table>
