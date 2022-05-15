//
//  ViewController.swift
//  Calculator
//
//  Created by 김영선 on 2021/11/10.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    private var userIsInTheMiddleOfTyping = false

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if textCurrentlyInDisplay.count < 9 { //9글자 초과되면 더 이상 추가되지 않음
                display.text = textCurrentlyInDisplay + digit
            }
        }else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        displayValue = 0
        userIsInTheMiddleOfTyping = false
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func touchOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{ //사용자 입력중인 상태라면
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    @IBAction func touchDot(_ sender: UIButton) {
        var textCurrently = display.text!
        if textCurrently.count < 8, !textCurrently.contains("."){
            textCurrently += textCurrently.isEmpty ? "0." : "."
            display.text = textCurrently
        }
    }
    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }set{
            if newValue.truncatingRemainder(dividingBy: 1) == 0{ //1로 나눈 값이 0이라면 result값에 int로 변환
                display.text = "\(Int(newValue))"
            }else{
                display.text = String(newValue)
            }
        }
    }
    
}
