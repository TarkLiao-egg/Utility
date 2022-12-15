import UIKit

class AnimateLabelController: UIViewController {
    
    var amountLabel = UILabel()
    
    var displayLink: CADisplayLink?
    let animationDuration = 3.0
    let animationStartDate = Date()
    var startValue = 0.0
    let endValue = 1200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountLabel.forSelf {
            $0.textColor = .black
            $0.font = UIFont.getDefaultFont(.medium, size: 30)
        }
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runAnimate() 
    }
    
    func runAnimate() {
        displayLink =  CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        
        if elapsedTime > animationDuration {
            amountLabel.text = "\(Int(endValue))"
            displayLink?.invalidate()
            // displayLink = nil crash
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            amountLabel.text = "\(Int(value))"
        }
    }
}
