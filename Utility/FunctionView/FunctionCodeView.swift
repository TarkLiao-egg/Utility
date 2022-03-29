//
//  FunctionCodeView.swift
//  Utility
//
//  Created by 廖力頡 on 2022/3/27.
//

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
    var borderStartColor: UIColor?
    var borderEndColor: UIColor?
    
    var viewBackgroundColor: UIColor?
    
    // Gradient
    var gradientStartPoint: CGPoint?
    var gradientEndPoint: CGPoint?
    var gradientStartColor: UIColor? = nil
    var gradientEndColor: UIColor? = nil
    
    // MARK: Shadow
    var shadowWidth: CGFloat = 0
    var shadowOffset: CGSize = CGSize.zero
    var shadowColor: UIColor?
    var shadowOpacity: Float = 1
    
    var isCircle: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        // Code create
        print("frame: CGRect")
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
            self.sendSubviewToBack(self.subviews[self.subviews.count - 1])
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
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        // view Color
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        if let gradientStartColor = gradientStartColor, let gradientEndColor = gradientEndColor, let gradientStartPoint = gradientStartPoint, let gradientEndPoint = gradientEndPoint {
            gradientViewLayer.startPoint = gradientStartPoint
            gradientViewLayer.endPoint = gradientEndPoint
            gradientViewLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        } else {
            gradientView.backgroundColor = viewBackgroundColor
        }
        gradientViewLayer.frame = bounds
        gradientView.layer.mask = maskLayer
        gradientView.layer.addSublayer(gradientViewLayer)
        
        // border
        if let borderStartColor = borderStartColor, let borderEndColor = borderEndColor {
            let borderShape = CAShapeLayer()
            borderShape.lineWidth = borderWidth
            borderShape.path = path.cgPath
            borderShape.strokeColor = UIColor.black.cgColor
            borderShape.fillColor = UIColor.clear.cgColor
            gradientBorderLayer = CAGradientLayer()
            gradientBorderLayer.frame =  bounds
            gradientBorderLayer.colors = [borderStartColor.cgColor, borderEndColor.cgColor]
            gradientBorderLayer.mask = borderShape
            gradientView.layer.addSublayer(gradientBorderLayer)
        } else {
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
