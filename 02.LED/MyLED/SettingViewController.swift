//
//  SettingViewController.swift
//  MyLED
//
//  Created by 김영선 on 2022/01/06.
//

import UIKit

//delegate protocol 정의, 선언
protocol MyLEDSettingDelegate: AnyObject{
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) //vc에서 정리
}

class SettingViewController: UIViewController {

    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    
    weak var delegate: MyLEDSettingDelegate?
    
    var Text: String?
    var textColor: UIColor = .black
    var backgroundColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView(){
        if let Text = self.Text{
            self.text.text = Text
        }
        self.changeTextColorButton(color: self.textColor)
        self.changeBackgroundColorButton(color: self.backgroundColor)
    }

    private func changeTextColorButton(color: UIColor){
        self.yellowButton.alpha = color == UIColor.yellow ? 0.5: 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 0.5: 0.2
        self.greenButton.alpha = color == UIColor.green ? 0.5: 0.2
    }
    
    private func changeBackgroundColorButton(color: UIColor){
        self.blueButton.alpha = color == UIColor.blue ? 0.5: 0.2
        self.orangeButton.alpha = color == UIColor.orange ? 0.5: 0.2
        self.blackButton.alpha = color == UIColor.black ? 0.5: 0.2
    }
    
    
    @IBAction func tabTextColorButton(_ sender: UIButton) {
        if sender == yellowButton{
            self.textColor = UIColor(red: 255/255, green: 255/255, blue: 102/255, alpha: 1)
            self.changeTextColorButton(color: .yellow)
        }else if sender == purpleButton{
            self.textColor = UIColor(red: 153/255, green: 102/255, blue: 204/255, alpha: 0.7)
            self.changeTextColorButton(color: .purple)
        }else if sender == greenButton{
            self.textColor = UIColor(red: 051/255, green: 153/255, blue: 051/255, alpha: 0.7)
            self.changeTextColorButton(color: .green)
        }
    }
    
    @IBAction func tabBackgroundColorButton(_ sender: UIButton) {
        if sender == blueButton{
            self.backgroundColor = UIColor(red: 102/255, green: 153/255, blue: 204/255, alpha: 0.7)
            self.changeBackgroundColorButton(color: .blue)
        }else if sender == orangeButton{
            self.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 051/255, alpha: 1)
            self.changeBackgroundColorButton(color: .orange)
        }else if sender == blackButton{
            self.backgroundColor = UIColor(red: 051/255, green: 051/255, blue: 051/255, alpha: 1)
            self.changeBackgroundColorButton(color: .black)
        }
    }
    
    @IBAction func tabSaveButton(_ sender: UIButton) {
        self.delegate?.changedSetting(
            text: self.text.text,
            textColor: self.textColor,
            backgroundColor: self.backgroundColor
        )
        self.navigationController?.popViewController(animated: true) //이전 화면으로 이동
    }
    
}
