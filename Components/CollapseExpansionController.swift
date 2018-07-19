
import UIKit

private func LOG(_ message: String)
{
    NSLog("CollapseExpansionController \(message)")
}

// Control collapse/expansion when panning vertically.
class CollapseExpansionController: NSObject, UIGestureRecognizerDelegate
{

    // MARK: - SETUP

    init(
        trackedView: UIView,
        minHeight: CGFloat,
        maxHeight: CGFloat
    ) {
        super.init()
        self.setupActivation(trackedView)
        self.setupCompletion(minHeight, maxHeight)
    }

    // MARK: - ACTIVATION

    // Only start tracking translation once `activateDistance` has been passed.
    var activationDistance: CGFloat = 10

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

    private func setupActivation(_ trackedView: UIView)
    {
        self.recognizer =
            UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.recognizer.delegate = self
        trackedView.addGestureRecognizer(self.recognizer)
    }

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

    // MARK: - COMPLETION

    // Only complete started expansion/collapse once `completionDistance` has been passed.
    var completionDistance: CGFloat = 30
    // Change this value if you need expansion downwards.
    var expandUpwards: Bool = true

    // Current height to use by clients.
    private(set) var height: CGFloat = 0
    // Gets reported when pan gesture is active.
    var heightChanged: SimpleCallback?
    // Gets reported when pan gesture has finished.
    var completeHeightChange: SimpleCallback?

    private var baseHeight: CGFloat = 0
    private var minHeight: CGFloat = 0
    private var maxHeight: CGFloat = 0

    private func setupCompletion(_ minHeight: CGFloat, _ maxHeight: CGFloat)
    {
        self.minHeight = minHeight
        self.maxHeight = maxHeight

        // Expanding upwards results in pan gesture translation negation
        let factor: CGFloat = self.expandUpwards ? -1 : 1

        // Follow translation to provide real-time height.
        self.translationChanged = { [weak self] in
            guard let this = self else { return }
            this.height = this.baseHeight + factor * this.translation
            // Report height.
            if let report = this.heightChanged
            {
                report()
            }
        }

        // Complete started translation.
        self.isActiveChanged = { [weak self] in
            guard let this = self else { return }

            // Find out where we are at.
            let complete =
                fabs(this.translation) > this.completionDistance
            let expand = (this.translation < 0)
            let distanceToBottom = fabs(this.height - this.minHeight)
            let distanceToTop = fabs(this.height - this.maxHeight)
            let isCollapsed =
                this.expandUpwards ?
                (distanceToTop > distanceToBottom) :
                (distanceToTop < distanceToBottom)

            // Find out where we are heading to.
            var targetStateIsCollapse = false

            // Target state: expanded.
            if
                isCollapsed &&
                expand &&
                complete
            {
                targetStateIsCollapse = false
            }
            // Target state: collapsed.
            else if
                !isCollapsed &&
                !expand &&
                complete
            {
                targetStateIsCollapse = true
            }
            // Target state: revert to current one.
            else
            {
                targetStateIsCollapse = isCollapsed
            }

            // Reset base height.
            this.baseHeight =
                targetStateIsCollapse ?
                this.minHeight :
                this.maxHeight

            // Set new height and report completion.
            if !this.isActive
            {
                // Set.
                this.height = 
                    targetStateIsCollapse ?
                    this.minHeight :
                    this.maxHeight
                // Report.
                if let report = this.completeHeightChange
                {
                    report()
                }
            }
        }
    }

}

