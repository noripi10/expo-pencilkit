import { ViewComponent, ViewProps } from 'react-native';

export type ExpoPencilkitViewProps = {
  imageData?: string;
} & ViewProps;

type ClearDrawProps = {
  force: boolean;
};

type ExportImageResult = {
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
