import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoPencilkitViewProps } from './ExpoPencilkit.types';

const NativeView: React.ComponentType<ExpoPencilkitViewProps> = requireNativeViewManager('ExpoPencilkit');

export default function ExpoPencilkit(props: ExpoPencilkitViewProps) {
  return <NativeView {...props} />;
}
