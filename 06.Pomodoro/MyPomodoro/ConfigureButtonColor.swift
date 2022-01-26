//
//  ConfigureButtonColor.swift
//  MyPomodoro
//
//  Created by 김영선 on 2022/01/26.
//

import UIKit

class ConfigureButtonColor: UIButton {

    override var isSelected: Bool{
        didSet {
            if isSelected {
                self.backgroundColor = UIColor.white
            }
        }
    }
}
