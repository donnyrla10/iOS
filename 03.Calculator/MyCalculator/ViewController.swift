//
//  ViewController.swift
//  MyCalculator
//
//  Created by 김영선 on 2022/01/10.
//

import UIKit

enum Operation{
    case add
    case subtract
    case divide
    case multiply
    case unknown //아무 연산자도 없음 = default
}

class ViewController: UIViewController {

    @IBOutlet var numberOutputLabel: UILabel!
    
    var displayNumber = ""                   //string -> numberOutputLabel에 display될 텍스트n
    var firstOperand = ""                    //string -> 첫번째 피연산자
    var secondOperand = ""                   //string -> 두번째 피연산자
    var result = ""                          //string -> 결과값 저장할 프로퍼티
    var curOperation : Operation = .unknown  //Operation -> default=  .unknown
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tabNumberButton(_ sender: UIButton) {
        //눌린 버튼의 타이틀을 가져와 numberValue 프로퍼티에 넣어준다.
        guard let numberValue = sender.title(for: .normal) else {return} //optional binding
        
        //9글자까지만 입력받을 수 있도록 한다.
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue //displayNumber 변수에 numberValue 값을 넣어준다.
            self.numberOutputLabel.text = displayNumber //numberOutputLabel에 displayNumber값을 넣어준다.
        }
    }
    
    @IBAction func tabSignButton(_ sender: UIButton) {
    }
    
    @IBAction func tabClearButton(_ sender: UIButton) { //계산값 초기화
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.curOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tabDotButton(_ sender: UIButton) {
        if self.displayNumber.count < 8, !self.displayNumber.contains("."){ //8글자아래고 .을 포함하지 않았다면
            self.displayNumber += displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tabPercentButton(_ sender: UIButton) { //퍼센트를 알 수 있는 연산
        guard let displayNumber = Double(self.displayNumber) else {return}
        if !self.displayNumber.isEmpty{
            self.displayNumber = "\(displayNumber * 0.01)"
            self.firstOperand = self.displayNumber
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tabAddButton(_ sender: UIButton) {
        self.operation(.add)
    }
    
    @IBAction func tabSubtractButton(_ sender: UIButton) {
        self.operation(.subtract)
    }
    
    @IBAction func tabMultiplyButton(_ sender: UIButton) {
        self.operation(.multiply)
    }
    
    @IBAction func tabDivideButton(_ sender: UIButton) {
        self.operation(.divide)
    }
    
    @IBAction func tabEqualButton(_ sender: UIButton) {
        self.operation(self.curOperation)
    }
    
    func operation(_ operation: Operation){ //parameter로 연산자가 들어온다.
        if self.curOperation != .unknown{   //operation == .add || .sub || .mul || .div
            //if displayNumber is not empty
            if !self.displayNumber.isEmpty{
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand) else {return}     //string -> double로 변경!
                guard let secondOperand = Double(self.secondOperand) else {return}
                
                //각 연산자 마다 계산 구현
                switch self.curOperation{
                case .add:
                    self.result = "\(firstOperand + secondOperand)"
                case .subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .multiply:
                    self.result = "\(firstOperand * secondOperand)"
                case .divide:
                    self.result = "\(firstOperand / secondOperand)"
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            self.curOperation = operation
        }else{ //operation == .unknown 이라면 (연산자가 없는 상태)
            self.firstOperand = self.displayNumber
            self.curOperation = operation
            self.displayNumber = ""
        }
    }
}

