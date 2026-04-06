// Flutter Web Bootstrap
(function() {
  'use strict';
  var flutter;
  // Flutter loader
  var scriptTag = document.currentScript;
  window.addEventListener('load', function(ev) {
    _flutter.loader.loadEntrypoint({
      entrypointUrl: scriptTag.src.replace(/[^/]*$/, 'main.dart.js'),
      onEntrypointLoaded: function(engineInitializer) {
        engineInitializer().then(function(appRunner) {
          appRunner.runApp();
        });
      }
    });
  });
})();
