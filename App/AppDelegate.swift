
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
    private var collapseExpansionController: CollapseExpansionController!

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

    private func setupCollapseExpansion()
    {
        let controller =
            CollapseExpansionController(
                trackedView: self.mainVC.detailsView,
                minHeight: self.mainVC.detailsHeightMin,
                maxHeight: self.mainVC.detailsHeightMax
            )
        controller.activationDistance = 10
        controller.completionDistance = 30
        self.collapseExpansionController = controller

        // Set current height while panning.
        self.collapseExpansionController.heightChanged = { [weak self] in
            guard let this = self else { return }
            this.mainVC.detailsHeight = this.collapseExpansionController.height
        }

        // Animate to height once panning finished.
        self.collapseExpansionController.completeHeightChange = { [weak self] in
            guard let this = self else { return }
            let animations = {
                this.mainVC.detailsHeight = this.collapseExpansionController.height
                this.mainVC.detailsView.superview?.layoutIfNeeded()
            }
            let completion: ((Bool) -> Void) = { _ in
                // Set details title based on the state.
                let isCollapsed = (this.mainVC.detailsHeight == this.mainVC.detailsHeightMin)
                let title =
                    isCollapsed ?
                    NSLocalizedString("Details.Title.Collapsed", comment: "") :
                    NSLocalizedString("Details.Title.Expanded", comment: "")
                this.mainVC.detailsTitle = title
            }
            UIView.animate(
                withDuration: 0.1,
                animations: animations,
                completion: completion
            )
        }

        // Set initial title.
        self.mainVC.detailsTitle =
            NSLocalizedString("Details.Title.Collapsed", comment: "")
    }

}

