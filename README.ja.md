# @noripi10/expo-pencilkit

iOS専用のApple PencilKitをExpo用のネイティブモジュールとして実装したライブラリです。
このライブラリを使用することで、ExpoアプリケーションでApple Pencilを使用した描画機能を簡単に実装することができます。

[English README](./README.md)

## 特徴

- Apple PencilKitのネイティブ実装
- Expoプロジェクトでの簡単な統合
- 描画のクリア、取り消し（undo）、やり直し（redo）機能
- 既存の画像データ上への描画サポート

## インストール

```bash
npx expo install @noripi10/expo-pencilkit
```

## 必要条件

- Expo SDK 48以上
- iOS 13.0以上
- iOS端末のみ対応（Android非対応）

## 使用方法

### 基本的な実装

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
        // 既存の画像データを表示する場合（オプション）
        imageData="base64 encoded image data"
      />

      {/* 操作ボタンの例 */}
      <Button title="クリア" onPress={() => pencilKitRef.current?.clearDraw()} />
      <Button title="元に戻す" onPress={() => pencilKitRef.current?.undo()} />
      <Button title="やり直し" onPress={() => pencilKitRef.current?.redo()} />
    </View>
  );
}
```

### Props

| プロパティ名 | 型      | 説明                                             |
| ------------ | ------- | ------------------------------------------------ |
| imageData    | string? | 描画の背景として表示する画像データ（Base64形式） |

### メソッド

| メソッド名 | パラメータ          | 説明                             |
| ---------- | ------------------- | -------------------------------- |
| clearDraw  | { force?: boolean } | 描画をクリアします               |
| undo       | -                   | 直前の描画操作を取り消します     |
| redo       | -                   | 取り消した描画操作をやり直します |

## 注意事項

- このライブラリはiOS専用です。Android端末では動作しません。
- Apple Pencilの機能を最大限に活用するため、iOS 13.0以上が必要です。
- Expoの開発者ビルドが必要です（Expo Goでは動作しません）。

## Preivew

<img alt='sample' src="https://pub-a5c462e215f34924adedf4246089186b.r2.dev/sample.png" width="240" style="max-width: 100%; height: auto;" />

## ライセンス

MIT

## 作者

noripi10 ([@noripi10](https://github.com/noripi10))

## バグ報告・機能要望

バグ報告や機能要望は[GitHub Issues](https://github.com/noripi10/expo-pencilkit/issues)にお願いします。
