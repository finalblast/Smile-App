//
//  9gagLayout.swift
//  Smile-App
//
//  Created by Nam (Nick) N. HUYNH on 3/4/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit

protocol _9gagLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForPostAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
    func collectionView(collecitonView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    
}

class _9gagLayout: UICollectionViewLayout {
    
    var delegate: _9gagLayoutDelegate!
    
    var numberOfColumns = 1
    var cellPadding: CGFloat = 5
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        
    }
    
    override func prepareLayout() {
    
        if cache.isEmpty {
            
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = CGFloat(0)
            var yOffset = CGFloat(0)
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                let width = columnWidth - cellPadding * 2
                let postHeight = delegate.collectionView(collectionView!, heightForPostAtIndexPath: indexPath, withWidth: width)
                let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding + postHeight + annotationHeight + cellPadding
                let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: height)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset = yOffset + height
                
            }
            
        }
        
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            
            if CGRectIntersectsRect(attributes.frame, rect) {
                
                layoutAttributes.append(attributes)
                
            }
            
        }
        
        return layoutAttributes
        
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        return cache[indexPath.row]
        
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        
        return true
        
    }
    
}