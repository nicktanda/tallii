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
  
  let deferredPrompt;
  window.addEventListener('beforeinstallprompt', (e) => {
    // Prevent Chrome 67 and earlier from automatically showing the prompt
    e.preventDefault();
    console.log("Fuck you")
    // Stash the event so it can be triggered later.
    deferredPrompt = e;
    
    // Optionally, you can show a custom install button
    const installButton = document.getElementById('install-button');
    installButton.style.display = 'block';
  
    installButton.addEventListener('click', () => {
      // Show the install prompt
      deferredPrompt.prompt();
      // Wait for the user to respond to the prompt
      deferredPrompt.userChoice.then((choiceResult) => {
        if (choiceResult.outcome === 'accepted') {
          console.log('User accepted the install prompt');
        } else {
          console.log('User dismissed the install prompt');
        }
        deferredPrompt = null;
      });
    });
  });
}