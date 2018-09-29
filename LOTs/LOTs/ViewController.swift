//
//  ViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import McPicker

class ViewController: UIViewController {

    @IBOutlet weak var mcTextField: McTextField!
    
    let data: [[String]] = [
        ["日式料理", "中式料理", "韓式料理", "台式料理", "美式料理", "義式料理"]
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let mcInputView = McPicker(data: data)

        // 彈跳起來的上方背景色
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        mcTextField.inputViewMcPicker = mcInputView
        
        mcTextField.doneHandler = { [weak mcTextField] (selections) in
            mcTextField?.text = selections[0]!
            print(mcTextField?.text)
        }
        
        mcTextField.selectionChangedHandler = { [weak mcTextField] (selections, componentThatChanged) in
            mcTextField?.text = selections[componentThatChanged]!
            print(mcTextField?.text)
        }
        mcTextField.cancelHandler = { [weak mcTextField] in
            mcTextField?.text = "Cancelled."
        }
        mcTextField.textFieldWillBeginEditingHandler = { [weak mcTextField] (selections) in
            if mcTextField?.text == "" {
                // Selections always default to the first value per component
                mcTextField?.text = selections[0]
            }
            
        }
        
    }
    
}
