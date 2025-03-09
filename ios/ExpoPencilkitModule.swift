import ExpoModulesCore

public class ExpoPencilkitModule: Module {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {

    Name("ExpoPencilkit")

    // Enables the module to be used as a native view. Definition components that are accepted as part of the
    // view definition: Prop, Events.
    View(ExpoPencilkitView.self) {
      // Defines a setter for the `name` prop.
        Prop("imageData") { (view, imageData: String) in
            view.pencilkitView.setImageData(imageData)
        }

        AsyncFunction("clearDraw") { (view: ExpoPencilkitView, options: CreaDrawOptions?, promise: Promise) in
            let options = options ?? CreaDrawOptions()

            view.pencilkitView.clearDraw(options)
            promise.resolve(nil)
        }
    }
  }
}