
import UIKit

private func LOG(_ message: String)
{
    NSLog("AppDelegate \(message)")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    // MARK: - SETUP

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        // Create window.
        self.window = UIWindow(frame: UIScreen.main.bounds)

        self.setupApplication()

        // Display window.
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        return true
    }

    // MARK: - APPLICATION

    private var mainVC: MainVC!
    private var detector: CollapseExpansionDetector!

    private func setupApplication()
    {        
        let storyboard = UIStoryboard.init(name: "MainVC", bundle: nil)
        self.mainVC =
            storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.window!.rootViewController = self.mainVC

        // Setup collapse/expansion once VC has been loaded.
        self.mainVC.loaded = { [weak self] in
            guard let this = self else { return }
            this.setupCollapseExpansion()
        }
    }

    enum TargetState
    {
        case none
        case collapse
        case expand
    }

    private var targetState = TargetState.none

    private var targetStateDetectionDistance: CGFloat = 30

    private var baseHeight: CGFloat = 0

    private func setupCollapseExpansion()
    {
        // Setup collapse/expansion.
        self.detector = CollapseExpansionDetector(trackedView: self.mainVC.detailsView)

        // Follow pan gesture and detect target state.
        self.detector.translationChanged = { [weak self] in
            guard let this = self else { return }
            let translation = this.detector.translation
            if fabs(translation) > this.targetStateDetectionDistance
            {
                this.targetState =
                    (translation < 0) ?
                    .expand :
                    .collapse
            }
            else
            {
                this.targetState = .none
            }

            this.mainVC.detailsHeight = this.baseHeight - translation

            var msg = ""
            msg += "Current translation: '\(translation)'"
            msg += "Target state: '\(this.targetState)'"
            LOG(msg)
        }

        // Animate to target state.
        // Set base height.
        // Reset target state.
        self.detector.isActiveChanged = { [weak self] in
            guard let this = self else { return }

            this.baseHeight =
                (this.targetState == .expand) ?
                this.mainVC.detailsHeightMax :
                this.mainVC.detailsHeightMin

            guard !this.detector.isActive else { return }

            UIView.animate(withDuration: 0.1) {
                LOG("Animate.01. details height before: '\(this.mainVC.detailsHeight)'")
                this.mainVC.detailsHeight =
                    (this.targetState == .expand) ?
                    this.mainVC.detailsHeightMax :
                    this.mainVC.detailsHeightMin
                LOG("Animate.02. details height after: '\(this.mainVC.detailsHeight)'")
                this.mainVC.detailsView.superview?.layoutIfNeeded()
            }

        }
    }

}

