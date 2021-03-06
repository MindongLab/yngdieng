import {IYngdiengEnvironment} from './environment';

// Local development environment
export const YngdiengDevEnvironment: IYngdiengEnvironment = {
  appName: '榕典 (dev)',
  slogan: '福州话电子词典',
  envName: 'dev',
  isProduction: false,
  // serverUrl: 'https://api.ydict.net',
  serverUrl: 'http://localhost:5000',
  structuredExplanations: {
    enabled: true,
    showDebugToggle: true,
  },
  showAudioPlayerButtons: true,
};
