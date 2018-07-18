
import UIKit

private func LOG(_ message: String)
{
    NSLog("MainVC \(message)")
}

private let ORIGINAL_DETAILS_HEIGHT: CGFloat = 100.0

class MainVC: UIViewController
{

    // MARK: - SETUP

    var loaded: SimpleCallback?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupDetails()

        // Report.
        if let report = loaded
        {
            report()
        }
    }

    // MARK: - DETAILS

    @IBOutlet private var detailsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private(set) var detailsView: UIView!

    var detailsHeight: CGFloat
    {
        get
        {
            return self.detailsHeightConstraint.constant
        }
        set
        {
            self.detailsHeightConstraint.constant = newValue
        }
    }

    private(set) var detailsHeightOrig: CGFloat = 0

    private func setupDetails()
    {
        self.detailsHeightOrig = self.detailsHeightConstraint.constant
    }
    
}
