//
//  ViewController.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func targetForPushButton(_ sender: UIButton) {
        navigationController?.pushViewController(MoreFuncController(), animated: true)
    }
    
}

