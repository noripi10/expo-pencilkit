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
    setRulerActive: async (active) => {
      if (nativeRef.current) {
        await nativeRef.current.setRulerActive(active);
      }
    },
    exportImage: async () => {
      if (nativeRef.current) {
        return await nativeRef.current.exportImage();
      }
      throw new Error('PencilKit view is not ready.');
    },
    setPanZoomMode: async (enable: boolean) => {
      if (nativeRef.current) {
        await nativeRef.current.setPanZoomMode(enable);
      }
    },
    resetZoom: async () => {
      if (nativeRef.current) {
        await nativeRef.current.resetZoom();
      }
    },
  }));

  return <NativeViewManager {...props} ref={nativeRef} />;
});
