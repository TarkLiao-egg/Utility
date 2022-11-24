import UIKit

class CardViewLayout: UICollectionViewFlowLayout {
    var cellAttrs = [UICollectionViewLayoutAttributes]()
     
    
    public var spacing: CGFloat = 16.0 {
        didSet{
            if collectionView != nil {
                invalidateLayout()
            }
        }
    }
    
    public var maximumVisibleItems: Int = 4 {
        didSet{
            if collectionView != nil {
                invalidateLayout()
            }
        }
    }
    var totalItemsCount = 0

    override func prepare() {
        super.prepare()
    }
    override var collectionViewContentSize: CGSize {
        if collectionView == nil { return CGSize.zero }
        
        let itemsCount = CGFloat(collectionView!.numberOfItems(inSection: 0))
        return CGSize(width: collectionView!.bounds.width * itemsCount,
                      height: collectionView!.bounds.height)
    }
        
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if collectionView == nil { return nil }
        
        totalItemsCount = collectionView!.numberOfItems(inSection: 0)
        let minVisibleIndex = max(0, Int(collectionView!.contentOffset.x) / Int(collectionView!.bounds.width))
        let maxVisibleIndex = totalItemsCount//min(totalItemsCount, minVisibleIndex + maximumVisibleItems)
        
        let contentCenterX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2
        let deltaOffset = Int(collectionView!.contentOffset.x) % Int(collectionView!.bounds.width)
        let percentageDeltaOffset = CGFloat(deltaOffset) / collectionView!.bounds.width
        
        var attributes = [UICollectionViewLayoutAttributes]()
        for i in minVisibleIndex..<maxVisibleIndex {
            let attribute = computeLayoutAttributesForItem(indexPath: IndexPath(item: i, section: 0),
                                                           minVisibleIndex: minVisibleIndex,
                                                           contentCenterX: contentCenterX,
                                                           deltaOffset: CGFloat(deltaOffset),
                                                           percentageDeltaOffset: percentageDeltaOffset)
            attributes.append(attribute)
        }

        return attributes
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func computeLayoutAttributesForItem(indexPath: IndexPath,
                                            minVisibleIndex: Int,
                                            contentCenterX: CGFloat,
                                            deltaOffset: CGFloat,
                                            percentageDeltaOffset: CGFloat) -> UICollectionViewLayoutAttributes {
            if collectionView == nil { return UICollectionViewLayoutAttributes(forCellWith:indexPath)}
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith:indexPath)
            let cardIndex = indexPath.row - minVisibleIndex
            attributes.size = CGSize(width: 250, height: 400)
            attributes.center = CGPoint(x: contentCenterX + spacing * CGFloat(cardIndex),
                                        y: collectionView!.bounds.midY + spacing * CGFloat(cardIndex))
            attributes.zIndex = totalItemsCount - cardIndex
            print("deltaOffset: \(deltaOffset), percent: \(percentageDeltaOffset)")
            switch cardIndex {
            case 0:
                attributes.center.x -= deltaOffset
                
            case 1..<totalItemsCount:
                attributes.center.x -= spacing * percentageDeltaOffset
                attributes.center.y -= spacing * percentageDeltaOffset
                
            default: break
                
            }
            return attributes
        }
}
