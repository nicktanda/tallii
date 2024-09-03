if (navigator.serviceWorker) {
  navigator.serviceWorker.register("/service-worker.js", { scope: "/" })
    .then(() => navigator.serviceWorker.ready)
    .then((registration) => {
      if ("SyncManager" in window) {
        registration.sync.register("sync-forms");
      } else {
        window.alert("This browser does not support background sync.")
      }
    }).then(() => console.log("[Companion]", "Service worker registered!"));

    // This variable will save the event for later use.
    let deferredPrompt;
    window.addEventListener('beforeinstallprompt', (e) => {
      // Prevents the default mini-infobar or install dialog from appearing on mobile
      e.preventDefault();
      // Save the event because you'll need to trigger it later.
      deferredPrompt = e;
      // Show your customized install prompt for your PWA
      // Your own UI doesn't have to be a single element, you
      // can have buttons in different locations, or wait to prompt
      // as part of a critical journey.
      showInAppInstallPromotion();
    });
}