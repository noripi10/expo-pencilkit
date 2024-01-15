import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoPencilkit.web.ts
// and on native platforms to ExpoPencilkit.ts
import ExpoPencilkit from './ExpoPencilkit';
import { ExpoPencilkitViewProps } from './ExpoPencilkit.types';
import ExpoPencilkitModule from './ExpoPencilkitModule';

const clearDrawAsync = async () => {
  return await ExpoPencilkitModule.clearDrawAsync();
};

export default ExpoPencilkit;
export { ExpoPencilkitViewProps, clearDrawAsync };
