(function () {
  "use strict";

  var acceptanceKey = "yalovy.eula.accepted.v1";
  var acceptedValue = "accepted";

  function hasAccepted() {
    try {
      return window.localStorage.getItem(acceptanceKey) === acceptedValue;
    } catch (_) {
      return false;
    }
  }

  function rememberAcceptance() {
    try {
      window.localStorage.setItem(acceptanceKey, acceptedValue);
      window.localStorage.setItem("yalovy.eula.acceptedAt.v1", new Date().toISOString());
    } catch (_) {}
  }

  if (!hasAccepted()) {
    document.documentElement.classList.add("yalovy-first-step-pending");
  }

  function createElement(markup) {
    var template = document.createElement("template");
    template.innerHTML = markup.trim();
    return template.content.firstElementChild;
  }

  function mountFirstStep() {
    if (hasAccepted()) {
      document.documentElement.classList.remove("yalovy-first-step-pending");
      return;
    }

    var screen = createElement(
      '<section class="yalovy-first-step" role="dialog" aria-modal="true" aria-labelledby="yalovy-first-step-title">' +
        '<div class="yalovy-first-step__glow yalovy-first-step__glow--top"></div>' +
        '<div class="yalovy-first-step__glow yalovy-first-step__glow--bottom"></div>' +
        '<main class="yalovy-first-step__main">' +
          '<header class="yalovy-first-step__hero">' +
            '<div class="yalovy-first-step__mark"><img src="./yalovy-content/interface-symbols/yalovy-paw.svg" alt=""></div>' +
            '<div class="yalovy-first-step__eyebrow">A gentle home for growing memories</div>' +
            '<h1 id="yalovy-first-step-title">Welcome to Yalovy</h1>' +
            '<p>Keep the little things that shape a pet\'s story—from a first walk and a new trick to the quiet routines that become part of home.</p>' +
          '</header>' +
          '<article class="yalovy-first-step__card" aria-label="End User License Agreement">' +
            '<div class="yalovy-first-step__card-heading">' +
              '<div><span class="yalovy-first-step__kicker">Before we begin</span><h2>End User License Agreement</h2></div>' +
              '<span class="yalovy-first-step__edition">Updated Sep 9, 2026</span>' +
            '</div>' +
            '<div class="yalovy-first-step__rules">' +
              '<section><span>01</span><div><h3>Eligibility and acceptance</h3><p>You must be at least 13 years old. By continuing, you agree to this agreement, the Terms of Service, and the Privacy Policy.</p></div></section>' +
              '<section><span>02</span><div><h3>A personal license</h3><p>Yalovy grants you a limited, personal, non-transferable license to use the app on Apple devices you own or control, subject to Apple\'s usage rules.</p></div></section>' +
              '<section><span>03</span><div><h3>Your pet memories</h3><p>You keep ownership of material you create. You confirm that you have the rights and permission needed for anything you add or make visible to others.</p></div></section>' +
              '<section><span>04</span><div><h3>Kind and lawful conduct</h3><p>Yalovy has no tolerance for objectionable material or abusive behavior. Do not add unlawful, deceptive, hateful, threatening, sexually explicit, privacy-invasive, or rights-infringing material, impersonate others, or disrupt the experience.</p></div></section>' +
              '<section><span>05</span><div><h3>Protection tools</h3><p>You can report inappropriate material and block unwanted interactions. Yalovy may review reports, restrict access, or remove material that violates these rules or applicable law.</p></div></section>' +
              '<section><span>06</span><div><h3>Privacy and device access</h3><p>Device capabilities are requested only when you choose a related feature. Information is handled as described in the Privacy Policy, and permission choices can be changed in iOS Settings.</p></div></section>' +
              '<section><span>07</span><div><h3>Apple transactions</h3><p>Optional digital items are processed through Apple\'s In-App Purchase system. Apple manages billing, storefront pricing, and eligible refund requests under its rules.</p></div></section>' +
              '<section><span>08</span><div><h3>Availability and responsibility</h3><p>The app is provided subject to applicable law. Features may change to protect users or maintain the service. Liability is limited only to the extent permitted by law.</p></div></section>' +
              '<section><span>09</span><div><h3>Ending access and support</h3><p>You may stop using Yalovy or delete your account in Settings. Access may be limited for serious or repeated violations. Questions can be sent to yalovy@gmail.com.</p></div></section>' +
            '</div>' +
            '<p class="yalovy-first-step__apple-note">This agreement supplements Apple\'s Standard End User License Agreement. If a provision conflicts with Apple\'s applicable terms, Apple\'s terms govern.</p>' +
          '</article>' +
        '</main>' +
        '<footer class="yalovy-first-step__footer">' +
          '<label class="yalovy-first-step__consent">' +
            '<input class="yalovy-first-step__checkbox" type="checkbox" aria-describedby="yalovy-first-step-hint">' +
            '<span class="yalovy-first-step__checkmark" aria-hidden="true"><svg viewBox="0 0 18 18"><path d="M4 9.2 7.3 12.5 14.2 5.7"></path></svg></span>' +
            '<span>I have read and agree to the <button type="button" data-legal-document="terms">Terms of Service</button> and <button type="button" data-legal-document="privacy">Privacy Policy</button>.</span>' +
          '</label>' +
          '<p id="yalovy-first-step-hint" class="yalovy-first-step__hint">Select the box to continue into Yalovy.</p>' +
          '<button class="yalovy-first-step__continue" type="button" disabled aria-disabled="true"><span>Agree &amp; Continue</span><span aria-hidden="true">→</span></button>' +
        '</footer>' +
      '</section>'
    );

    var legalLayer = createElement(
      '<section class="yalovy-legal-layer" role="dialog" aria-modal="true" aria-labelledby="yalovy-legal-title" hidden>' +
        '<button class="yalovy-legal-layer__backdrop" type="button" aria-label="Close"></button>' +
        '<article class="yalovy-legal-sheet">' +
          '<div class="yalovy-legal-sheet__handle"></div>' +
          '<header><div><span>Yalovy</span><h2 id="yalovy-legal-title"></h2></div><button class="yalovy-legal-sheet__close" type="button" aria-label="Close">×</button></header>' +
          '<div class="yalovy-legal-sheet__body"></div>' +
        '</article>' +
      '</section>'
    );

    var legalDocuments = {
      terms: {
        title: "Terms of Service",
        body:
          '<p class="yalovy-legal-sheet__updated">Last updated: September 9, 2026</p>' +
          '<h3>1. Using Yalovy</h3><p>Yalovy is a pet-focused place for preserving and exploring everyday pet memories. You must be at least 13 years old and provide accurate account information. You are responsible for activity under your account.</p>' +
          '<h3>2. Material you provide</h3><p>You retain ownership of your original material. You grant Yalovy the limited permission needed to store, display, and operate the features you choose. Only add material you own or are authorized to use.</p>' +
          '<h3>3. Respectful participation</h3><p>Yalovy has no tolerance for objectionable material or abusive behavior. Do not provide unlawful, fraudulent, hateful, threatening, sexually explicit, privacy-invasive, or intellectual-property-infringing material. Do not impersonate another person, manipulate app functions, or interfere with another person\'s use.</p>' +
          '<h3>4. Reports and blocks</h3><p>Use the in-app report and block controls when needed. Yalovy may examine reports, restrict visibility, remove material, or limit access when reasonably necessary to enforce these terms, protect people, or comply with law.</p>' +
          '<h3>5. Optional digital items</h3><p>Eligible transactions are processed by Apple through the App Store. Storefront pricing, taxes, billing, and refund handling are governed by Apple\'s terms. Digital items have no cash value and cannot be transferred outside Yalovy.</p>' +
          '<h3>6. Changes and availability</h3><p>Features may evolve, pause, or end. We will not exclude rights that cannot legally be excluded. To the extent permitted by law, Yalovy is not responsible for indirect or unforeseeable loss.</p>' +
          '<h3>7. Account choices</h3><p>You can remove your material, manage blocked accounts, or delete your account from Settings. Serious or repeated violations may result in restricted access.</p>' +
          '<h3>8. Contact</h3><p>For questions about these terms, contact yalovy@gmail.com.</p>'
      },
      privacy: {
        title: "Privacy Policy",
        body:
          '<p class="yalovy-legal-sheet__updated">Last updated: September 9, 2026</p>' +
          '<h3>1. Information you choose to provide</h3><p>Yalovy may process account details, pet details, photos, notes, preferences, reports, and other information you choose to use with app features.</p>' +
          '<h3>2. Device capabilities</h3><p>Camera, photo-library, and microphone access is requested only when you choose a related creation feature. You can decline a request or change access later in iOS Settings.</p>' +
          '<h3>3. How information is used</h3><p>Information is used to provide chosen features, preserve your settings, maintain account and protection tools, respond to requests, prevent misuse, and meet legal obligations.</p>' +
          '<h3>4. Visibility and control</h3><p>The visibility choice you make determines whether an entry remains private or is available in pet-focused discovery areas. You can edit or remove your entries and use reporting and blocking controls.</p>' +
          '<h3>5. Apple services</h3><p>Apple processes App Store transactions under Apple\'s privacy terms. Yalovy does not receive your full card details.</p>' +
          '<h3>6. Retention and deletion</h3><p>Information is kept only as needed for app operation, protection, and legal requirements. You may delete your account in Settings. Limited records may be retained where required for fraud prevention, dispute handling, or legal compliance.</p>' +
          '<h3>7. Children</h3><p>Yalovy is not intended for children under 13. Contact us if you believe a child has provided personal information.</p>' +
          '<h3>8. Contact</h3><p>For privacy questions or requests, contact yalovy@gmail.com.</p>'
      }
    };

    function closeLegalDocument() {
      legalLayer.classList.remove("yalovy-legal-layer--visible");
      window.setTimeout(function () {
        legalLayer.hidden = true;
      }, 220);
    }

    function openLegalDocument(kind) {
      var chosenLeaf = legalDocuments[kind];
      if (!chosenLeaf) return;
      legalLayer.querySelector("#yalovy-legal-title").textContent = chosenLeaf.title;
      legalLayer.querySelector(".yalovy-legal-sheet__body").innerHTML = chosenLeaf.body;
      legalLayer.hidden = false;
      window.requestAnimationFrame(function () {
        legalLayer.classList.add("yalovy-legal-layer--visible");
        legalLayer.querySelector(".yalovy-legal-sheet__close").focus();
      });
    }

    var checkbox = screen.querySelector(".yalovy-first-step__checkbox");
    var continueButton = screen.querySelector(".yalovy-first-step__continue");
    var hint = screen.querySelector(".yalovy-first-step__hint");

    checkbox.addEventListener("change", function () {
      continueButton.disabled = !checkbox.checked;
      continueButton.setAttribute("aria-disabled", String(!checkbox.checked));
      hint.textContent = checkbox.checked
        ? "Thank you. Your choice will be remembered on this device."
        : "Select the box to continue into Yalovy.";
      screen.classList.toggle("yalovy-first-step--ready", checkbox.checked);
    });

    screen.querySelectorAll("[data-legal-document]").forEach(function (button) {
      button.addEventListener("click", function (event) {
        event.preventDefault();
        openLegalDocument(button.getAttribute("data-legal-document"));
      });
    });

    continueButton.addEventListener("click", function () {
      if (!checkbox.checked) return;
      rememberAcceptance();
      screen.classList.add("yalovy-first-step--leaving");
      document.documentElement.classList.remove("yalovy-first-step-pending");
      window.dispatchEvent(new CustomEvent("yalovy:eulaAccepted"));
      window.setTimeout(function () {
        screen.remove();
        legalLayer.remove();
      }, 360);
    });

    legalLayer.querySelector(".yalovy-legal-layer__backdrop").addEventListener("click", closeLegalDocument);
    legalLayer.querySelector(".yalovy-legal-sheet__close").addEventListener("click", closeLegalDocument);
    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape" && !legalLayer.hidden) closeLegalDocument();
    });

    document.body.appendChild(screen);
    document.body.appendChild(legalLayer);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mountFirstStep, { once: true });
  } else {
    mountFirstStep();
  }
})();
