import Foundation
import UIKit
import SnapKit
class AnimateLabelView: UIView {
    let currentView = UIView()
    var defaultFont: UIFont
    var fontSize: CGFloat
    var textColor: UIColor
    var startValue: String = "0"
    var endValue: String = "0"
    var labelWidth: CGFloat = 0
    var labelHeight: CGFloat = 0
    var views = [UIView]()
    var duration: Double = 1.5
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.forSelf {
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
        return stack
    }()
    
    init(font: UIFont, size: CGFloat, textColor: UIColor) {
        self.defaultFont = font
        self.fontSize = size
        self.textColor = textColor
        super.init(frame: .zero)
        clipsToBounds = true
        setupUI()
    }
    
    override init(frame: CGRect) {
        self.defaultFont = UIFont.systemFont(ofSize: 14)
        self.textColor = .black
        self.fontSize = 40
        super.init(frame: frame)
        // Code create
    }
    
    required init?(coder: NSCoder) {
        self.defaultFont = UIFont.systemFont(ofSize: 14)
        self.textColor = .black
        self.fontSize = 40
        super.init(coder: coder)
        // Storyboard create
    }
    
    private func setupUI() {
        addSubview(currentView)
        addSubview(stackView)
        currentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.width.equalTo(currentView.snp.width)
            make.height.equalTo(currentView.snp.height)
            make.center.equalTo(currentView.snp.center)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func refreshLabel() {
        for subview in stackView.subviews {
            subview.removeFromSuperview()
        }
        views.removeAll()
        let viewCount = String(endValue).count
        labelWidth = CGFloat(Int(self.frame.width / CGFloat(viewCount)))
        labelHeight = CGFloat(Int(self.frame.height))
        let defaultLabel = UILabel()
        defaultLabel.font = defaultFont
        var str = ""
        for _ in 0..<viewCount {
            str += "9"
        }
        defaultLabel.text = str
        let needWidth: CGFloat = CGFloat(Int(defaultLabel.textWidth()))
        defaultLabel.text = "9"
        let fontSize = defaultLabel.getFontToFitWidth(max: fontSize, labelWidth: labelWidth)
        if needWidth <= frame.width {
            labelWidth = CGFloat(Int(needWidth / CGFloat(viewCount)))
        }
        stackView.addArrangedSubview(UIView())
        for value in endValue {
            getLabelStackView(fontSize: fontSize, value: value)
        }
    }
    
    func getLabelStackView(fontSize: CGFloat, value: Character) {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(labelWidth)
        }
        let longLabelStackView = UIStackView()
        longLabelStackView.forSelf {
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .vertical
            $0.spacing = 0
        }
        view.addSubview(longLabelStackView)
        longLabelStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(labelWidth)
            make.height.equalTo(labelHeight * 11)
        }
        if value.isNumber {
            for i in -1...9 {
                let label = UILabel()
                label.forSelf {
                    $0.text = i == -1 ? " " : String(i)
                    $0.textColor = textColor
                    $0.textAlignment = .center
                    $0.font = UIFont.getDefaultFont(.medium, size: fontSize)
                }
                longLabelStackView.addArrangedSubview(label)
            }
        } else {
            let label = UILabel()
            label.forSelf {
                $0.text = String(value)
                $0.textColor = textColor
                $0.textAlignment = .center
                $0.font = UIFont.getDefaultFont(.medium, size: fontSize)
            }
            longLabelStackView.addArrangedSubview(label)
        }
        views.append(view)
        stackView.addArrangedSubview(view)
    }
    
    private func setStartValue() {
        for (index, view) in views.reversed().enumerated() {
            guard let stackview = view.subviews[safe: 0] else { return }
            if let exist = startValue.reversed()[safe: index], exist.isNumber, let integer = Int(String(exist)) {
                stackview.snp.remakeConstraints { make in
                    make.top.equalToSuperview().inset(-labelHeight * CGFloat(integer + 1))
                    make.leading.trailing.equalToSuperview()
                    make.width.equalTo(labelWidth)
                    make.height.equalTo(labelHeight * 11)
                }
            } else {
                stackview.snp.remakeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                    make.width.equalTo(labelWidth)
                    make.height.equalTo(labelHeight * 11)
                }
            }
            view.layoutIfNeeded()
        }
    }
    
    private func animateEndValue() {
        for (index, view) in views.reversed().enumerated() {
            guard let stackview = view.subviews[safe: 0] else { return }
            if let exist = endValue.reversed()[safe: index], let integer = Int(String(exist)) {
                stackview.snp.remakeConstraints { make in
                    make.top.equalToSuperview().inset(-labelHeight * CGFloat(integer + 1))
                    make.leading.trailing.equalToSuperview()
                    make.width.equalTo(labelWidth)
                    make.height.equalTo(labelHeight * 11)
                }
            } else {
                stackview.snp.remakeConstraints { make in
                    make.top.leading.trailing.equalToSuperview()
                    make.width.equalTo(labelWidth)
                    make.height.equalTo(labelHeight * 11)
                }
            }
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                view.layoutIfNeeded()
            }
        }
    }
}

// MARK: Public
extension AnimateLabelView {
    func animate(_ value: String, duration: TimeInterval = 1.5) {
        self.duration = duration
        startValue = endValue
        endValue = value
        refreshLabel()
        setStartValue()
        animateEndValue()
    }
}
