// import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoPencilkit.web.ts
// and on native platforms to ExpoPencilkit.ts
import { ExpoPencilkit } from './ExpoPencilkit';
import { ExpoPencilkitViewProps, ExpePencilKitViewMethods } from './ExpoPencilkit.types';

// Get the native constant value.
export default ExpoPencilkit;
export { ExpoPencilkitViewProps, ExpePencilKitViewMethods };
