//
//  SetCollectionViewController.swift
//  Utility
//
//  Created by 廖力頡 on 2022/4/23.
//

import UIKit


class SetCollectionViewController: UIViewController {
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
    
    var datas = [0, 1, 2, 3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
}

extension SetCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.configure()
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(collectionView.visibleCells)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("highLight\(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -collectionView.frame.width * 0.2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat = (UIScreen.main.bounds.width - 34 - 9) / 2
//        let newWidth = CGFloat(Int(width))
//        return CGSize(width: newWidth, height: 200 * width / 167)
        print(collectionView.frame.width)
        self.layout.itemSize = CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.scrollOffset(scrollView)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollOffset(scrollView)
//        0:0.4
//        1:1
//        2:1.6
//        3:2.2
//        4:2.8
//        5:3.4
    }
    
    func scrollOffset(_ scrollView: UIScrollView) {
        
        let itemWidth: CGFloat = collectionView.frame.width * 0.8
        let space: CGFloat = collectionView.frame.width * 0.2
        let centerWidth:CGFloat = itemWidth - space
        var centers: [CGFloat] = [itemWidth * 0.5 - collectionView.frame.width / 2]

        var minOffset: (diff: CGFloat, index: Int, center: CGFloat) = (scrollView.contentSize.width, 0, scrollView.contentSize.width)
        
        for i in 1..<datas.count {
            let data = centers[0] + centerWidth * CGFloat(i)
            centers.append(data)
        }
        for (index, center) in centers.enumerated() {
            
            let diff = (abs(scrollView.contentOffset.x - center))
//            print("\(center),\(diff)")
            if diff < minOffset.diff {
                minOffset = (diff, index, center)
            }
            
        }
        if minOffset.center < 0 {
            minOffset.center = 0
        }
        scrollView.setContentOffset(CGPoint(x: minOffset.center, y: scrollView.contentOffset.y), animated: true)
        
    }
}

extension SetCollectionViewController {
    func setupUI() {
        view.backgroundColor = .clear
        layout = NewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = -20
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

class NewFlowLayout: UICollectionViewFlowLayout {
    //MARK: - 构造方法
    
    deinit {
        NSLog("[%@ -- %@]",NSStringFromClass(self.classForCoder) ,#function);
    }
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Override
    override func prepare() {
        super.prepare()
        guard self.collectionView != nil else {
            assert(self.collectionView != nil, "error")
            return
        }
        self.scrollDirection = .horizontal
        let height = self.collectionView!.frame.height
        let width = self.collectionView!.frame.width * self.itemWidthScale
        self.itemSize = CGSize.init(width: width, height: height)
        let padding = width * (1 - self.minScale) * 0.5;
        self.minimumLineSpacing = self.itemSpace - padding;
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arr: [UICollectionViewLayoutAttributes]? = nil;
        
        arr = self.caculateScale(rect: rect, block: { (width, space) -> CGFloat in
            return (self.minScale - 1) / (self.itemSize.width) * space + 1;
        })
        return arr
    }
    
    //MARK: - Property
    /// banner风格
    
    /// 每张图之间的间距, 默认为0
    var itemSpace: CGFloat = 0
    
    /*
     *   cell的宽度占总宽度的比例
     *   默认: 0.75
     *   normal 样式下无效
     */
    var itemWidthScale: CGFloat = 0.75
    
    /**
     * style = preview_zoom 有效
     * 前后2张图的缩小比例 (0.0 ~ 1.0)
     * 默认: 0.8
     */
    var minScale: CGFloat = 0.8
    
    fileprivate func caculateScale(rect: CGRect, block: (CGFloat, CGFloat) -> CGFloat) -> [UICollectionViewLayoutAttributes]? {
        let arr = super.layoutAttributesForElements(in: rect)?.map({$0.copy()}) as! [UICollectionViewLayoutAttributes]?
        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.width * 0.5
        let width = self.collectionView!.frame.width * self.itemWidthScale
        var maxScale: CGFloat = 0
        var attri: UICollectionViewLayoutAttributes? = nil
        arr?.forEach({ (element) in
            let space = CGFloat(abs(element.center.x - centerX))
            var scale: CGFloat = 1.0
            scale = block(width, space)
            if element.indexPath.row == 2 {
                print("center.X:\(element.center.x), centerX:\(centerX), scale: \(scale)")
            }
            element.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            if maxScale < scale {
                maxScale = scale
                attri = element
            }
            element.zIndex = 0
        })
        if attri != nil {
            attri?.zIndex = 1
        }
        return arr
    }
}
