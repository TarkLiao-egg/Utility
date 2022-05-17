import Foundation
import Photos
import PhotosUI

class PermissionUtil {
    static func checkCameraPermission(_ target: UIViewController?, completion: @escaping ((Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("authorized")
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    setAlert(target: target, title: "Permission denied", msg: "Please allow the app to use the camera permission by the System Setting.")
                    completion(false)
                }
            }
        
        case .denied, .restricted:
            setAlert(target: target, title: "Permission denied", msg: "Please allow the app to use the camera permission by the System Setting.")
            completion(false)
        default:
            completion(false)
        }
        completion(true)
    }
    
    static func checkLocationPermission(_ target: UIViewController?, completion: @escaping ((Bool) -> Void)) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                setAlert(target: target, title: "Permission denied", msg: "Please allow the app to use the location permission by the System Setting.")
                completion(false)
            default:
                print("unknown")
            }
        } else {
            print("Location services are not enabled")
        }
        completion(true)
    }

    
    static func setAlert(target: UIViewController?, title: String, msg: String) {
        guard let target = target else { return }
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Go", style: .default) { _ in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        target.present(alertVC, animated: true)
    }
}
