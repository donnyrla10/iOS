//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 김영선 on 2022/05/15.
//

import Foundation

//Model 부분으로, 계산하는 곳

class CalculatorBrain{
    private var accumulator = 0.0
    
    private var operations : Dictionary<String, Operation> = [
        "+/-" : Operation.UnaryOperation({ -$0 }),
        "%" : Operation.UnaryOperation({ $0 * 0.01}),
        "x" : Operation.BinaryOperation({ $0 * $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo{
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double //들어가있는 값
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double{
        get {
            return accumulator
        }
    }
}
