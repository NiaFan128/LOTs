//
//  Lay.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/28.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

struct InspireSize {
    
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    
}

class InspireCollectionViewLayout: UICollectionViewLayout {
    
    var itemSize = CGSize(width: 200, height: 150)
    var attributesList = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        
        super.prepare()
        
        let itemNo = collectionView?.numberOfItems(inSection: 0) ?? 0
        let length = (collectionView!.frame.width - 40) / 3
        
        itemSize = CGSize(width: length, height: length)
        
        var dictionary: [Int: InspireSize] = [:]
        
        for index in 0 ... 5 {
            
            var x = CGFloat(index % 3) * (itemSize.width + 10) + 10
            var y = CGFloat(index / 3) * (itemSize.width + 10) + 10

            switch index {
                
            case 0:
                
                let inspireSize = InspireSize(x: x,
                                              y: y,
                                              width: itemSize.width * 2 + 10,
                                              height: itemSize.height * 2 + 10)
                
                dictionary[0] = inspireSize

            case 1:
                
                x = itemSize.width * 2 + 30
                let inspireSize = InspireSize(x: x,
                                              y: y,
                                              width: itemSize.width,
                                              height: itemSize.height)
                
                dictionary[1] = inspireSize
                
            case 2:
                
                x = itemSize.width * 2 + 30
                y += itemSize.height + 10
                let inspireSize = InspireSize(x: x,
                                              y: y,
                                              width: itemSize.width,
                                              height: itemSize.height)
                
                dictionary[2] = inspireSize
                
            case 3:
                
                y += (itemSize.width + 10)
                                
                let inspireSize = InspireSize(x: x,
                                              y: y,
                                              width: itemSize.width,
                                              height: itemSize.height)
                
                dictionary[3] = inspireSize
                
            case 4:
                
                y += (itemSize.width + 10)
                
                let inspireSize = InspireSize(x: x,
                                              y: y,
                                              width: itemSize.width,
                                              height: itemSize.height)
                
                dictionary[4] = inspireSize
                
            case 5:
                
                y += (itemSize.width + 10)
                
                let inspireSize = InspireSize(x: x,
                                              y: y,
                                              width: itemSize.width,
                                              height: itemSize.height)
                
                dictionary[5] = inspireSize

            default: break
            
            }
            
        }
        
        attributesList = (0 ..< itemNo).map { (i) -> UICollectionViewLayoutAttributes in
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            
            attributes.size = self.itemSize
            
            var inspireSize: InspireSize?
            
            switch i % 6 {
                
            case 0: inspireSize = dictionary[0]
                
            case 1: inspireSize = dictionary[1]

            case 2: inspireSize = dictionary[2]
                
            case 3: inspireSize = dictionary[3]
                
            case 4: inspireSize = dictionary[4]
                
            case 5: inspireSize = dictionary[5]
                
            default: break
                
            }

            if let size = inspireSize {
                
                attributes.frame = CGRect(x: size.x, y: size.y + (3 * self.itemSize.width + 30) * CGFloat(i / 6), width: size.width, height: size.height)
                
            }
            
            return attributes
            
        }
        
    }
    
    override var collectionViewContentSize : CGSize {
        
//        return CGSize(width: collectionView!.bounds.width, height: (itemSize.height + 10) * CGFloat(ceil(Double(collectionView!.numberOfItems(inSection: 0)) / 3)) + (itemSize.height + 20))

        return CGSize(width: collectionView!.bounds.width, height: (itemSize.height + 10) * CGFloat(ceil(Double(collectionView!.numberOfItems(inSection: 0)) / 2)) + 10)
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributesList
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if indexPath.row < attributesList.count
            
        {
            
            return attributesList[indexPath.row]
            
        }
        
        return nil
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return true
        
    }
    
}
