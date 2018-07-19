
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

    // Complete motion after passing this distance.
    private var completionDistance: CGFloat = 30

    private var baseHeight: CGFloat = 0

    private func setupCollapseExpansion()
    {
        // Setup collapse/expansion.
        self.detector = CollapseExpansionDetector(trackedView: self.mainVC.detailsView)

        // Follow pan gesture and detect target state.
        self.detector.translationChanged = { [weak self] in
            guard let this = self else { return }
            let translation = this.detector.translation
            this.mainVC.detailsHeight = this.baseHeight - translation
        }

        // Set base height.
        // Animate to target state.
        self.detector.isActiveChanged = { [weak self] in
            guard let this = self else { return }

            let completionDistanceReached =
                fabs(this.detector.translation) > this.completionDistance
            let shouldExpand = (this.detector.translation < 0)
            let distanceToBottom = fabs(this.mainVC.detailsHeight - this.mainVC.detailsHeightMin)
            let distanceToTop = fabs(this.mainVC.detailsHeight - this.mainVC.detailsHeightMax)
            let isCollapsed = (distanceToTop > distanceToBottom)

            var targetStateIsCollapse = false

            // Target state: expanded.
            if
                isCollapsed &&
                shouldExpand &&
                completionDistanceReached
            {
                targetStateIsCollapse = false
            }
            // Target state: collapsed.
            else if
                !isCollapsed &&
                !shouldExpand &&
                completionDistanceReached
            {
                targetStateIsCollapse = true
            }
            // Revert to current state.
            else
            {
                targetStateIsCollapse = isCollapsed
            }

            // Reset base height.
            this.baseHeight =
                targetStateIsCollapse ?
                this.mainVC.detailsHeightMin :
                this.mainVC.detailsHeightMax

            guard !this.detector.isActive else { return }

            UIView.animate(withDuration: 0.1) {
                this.mainVC.detailsHeight =
                    targetStateIsCollapse ?
                    this.mainVC.detailsHeightMin :
                    this.mainVC.detailsHeightMax
                this.mainVC.detailsView.superview?.layoutIfNeeded()
            }

        }
    }

}

