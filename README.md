# @noripi10/expo-pencilkit

A native module implementation of Apple PencilKit for Expo applications on iOS. This library allows you to easily implement drawing functionality using Apple Pencil in your Expo applications.

[日本語のREADME](./README.ja.md)

## Features

- Native implementation of Apple PencilKit
- Easy integration with Expo projects
- Drawing operations: clear, undo, and redo functionality
- Support for drawing on existing image data

## Installation

```bash
npx expo install @noripi10/expo-pencilkit
```

## Requirements

- Expo SDK 48 or higher
- iOS 13.0 or higher
- iOS devices only (Not available for Android)

## Usage

### Basic Implementation

```typescript
import { ExpoPencilkit } from '@noripi10/expo-pencilkit';
import { useRef } from 'react';

export default function App() {
  const pencilKitRef = useRef<ExpePencilKitViewMethods>(null);

  return (
    <View style={styles.container}>
      <ExpoPencilkit
        ref={pencilKitRef}
        style={styles.pencilKit}
        // Optional: Display existing image data
        imageData="base64 encoded image data"
      />

      {/* Control buttons example */}
      <Button title="Clear" onPress={() => pencilKitRef.current?.clearDraw()} />
      <Button title="Undo" onPress={() => pencilKitRef.current?.undo()} />
      <Button title="Redo" onPress={() => pencilKitRef.current?.redo()} />
    </View>
  );
}
```

### Props

| Property Name | Type    | Description                                                    |
| ------------- | ------- | -------------------------------------------------------------- |
| imageData     | string? | Base64 encoded image data to display as background for drawing |

### Methods

| Method Name | Parameters          | Description                                    |
| ----------- | ------------------- | ---------------------------------------------- |
| clearDraw   | { force?: boolean } | Clears the drawing canvas                      |
| undo        | -                   | Undoes the last drawing operation              |
| redo        | -                   | Redoes the previously undone drawing operation |
| setRulerActive | boolean          | Shows or hides the ruler in the tool picker    |

## Important Notes

- This library is iOS-exclusive and will not work on Android devices
- Requires iOS 13.0 or higher to fully utilize Apple Pencil features
- Requires Expo Development Build (will not work in Expo Go)

## Preivew

<img alt='sample' src="https://pub-a5c462e215f34924adedf4246089186b.r2.dev/sample.png" width="240" style="max-width: 100%; height: auto;" />

## License

MIT

## Author

noripi10 ([@noripi10](https://github.com/noripi10))

## Issues and Feature Requests

Please submit bug reports and feature requests to [GitHub Issues](https://github.com/noripi10/expo-pencilkit/issues).
