
import UIKit

private func LOG(_ message: String)
{
    NSLog("MainVC \(message)")
}

private let ORIGINAL_DETAILS_HEIGHT: CGFloat = 100.0

class MainVC: UIViewController
{

    // MARK: - SETUP

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupDetails()
    }

    // MARK: - DETAILS

    var detailsDescriptionIsVisible = false
    {
        didSet
        {
            self.detailsDescriptionLabel.isHidden = !self.detailsDescriptionIsVisible
        }
    }

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
    var detailsHeightsAreAvailable: SimpleCallback?

    @IBOutlet private var detailsBackgroundView: UIView!
    @IBOutlet private var detailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var detailsTopConstraint: NSLayoutConstraint!
    @IBOutlet private(set) var detailsView: LayoutReportingView!
    @IBOutlet private var detailsTitleLabel: UILabel!
    @IBOutlet private var detailsDescriptionLabel: UILabel!
    
    private func setupDetails()
    {
        // Round (visible) top.
        self.detailsBackgroundView.layer.cornerRadius = 20.0
        self.detailsBackgroundView.layer.masksToBounds = true

        self.detailsView.layoutChanged = { [weak self] in
            guard let this = self else { return }
            // We only need the first event.
            this.detailsView.layoutChanged = nil

            // Setup height.
            this.setupDetailsHeight()

            // Report available heights.
            if let report = this.detailsHeightsAreAvailable
            {
                report()
            }
        }
    }

    private func setupDetailsHeight()
    {
        // Get height values.
        self.detailsHeightMin = self.detailsHeightConstraint.constant
        self.detailsHeightMax = self.detailsView.frame.size.height
        LOG("details height min: '\(self.detailsHeightMin)' max: '\(self.detailsHeightMax)'")

        // Disable top constraint since we no longer need it.
        self.detailsTopConstraint.isActive = false
        self.detailsView.superview?.layoutIfNeeded()
    }

}
