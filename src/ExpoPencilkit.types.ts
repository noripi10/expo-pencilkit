import { ViewProps } from 'react-native';

export type ExpoPencilkitViewProps = {
  imageData?: string;
} & ViewProps;

export type ClearDrawProps = {
  force: boolean;
};

export type ExportImageResult = {
  path: string;
  base64: string;
};

export type ExpePencilKitViewMethods = {
  clearDraw: (props?: ClearDrawProps) => Promise<void>;
  undo: () => Promise<void>;
  redo: () => Promise<void>;
  setRulerActive: (active: boolean) => Promise<void>;
  exportImage: () => Promise<ExportImageResult>;
};
