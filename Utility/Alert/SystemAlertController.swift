import UIKit

class SystemAlertController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertController = UIAlertController(title: "Do you want to delete this data?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { [unowned self] (action) in
        }
        alertController.addAction(deleteAction)
        let closeAction = UIAlertAction(title: "No", style: .default)
        alertController.addAction(closeAction)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if let popOver = alertController.popoverPresentationController {
            popOver.sourceView = view
            popOver.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popOver.permittedArrowDirections = []
        }
        present(alertController, animated: true, completion: nil)
    }

}
