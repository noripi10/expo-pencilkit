import { ViewComponent, ViewProps } from 'react-native';

export type ExpoPencilkitViewProps = {
  imageData?: string;
} & ViewProps;

type ClearDrawProps = {
  force: boolean;
};

export type ExpePencilKitViewMethods = {
  clearDraw: (props?: ClearDrawProps) => Promise<void>;
};
