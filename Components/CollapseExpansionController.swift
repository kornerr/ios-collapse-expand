
import UIKit

private func LOG(_ message: String)
{
    NSLog("CollapseExpansionController \(message)")
}

// Controll collapse/expansion when panning vertically.
class CollapseExpansionController: NSObject, UIGestureRecognizerDelegate
{

    // MARK: - SETUP

    // Only start tracking translation once `activateDistance` has been passed.
    var activationDistance: CGFloat = 10

    init(trackedView: UIView)
    {
        super.init()
        
        self.recognizer =
            UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.recognizer.delegate = self
        trackedView.addGestureRecognizer(self.recognizer)
    }

    // MARK: - TRANSLATION AND ACTIVATION

    // Current translation.
    private var translation: CGFloat = 0
    {
        didSet
        {
            if let report = translationChanged
            {
                report()
            }
        }
    }
    private var translationChanged: SimpleCallback?

    // Whether this controller is currently active.
    private var isActive = false
    {
        didSet
        {
            if let report = isActiveChanged
            {
                report()
            }
        }
    }
    var isActiveChanged: SimpleCallback?

    // Source of pan gestures.
    private var recognizer: UIPanGestureRecognizer!

    @objc func pan(_ recognizer: UIPanGestureRecognizer)
    {
        guard let view = recognizer.view else { return }
        let translation = recognizer.translation(in: view)

        if recognizer.state != .cancelled
        {
            // Activate only after passing activation distance.
            if
                !self.isActive &&
                fabs(translation.y) > self.activationDistance
            {
                self.isActive = true
            }
        }
        else
        {
            self.isActive = false
        }

        // Deactivate when done.
        if
            self.isActive,
            recognizer.state == .ended
        {
            self.isActive = false
        }

        // Translate.
        if self.isActive
        {
            self.translation = translation.y
        }
    }

    func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard
            let recognizer = gestureRecognizer as? UIPanGestureRecognizer,
            let view = recognizer.view 
        else
        {
            return false
        }
        let translation = recognizer.translation(in: view)
        // Prefer vertical pan.
        return fabs(translation.y) > fabs(translation.x)
    }

}

