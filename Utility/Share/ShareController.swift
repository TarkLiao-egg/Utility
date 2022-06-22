import UIKit
import LinkPresentation


class ShareController: UIViewController {
    var aboutImgView: UIImageView!
    var aboutView: UIView!
    var infoView: UIView!
    var textField: UITextField!
    lazy var pickView: UIPickerView = {
        let pick = UIPickerView()
        pick.delegate = self
        pick.dataSource = self
        return pick
    }()
    var shareView: UIView!
    let urlString: String = "https://apps.apple.com/us/app/mymalaa/id1622160217"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
        setupPicker()
    }

}

extension ShareController {
    func setupButton() {
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutSelector)))
        shareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareSelector)))
    }
    
    @objc func aboutSelector() {
        infoView.isHidden = !infoView.isHidden
        aboutImgView.image = UIImage(named: infoView.isHidden ? "arrowBottom" : "arrowTop")
    }
    
    @objc func shareSelector() {
        let loading = UIActivityIndicatorView().VS({
            $0.color = .white
        }, view) { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        loading.startAnimating()
        
        let url = URL(string: urlString)!
        if #available(iOS 13.0, *) {
            LPMetadataProvider().startFetchingMetadata(for: url) { linkMetadata, _ in
                let activityVc = UIActivityViewController(activityItems: [self/*, UIImage(named:"imageName")*/], applicationActivities: nil)
                DispatchQueue.main.async {
                    self.present(activityVc, animated: true) {
                        loading.stopAnimating()
                    }
                }
            }
        } else {
            let activities: [Any] = [UIImage(named: "test"), "text"]
            let controller = UIActivityViewController(activityItems: activities, applicationActivities: nil)
            present(controller, animated: true, completion: nil)
        }
    }
}

extension ShareController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "myCollect"
    }
    
    // The item we want the user to act on.
    // In this case, it's the URL to the Wikipedia page
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return urlString
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return UIImage(named: "myCollect")!
    }
    
    // The metadata we want the system to represent as a rich link
    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        let url = URL(string: urlString)!
        metadata.title = "myCollect" // Preview Title

    // Set image
        let img: NSItemProvider = NSItemProvider(object: UIImage(named: "myCollect")!)
        metadata.imageProvider = img
        metadata.iconProvider = img
        metadata.url = url

   // Set URL for sharing
        metadata.originalURL = URL(fileURLWithPath:"Share this app to your friends!") // Add this if you want to have a url in your share message.
    

        return metadata
    }
}

extension ShareController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPicker() {
        textField.inputView = pickView
        textField.addDoneButtonOnKeyboard(self, doneSelector: #selector(doneSeletor))
    }
    
    @objc func doneSeletor() {
        textField.resignFirstResponder()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "English"
    }
}

extension ShareController {
    func setupUI() {
        view.backgroundColor = UIColor.hex(0x333333)
        
        UIView().VS({
            $0.backgroundColor = UIColor.hex(0x222222)
        }, view) { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        var btn: UIButton?
        var btn2: UIButton?
        let navView = ReuseUI.getNavBarView(title: "About us", backBtn: &btn, settingBtn: &btn2).VS(nil, view) { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        let stackview = UIStackView().VS({
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }, view) { make in
            make.top.equalTo(navView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        aboutView = getAboutView()
        stackview.addArrangedSubview(aboutView)
        stackview.addArrangedSubview(ReuseUI.getLineView())
        infoView = getInfoView()
        stackview.addArrangedSubview(infoView)
        stackview.addArrangedSubview(getLangView())
        stackview.addArrangedSubview(ReuseUI.getLineView())
        shareView = getShareView()
        stackview.addArrangedSubview(shareView)
        stackview.addArrangedSubview(ReuseUI.getLineView())
        stackview.addArrangedSubview(UIView())
    }
    
    func getShareView() -> UIView {
        return UIView().S { view in
            UILabel().VS({
                $0.text = "Share App"
                $0.textColor = .white
                $0.font = UIFont.getDefaultFont(.medium, size: 18)
            }, view) { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(38)
            }
        } _: { make in
            make.height.equalTo(65)
        }
    }
    
    func getLangView() -> UIView {
        return UIView().S { view in
            UILabel().VS({
                $0.text = "Language"
                $0.textColor = .white
                $0.font = UIFont.getDefaultFont(.medium, size: 18)
            }, view) { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(38)
            }
            
            textField = UITextField().VS({
                $0.tintColor = .clear
                $0.text = "English"
                $0.textColor = UIColor.hex(0x999999)
                $0.font = UIFont.getDefaultFont(.regular, size: 18)
                $0.textAlignment = .center
                $0.layer.borderColor = UIColor.hex(0x999999).cgColor
                $0.layer.borderWidth = 0.5
                $0.layer.cornerRadius = 12
            }, view) { make in
                make.width.equalTo(110)
                make.height.equalTo(36)
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(30)
            }
        } _: { make in
            make.height.equalTo(65)
        }
    }
    
    func getInfoView() -> UIView {
        return UIView().S { view in
            view.isHidden = true
            UILabel().VS({
                $0.font = UIFont.getDefaultFont(.medium, size: 14)
                $0.text = "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet."
                $0.textColor = .white
                $0.numberOfLines = 0
            }, view) { make in
                make.top.equalToSuperview().inset(18)
                make.leading.trailing.equalToSuperview().inset(34)
                make.bottom.equalToSuperview().inset(15)
            }
            
            ReuseUI.getLineView().VS(nil, view) { make in
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    func getAboutView() -> UIView {
        return UIView().S { view in
            UILabel().VS({
                $0.text = "About"
                $0.textColor = .white
                $0.font = UIFont.getDefaultFont(.medium, size: 18)
            }, view) { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(38)
            }
            
            aboutImgView = UIImageView.name("arrowBottom").VS({
                $0.contentMode = .scaleToFill
            }, view) { make in
                make.size.equalTo(36)
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(30)
            }
        } _: { make in
            make.height.equalTo(65)
        }
    }
}
