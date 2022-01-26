//
//  ViewController.swift
//  MyPomodoro
//
//  Created by 김영선 on 2022/01/26.
//

import UIKit
import AudioToolbox

enum TimeState{
    case start, end, pause
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var timeState : TimeState? = .end //TimeState 타입으로 선언(초기상태 = .end)
    var duration = 60  //초기 상태: 60(sec)
    var timer : DispatchSourceTimer?//timer 객체 생성
    var currentSec = 0    // 현재 카운트 수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStartButton()
    }
    
    func setTimerInforViewVisible(state: Bool){
        self.timeLabel.isHidden = state
        self.progressView.isHidden = state
    }
    
    func configureStartButton(){
        self.startButton.setTitle("시작", for: .normal)
        self.startButton.setTitle("일시정지", for: .selected)
    }
    
    func startTimer(){
        //timer 객체 만들기
        if self.timer == nil{ //시작 전인 상태
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            //카운트 다운
            self.timer?.setEventHandler(handler: { [weak self]  in
                guard let self = self else {return}
                self.currentSec -= 1 //1초씩 뺌
                let hour = self.currentSec/3600
                let minute = (self.currentSec%3600)/60
                let second = (self.currentSec%3600)%60
                
                self.timeLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)
                self.progressView.progress = Float(self.currentSec)/Float(self.duration)
                
                UIView.animate(withDuration: 1.1, delay: 0.0, animations: {
                    self.imageView.transform = CGAffineTransform(translationX: 80, y: 0)
                })
                UIView.animate(withDuration: 1.1, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(translationX: -80, y: 0)
                })
                
                if self.currentSec <= 0 {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                }
            })
        }
        self.timer?.resume()
    }
    
    func stopTimer(){
        if self.timeState == .pause{
            self.timer?.resume()
        }
        self.timeState = .end
        self.startButton.isSelected = false //초기화 -> "시작"버튼
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timeLabel.alpha = 0        //사라짐
            self.datePicker.alpha = 1       //나타남
            self.progressView.alpha = 0     //사라짐
        })
        self.timer?.cancel()
        self.timer = nil //timer 객체 해제 (중요)
    }

    @IBAction func tabStartButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)

        switch self.timeState {
        case .end: //기본 상태라면, 시작버튼을 누르면 타이머 시작
            self.currentSec = self.duration
            self.timeState = .start
            self.startButton.isSelected = true              //startButton -> selected -> "일시정지"
            UIView.animate(withDuration: 0.5, animations: {
                self.timeLabel.alpha = 1        //사라짐
                self.datePicker.alpha = 0       //나타남
                self.progressView.alpha = 1     //사라짐
            })
            self.cancelButton.isEnabled = true              //cancelButton enabled
            //self.startButton.backgroundColor = UIColor.white
            self.startTimer()
        case .start: //시작된 상태, 시작버튼을 누르면 일시정지
            self.timeState = .pause
            self.startButton.isSelected = false             //startButton -> unselected -> "시작"
            self.timer?.suspend()
        case .pause: //일기정지된 상태, 일시정지버튼 누르면 이어서 시작
            self.timeState = .start
            self.startButton.isSelected = true              //startButton -> unselected -> "일시정지"
            self.startButton.backgroundColor = UIColor.white
            self.timer?.resume()
        default:
            break
        }
    }
    
    @IBAction func tabCancelButton(_ sender: UIButton) {
        switch self.timeState {
        case .start, .pause:
            self.stopTimer()
            self.imageView.transform = .identity
        default:
            break
        }
    }
}

