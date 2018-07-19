
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

    @IBOutlet private var detailsBackgroundView: UIView!
    @IBOutlet private var detailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var detailsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet private(set) var detailsView: LayoutReportingView!
    @IBOutlet var detailsTitleLabel: UILabel!
    
    var detailsTitle: String?
    {
        get
        {
            return self.detailsTitleLabel.text
        }
        set
        {
            self.detailsTitleLabel.text = newValue
        }
    }

    var detailsHeight: CGFloat
    {
        get
        {
            return self.detailsHeightConstraint.constant
        }
        set
        {
            var height = newValue
            // Restrict lower value.
            if height < self.detailsHeightMin
            {
                height = self.detailsHeightMin
            }
            // Restrict upper value.
            if height > self.detailsHeightMax
            {
                height = self.detailsHeightMax
            }
            // Apply.
            self.detailsHeightConstraint.constant = height
        }
    }

    private(set) var detailsHeightMin: CGFloat = 0
    private(set) var detailsHeightMax: CGFloat = 0

    private func setupDetails()
    {
        self.detailsHeightMin = self.detailsHeightConstraint.constant
        self.detailsHeightMax = self.detailsView.frame.size.height
        LOG("details height min: '\(self.detailsHeightMin)' max: '\(self.detailsHeightMax)'")

        /*
        // Disable top constraint since we no longer need it.
        self.detailsTopConstraint.isActive = false
        self.detailsView.superview?.layoutIfNeeded()
        */

        // Round (visible) top.
        self.detailsBackgroundView.layer.cornerRadius = 20.0
        self.detailsBackgroundView.layer.masksToBounds = true

        self.detailsView.layoutChanged = { [weak self] in
            guard let this = self else { return }
            LOG("DetailsView layout changed")
            let detailsHeightMin = this.detailsHeightConstraint.constant
            let detailsHeightMax = this.detailsView.frame.size.height
            LOG("details height min: '\(detailsHeightMin)' max: '\(detailsHeightMax)'")
        }

    }

}
