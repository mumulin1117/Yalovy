(function () {
  "use strict";

  var originalPrompt = "Enter  email";
  var yalovyPrompt = "Enter  email";
  var originalPasswordPrompt = "Enter password";
  var yalovyPasswordPrompt = "Enter password";

  function refineSignupPrompt(root) {
    if (!root || typeof root.querySelectorAll !== "function") return;
    root
      .querySelectorAll(
        '.signup-page uni-input[placeholder="' + originalPrompt + '"], ' +
        '.signup-page input[placeholder="' + originalPrompt + '"]'
      )
      .forEach(function (field) {
        field.setAttribute("placeholder", yalovyPrompt);
      });

    root
      .querySelectorAll(
        '.login-page uni-input[placeholder="' + originalPasswordPrompt + '"], ' +
        '.login-page input[placeholder="' + originalPasswordPrompt + '"]'
      )
      .forEach(function (field) {
        field.setAttribute("placeholder", yalovyPasswordPrompt);
      });
  }

  function beginRefinement() {
    refineSignupPrompt(document);
    var fieldRefinement = new MutationObserver(function () {
      refineSignupPrompt(document);
    });
    fieldRefinement.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["placeholder"],
      childList: true,
      subtree: true
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", beginRefinement, { once: true });
  } else {
    beginRefinement();
  }
})();
