import * as React from 'react';
import { requireNativeViewManager } from 'expo-modules-core';

import { ExpePencilKitViewMethods, ExpoPencilkitViewProps } from './ExpoPencilkit.types';

const NativeViewManager = requireNativeViewManager('ExpoPencilkit');

export const ExpoPencilkit = React.forwardRef<ExpePencilKitViewMethods, ExpoPencilkitViewProps>((props, ref) => {
  const nativeRef = React.useRef<ExpePencilKitViewMethods>(null);

  React.useImperativeHandle(ref, () => ({
    clearDraw: async (props) => {
      if (nativeRef.current) {
        await nativeRef.current.clearDraw(props);
      }
    },
    undo: async () => {
      if (nativeRef.current) {
        await nativeRef.current.undo();
      }
    },
    redo: async () => {
      if (nativeRef.current) {
        await nativeRef.current.redo();
      }
    },
  }));

  return <NativeViewManager {...props} ref={nativeRef} />;
});
