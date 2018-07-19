
import UIKit

class LayoutReportingView: UIView
{
    var layoutChanged: SimpleCallback?

    override func layoutSubviews()
    {
        super.layoutSubviews()

        // Report layout change.
        if let report = self.layoutChanged
        {
            report()
        }
    }
}

