import UIKit

let cellReuseId = "cellReuseId"
class CWBannerController: UIViewController {
    //MARK: - INITILAL
    init(style: CWBannerStyle) {
        self.bannerStyle = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.bannerStyle = .unknown
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSLog("[%@ -- %@]", NSStringFromClass(self.classForCoder), #function)
    }
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bannerView.bannerWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bannerView.bannerWillDisAppear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: - PROPERTY
    let bannerStyle: CWBannerStyle
    
    let imgNames = ["01.jpg",
                    "02.jpg",
                    "03.jpg",
                    "04.jpg",
                    "05.jpg"]
    
    lazy var bannerView: CWBanner = {
        let layout = CWSwiftFlowLayout.init(style: self.bannerStyle)
        layout.itemSpace = 10
        if self.bannerStyle == .preview_big {
            layout.itemSpace = -20
        }
        let banner = CWBanner.init(frame: CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 240), flowLayout: layout, delegate: self)
        self.view.addSubview(banner)
        
        banner.backgroundColor = self.view.backgroundColor
        banner.banner.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
        
        banner.autoPlay = false
        banner.endless = true
        banner.timeInterval = 2
        
        return banner
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.bannerView.scroll(to: 3, animated: false)
    }
}

//MARK: - CWBannerDelegate
extension CWBannerController: CWBannerDelegate {
    func bannerNumbers() -> Int {
        return self.imgNames.count
    }
    
    func bannerView(banner: CWBanner, index: Int, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = banner.banner.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat.random(in: 0...255) / 255, green: CGFloat.random(in: 0...255) / 255, blue: CGFloat.random(in: 0...255) / 255, alpha: 1)
        var imgView = cell.contentView.viewWithTag(999)
        var label = cell.contentView.viewWithTag(888)
        if imgView == nil {
            imgView = UIImageView.init(frame: cell.contentView.bounds)
            imgView?.tag = 999
            cell.contentView.addSubview(imgView!)
            imgView?.layer.cornerRadius = 4.0
            imgView?.layer.masksToBounds = true
            
            label = UILabel.init(frame: CGRect.init(x: 30, y: 0, width: 60, height: 30))
            (label as! UILabel).textColor = UIColor.white
            (label as! UILabel).font = UIFont.systemFont(ofSize: 21)
            label?.tag = 888
            cell.contentView.addSubview(label!)
        }
        (imgView as! UIImageView).image = UIImage.init(named: self.imgNames[index])
        (label as! UILabel).text = "\(index)"
        return cell
    }
    
    func didSelected(banner: CWBanner, index: Int, indexPath: IndexPath) {
        print("点击 \(index) click...")
    }
    
    func didStartScroll(banner: CWBanner, index: Int, indexPath: IndexPath) {
        print("开始滑动: \(index) ...")
    }
    
    func didEndScroll(banner: CWBanner, index: Int, indexPath: IndexPath) {
        print("结束滑动: \(index) ...")
    }
}

// MARK: - CONFIGURE UI
extension CWBannerController {
    fileprivate func configureUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "show"
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.bannerView.freshBanner()
        self.automaticallyAdjustsScrollViewInsets = false
    }
}
