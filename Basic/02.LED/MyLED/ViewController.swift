//
//  ViewController.swift
//  MyLED
//
//  Created by nyeongExE on 2022/01/05.
//

import UIKit

class ViewController: UIViewController, MyLEDSettingDelegate {

    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentsLabel.textColor = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let settingViewController = segue.destination as? SettingViewController {
            settingViewController.delegate = self
            settingViewController.Text = self.contentsLabel.text
            settingViewController.textColor = self.contentsLabel.textColor
            settingViewController.backgroundColor = self.view.backgroundColor ?? .white
        }
    }
    
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor){
        if let text = text{
            self.contentsLabel.text = text
        }
        
        self.contentsLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
    }

}

