import UIKit

class ChartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pieChartView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
                
        let values = [20, 30, 50]
        let colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: pieChartView.frame.width / 2, y: pieChartView.frame.height / 2)
        let radius = min(pieChartView.frame.width, pieChartView.frame.height) / 2
        var startAngle = -CGFloat.pi / 2
        
        var endAngle = startAngle
        for i in 0..<values.count {
            endAngle += 2 * CGFloat.pi * CGFloat(values[i]) / CGFloat(values.reduce(0, +))
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            
            let sliceLayer = CAShapeLayer()
            sliceLayer.path = path.cgPath
            sliceLayer.fillColor = colors[i]
            shapeLayer.addSublayer(sliceLayer)
            
            startAngle = endAngle
        }
        
        pieChartView.layer.addSublayer(shapeLayer)
        self.view.addSubview(pieChartView)
    }
}
