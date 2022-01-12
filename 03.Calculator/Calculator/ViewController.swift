//
//  ViewController.swift
//  Calculator
//
//  Created by 김영선 on 2021/11/10.
//

import UIKit

enum Operation{
    case Add
    case Subtract
    case Divide
    case Multiply
    case unknown //아무 연산자도 아님
}

class ViewController: UIViewController {

    @IBOutlet var numberOutputLabel: UILabel!
    
    var displayNumber = "" //계산기 버튼을 누를 때마다 numberOutputLabel의 수를 가지고 있는 변수
    var firstOperand = ""  //이전 계산값을 저장하는 피연산자
    var secondOperand = "" //새롭게 입력된 값을 저장하는 피연산자
    var result = ""         //계산의 결과값 저장 변수
    var currentOperation: Operation = .unknown //현재 계산기에 어떤 연산자가 입력되었는지 연산자 값을 저장하는 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tabNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.title(for: .normal) else {return}
        //선택한 버튼의 title 값을 가져오겠다! title이 숫자로 되어 있어서 선택한 숫자값이 리턴되는데
        //optional 이므로 guard문으로 optional binding 해주자
        
        if self.displayNumber.count < 9{
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
        //선택된 숫자값을 displayNumber 변수에 문자열로 계속 추가시켜줄 것임. 9자리까지
    }
    
    @IBAction func tabClearButton(_ sender: UIButton) {
        //모든 변수를 초기값으로 초기화
        //numberOutputLabel = 0
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tabSignButton(_ sender: UIButton) {
    }
    
    @IBAction func tabPercentageButton(_ sender: UIButton) {
        if !self.displayNumber.isEmpty{
            guard let number = Double(self.displayNumber) else {return}
            self.result = "\(number * 0.01)"
            if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                self.result = "\(Int(result))"
            }
            self.numberOutputLabel.text = self.result
        }
    }
    
    
    @IBAction func tabDotButton(_ sender: UIButton) {
        //숫자를 8자리까지 입력하고 소수점을 선택하고 또 숫자를 선택하게 되면 소수점포함 10자리가 표시되기 때문에
        //소수점 포함 9자리까지 표시되도록 예외 처리
        //&& 소수점이 중복으로 찍히면 안되므로 -> "."이 포함되지 않으면
        if self.displayNumber.count < 8, !self.displayNumber.contains("."){
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            //삼항 연산자를 사용해서, 소수점을 눌렀는데 displayNumber가 비어있으면 "0." 표시되고 아니면 "." 표시되도록
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tabDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tabMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)

    }
    
    @IBAction func tabSubstractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tabAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tabEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation){
        if self.currentOperation != .unknown{
            if !self.displayNumber.isEmpty{  //displayNumber가 비어있지 않으면
                self.secondOperand = self.displayNumber //두번째 입력받은 값을 넣어준다.
                self.displayNumber = "" //결과값이 나와야 되니까 초기화시켜줌
                
                guard let firstOperand = Double(self.firstOperand) else {return}
                guard let secondOperand = Double(self.secondOperand) else {return}
                
                //첫번째 피연산자와 두번째 피연산자를 연산시켜주는 코드
                switch self.currentOperation{
                case .Add:
                    //결과값을 저장한느 result 변수에
                    self.result = "\(firstOperand + secondOperand)"
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                default:
                    break
                }
                
                //1로 나눈 나머지 값이 0이라면 resut값에 Int로 변환한 resut 값을 넣어준다
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0{
                    self.result = "\(Int(result))"
                }
                
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            //현재 함수 param으로 전달한 operation값을 currentOperation으로 저장
            self.currentOperation = operation
        }else{
            //계산기가 초기화된 상태에서 사용자가 첫번째 피연산자와 연산자를 선택한 상태
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
            //-> 3, + 버튼을 누르면 tabAddButton 액션 함수 안에서 oepration()호출되고 함수 param으로 .Add 열거형 값 전달
            //operation()함수 실행 -> else 구문 실행
            //firstOperation = 3
            //currentOperation = add 열거형값
            //displayNumber = "" -> 다음 피연산자를 누르면 그 새롭게 바뀐 숫자(8)가 나와야 되기 때문에 초기화시켜준 것임
        }
    }
}

