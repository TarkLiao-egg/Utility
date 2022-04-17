import UIKit

class FunctionCodeView: UIView {
    var gradientView: UIView!
    private let gradientViewLayer = CAGradientLayer()
    private var gradientBorderLayer = CAGradientLayer()
    private var specificCornerLayer = CAShapeLayer()
    private var innerShadowLayer = InnerShadowLayer()
    private var isMoveLast = false // 把GradientView移到最下層，只需要一次

    // MARK: Specific corner
    var cornerRadius: CGFloat = 0
    var corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    // MARK: Border
    var borderWidth: CGFloat = 0
    var borderColor: UIColor?
    var borderColors = [UIColor]()
    
    var viewBackgroundColor: UIColor?
    
    // Gradient
    var gradientStartPoint: CGPoint?
    var gradientEndPoint: CGPoint?
    var gradientColors = [UIColor]()
    
    // MARK: Shadow
    var shadowWidth: CGFloat = 0
    var shadowOffset: CGSize = CGSize.zero
    var shadowColor: UIColor?
    var shadowOpacity: Float = 1
    
    // MARK: InnerShadow
    var innerShadowColor: CGColor?
    var innerShadowOffset: CGSize = .zero
    var innerShadowRadius: CGFloat = 0
    var innerShadowOpacity: Float = 1
    
    var isCircle: Bool = false
    
    var cornersMaskLayer = CAShapeLayer()
    var cornerPath = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        // Code create
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Storyboard create
        setupLayout()
    }
    
    private func setupLayout() {
        gradientView = UIView()
        addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clearLayer()
        reDrawLayer()
        
        // 將gradientView 移到最後一層，不能用@IBOutlet, 似乎不是同一個
        if !isMoveLast {
            self.sendSubviewToBack(gradientView)
            isMoveLast = !isMoveLast
        }
    }
    
    private func clearLayer() {
        gradientViewLayer.removeFromSuperlayer()
        gradientBorderLayer.removeFromSuperlayer()
        innerShadowLayer.removeFromSuperlayer()
    }
    
    private func reDrawLayer() {
        // shadow
        layer.shadowRadius = shadowWidth
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        
        
        // specificCornerLayer
        let cornerRadius = isCircle ? bounds.height / 2 : cornerRadius
        let corners = isCircle ? [.topLeft, .topRight, .bottomLeft, .bottomRight] : corners
        cornerPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        // view Color
        cornersMaskLayer = CAShapeLayer()
        cornersMaskLayer.frame = bounds
        cornersMaskLayer.path = cornerPath.cgPath
        if let gradientStartPoint = gradientStartPoint, let gradientEndPoint = gradientEndPoint, gradientColors.count > 0 {
            gradientViewLayer.startPoint = gradientStartPoint
            gradientViewLayer.endPoint = gradientEndPoint
            gradientViewLayer.colors = gradientColors.compactMap({$0.cgColor})
        } else {
            gradientView.backgroundColor = viewBackgroundColor
        }
        gradientViewLayer.frame = bounds
        gradientView.layer.mask = cornersMaskLayer
        gradientView.layer.addSublayer(gradientViewLayer)
        
        // border
        if borderColors.count > 0 {
            let borderShape = CAShapeLayer()
            borderShape.lineWidth = borderWidth
            borderShape.path = cornerPath.cgPath
            borderShape.strokeColor = UIColor.black.cgColor
            borderShape.fillColor = UIColor.clear.cgColor
            gradientBorderLayer = CAGradientLayer()
            gradientBorderLayer.frame =  bounds
            gradientBorderLayer.colors = borderColors.compactMap({$0.cgColor})
            gradientBorderLayer.mask = borderShape
            gradientView.layer.addSublayer(gradientBorderLayer)
        } else {
            gradientView.layer.cornerRadius = cornerRadius
            gradientView.layer.borderWidth = borderWidth
            gradientView.layer.borderColor = borderColor?.cgColor
        }
        
        // innerShadow
        if let innerShadowColor = innerShadowColor {
            innerShadowLayer = InnerShadowLayer()
            innerShadowLayer.frame              = bounds
            innerShadowLayer.cornersPath        = cornerPath.cgPath
            innerShadowLayer.corners            = corners
            innerShadowLayer.customBorderWidth  = borderWidth
            innerShadowLayer.customCornerRadius = cornerRadius
            innerShadowLayer.innerShadowColor   = innerShadowColor
            innerShadowLayer.innerShadowOffset  = innerShadowOffset
            innerShadowLayer.innerShadowOpacity = innerShadowOpacity
            innerShadowLayer.innerShadowRadius  = innerShadowRadius
            gradientView.layer.addSublayer(innerShadowLayer)
        }
    }
}

extension FunctionCodeView {
    func reDraw() {
        clearLayer()
        reDrawLayer()
    }
    
    func getCornersMaskLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = cornersMaskLayer.frame
        shapeLayer.path = cornersMaskLayer.path
        return shapeLayer
    }
    
    func setBackground(_ color: UIColor) {
        viewBackgroundColor = color
    }
    
    func setCornerRadius(_ cornerRadius: CGFloat, corners: UIRectCorner = [.bottomLeft, .bottomRight, .topLeft, .topRight], isCircle: Bool = false) {
        self.cornerRadius = cornerRadius
        self.corners = corners
        self.isCircle = isCircle
    }
    
    func setGradient(_ colors: UIColor..., startPoint: CGPoint, endPoint: CGPoint) {
        gradientColors = colors
        gradientStartPoint = startPoint
        gradientEndPoint = endPoint
    }
    
    func setGradient(_ colors: UIColor..., axis: NSLayoutConstraint.Axis) {
        gradientColors = colors
        if axis == .horizontal {
            gradientStartPoint = CGPoint(x: 0, y: 0.5)
            gradientEndPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientStartPoint = CGPoint(x: 0.5, y: 0)
            gradientEndPoint = CGPoint(x: 0.5, y: 1)
        }
    }
    
    func setBorder(_ cornerRadius: CGFloat, borderColors: UIColor..., borderWidth: CGFloat) {
        self.cornerRadius = cornerRadius
        if borderColors.count == 1 {
            borderColor = borderColors[0]
        } else if borderColors.count > 1 {
            self.borderColors = borderColors
        }
        self.borderWidth = borderWidth
    }
    
    func setShadow(shadowOpacity: Float = 0.8, shadowColor: UIColor = .black, shadowOffset: CGSize = .zero, shadowWidth: CGFloat = 5) {
        self.shadowOpacity = shadowOpacity
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowWidth = shadowWidth
    }
    
    func setInnerShadow(shadowOpacity: Float = 0.8, shadowColor: UIColor = .black, shadowOffset: CGSize = CGSize(width: 4, height: 4), shadowWidth: CGFloat = 15) {
        innerShadowOpacity = shadowOpacity
        innerShadowColor = shadowColor.cgColor
        innerShadowOffset = shadowOffset
        innerShadowRadius = shadowWidth
    }
}

class InnerShadowLayer: CAShapeLayer {
    var innerShadowColor: CGColor? = UIColor.black.cgColor {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowRadius: CGFloat = 8 {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowOpacity: Float = 1 {
        didSet { setNeedsDisplay() }
    }
    
    var cornersPath: CGPath?
    var customCornerRadius: CGFloat = 0
    var customBorderWidth: CGFloat?
    var corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.masksToBounds      = true
        self.shouldRasterize    = true
        self.contentsScale      = UIScreen.main.scale
        self.rasterizationScale = UIScreen.main.scale
        
        setNeedsDisplay()
    }
    
    override func draw(in ctx: CGContext) {
        // 设置 Context 属性
        // 允许抗锯齿
        ctx.setAllowsAntialiasing(true);
        // 允许平滑
        ctx.setShouldAntialias(true);
        // 设置插值质量
        ctx.interpolationQuality = .high;
        
        // 以下为核心代码
        
        // 创建 color space
        let colorspace = CGColorSpaceCreateDeviceRGB();
        
        var rect   = self.bounds
        var radius = customCornerRadius
        
        // 去除边框的大小
        if let customBorderWidth = customBorderWidth {
            rect   = rect.insetBy(dx: customBorderWidth / 2, dy: customBorderWidth / 2);
            radius -= customBorderWidth
            radius = max(0, radius)
        }
        
        // 创建 inner shadow 的镂空路径
//        let someInnerPath: CGPath = cornersPath == nil ? UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath : cornersPath!
        let someInnerPath: CGPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
//        let someInnerPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        ctx.addPath(someInnerPath)
        ctx.clip()
        
        // 创建阴影填充区域，并镂空中心
        let shadowPath = CGMutablePath()
        let shadowRect = rect.insetBy(dx: -rect.size.width, dy: -rect.size.width)
        shadowPath.addRect(shadowRect)
        shadowPath.addPath(someInnerPath)
        shadowPath.closeSubpath()
        
        // 获取填充颜色信息
        
        let oldComponents: [CGFloat] = innerShadowColor?.components ?? [0, 0, 0, 0]
        var newComponents:[CGFloat] = [0, 0, 0, 0]
        let numberOfComponents: Int = (innerShadowColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 1) as! CGColor).numberOfComponents;
        switch (numberOfComponents){
        case 2:
            // 灰度
            newComponents[0] = oldComponents[0]
            newComponents[1] = oldComponents[0]
            newComponents[2] = oldComponents[0]
            newComponents[3] = oldComponents[1] * CGFloat(innerShadowOpacity)
        case 4:
            // RGBA
            newComponents[0] = oldComponents[0]
            newComponents[1] = oldComponents[1]
            newComponents[2] = oldComponents[2]
            newComponents[3] = oldComponents[3] * CGFloat(innerShadowOpacity)
        default: break
        }
        
        // 根据颜色信息创建填充色
        let innerShadowColorWithMultipliedAlpha = CGColor(colorSpace: colorspace, components: newComponents)
        
        // 填充阴影
        guard let innerShadowColorWithMultipliedAlpha = innerShadowColorWithMultipliedAlpha else { return }
        ctx.setFillColor(innerShadowColorWithMultipliedAlpha)
        ctx.setShadow(offset: innerShadowOffset, blur: innerShadowRadius, color: innerShadowColorWithMultipliedAlpha)
        ctx.addPath(shadowPath)
        ctx.fillPath(using: .evenOdd)
    }
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//@available(iOS 13.0, *)
//struct ControllersPreviews: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> FunctionCodeView {
//        FunctionCodeView()
//    }
//
//    func updateUIView(_ uiView: FunctionCodeView, context: Context) {
//    }
//
//    typealias UIViewType = FunctionCodeView
//}
//@available(iOS 13.0.0, *)
//struct Controller_Previews: PreviewProvider {
//    static var previews: some View {
//        ControllersPreviews()
//            .previewLayout(.fixed(width: 375, height: 80))
//    }
//}
//#endif
