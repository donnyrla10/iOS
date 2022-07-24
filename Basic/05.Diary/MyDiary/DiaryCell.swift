//
//  DiaryCell.swift
//  MyDiary
//
//  Created by 김영선 on 2021/12/21.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //UIView가 스토리보드에서 생성될 때, 이 생성자를 통해 객체 생성
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //셀 테두리 그림
        self.contentView.layer.cornerRadius = 4.0
        self.contentView.layer.borderWidth = 0.8
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
