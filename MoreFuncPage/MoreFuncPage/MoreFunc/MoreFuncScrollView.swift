//
//  MoreFuncScrollView.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import UIKit

class MoreFuncScrollView: UIScrollView {
    
    /// 已选功能
    private lazy var selectedFuncsCollectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: selectedLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        let height = selectedLayout.verticalMargin * 3
            + selectedLayout.itemHeight * 2
            + selectedLayout.headerReferenceSize.height
            + selectedLayout.footerReferenceSize.height
        
        collectionView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: self.bounds.width,
                                      height: height)
        collectionView.register(UINib(nibName: "UndefineFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.undefine.rawValue)
        collectionView.register(UINib(nibName: "NormalFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.normal.rawValue)
        collectionView.register(UINib(nibName: "RemoveFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.remove.rawValue)
        
        collectionView.register(UINib(nibName: "SelectedSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.selectedHeader.rawValue)
        collectionView.register(UINib(nibName: "SelectedSectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.selectedFooter.rawValue)
        
        return collectionView
    }()
    
    private lazy var optionalFuncsCollectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: optionalLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        let coorY = selectedFuncsCollectionView.frame.height
        collectionView.frame = CGRect(x: 0,
                                      y: coorY,
                                      width: bounds.width,
                                      height: bounds.height - coorY)
        collectionView.register(UINib(nibName: "AddFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.add.rawValue)
        collectionView.register(UINib(nibName: "NormalFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.normal.rawValue)
        
        collectionView.register(UINib(nibName: "OptionalSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalHeader.rawValue)
        
        return collectionView
    }()
    
    private lazy var selectedLayout: FLowLayout = {
        let layout = FLowLayout()
        layout.headerReferenceSize = CGSize(width: bounds.width, height: 80)
        layout.footerReferenceSize = CGSize(width: bounds.width, height: 60)
        return layout
    }()
    private lazy var optionalLayout: FLowLayout = {
        let layout = FLowLayout()
        layout.headerReferenceSize = CGSize(width: bounds.width, height: 44)
        layout.footerReferenceSize = .zero
        return layout
    }()
    
    
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
        
        bounces = false
        backgroundColor = .white
        contentInsetAdjustmentBehavior = .never
        addSubview(selectedFuncsCollectionView)
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
        optionalFuncsCollectionView.reloadData()
        
        optionalFuncsCollectionView.layoutIfNeeded()
        let contentHeight = optionalFuncsCollectionView.contentSize.height
        let optionalY = optionalFuncsCollectionView.frame.origin.y
        let optionalHeight = max(contentHeight, bounds.height - optionalFuncsCollectionView.frame.origin.y)
        optionalFuncsCollectionView.frame = CGRect(x: 0,
                                                   y: optionalY,
                                                   width: self.bounds.width,
                                                   height: contentHeight)
        contentSize = CGSize(width: bounds.width, height: optionalY + optionalHeight + 20)
        
    }
}

extension MoreFuncScrollView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == optionalFuncsCollectionView { return functionDataSource?.data.count ?? 0 }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectedFuncsCollectionView { return 8 }
        if collectionView == optionalFuncsCollectionView { return functionDataSource?.data[section].groupData.count ?? 0 }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let dataSource = functionDataSource else { return collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.undefine.rawValue, for: indexPath) }
        
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
        item.functionLabel.text = dataSource.data[indexPath.section].groupData[indexPath.item].functionName
        item.functionImageView.image = UIImage(named: dataSource.data[indexPath.section].groupData[indexPath.item].icon)
        return item
    }
}

extension MoreFuncScrollView: UICollectionViewDelegate {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        if collectionView == optionalFuncsCollectionView && functionDataSource?.data[section].groupData.isEmpty == false {
//            return CGSize(width: self.bounds.width, height: 44)
//        }
//        return .zero
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader && collectionView == selectedFuncsCollectionView {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.selectedHeader.rawValue, for: indexPath) as! SelectedSectionHeader
            return sectionHeader
        }
        if kind == UICollectionView.elementKindSectionFooter && collectionView == selectedFuncsCollectionView {
            let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.selectedFooter.rawValue, for: indexPath) as! SelectedSectionFooter
            return sectionFooter
        }
        
        if kind == UICollectionView.elementKindSectionHeader && collectionView == optionalFuncsCollectionView {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalHeader.rawValue, for: indexPath) as! OptionalSectionHeader
            sectionHeader.sectionLabel.text = functionDataSource?.data[indexPath.section].groupTitle
            return sectionHeader
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalHeader.rawValue, for: indexPath) as! OptionalSectionHeader
    }
}
