import Foundation
import UIKit
import SnapKit
class AnimateLabelView: UIView {
    private let currentView = UIView()
    private var defaultFont: UIFont
    private var fontSize: CGFloat
    private var textColor: UIColor
    private var startValue: String = "0"
    private var endValue: String = "0"
    private var labelWidth: CGFloat = 0
    private var labelHeight: CGFloat = 0
    private var views = [UIView]()
    private var duration: Double = 1.5
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .horizontal
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
    
    private func refreshLabel() {
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
        let needWidth: CGFloat = CGFloat(Int(defaultLabel.textSizeWidth()))
        defaultLabel.text = "9"
        let fontSize = defaultLabel.getSizeToFitWidth(max: fontSize, labelWidth: labelWidth)
        if needWidth <= frame.width {
            labelWidth = CGFloat(Int(needWidth / CGFloat(viewCount)))
        }
        stackView.addArrangedSubview(UIView())
        for value in endValue {
            getLabelStackView(fontSize: fontSize, value: value)
        }
    }
    
    private func getLabelStackView(fontSize: CGFloat, value: Character) {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.width.equalTo(labelWidth)
        }
        let longLabelStackView = UIStackView()
        longLabelStackView.distribution = .fillEqually
        longLabelStackView.alignment = .fill
        longLabelStackView.axis = .vertical
        longLabelStackView.spacing = 0
        view.addSubview(longLabelStackView)
        longLabelStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(labelWidth)
            make.height.equalTo(labelHeight * 11)
        }
        if value.isNumber {
            for i in -1...9 {
                let label = UILabel()
                label.text = i == -1 ? " " : String(i)
                label.textColor = textColor
                label.textAlignment = .center
                label.font = UIFont(name: "PingFangTC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
                longLabelStackView.addArrangedSubview(label)
            }
        } else {
            let label = UILabel()
            label.text = String(value)
            label.textColor = textColor
            label.textAlignment = .center
            label.font = UIFont(name: "PingFangTC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
            longLabelStackView.addArrangedSubview(label)
        }
        views.append(view)
        stackView.addArrangedSubview(view)
    }
    
    private func setStartValue() {
        for (index, view) in views.reversed().enumerated() {
            guard let stackview = view.subviews[optional: 0] else { return }
            if let exist = startValue.reversed()[optional: index], exist.isNumber, let integer = Int(String(exist)) {
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
            guard let stackview = view.subviews[optional: 0] else { return }
            if let exist = endValue.reversed()[optional: index], let integer = Int(String(exist)) {
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

extension Array {
    subscript (optional index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UILabel {
    func textSizeWidth() -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.size.width
    }
    
    func getSizeToFitWidth(min: CGFloat = 2, max: CGFloat = 70, labelWidth: CGFloat) -> CGFloat {
        var minFontSize: CGFloat = min
        var maxFontSize: CGFloat = max
        var fontSizeAverage: CGFloat = 0
        var textAndLabelWidthDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            // Abort if text happens to be nil
            guard let text = self.text, text.count > 0 else {
                break
            }
            if let labelText: NSString = text as NSString? {
                
                let testStringWidth = labelText.size(withAttributes: [NSAttributedString.Key.font: self.font.withSize(fontSizeAverage)]).width
                
                textAndLabelWidthDiff = labelWidth - testStringWidth
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelWidthDiff < 0) {
                        return fontSizeAverage - 1
                    }
                    return fontSizeAverage
                }
                
                if (textAndLabelWidthDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelWidthDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return fontSizeAverage
                }
            }
        }
        return fontSizeAverage
    }
}
