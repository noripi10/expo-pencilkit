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

        AsyncFunction("undo") { (view: ExpoPencilkitView, promise: Promise) in
            view.pencilkitView.undo()
            promise.resolve(nil)
        }

        AsyncFunction("redo") { (view: ExpoPencilkitView, promise: Promise) in
            view.pencilkitView.redo()
            promise.resolve(nil)
        }

        AsyncFunction("setRulerActive") { (view: ExpoPencilkitView, active: Bool, promise: Promise) in
            view.pencilkitView.setRulerActive(active)
            promise.resolve(nil)
        }

        AsyncFunction("exportImage") { (view: ExpoPencilkitView, promise: Promise) in
            do {
                let result = try view.pencilkitView.exportImage()
                promise.resolve(result)
            } catch {
                promise.reject("EXPORT IMAGE ERROR", error.localizedDescription)
            }
        }.runOnQueue(.main)
    }
  }
}