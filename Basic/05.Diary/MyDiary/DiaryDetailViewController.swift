//
//  DiaryDetailViewController.swift
//  MyDiary
//
//  Created by 김영선 on 2021/12/21.
//

import UIKit

//protocol DiaryDetailViewDelegate: AnyObject {
//    func didSelectDelete(indexPath: IndexPath)
////    func didSelectStar(indexPath: IndexPath, isStar: Bool)
//}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
//    weak var delegate : DiaryDetailViewDelegate?
    var starButton: UIBarButtonItem?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        //즐겨찾기 토글이 일어날 때, Observer를 통해 해당 셀렉터 메소드 호출
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification),
            name: NSNotification.Name("starDiary"),
            object: nil)
    }
    
    @objc func starDiaryNotification(_ notification: Notification){
        guard let stardiary = notification.object as? [String: Any] else {return}
        guard let isStar = stardiary["isStar"] as? Bool else {return}
        guard let uuidString = stardiary["uuidString"] as? String else {return}
        guard let diary = self.diary else {return}
        if diary.uuidString == uuidString { //전달받은 uuidString과 같다면
            self.diary?.isStar = isStar //isStar 업데이트
            self.configureView() //view update
        }
    }
    
    private func configureView(){
        guard let diary = self.diary else {return}
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tabStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star") //즐겨찾기가 되어 있으면 유저 이미지에 색칠별 표시
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    @objc func tabStarButton(){
        guard let isStar = self.diary?.isStar else {return}
//        guard let indexPath = self.indexPath else {return}
        
        if isStar{
            self.starButton?.image = UIImage(systemName: "star")
        }else{
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: [
                "diary" : self.diary, //즐겨찾기된 일기 객체를 notification에 전달
                "isStar" : self.diary?.isStar ?? false, //즐겨찾기 상태값 넣어줌
//                "indexPath" : indexPath
                "uuidString":diary?.uuidString
            ],
            userInfo: nil)
//        self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false) //즐겨찾기 상태 전달
    }
    
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd(EE)"
        return formatter.string(from: date)
    }
    
    //editDiary notification 메소드호출 -> 수정된 일기 객체를 전달받아서 view에 업데이트
    @objc func editDiaryNotification(_ notification: Notification){
        //post에서 보낸 수정된 일기 객체 가져오는 코드
        guard let diary = notification.object as? Diary else {return}
        //전달받은 수정된 일기 객체 대입
        self.diary = diary
        //수정된 일기 내용으로 뷰 업데이트
        self.configureView()
    }
    
    //modify 버튼 누르면 WirteDiaryViewController 화면 표시되도록!
    @IBAction func tabModifyButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else{ return }
        guard let indexPath = self.indexPath else {return}
        guard let diary = self.diary else {return}
        viewController.diaryEditorMode = .edit(indexPath, diary)
        //수정 버튼 누르면, writeDiaryViewController에 선언된 diaryEditMode에 선언된 열거형 edit 전달하고, 연관값으로 indexPath와 diary 값이 전달된다.
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
            )
            
        //1st: 어떤 객체에서 observing할지
        //2nd: notification을 관찰하고 있다가 이벤트가 발생하면 selector에 정의된 함수 호출
        //3rd: 어떤 notification 관찰할지 이름 넣어준다.
        
        self.navigationController?.pushViewController(viewController, animated: true) //수정 버튼 누르면 writeDiaryViewController로 이동(push)
    }
    
    //일기장 상세화면에서 삭제버튼을 누르면, 메소드를 통해 일기장 리스트 화면에 indexPath를 전달해서 🔥다이어리 리스트 배열🔥과 🔥콜렉션 뷰🔥에 일기장 삭제!
    @IBAction func tabDeleteButton(_ sender: UIButton) {
//        guard let indexPath = self.indexPath else {return}
        guard let uuidString = self.diary?.uuidString else {return}
//        self.delegate?.didSelectDelete(indexPath: indexPath)
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
//            object: indexPath,
            object: uuidString,
            userInfo: nil
        )
        self.navigationController?.popViewController(animated: true) //삭제버튼이 눌러지면 전 화면으로 이동(일기 리스트 화면)
    }
    
    //객체가 deinit 될 때,
    deinit{
        NotificationCenter.default.removeObserver(self) //해당 객체에 붙은 observer 모두 삭제
    }
}
