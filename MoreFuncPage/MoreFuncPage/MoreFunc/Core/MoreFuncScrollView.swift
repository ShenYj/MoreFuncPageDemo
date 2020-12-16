//
//  MoreFuncScrollView.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import UIKit
import Dollar
import SwiftMessages
import SkeletonView

extension MoreFuncScrollView {
    
    /// 外接调整编辑状态的接口
    /// - Parameter isEditing: 将被设置成的状态
    func changeEditStatus(isEditing: Bool, reset: Bool = false) {
        needReset = reset
        isEdit = isEditing
    }
}

class MoreFuncScrollView: UIScrollView {
    
    // MARK: Datasource
    var selectedFuncs: [FunctionModel] = []
    var optionalGroupFuncs: [GroupFunctionModel] = []
    // MARK: 用于编辑状态下重置的数据
    var defaultSelectedFuncs: [FunctionModel] = []
    var defaultOptionalGroupFuncs: [GroupFunctionModel] = []
    
    private var needReset: Bool = false
    private(set) var isEdit: Bool = false {
        willSet {
            // 即将进入编辑状态
            if newValue {
                defaultSelectedFuncs = selectedFuncs
                defaultOptionalGroupFuncs = optionalGroupFuncs
                return
            }
            // 即将取消编辑并需要恢复到编辑前的状态
            if needReset {
                selectedFuncs = defaultSelectedFuncs
                optionalGroupFuncs = defaultOptionalGroupFuncs
                defaultSelectedFuncs.removeAll(keepingCapacity: true)
                defaultOptionalGroupFuncs.removeAll(keepingCapacity: true)
            }
        }
        didSet {
            refreshCollection()
            guard let delegate = moreFuncDelegate else { return }
            delegate.moreFuncView?(self, inEditStatus: isEdit)
        }
    }
    
    var currentIndexPath: IndexPath?
    var sourceIndexPath: IndexPath?
    var snapView: UIView?
    
    weak var moreFuncDelegate: MoreFuncProtocol?
    
    /// 已选功能列表
    private lazy var selectedFuncsCollectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: selectedLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        let height = selectedLayout.verticalMargin * 3
            + selectedLayout.itemHeight * 2
            + selectedLayout.headerReferenceSize.height
            + selectedLayout.footerReferenceSize.height
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: height)
        
        collectionView.register(UINib(nibName: "UndefineFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.undefine.rawValue)
        collectionView.register(UINib(nibName: "NormalFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.normal.rawValue)
        collectionView.register(UINib(nibName: "RemoveFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.remove.rawValue)
        
        collectionView.register(UINib(nibName: "SelectedSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.selectedHeader.rawValue)
        collectionView.register(UINib(nibName: "SelectedSectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.selectedFooter.rawValue)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(targetForSelectedFuncCollectionView(longPressGesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
        return collectionView
    }()
    /// 可选功能列表
    private lazy var optionalFuncsCollectionView: CollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: optionalLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isSkeletonable = true
        let coorY = selectedFuncsCollectionView.frame.height
        collectionView.frame = CGRect(x: 0,
                                      y: coorY,
                                      width: bounds.width,
                                      height: bounds.height - coorY)
        collectionView.register(UINib(nibName: "AddFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.add.rawValue)
        collectionView.register(UINib(nibName: "NormalFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.normal.rawValue)
        // 占位使用
        collectionView.register(UINib(nibName: "UndefineFuncCell", bundle: nil), forCellWithReuseIdentifier: ReusedIdentifier.undefine.rawValue)
        
        collectionView.register(UINib(nibName: "OptionalSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalHeader.rawValue)
        collectionView.register(UINib(nibName: "OptionalSectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalFooter.rawValue)
        return collectionView
    }()
    
    private lazy var selectedLayout: FLowLayout = {
        let layout = FLowLayout()
        layout.headerReferenceSize = CGSize(width: bounds.width, height: 80)
        layout.footerReferenceSize = CGSize(width: bounds.width, height: 60)
        return layout
    }()
    private lazy var optionalLayout: FLowLayout = FLowLayout()
    
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
        backgroundColor = .systemOrange
        optionalFuncsCollectionView.showAnimatedGradientSkeleton()
        contentInsetAdjustmentBehavior = .never
        addSubview(selectedFuncsCollectionView)
        addSubview(optionalFuncsCollectionView)
        
        FunctionManager.loadLocalFuncs { [weak self] (config) in
            
            self?.optionalFuncsCollectionView.hideSkeleton(transition: .crossDissolve(0.25))
            
            self?.selectedFuncs = config?.defaultSelectedFunctions ?? []
            self?.updateOptionalGroupFunctions()
            self?.refreshCollection()
        }
    }
}

extension MoreFuncScrollView {
    
    @objc private func refreshCollection() {
        
        selectedFuncsCollectionView.reloadData()
        optionalFuncsCollectionView.reloadData()
        selectedFuncsCollectionView.layoutIfNeeded()
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
            
            guard indexPath.item < selectedFuncs.count else {
                let undefineItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.undefine.rawValue, for: indexPath) as! UndefineFuncCell
                undefineItem.isHidden = false
                return undefineItem
            }
            
            if isEdit {
                let removeItem = collectionView.dequeueReusableCell(withReuseIdentifier: ReusedIdentifier.remove.rawValue, for: indexPath) as! RemoveFuncCell
                let function = selectedFuncs[indexPath.item]
                removeItem.functionLabel.text = function.functionName
                removeItem.functionImageView.image = UIImage(named: function.icon)
                removeItem.clickCallback = { [weak self] in
                    // MARK: 移除
                    self?.remove(function: function, selectedIndexPath: indexPath)
                }
                removeItem.isEditing = isEdit
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
                addItem.isEditing = isEdit
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

extension MoreFuncScrollView: UICollectionViewDelegateFlowLayout {
    
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
        if kind == UICollectionView.elementKindSectionFooter && collectionView == optionalFuncsCollectionView
            && ( optionalGroupFuncs.isEmpty == false && indexPath.section == optionalGroupFuncs.count - 1 ) {
            let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalFooter.rawValue, for: indexPath) as! OptionalSectionFooter
            return sectionFooter
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusedIdentifier.SupplementaryElement.optionalHeader.rawValue, for: indexPath) as! OptionalSectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == selectedFuncsCollectionView {
            return (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize
        }
        if collectionView == optionalFuncsCollectionView
            && ( optionalGroupFuncs.isEmpty == false && optionalGroupFuncs.count > section)
            && optionalGroupFuncs[section].groupData.isEmpty == false {
            return CGSize(width: bounds.width, height: 44)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == selectedFuncsCollectionView {
            return (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).footerReferenceSize
        }
        if collectionView == optionalFuncsCollectionView && optionalGroupFuncs.isEmpty == false && section == optionalGroupFuncs.count - 1 {
            return CGSize(width: collectionView.bounds.width, height: 80)
        }
        return .zero
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
            view.button?.setTitle("关闭", for: .normal)
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            SwiftMessages.show(view: view)
            return
        }
        guard selectedFuncs.contains(function) == false else { return }
        selectedFuncs.append(function)
        
        /// 添加动画
        if let optionalCell = optionalFuncsCollectionView.cellForItem(at: opIndexPath) as? AddFuncCell {
            
            /// 在镜像中隐藏掉添加按钮 && 防止连续点击
            optionalCell.isEditing = false
            
            if let snapCell = optionalCell.snapshotView(afterScreenUpdates: true) {
                
                let sourceRect = optionalCell.convert(optionalCell.bounds, to: self)
                let destinationIndexPath = IndexPath(item: selectedFuncs.count - 1, section: 0)
                if let destinationCell = selectedFuncsCollectionView.cellForItem(at: destinationIndexPath) {
                    destinationCell.isHidden = true
                    let destinationRect = destinationCell.convert(destinationCell.bounds, to: self)
                    
                    addSubview(snapCell)
                    let spring = CASpringAnimation(keyPath: "position")
                    spring.damping = 80
                    spring.stiffness = 120
                    spring.mass = 2
                    spring.initialVelocity = 10
                    spring.isRemovedOnCompletion = false
                    spring.fillMode = .forwards
                    spring.fromValue = CGPoint(x: sourceRect.origin.x + 0.5 * optionalCell.bounds.width, y: sourceRect.origin.y + 0.5 * optionalCell.bounds.height)
                    spring.toValue = CGPoint(x: destinationRect.origin.x + 0.5 * destinationCell.bounds.width, y: destinationRect.origin.y + 0.5 * destinationCell.bounds.height)
                    spring.duration = spring.settlingDuration
                    
                    snapCell.layer.add(spring, forKey: "springAnimation")
                    
                    snapCell.perform(#selector(removeFromSuperview), with: nil, afterDelay: spring.duration)
                    
                    selectedFuncsCollectionView.perform(#selector(UICollectionView.reloadData), with: nil, afterDelay: spring.duration)
                    updateOptionalGroupFunctions()
                    perform(#selector(self.refreshCollection), with: nil, afterDelay: spring.duration)
                    return
                }
            }
        }
        updateOptionalGroupFunctions()
        refreshCollection()
    }
    
    private func remove(function: FunctionModel, selectedIndexPath selIndexPath: IndexPath) {
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

extension MoreFuncScrollView {
    
    @objc private func targetForSelectedFuncCollectionView(longPressGesture gesture: UILongPressGestureRecognizer) {
        
        if isEdit == false { isEdit = true }
        
        switch gesture.state {
        case .began:
            let location = gesture.location(in: selectedFuncsCollectionView)
            guard let indexPath = selectedFuncsCollectionView.indexPathForItem(at: location) else { return }
            currentIndexPath = indexPath
            sourceIndexPath = indexPath
            let targetCell = selectedFuncsCollectionView.cellForItem(at: currentIndexPath!)
            guard let snap = targetCell?.snapshotView(afterScreenUpdates: true) else { return }
            snapView = snap
            targetCell?.isHidden = true
            selectedFuncsCollectionView.addSubview(snapView!)
            snapView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            snapView?.center = targetCell?.center ?? .zero
        case .changed:
            let location = gesture.location(in: selectedFuncsCollectionView)
            snapView?.center = location
            if let indexPath = selectedFuncsCollectionView.indexPathForItem(at: location),
               let current = currentIndexPath,
               current.section == indexPath.section {
                selectedFuncsCollectionView.moveItem(at: current, to: indexPath)
                currentIndexPath = indexPath
            }
        case .ended:
            guard currentIndexPath != nil else { return }
            let sourceCell = selectedFuncsCollectionView.cellForItem(at: currentIndexPath!)
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.snapView?.center = sourceCell?.center ?? .zero
            } completion: { [weak self] (finished) in
                self?.change(sourceIndexPath: self?.sourceIndexPath, toIndexPath: self?.currentIndexPath)
                self?.snapView?.removeFromSuperview()
                sourceCell?.isHidden = false
                self?.snapView = nil
                self?.currentIndexPath = nil
                self?.sourceIndexPath = nil
                self?.selectedFuncsCollectionView.reloadData()
            }
        default: break
        }
    }
    
    private func change(sourceIndexPath: IndexPath?, toIndexPath: IndexPath?) {
        
        guard let source = sourceIndexPath, let destination = toIndexPath, source.item != destination.item else { return }
        guard source.item < selectedFuncs.count, destination.item < selectedFuncs.count else { return }
        let offset = abs(source.item - destination.item)
        if offset == 1 {
            print("相邻交换, source: \(source.item) destination: \(destination.item)")
            selectedFuncs.swapAt(source.item, destination.item)
        } else {
            print("非相邻调整: \(source.item) destination: \(destination.item)")
            let sourceItem = selectedFuncs.remove(at: source.item)
            if destination.item >= selectedFuncs.count {
                selectedFuncs.append(sourceItem)
            } else {
                selectedFuncs.insert(sourceItem, at: destination.item)
            }
        }
    }
}

extension MoreFuncScrollView: SkeletonCollectionViewDataSource {
   
    func numSections(in collectionSkeletonView: UICollectionView) -> Int { 2 }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 10 }
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? { ReusedIdentifier.SupplementaryElement.optionalHeader.rawValue }
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier { ReusedIdentifier.undefine.rawValue }
}
