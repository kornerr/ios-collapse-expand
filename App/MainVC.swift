
import UIKit

private func LOG(_ message: String)
{
    NSLog("MainVC \(message)")
}

private let ORIGINAL_DETAILS_HEIGHT: CGFloat = 100.0

class MainVC: UIViewController/*, UIGestureRecognizerDelegate*/
{

    // MARK: - SETUP

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBOutlet private var detailsHeightConstraint: NSLayoutConstraint!
    
}
