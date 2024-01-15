import * as React from 'react';

import { ExpoPencilkitViewProps } from './ExpoPencilkit.types';

export default function ExpoPencilkitView(props: ExpoPencilkitViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
