import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoPencilkitViewProps } from './ExpoPencilkit.types';

const NativeView: React.ComponentType<ExpoPencilkitViewProps> =
  requireNativeViewManager('ExpoPencilkit');

export default function ExpoPencilkitView(props: ExpoPencilkitViewProps) {
  return <NativeView {...props} />;
}
