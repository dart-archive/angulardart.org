// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Convert template/dart templates to <pre class="prettyprint"> tags
(function() {
  var scripts = document.getElementsByTagName("script");
  var length = scripts.length;
  for (var i = 0; i < length; ++i) {
    if (scripts[i].type == "template/code") {
      var code = document.createElement("pre");
      code.className = "prettyprint";
      code.textContent = scripts[i].textContent.replace(/^\s+|\s+$/g, '');
      var parent = scripts[i].parentNode;
      parent.insertBefore(code, scripts[i]);
    }
  }
})();