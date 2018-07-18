
import UIKit

private func LOG(_ message: String)
{
    NSLog("CollapseExpansionDetector \(message)")
}

// Detect collapse/expansion when panning vertically.
class CollapseExpansionDetector: NSObject, UIGestureRecognizerDelegate
{
    // Only start the action once delta has been panned.
    var activationDistance: CGFloat = 10

    var translation: CGFloat = 0
    var translationChanged: SimpleCallback?

    private var isActive = false

    private var recognizer: UIPanGestureRecognizer!

    init(trackedView: UIView)
    {
        super.init()
        
        self.recognizer =
            UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.recognizer.delegate = self
        trackedView.addGestureRecognizer(self.recognizer)
    }

    @objc func pan(_ recognizer: UIPanGestureRecognizer)
    {
        guard
            let view = recognizer.view 
        else
        {
            LOG("ERROR Gesture recognizer has no view. Cannot proceed")
            return
        }

        //if recognizer.state == .begin

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

            self.translation = translation.y

            // Report translation.
            if let report = translationChanged
            {
                report()
            }
        }
        else
        {
            self.isActive = false
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

