
import UIKit

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

        self.setupCoordinator()

        // Display window.
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        return true
    }

    // MARK: - COORDINATOR

    //private var sampleCoordinator: SampleCoordinator!
    
    private func setupCoordinator()
    {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        self.window!.rootViewController = vc
        /*
        self.sampleCoordinator = SampleCoordinator()
        self.window!.rootViewController = self.sampleCoordinator.rootVC

        // If root VC changes, re-assign it to the window.
        self.sampleCoordinator.rootVCChanged = { [weak self] in
            guard let this = self else { return }
            this.window!.rootViewController = this.sampleCoordinator.rootVC
        }
        */
    }

}

