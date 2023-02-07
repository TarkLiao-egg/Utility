import UIKit
import CoreMotion
import Combine
@available(iOS 13.0, *)
class CMPedomemterController: UIViewController {
    var bindArray = Set<AnyCancellable>()
    /* Info Privacy - Motion Usage Description */
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityManager.startActivityUpdates(to: .main) { (activity: CMMotionActivity?) in
            guard let activity else { return }
            DispatchQueue.main.async {
                if activity.stationary {
                    print("Stationary")
                } else if activity.walking {
                    print("walking")
                } else if activity.running {
                    print("running")
                } else if activity.automotive {
                    print("car")
                }
            }
        }
        
//        if CMPedometer.isStepCountingAvailable() {
//            pedometer.startUpdates(from: "2023-02-02".getDate()!) { pedometerData, error in
//                guard let pedometerData = pedometerData, error == nil else { return }
//
//                DispatchQueue.main.async {
//                    print(pedometerData.numberOfSteps.intValue)
//                }
//            }
//        }
        
        Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [unowned self]  _  in
            pedometer.queryPedometerData(from: "2023-02-02".getDate()!, to: Date(), withHandler: { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else { return }
                
                DispatchQueue.main.async {
                    label.text = String(pedometerData.numberOfSteps.intValue)
                    print(pedometerData.numberOfSteps.intValue)
                }
            })
        }.store(in: &bindArray)
    }
}
