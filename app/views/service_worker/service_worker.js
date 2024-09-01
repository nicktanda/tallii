function onInstall(event) {
  console.log('[Serviceworker]', "Installing!", event);
}
 
function onActivate(event) {
  console.log('[Serviceworker]', "Activating!", event);
}
 
function onFetch(event) {
  console.log('[Serviceworker]', "Fetching!", event);
}
self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);

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
