//
//  WriteDiaryViewController.swift
//  MyDiary
//
//  Created by 김영선 on 2021/12/21.
//

import UIKit

//delegate를 통해 일기장 리스트 화면에 작성된 일기 객체 전달!
protocol WriteDiaryViewDelegate: AnyObject{
    //메소드에 일기가 작성된 다이어리 객체를 전달할 것
    func didSelectRegister(diary: Diary)
}

//열거형 정의
enum DiaryEditorMode{
    case new
    case edit(IndexPath, Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var registerButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate : Date? //datePicker에서 선택된 날짜 저장 프로퍼티
    weak var delegate: WriteDiaryViewDelegate?
    
    //DiaryEditorMode 저장하는 프로퍼티 선언
    //-> 수정할 다이어리 객체 전달
    var diaryEditorMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView() //contentsTextView 테두리 생성
        self.configureDatePicker()       //dateTextField에 datePicker 추가
        self.configureInputField()
        self.configureEditMode()
        self.registerButton.isEnabled = false
    }
    
    //registerbutton 누르면, 일기 객체를 생성하고 delegate애 정의한 didSelectRegister 메소드 호출
    //메소드 파라미터에 생성된 일기 객체 전달
    @IBAction func tabRegisterButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else{return}
        guard let content = self.contentsTextView.text else{return}
        guard let date = self.diaryDate else{return}
//        let diary = Diary(title: title, contents: content, date: date, isStar: false)
        
        //notification center
        switch self.diaryEditorMode{
        case .new:
            //일기 등록 행위
            let diary = Diary(
                uuidString: UUID().uuidString, //일기를 생성할 때마다 uuidString 프로퍼티에 일기 특정할 수 있는 uuid 값이 생성된다.
                title: title,
                contents: content,
                date: date,
                isStar: false)
            self.delegate?.didSelectRegister(diary: diary)
        case let .edit(indexPath, diary):
            let diary = Diary(
                uuidString: diary.uuidString,
                title: title,
                contents: content,
                date: date,
                isStar: diary.isStar)

            //일기 수정 행위
            //post 메소드를 통해 수정된 일기 객체 전달
            NotificationCenter.default.post(
                name: Notification.Name("editDiary"),
                object: diary,
                userInfo: nil
//                userInfo: [
//                    "indexPath.row": indexPath.row
//                ]
            )
        }
//        self.delegate?.didSelectRegister(diary: diary)
        
        //전 화면으로 이동
        self.navigationController?.popViewController(animated: true)
    }
    
    //contentsTextView의 테두리 만들어주는 함수 (ContentsTextView 설정)
    private func configureContentsTextView(){
        //UIColor 객체 사용
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        
        //layer관련 색상 설정할 때는 UIColor가 아닌 cgColor 사용!
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    //dateTextField에 datePicker 나오도록!
    private func configureDatePicker(){
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        
        //UIController 객체가 이벤트에 응답하는 방식으로 설정해주는 메소드
        //1: 타겟 설정, 해당 뷰컨트롤러에서 처리를 할것이므로 self
        //2: 이벤트 발생 시, 호출될 메소드
        //3: 이벤트 발생시, 액션에 정의한 메소드 호출할지 설정
        //-> .valueChanged: 값이 변경될 때 2번 메소드 호출되도록!
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        //self.datePicker.locale = Locale(identifier: "ko_KR")                 //한국어로 변환
        
        //->DatePicker의 값이 바뀔 때마다 datePickerValueDidChange 메소드 호출
        //메소드 파라미터를 통해 변경된 datePicker의 상태를 UIDatePicker로 전달
        
        //이렇게 되면, dateTextField를 선택하게 되면 키보드가 아니라 datePicker가 표시
        self.dateTextField.inputView = self.datePicker
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker){
        //DateFormatter 객체: 날짜와 텍스트 반환
        //date type <-> string type
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd(EE)"
//        formatter.locale = Locale(identifier: "ko_KR")                          //한국어로 변환
        self.diaryDate = datePicker.date                                        //datePicker에서 선택한 date타입 저장
        self.dateTextField.text = formatter.string(from: datePicker.date)       //dateTextField text에 date를 formatter에 지정한 문자열로 변환
        
        //날짜 변경될 때마다 editingChanged 액션을 발생시켜서 dateTextFieldDidChange 함수 호출
        //-> date는 키보드가 아니라 datePicker로 변경되기 때문에, 값이 입력되어도 dateTextFieldDidChange 메소드 호출 안됨
        //-> 변경마다 editChanged 액션 발생시켜서 dateTextFieldDidChange 메소드 호출
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    //유저가 화면을 터치하면 호출되는 메소드!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //빈 화면을 누를 때마다 키보드나 datePicker 사라짐
    }
    
    private func configureInputField(){
        self.contentsTextView.delegate = self
        //textField에 내용이 입력될 때마다 titleTextFieldDidChange() 호출
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField){
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField){
        self.validateInputField()
    }
    
    //Register Button 활성화 여부 판단 메소드
    private func validateInputField(){
        //titletextField && dateTextField && contentsTextField에 내용이 비어있지 않으면 활성화
        self.registerButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
    
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd(EE)"
//        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    //연관값으로 전달받은 객체를 writeDiaryViewController에 textfield, textview에 표시
    private func configureEditMode(){
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.contentsTextView.text = diary.contents
            self.diaryDate = diary.date
            self.registerButton.title = "수정" //버튼 이름 변경
        default:
            break
        }
    }
}

extension WriteDiaryViewController: UITextViewDelegate{
    //TextView에 텍스트 입력될 때마다 호출되는 메소드
    //-> 등록 버튼 활성화 여부 판단
    func textViewDidChange(_ textView: UITextView) {
        self.validateInputField()
    }
}
