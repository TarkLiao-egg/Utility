import Foundation
import Photos
import PhotosUI


@available(iOS 13.0, *)
class PhotoUtil: NSObject {
    static let shared = PhotoUtil()
    var imageCallback: ((UIImage?) -> Void)?
    @Published var image: UIImage?
    func cameraAction(_ vc: UIViewController?, imageCallback: ((UIImage?) -> Void)?) {
        self.imageCallback = imageCallback
        let pickerViewController = UIImagePickerController()
        pickerViewController.delegate = self
        pickerViewController.allowsEditing = true
        pickerViewController.sourceType = .camera
        pickerViewController.cameraFlashMode = .off
        pickerViewController.modalPresentationStyle = .overFullScreen
        vc?.present(pickerViewController, animated: true, completion: nil)
    }
    
    func albumAction(_ vc: UIViewController?, imageCallback: ((UIImage?) -> Void)?) {
        self.imageCallback = imageCallback
        let pickerViewController = UIImagePickerController()
        pickerViewController.delegate = self
        pickerViewController.allowsEditing = true
        pickerViewController.sourceType = .photoLibrary
        pickerViewController.modalPresentationStyle = .overFullScreen
        vc?.present(pickerViewController, animated: true, completion: nil)
    }
}

@available(iOS 13.0, *)
extension PhotoUtil: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the picker
        picker.dismiss(animated: true) {}
        
        // Get the image
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        PhotoUtil.shared.image = image
        imageCallback?(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker
        picker.dismiss(animated: true) {}
    }
}
