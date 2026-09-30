import { createStandaloneApplication } from './standalone/application.js';
import { describeError } from './standalone/errors.js';

const application = createStandaloneApplication({
  googleApiKey:
    (typeof window !== 'undefined' && window.__GOOGLE_MAPS_API_KEY__) ||
    import.meta.env.GOOGLE_MAPS_API_KEY,
  cesiumToken:
    (typeof window !== 'undefined' && window.__CESIUM_ION_TOKEN__) ||
    import.meta.env.CESIUM_ION_TOKEN,
  allowQaRegistration: import.meta.env.DEV,
});

application.start().catch((error) => {
  console.error("God's Eye View initialization failed:", error);
  const loaderStatus = document.querySelector('#loading-screen .loader-status');
  loaderStatus.textContent = `Error: ${describeError(error)}`;
  loaderStatus.style.color = '#ff4444';
});

export { application };
