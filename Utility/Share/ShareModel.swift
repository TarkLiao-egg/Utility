import LinkPresentation

class ShareModel: NSObject {
    let appName: String
    let iconName: String
    var urlStr: String
    let shareStr: String
    init(iconName: String, shareStr: String) {
        self.appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String
        self.iconName = iconName
        self.urlStr = ""
        self.shareStr = shareStr
    }
    
    func shareAction(_ vc: UIViewController, color: UIColor = .black, image: UIImage? = nil, str: String? = nil) {
        let loading = UIActivityIndicatorView()
        loading.color = color
        vc.view.addSubview(loading)
        loading.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        loading.startAnimating()
        
        urlStr = str ?? ""
        
        if #available(iOS 13.0, *) {
            var items: [Any] = [self]
            if let image = image {
                items.append(image)
            }
            let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            DispatchQueue.main.async {
                vc.present(activityVc, animated: true) {
                    loading.stopAnimating()
                }
            }
        }
    }
}

extension ShareModel: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return appName
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return urlStr
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return UIImage(named: iconName)!
    }
    
    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        metadata.title = appName

        if let img = UIImage(named: iconName) {
            let img: NSItemProvider = NSItemProvider(object: img)
            metadata.imageProvider = img
            metadata.iconProvider = img
        }
        if let url = URL(string: urlStr) {
            metadata.url = url
        }

        metadata.originalURL = URL(fileURLWithPath: shareStr)
    
        return metadata
    }
}
