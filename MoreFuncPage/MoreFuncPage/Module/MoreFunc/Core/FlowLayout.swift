//
//  FlowLayout.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

internal class FLowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        minimumLineSpacing = verticalMargin
        minimumInteritemSpacing = horizontalMargin
        minimumInteritemSpacing = verticalMargin
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.showsHorizontalScrollIndicator = false
        sectionHeadersPinToVisibleBounds = true
        
    }
    
    var rowItemCount: Int { 4 }
    var horizontalMargin: CGFloat { 5 }
    var verticalMargin: CGFloat { 5 }
    var itemWidth: CGFloat { (UIScreen.main.bounds.width - CGFloat((rowItemCount + 1)) * horizontalMargin) / CGFloat(rowItemCount) }
    var itemHeight: CGFloat { itemWidth * 1.0 }
    
}
