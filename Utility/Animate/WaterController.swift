import UIKit

class WaterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wave  = WaveView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2))
        wave.backgroundColor = .red
        wave.center = self.view.center
        wave.color1 = UIColor.magenta
        wave.color2 = UIColor.cyan
        wave.waveSpeed = 10
        wave.wave = 4
        self.view.addSubview(wave)
        wave.start()
    }
    

}
