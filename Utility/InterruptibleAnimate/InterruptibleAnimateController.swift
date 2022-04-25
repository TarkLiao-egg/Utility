import UIKit
import SnapKit
class InterruptibleAnimateController: UIViewController {
    var interactiveView: UIView!
    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
    var isOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }

}

// MARK: Gesture
extension InterruptibleAnimateController {
    func setupButton() {
        interactiveView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: view)
        
        let shouldComplete = velocity.y < 0
        switch recognizer.state {
        case .began:
            if isOpen {
                closeRemake()
                animator.addAnimations { [unowned self] in
                    view.layoutIfNeeded()
                }
                animator.addCompletion { [unowned self] position in
                    if position == .start {
                        openRemake()
                    } else if position == .end {
                        isOpen = false
                    }
                    interactiveView.isUserInteractionEnabled = true
                }
            } else {
                openRemake()
                animator.addAnimations { [unowned self] in
                    view.layoutIfNeeded()
                }
                animator.addCompletion { [unowned self] position in
                    if position == .start {
                        closeRemake()
                    } else if position == .end {
                        isOpen = true
                    }
                    interactiveView.isUserInteractionEnabled = true
                }
            }
            animator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: view)
            var progress = -translation.y / (view.frame.height / 3)
            progress = isOpen ? -progress : progress
            animator.fractionComplete = progress
        case .ended:
            if velocity.y == 0 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            if isOpen {
                if !shouldComplete && animator.isReversed { animator.isReversed = false }
                if shouldComplete && !animator.isReversed { animator.isReversed = true }
            } else {
                if !shouldComplete && !animator.isReversed { animator.isReversed = true }
                if shouldComplete && animator.isReversed { animator.isReversed = false }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            interactiveView.isUserInteractionEnabled = false
        default: break
        }
    }
}

// MARK: Layout
extension InterruptibleAnimateController {
    func setupUI() {
        interactiveView = UIView()
        interactiveView.backgroundColor = .red
        view.addSubview(interactiveView)
        interactiveView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(interactiveView.snp.width)
        }
    }
    
    func openRemake() {
        interactiveView.snp.remakeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(interactiveView.snp.width)
        }
    }
    
    func closeRemake() {
        interactiveView.snp.remakeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(interactiveView.snp.width)
        }
    }
}
