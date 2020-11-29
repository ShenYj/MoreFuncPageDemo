//
//  MoreFuncScrollView.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import UIKit
import Dollar
import SwiftMessages

class MoreFuncScrollView: UIScrollView {
    
    // MARK: Datasource
    var selectedFuncs: [FunctionModel] = []
    var optionalGroupFuncs: [GroupFunctionModel] = []
    
    var isEdit: Bool = false { didSet { refreshCollection() } }
    
    /// 已选功能列表
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
    /// 可选功能列表
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
            
            self?.selectedFuncs = config?.defaultSelectedFunctions ?? []
            self?.updateOptionalGroupFunctions()
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
        if collectionView == optionalFuncsCollectionView { return optionalGroupFuncs.count }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectedFuncsCollectionView { return 8 }
        if collectionView == optionalFuncsCollectionView { return optionalGroupFuncs[section].groupData.count }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == selectedFuncsCollectionView {
            
            guard indexPath.item < selectedFuncs.count else { return collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.undefine.rawValue, for: indexPath) as! UndefineFuncCell }
            
            if isEdit {
                let removeItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.remove.rawValue, for: indexPath) as! RemoveFuncCell
                let function = selectedFuncs[indexPath.item]
                removeItem.functionLabel.text = function.functionName
                removeItem.functionImageView.image = UIImage(named: function.icon)
                removeItem.clickCallback = { [weak self] in
                    // MARK: 移除
                    self?.remove(function: function, selectedIndexPath: indexPath)
                }
                return removeItem
            } else {
                let normalItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.normal.rawValue, for: indexPath) as! NormalFuncCell
                normalItem.functionLabel.text = selectedFuncs[indexPath.item].functionName
                normalItem.functionImageView.image = UIImage(named: selectedFuncs[indexPath.item].icon)
                return normalItem
            }
        }
        
        if collectionView == optionalFuncsCollectionView {
            
            if isEdit {
                let addItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.add.rawValue, for: indexPath) as! AddFuncCell
                let function = optionalGroupFuncs[indexPath.section].groupData[indexPath.item]
                addItem.functionLabel.text = function.functionName
                addItem.functionImageView.image = UIImage(named: function.icon)
                addItem.clickCallback = { [weak self] in
                    // MARK: 添加
                    self?.add(function: function, optionalIndexPath: indexPath)
                }
                return addItem
            } else {
                let normalItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.normal.rawValue, for: indexPath) as! NormalFuncCell
                normalItem.functionLabel.text = optionalGroupFuncs[indexPath.section].groupData[indexPath.item].functionName
                normalItem.functionImageView.image = UIImage(named: optionalGroupFuncs[indexPath.section].groupData[indexPath.item].icon)
                return normalItem
            }
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.undefine.rawValue, for: indexPath)
    }
}

extension MoreFuncScrollView: UICollectionViewDelegate {
    
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
            sectionHeader.sectionLabel.text = optionalGroupFuncs[indexPath.section].groupTitle
            return sectionHeader
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalHeader.rawValue, for: indexPath) as! OptionalSectionHeader
    }
}

extension MoreFuncScrollView {
    
    private func add(function: FunctionModel, optionalIndexPath opIndexPath: IndexPath) {
        guard selectedFuncs.count < 8 else {
            
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.warning)
            view.configureDropShadow()
            let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
            view.configureContent(title: "Warning", body: "已达到上限", iconText: iconText)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            SwiftMessages.show(view: view)
            
            return
        }
        guard selectedFuncs.contains(function) == false else { return }
        selectedFuncs.append(function)
        updateOptionalGroupFunctions()
        refreshCollection()
    }
    
    private func remove(function: FunctionModel, selectedIndexPath selIndexPath: IndexPath) {
        //selectedFuncs = selectedFuncs.filter { $0.functionId != function.functionId }
        selectedFuncs = Dollar.remove(selectedFuncs, value: function)
        updateOptionalGroupFunctions()
        refreshCollection()
    }
}

extension MoreFuncScrollView {
    
    /// 可选功能
    func updateOptionalGroupFunctions() {
        optionalGroupFuncs = FunctionManager.shared.functionConfig?.optionalGroupFunctions(selectedFuncs: selectedFuncs) ?? []
    }
}
