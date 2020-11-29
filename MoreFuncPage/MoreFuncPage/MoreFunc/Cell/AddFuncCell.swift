//
//  AddFuncCell.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import UIKit

class AddFuncCell: UICollectionViewCell {
    
    var clickCallback: (() -> Void)?
    
    @IBOutlet weak var addFunctionButton: UIButton!
    @IBOutlet weak var functionImageView: UIImageView!
    @IBOutlet weak var functionLabel: UILabel!
    
}


extension AddFuncCell {
    
    @IBAction func targetForAdd(_ sender: UIButton) {
        guard let callback = clickCallback else { return }
        callback()
    }
}
