//
//  CollectionView.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

internal class CollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionView {
    
    private func setupUI() {
        contentInsetAdjustmentBehavior = .never
        bounces = false
        backgroundColor = .white
    }
}
