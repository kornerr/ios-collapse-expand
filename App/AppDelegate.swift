
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


    private func setupCollapseExpansion()
    {
        // Setup collapse/expansion.
        self.detector = CollapseExpansionDetector(trackedView: self.mainVC.detailsView)
        self.detector.translationChanged = { [weak self] in
            guard let this = self else { return }
            let translation = this.detector.translation
            LOG("Current translation: '\(translation)'")
            this.mainVC.detailsHeight = this.mainVC.detailsHeightMin - translation
        }
    }

}

