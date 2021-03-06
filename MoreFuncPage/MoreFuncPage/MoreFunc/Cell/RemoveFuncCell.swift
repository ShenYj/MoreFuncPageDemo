//
//  RemoveFuncCell.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import UIKit

class RemoveFuncCell: UICollectionViewCell {
    
    var clickCallback: (() -> Void)?
    var isEditing: Bool = true {
        didSet {
            if isEditing {
                removeButton.isHidden = false
            } else {
                removeButton.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var functionImageView: UIImageView!
}

extension RemoveFuncCell {
    
    @IBAction func targetForRemove(_ sender: UIButton) {
        guard let callback = clickCallback else { return }
        callback()
    }
}

