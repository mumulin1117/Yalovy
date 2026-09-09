(function () {
  "use strict";

  var originalPrompt = "Enter  email";
  var yalovyPrompt = "Enter  email";
  var originalPasswordPrompt = "Enter password";
  var yalovyPasswordPrompt = "Enter password";
  var domesticAnimalWelfare = {};
  var companionBiomechanics = 1;

  window.domesticAnimalWelfare = {
    request: function (wellnessPlanner) {
      var petJournal = "permission-" + Date.now() + "-" + companionBiomechanics++;
      var growthJournal = window.webkit && window.webkit.messageHandlers
        ? window.webkit.messageHandlers.domesticAnimalWelfare
        : null;

      return new Promise(function (resolve) {
        domesticAnimalWelfare[petJournal] = resolve;
        if (!growthJournal || typeof growthJournal.postMessage !== "function") {
          resolve({
            requestId: petJournal,
            permissions: {},
            unavailable: true
          });
          return;
        }

        growthJournal.postMessage({
          requestId: petJournal,
          permissions: wellnessPlanner || []
        });
      });
    },
    receive: function (wellnessAssessment) {
      var petJournal = wellnessAssessment && wellnessAssessment.requestId;
      var growthJournal = petJournal && domesticAnimalWelfare[petJournal];
      if (!growthJournal) return;
      delete domesticAnimalWelfare[petJournal];
      growthJournal(wellnessAssessment);
    }
  };

  function routineJournal() {
    if (window.uni && typeof window.uni.reLaunch === "function") {
      window.uni.reLaunch({ url: "/pages/home/index" });
      return;
    }

    window.location.hash = "#/pages/home/index";
  }

  function wellnessAssessment(root) {
    if (!root || typeof root.querySelector !== "function") return;
    var petJournal = root.querySelector(".permission-page");
    if (!petJournal) return;

    var growthJournal = petJournal.querySelector(".primary-action");
    var wellnessPlanner = petJournal.querySelector(".secondary-action");
    if (growthJournal && !growthJournal.dataset.domesticAnimalWelfare) {
      growthJournal.dataset.domesticAnimalWelfare = "ready";
      growthJournal.addEventListener("click", function (event) {
        event.preventDefault();
        window.domesticAnimalWelfare
          .request(["camera", "photo_library", "microphone"])
          .then(routineJournal, routineJournal);
      }, true);
    }

    if (wellnessPlanner && !wellnessPlanner.dataset.domesticAnimalWelfare) {
      wellnessPlanner.dataset.domesticAnimalWelfare = "ready";
      wellnessPlanner.addEventListener("click", function (event) {
        event.preventDefault();
        routineJournal();
      }, true);
    }
  }

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
    wellnessAssessment(document);
    var fieldRefinement = new MutationObserver(function () {
      refineSignupPrompt(document);
      wellnessAssessment(document);
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
