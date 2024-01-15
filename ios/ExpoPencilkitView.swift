import ExpoModulesCore

// This view will be used as a native component. Make sure to inherit from `ExpoView`
// to apply the proper styling (e.g. border radius and shadows).
class ExpoPencilkitView: ExpoView {
    let pencilkitView = PencilkitView()

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        clipsToBounds = true
        addSubview(pencilkitView)
    }

    override func layoutSubviews() {
        pencilkitView.frame = bounds
    }
}
