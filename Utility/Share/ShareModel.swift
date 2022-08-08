import LinkPresentation

class ShareModel: NSObject {
    let appName: String
    let iconName: String
    var urlStr: String
    let shareStr: String
    init(appName: String, iconName: String, shareStr: String) {
        self.appName = appName
        self.iconName = iconName
        self.urlStr = ""
        self.shareStr = shareStr
    }
    
    func shareAction(_ vc: UIViewController, color: UIColor = .black, image: UIImage? = nil, str: String? = nil) {
        let loading = UIActivityIndicatorView().VS({
            $0.color = color
        }, vc.view) { make in
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
    
    // The item we want the user to act on.
    // In this case, it's the URL to the Wikipedia page
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return urlStr
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return UIImage(named: iconName)!
    }
    
    // The metadata we want the system to represent as a rich link
    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        let url = URL(string: urlStr)!
        metadata.title = appName

    
        let img: NSItemProvider = NSItemProvider(object: UIImage(named: iconName)!)
        metadata.imageProvider = img
        metadata.iconProvider = img
        metadata.url = url

        metadata.originalURL = URL(fileURLWithPath: shareStr)
    
        return metadata
    }
}
