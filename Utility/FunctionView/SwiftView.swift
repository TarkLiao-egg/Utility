import UIKit

class SwiftView: UIView {
    class GradientObject {
        let view = UIView()
        let viewLayer = CAGradientLayer()
        var borderLayer = CAGradientLayer()
    }

    class InnerObject {
        var layer = ShadowLInnerLayer()
        var param = InnerParameter()
    }
    class ShadowObject {
        var layer = CALayer()
        var param = ShadowParameter()
    }

    struct CornerParameter {
        var isCircleRect: Bool = false
        var specificCornerLayer = CAShapeLayer()
        var radius: CGFloat = 0
        var rectCorner: UIRectCorner = .allCorners
        var maskLayer = CAShapeLayer()
        var path = UIBezierPath()
    }

    struct BorderParameter {
        var colors = [UIColor]()
        var borderWidth: CGFloat = 0
    }

    struct GradientParameter {
        var colors = [UIColor]()
        var startPoint: CGPoint?
        var endPoint: CGPoint?
    }

    struct ShadowParameter {
        var shadowColor: UIColor?
        var shadowOffset: CGSize = CGSize.zero
        var shadowRadius: CGFloat = 0
        var shadowOpacity: Float = 1
    }

    struct InnerParameter {
        var shadowColor: UIColor?
        var shadowOffset: CGSize = .zero
        var shadowRadius: CGFloat = 0
        var shadowOpacity: Float = 1
    }
    
    private var viewColor: UIColor?
    
    private let gradientObject = GradientObject()
    private var innerObjects = [InnerObject]()
    private var shadowObjects = [ShadowObject]()
    
    private var isSortLayer = false
    private var cornerParam = CornerParameter()
    private var shadowParam = ShadowParameter()
    private var borderParam = BorderParameter()
    private var gradientParam = GradientParameter()
    private let outsideShadowView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        reloadLayer()
        
        guard isSortLayer else {
            self.sendSubviewToBack(gradientObject.view)
            self.sendSubviewToBack(outsideShadowView)
            isSortLayer = true
            return
        }
    }
    
    private func setConstraints() {
        outsideShadowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(outsideShadowView)
        outsideShadowView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        outsideShadowView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        outsideShadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outsideShadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        gradientObject.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientObject.view)
        gradientObject.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gradientObject.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        gradientObject.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gradientObject.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func removeAllLayer() {
        gradientObject.viewLayer.removeFromSuperlayer()
        gradientObject.borderLayer.removeFromSuperlayer()
        for innerObject in innerObjects {
            innerObject.layer.removeFromSuperlayer()
        }
        for shadowObject in shadowObjects {
            shadowObject.layer.removeFromSuperlayer()
        }
    }
    
    private func drawLayer() {
        let cornerRadius = cornerParam.isCircleRect ? bounds.height / 2 : cornerParam.radius
        let rectCorner = cornerParam.isCircleRect ? [.topLeft, .topRight, .bottomLeft, .bottomRight] : cornerParam.rectCorner
        cornerParam.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        cornerParam.maskLayer = CAShapeLayer()
        cornerParam.maskLayer.frame = bounds
        cornerParam.maskLayer.path = cornerParam.path.cgPath
        
        if let startPoint = gradientParam.startPoint, let endPoint = gradientParam.endPoint, gradientParam.colors.count > 0 {
            gradientObject.viewLayer.frame = bounds
            gradientObject.viewLayer.startPoint = startPoint
            gradientObject.viewLayer.endPoint = endPoint
            gradientObject.viewLayer.colors = gradientParam.colors.compactMap({$0.cgColor})
            gradientObject.view.layer.addSublayer(gradientObject.viewLayer)
        } else {
            gradientObject.view.backgroundColor = viewColor
        }
        
        if let shadowColor = shadowParam.shadowColor {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = shadowParam.shadowOffset
            layer.shadowRadius = shadowParam.shadowRadius
            layer.shadowOpacity = shadowParam.shadowOpacity
        }
        for (i,object) in shadowObjects.enumerated() {
            if let shadowColor = object.param.shadowColor {
                shadowObjects[i].layer = CALayer()
                shadowObjects[i].layer.backgroundColor = viewColor?.cgColor
                shadowObjects[i].layer.frame = bounds
                shadowObjects[i].layer.cornerRadius = cornerRadius
                shadowObjects[i].layer.shadowPath = cornerParam.path.cgPath
                let param = shadowObjects[i].param
                shadowObjects[i].layer.shadowColor = shadowColor.cgColor
                shadowObjects[i].layer.shadowOffset = param.shadowOffset
                shadowObjects[i].layer.shadowRadius = param.shadowRadius
                shadowObjects[i].layer.shadowOpacity = param.shadowOpacity
                outsideShadowView.layer.insertSublayer(shadowObjects[i].layer, at: 0)
            }
        }
        for (i,object) in innerObjects.enumerated() {
            if let shadowColor = object.param.shadowColor {
                innerObjects[i].layer = ShadowLInnerLayer()
                innerObjects[i].layer.frame = bounds
                innerObjects[i].layer.cornersPath = cornerParam.path.cgPath
                innerObjects[i].layer.rectCorner = rectCorner
                innerObjects[i].layer.innerBorderWidth = borderParam.borderWidth
                innerObjects[i].layer.innerCornerRadius = cornerRadius
                innerObjects[i].layer.shadowColor = shadowColor.cgColor
                let param = innerObjects[i].param
                innerObjects[i].layer.shadowOffset = param.shadowOffset
                innerObjects[i].layer.shadowOpacity = param.shadowOpacity
                innerObjects[i].layer.shadowRadius = param.shadowRadius
                gradientObject.view.layer.addSublayer(innerObjects[i].layer)
            }
        }
        let borderShape = CAShapeLayer()
        borderShape.strokeColor = UIColor.black.cgColor
        borderShape.fillColor = UIColor.clear.cgColor
        borderShape.lineWidth = borderParam.borderWidth
        borderShape.path = cornerParam.path.cgPath
        gradientObject.borderLayer = CAGradientLayer()
        gradientObject.borderLayer.frame = bounds
        gradientObject.borderLayer.colors = borderParam.colors.compactMap({$0.cgColor})
        gradientObject.borderLayer.mask = borderShape
        gradientObject.view.layer.addSublayer(gradientObject.borderLayer)
        gradientObject.view.layer.mask = cornerParam.maskLayer
        
        
        
    }
    
    // MARK: Public Method
    public func reloadLayer(_ reload: Bool = true) {
        removeAllLayer()
        drawLayer()
    }
    
    public func setInnerView(_ view: UIView) {
        gradientObject.view.addSubview(view)
    }
    
    public func setBackgroundColor(_ color: UIColor, reload: Bool = false) {
        viewColor = color
        reloadLayer(reload)
    }
    
    public func setCorner(isCircleRect: Bool = false, _ cornerRadius: CGFloat, rectCorner: UIRectCorner = .allCorners, reload: Bool = false) {
        cornerParam.radius = cornerRadius
        cornerParam.rectCorner = rectCorner
        cornerParam.isCircleRect = isCircleRect
        reloadLayer(reload)
    }
    
    public func setGradientPointColor(startPoint: CGPoint, endPoint: CGPoint, _ colors: [UIColor], reload: Bool = false) {
        gradientParam.startPoint = startPoint
        gradientParam.endPoint = endPoint
        gradientParam.colors = colors
        reloadLayer(reload)
    }
    
    public func setGradientAxisColor(_ axis: NSLayoutConstraint.Axis, _ colors: [UIColor], reload: Bool = false) {
        if axis == .horizontal {
            gradientParam.startPoint = CGPoint(x: 0, y: 0.5)
            gradientParam.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientParam.startPoint = CGPoint(x: 0.5, y: 0)
            gradientParam.endPoint = CGPoint(x: 0.5, y: 1)
        }
        gradientParam.colors = colors
        reloadLayer(reload)
    }
    
    public func setBorder(borderColors: [UIColor], borderWidth: CGFloat, _ cornerRadius: CGFloat, reload: Bool = false) {
        if borderColors.count == 1 {
            borderParam.colors = [borderColors[0], borderColors[0]]
        } else if borderColors.count > 1 {
            borderParam.colors = borderColors
        }
        borderParam.borderWidth = borderWidth
        cornerParam.radius = cornerRadius
        reloadLayer(reload)
    }
    
    public func setShadow(shadowColor: UIColor = .black, shadowOffset: CGSize = .zero, shadowRadius: CGFloat, shadowOpacity: Float, reload: Bool = false) {
        shadowParam.shadowColor = shadowColor
        shadowParam.shadowOffset = shadowOffset
        shadowParam.shadowRadius = shadowRadius
        shadowParam.shadowOpacity = shadowOpacity
        reloadLayer(reload)
    }
    
    public func addShadows(_ params: [ShadowParameter]) {
        for param in params {
            let obj = ShadowObject()
            obj.param = param
            shadowObjects.append(obj)
        }
        reloadLayer()
    }
    
    public func addInnerShadows(_ params: [InnerParameter]) {
        for param in params {
            let obj = InnerObject()
            obj.param = param
            innerObjects.append(obj)
        }
        reloadLayer()
    }
}

class ShadowLInnerLayer: CAShapeLayer {
    override var shadowColor: CGColor? {
        didSet { setNeedsDisplay() }
    }
    
    override var shadowOffset: CGSize {
        didSet { setNeedsDisplay() }
    }
    
    override var shadowRadius: CGFloat {
        didSet { setNeedsDisplay() }
    }
    
    override var shadowOpacity: Float {
        didSet { setNeedsDisplay() }
    }
    
    var cornersPath: CGPath?
    var innerCornerRadius: CGFloat = 0
    var innerBorderWidth: CGFloat?
    var rectCorner: UIRectCorner = .allCorners
    
    override init(layer: Any) {
        super.init(layer: layer)
        initialize()
    }
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.masksToBounds = true
        self.shouldRasterize = true
        self.contentsScale = UIScreen.main.scale
        self.rasterizationScale = UIScreen.main.scale
        setNeedsDisplay()
    }
    
    override func draw(in context: CGContext) {
        context.setAllowsAntialiasing(true)
        context.setShouldAntialias(true)
        context.interpolationQuality = .high
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        var rect = self.bounds
        var radius = innerCornerRadius
        
        if let innerBorderWidth = innerBorderWidth {
            rect = rect.insetBy(dx: innerBorderWidth / 2, dy: innerBorderWidth / 2);
            radius -= innerBorderWidth
            radius = max(0, radius)
        }
        
        let innerPath: CGPath = UIBezierPath(roundedRect: rect, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        context.addPath(innerPath)
        context.clip()
        
        let shadowPath = CGMutablePath()
        let shadowRect = rect.insetBy(dx: -rect.size.width, dy: -rect.size.width)
        shadowPath.addRect(shadowRect)
        shadowPath.addPath(innerPath)
        shadowPath.closeSubpath()
        
        let old: [CGFloat] = shadowColor?.components ?? [0, 0, 0, 0]
        var new:[CGFloat] = [0, 0, 0, 0]
        let numberOfComponents: Int = (shadowColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1) as! CGColor).numberOfComponents;
        switch numberOfComponents {
        case 2:
            new[0] = old[0]
            new[1] = old[0]
            new[2] = old[0]
            new[3] = old[1] * CGFloat(shadowOpacity)
        case 4:
            new[0] = old[0]
            new[1] = old[1]
            new[2] = old[2]
            new[3] = old[3] * CGFloat(shadowOpacity)
        default: break
        }
        
        let innerShadowColorWithMultipliedAlpha = CGColor(colorSpace: colorspace, components: new)
        
        if let innerShadowColorWithMultipliedAlpha = innerShadowColorWithMultipliedAlpha {
            context.setFillColor(innerShadowColorWithMultipliedAlpha)
            context.setShadow(offset: shadowOffset,
                              blur: shadowRadius,
                              color: innerShadowColorWithMultipliedAlpha)
            context.addPath(shadowPath)
            context.fillPath(using: .evenOdd)
        }
    }
}
