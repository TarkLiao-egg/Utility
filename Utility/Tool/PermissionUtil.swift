import Foundation
import Photos
import PhotosUI

class PermissionUtil {
    enum Feature {
        case camera
        case location
    }
    static func checkCameraPermission(_ target: UIViewController?, completion: @escaping ((Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("authorized")
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    setFeatrueAlert(target, .camera)
                    completion(false)
                }
            }
        
        case .denied, .restricted:
            setFeatrueAlert(target, .camera)
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
                setFeatrueAlert(target, .location)
                completion(false)
            default:
                print("unknown")
            }
        } else {
            print("Location services are not enabled")
        }
        completion(true)
    }
    
    static func setFeatrueAlert(_ target: UIViewController?, _ type: Feature) {
        switch type {
        case .camera:
            setAlert(target: target, title: "Camera Permission", msg: "Please go to the settings page to allow the app to access your camera permissions.")
        case .location:
            setAlert(target: target, title: "Location permission", msg: "Please go to the settings page to allow the app to access your location permissions.")
        }
    }
    
    static func setAlert(target: UIViewController?, title: String, msg: String) {
        guard let target = target else { return }
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }
        let noAction = UIAlertAction(title: "Not now", style: .cancel)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        target.present(alertVC, animated: true)
    }
}
