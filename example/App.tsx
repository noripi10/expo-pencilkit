import ExpoPencilkit, { ExpePencilKitViewMethods } from 'expo-pencilkit';
import { useRef } from 'react';
import { Button, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import { captureRef } from 'react-native-view-shot';

const imageData =
  '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';

export default function App() {
  const viewRef = useRef<View>(null);
  const pencilKitRef = useRef<ExpePencilKitViewMethods>(null);

  const captureHandler = async () => {
    if (!viewRef.current) return;
    const result = await captureRef(viewRef.current, {
      result: 'tmpfile',
    });
    console.info(result);
  };

  return (
    <View style={styles.container}>
      <SafeAreaView style={styles.container}>
        <Text style={{ alignSelf: 'center' }}>Create Expo Modules + Apple PencilKit</Text>
        <View ref={viewRef} style={{ flex: 1 }}>
          <ExpoPencilkit ref={pencilKitRef} style={{ flex: 1 }} imageData={imageData} />
        </View>
      </SafeAreaView>

      <View style={styles.captureButton}>
        <Button
          title='clear(force)'
          onPress={async () => {
            await pencilKitRef.current?.clearDraw();
          }}
        />

        <Button
          title='clear(cofirm)'
          onPress={async () => {
            await pencilKitRef.current?.clearDraw({ force: false });
          }}
        />

        <Button title='capture' onPress={captureHandler} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  captureButton: {
    position: 'absolute',
    top: 80,
    right: 20,
    alignItems: 'flex-end',
  },
});
