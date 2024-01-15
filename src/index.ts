import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoPencilkit.web.ts
// and on native platforms to ExpoPencilkit.ts
import ExpoPencilkitModule from './ExpoPencilkitModule';
import ExpoPencilkitView from './ExpoPencilkitView';
import { ChangeEventPayload, ExpoPencilkitViewProps } from './ExpoPencilkit.types';

// Get the native constant value.
export const PI = ExpoPencilkitModule.PI;

export function hello(): string {
  return ExpoPencilkitModule.hello();
}

export async function setValueAsync(value: string) {
  return await ExpoPencilkitModule.setValueAsync(value);
}

const emitter = new EventEmitter(ExpoPencilkitModule ?? NativeModulesProxy.ExpoPencilkit);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ExpoPencilkitView, ExpoPencilkitViewProps, ChangeEventPayload };
