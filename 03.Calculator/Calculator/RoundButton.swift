//
//  RoundButton.swift
//  Calculator
//
//  Created by 김영선 on 2021/11/10.
//

import UIKit

class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet{
            if isRound{
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}



//RoundButton을 사용하는 버튼들은
//storyboard 상에서 isRound = true 로 변경시켜주면
//버튼들이 동그랗게 변한다!

//custom button
//변경된 설정값을 storyboard상에 실시간으로 확인할 수 있도록 @IBDesignable 붙인다
//@IBInspectable 키워드를 붙여서 storyboard에서도 isRound 속성의 값을 변경시킬 수 있도록 한다.
//연산 프로퍼티로 만듦
//버튼의 높이를 2로 나눈 값으로 설정하면 정사각형 버튼이 원이 되고
//정사각형이 아닌 버튼은 모서리가 둥글게 변한다.
