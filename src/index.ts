// import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoPencilkit.web.ts
// and on native platforms to ExpoPencilkit.ts
import { ExpoPencilkit } from './ExpoPencilkit';

// Get the native constant value.
export default ExpoPencilkit;
export * from './ExpoPencilkit.types';
