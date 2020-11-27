//
//  MoreFuncScrollView.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import UIKit

class MoreFuncScrollView: UIScrollView {
    
    private lazy var headerView: HeaderView = {
        let header = HeaderView.loadHeaderView()
        header.frame = CGRect(x: 0,
                              y: 0,
                              width: self.bounds.width,
                              height: 80)
        return header
    }()
    private lazy var moreView: MoreFuncView = {
        let more = MoreFuncView.loadMoreFuncView()
        more.frame = CGRect(x: 0,
                            y: selectedFuncsCollectionView.frame.height + selectedFuncsCollectionView.frame.origin.y,
                            width: self.bounds.width,
                            height: 50)
        return more
    }()
    
    /// 已选功能
    private lazy var selectedFuncsCollectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        let height = collectionLayout.verticalMargin * 3 + collectionLayout.itemHeight * 2
        collectionView.frame = CGRect(x: 0,
                                      y: headerView.frame.origin.y + headerView.frame.height,
                                      width: self.bounds.width,
                                      height: height)
        collectionView.register(UINib.init(nibName: "UndefineFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.undefine.rawValue)
        collectionView.register(UINib.init(nibName: "NormalFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.normal.rawValue)
        return collectionView
    }()
    
    private lazy var optionalFuncsCollectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        let coorY = moreView.frame.height + moreView.frame.origin.y
        collectionView.frame = CGRect(x: 0,
                                      y: coorY,
                                      width: self.bounds.width,
                                      height: self.bounds.height - coorY)
        collectionView.register(UINib.init(nibName: "AddFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.add.rawValue)
        collectionView.register(UINib.init(nibName: "RemoveFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.remove.rawValue)
        collectionView.register(UINib.init(nibName: "NormalFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.normal.rawValue)
        return collectionView
    }()
    
    private lazy var collectionLayout: FLowLayout = FLowLayout()
    
    
    // MARK: Datasource
    private var functionDataSource: FunctionsModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoreFuncScrollView {
    
    private func setupUI() {
        
        backgroundColor = .white
        addSubview(headerView)
        addSubview(selectedFuncsCollectionView)
        addSubview(moreView)
        addSubview(optionalFuncsCollectionView)
        
        FunctionManager.loadLocalFuncs { [weak self] (config) in
            self?.functionDataSource = config
            self?.refreshCollection()
        }
    }
}

extension MoreFuncScrollView {
    
    private func refreshCollection() {
        selectedFuncsCollectionView.reloadData()
    }
}

extension MoreFuncScrollView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectedFuncsCollectionView {
            return 8
        }
        if collectionView == optionalFuncsCollectionView {
            return functionDataSource?.optionalFunctions.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let dataSource = functionDataSource else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.undefine.rawValue, for: indexPath)
        }
        
        if collectionView == selectedFuncsCollectionView {
            if indexPath.item < dataSource.selectedFunctions.count {
                let normalItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.normal.rawValue, for: indexPath) as! NormalFuncCell
                normalItem.functionLabel.text = dataSource.selectedFunctions[indexPath.item].functionName
                normalItem.functionImageView.image = UIImage(named: dataSource.selectedFunctions[indexPath.item].icon)
                return normalItem
            }
            return collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.undefine.rawValue, for: indexPath) as! UndefineFuncCell
        }
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.normal.rawValue, for: indexPath) as! NormalFuncCell
        item.functionLabel.text = dataSource.optionalFunctions[indexPath.item].functionName
        item.functionImageView.image = UIImage(named: dataSource.optionalFunctions[indexPath.item].icon)
        return item
    }
}
