import UIKit
import Lottie

class JsonGifController: UIViewController {
    
    let gif = LottieAnimationView(asset: "animate")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimate(gif)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func playAnimate(_ animateView: LottieAnimationView) {
        if animateView.isAnimationPlaying {
            animateView.stop()
            return
        }
        animateView.play(completion: { [weak self] isEnd in
            if isEnd {
                animateView.stop()
            } else {
                self?.playAnimate(animateView)
            }
        })
    }
}
