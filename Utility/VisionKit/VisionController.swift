import UIKit
import VisionKit
import SnapKit

@available(iOS 13.0, *)
class VisionController: UIViewController {
//    let scanner = VNDocumentCameraViewController()
//    private lazy var interaction: ImageAnalysisInteraction = {
//        let interaction = ImageAnalysisInteraction()
//        interaction.preferredInteractionTypes = .automatic
//        return interaction
//    }()
//
//    private let imageAnalyzer = ImageAnalyzer()
    override func viewDidLoad() {
        super.viewDidLoad()
//        DataScannerViewController.isAvailable
//        delegate = self
//        view.addSubview(scanner)
//        scanner.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
@available(iOS 13.0, *)
extension VisionController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var scannedPages = [UIImage]()

        for i in 0..<scan.pageCount {
            scannedPages.append(scan.imageOfPage(at: i))
        }
        print(scannedPages.count)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        print("cancel")
        controller.dismiss(animated: true) {
            
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        
    }
}
