---
layout: tutorial
title: Production Deployment
previous: 08-ch06-view.html
---

# {{page.title}}

<p>
This chapter shows how to create tree-shaken, minified JavaScript that
can run in any modern browser.
It relies on the
<a href="https://www.dartlang.org/tools/pub/">pub tool</a>
<code>serve</code> and <code>build</code> commands,
both of which use a <em>transformer</em>
provided by the <code>angular</code> package.
</p>


<h2 id="adding-the-transformer">Specifying the angular transformer</h2>

<p>
Before you convert your AngularDart app to JavaScript,
your app's <code>pubspec.yaml</code> file
needs to specify the <code>angular</code> transformer:
</p>

<script type="template/code">
transformers:
- angular
</script>

<p>
For more information about transformers, see
<a href="https://www.dartlang.org/tools/pub/assets-and-transformers.html">Pub Assets and Transformers</a>.

<h2 id="running-the-sample-app">Running the sample app</h2>

<p>
Once your app is working in Dartium,
you're ready to test it in other browsers.
We recommend starting with the <code>pub serve</code> command,
either from the command line or from Dart Editor.
Pub serve continuously monitors your app's assets,
running transformers as necessary
and serving up the transformed assets.
Pub serve doesn't produce files;
all of the transformed assets are in memory.
</p>

<p>
To run <code>pub serve</code> from Dart Editor,
go to the Files view, right-click <b>Chapter_06/web/index.html</b>,
and choose <b>Run as JavaScript</b>.
</p>

<p>
Dart Editor starts <code>pub serve</code>, displaying its output,
and brings up the app in your default browser.
Conversion to JavaScript might take half a minute.
Once the app is available, you can test it in other browsers
by copying the URL into them.
</p>


<h2 id="cross-browser-support">Supporting multiple browsers</h2>

<p>Angular components use  <a href="http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/">
  Shadow DOM</a>, but unfortunately it’s not natively supported in all
modern browsers, so you need to use a
<a href="http://pub.dartlang.org/packages/web_components">polyfill</a>.</p>

<p>
First, include the following script tags in the HTML <code>&lt;head&gt;</code> before any other script tags:
</p>

<!-- Can not use a script tag here because of nested script tags -->
<pre class="prettyprint">
&lt;script src="packages/web_components/webcomponents.min.js"&gt;&lt;/script&gt;
&lt;script src="packages/web_components/dart_support.js"&gt;&lt;/script&gt;
</pre>

<p>You can also use an unminified version for development:</p>

<!-- Can not use a script tag here because of nested script tags -->
<pre class="prettyprint">
&lt;script src="packages/web_components/webcomponents.js"&gt;&lt;/script&gt;
&lt;script src="packages/web_components/dart_support.js"&gt;&lt;/script&gt;
</pre>

<p><strong>Note:</strong> Using the polyfill has
<a href="https://github.com/polymer/ShadowDOM#known-limitations">
  some limitations</a>, so make sure you are aware of those limitations
before you start using it.</p>


<h2 id="generating-files">Generating deployable files</h2>

<p>
Use <code>pub build</code> to generate the app's files.
You can run <code>pub build</code> either from the command line
or from Dart Editor.
</p>

<p>
To run <code>pub build</code> from Dart Editor,
go to the Files view,
right-click the app's <b>pubspec.yaml</b> file,
and choose <b>Pub Build</b>.
The app's deployable files appear
under a directory named <b>build/web</b>.
</p>
