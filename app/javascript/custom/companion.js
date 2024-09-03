// if (navigator.serviceWorker) {
//   navigator.serviceWorker.register("/service-worker.js", { scope: "/" })
//     .then(() => navigator.serviceWorker.ready)
//     .then((registration) => {
//       if ("SyncManager" in window) {
//         registration.sync.register("sync-forms");
//       } else {
//         window.alert("This browser does not support background sync.")
//       }
//     }).then(() => console.log("[Companion]", "Service worker registered!"));
// }
if (navigator.serviceWorker) {
  navigator.serviceWorker.register("/service-worker.js", { scope: "/" })
    .then(() => console.log("Service worker registered!"))
    .catch((error) => console.error("Service worker registration failed:", error));
  
  window.addEventListener('beforeinstallprompt', (e) => {
    console.log('beforeinstallprompt event fired');
    // Prevent the mini-infobar from appearing
    e.preventDefault();
    // Stash the event so it can be triggered later.
    deferredPrompt = e;
    // Optionally, show your custom install UI here
  });
}