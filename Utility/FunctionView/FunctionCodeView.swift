import UIKit

class FunctionCodeView: UIView {
    var gradientView: UIView!
    private let gradientViewLayer = CAGradientLayer()
    private var gradientBorderLayer = CAGradientLayer()
    private var specificCornerLayer = CAShapeLayer()
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
