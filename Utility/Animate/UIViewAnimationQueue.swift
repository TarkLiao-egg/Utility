import UIKit

class UIViewAnimationQueue {
    var animations: [AnimationInfo] = []
    
    func add(duration: TimeInterval = 1, options: UIView.AnimationOptions = [], delay: TimeInterval = 0, dampingRatio: CGFloat = 1, velocity: CGFloat = 0, _ animation: @escaping () -> Void) -> UIViewAnimationQueue {
        animations.append(AnimationInfo(duration: duration, options: options, delay: delay, dampingRatio: dampingRatio, velocity: velocity, animation: animation))
        return self
    }
    
    @objc func start() {
        if animations.count > 0 {
            let ani = animations.removeFirst()
            switch ani.type {
            case .Normal:
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: ani.duration, delay: ani.delay, options: ani.options!, animations: ani.animation!) { _ in
                    for call in ani.completionCall {
                        call()
                    }
                    self.start()
                }
//                UIView.animate(withDuration: ani.duration, delay: ani.delay, usingSpringWithDamping: ani.dampingRatio, initialSpringVelocity: ani.velocity, options: ani.options!, animations: ani.animation!, completion: { (complete) in
//                    if complete {
//                        for call in ani.completionCall {
//                            call()
//                        }
//                        self.start()
//                    }
//                })
                break
            case .Pause:
                Timer.scheduledTimer(withTimeInterval: ani.duration, repeats: false, block: { (timer) in
                    timer.invalidate()
                    for call in ani.completionCall {
                        call()
                    }
                    self.start()
                })
                break
            }
        }
    }
    
    func done(_ somethingToDo: @escaping () -> Void) -> UIViewAnimationQueue {
            animations.last?.completionCall.append(somethingToDo)
            return self
        }
    
    func pause(_ duration: TimeInterval = 1) -> UIViewAnimationQueue {
        animations.append(AnimationInfo(duration: duration))
        return self
    }
}

class AnimationInfo {
    var duration: TimeInterval = 0
    var animation: (() -> Void)?
    var options: UIView.AnimationOptions?
    var delay: TimeInterval = 0
    var dampingRatio: CGFloat = 1
    var velocity: CGFloat = 0
    var completionCall: [(() -> Void)] = []
    let type: AnimationType
    
    enum AnimationType {
        case Normal, Pause
    }
    // for pause
    init(duration: TimeInterval, _ type: AnimationType = .Pause) {
        self.duration = duration
        self.type = type
    }
    
    // for animation
    convenience init(duration: TimeInterval, options: UIView.AnimationOptions, delay: TimeInterval, dampingRatio: CGFloat, velocity: CGFloat, animation: @escaping () -> Void) {
        self.init(duration: duration, .Normal)
        self.options = options
        self.delay = delay
        self.dampingRatio = dampingRatio
        self.velocity = velocity
        self.animation = animation
    }
}

extension UIView {
    class var animateQueue: UIViewAnimationQueue {
        get {
            return UIViewAnimationQueue()
        }
    }
}
