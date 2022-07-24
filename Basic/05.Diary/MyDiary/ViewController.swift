//
//  ViewController.swift
//  MyDiary
//
//  Created by 김영선 on 2021/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //collection view 구성 -> Diary 타입 배열
    //diaryList 프로퍼티를 프로퍼티 옵져버로 만든다.
    private var diaryList = [Diary](){
        //diaryList 배열에 일기가 추가되거나 변경이 일어날 때마다 useDefaults에 저장된다.
        didSet{
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        //수정된 화면으로 로드
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"), //editDiary notification 관찰
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteDiaryNotification(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil)
    }
    
    @objc func starDiaryNotification(_ notification: Notification){
        guard let starDiary = notification.object as? [String: Any] else {return}
        guard let isStar = starDiary["isStar"] as? Bool else {return}
//        guard let indexPath = starDiary["indexPath"] as? IndexPath else {return}
        guard let uuidString = starDiary["uuidString"] as? String else {return}
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else {return}
        self.diaryList[index].isStar = isStar //즐겨찾기 여부 업데이트

    }
    
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else {return} //전달받은 일기 객체 가져옴
//        guard let row = notification.userInfo?["indexPath.row"] as? Int else {return}
        
        //전달받은 uuidString 값이 있는지 확인하고 업데이트 되도록
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == diary.uuidString}) else {return}
        self.diaryList[index] = diary //해당 배열 객체 원소를 수정된 일기 객체로
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending //날짜수정될 수 있으므로 날짜순(최신순)으로 정렬
        })
        self.collectionView.reloadData()
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification){
//        guard let indexPath = notification.object as? IndexPath else {return}
        guard let uuidString = notification.object as? String else {return}
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else {return}
        self.diaryList.remove(at: index) //전달받은 indexPath의 row 값 삭제
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)]) //collectionview에 일기가 삭제되도록
    }
    
    //일기를 userDefualt에 dictionary 형태로 저장
    private func saveDiaryList(){
        let date = self.diaryList.map{
            [
                "uuidString": $0.uuidString,
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        //userDefaults에 접근할 수 있도록
        let userDefaults = UserDefaults.standard
        //1번: 일기가 저장된 date, 2번: key 이름 설정
        userDefaults.set(date, forKey: "diaryList")
    }
    
    //userDefaults에서 일기 불러오기
    private func loadDiaryList(){
        let userDefaults = UserDefaults.standard
        //일기리스트 가져오기 -> object 메소드는 Any 타입으로 리턴되므로 dictionary 배열 형태로 타입캐스팅
        //실패하면 nil 되므로 guard로 옵셔널 바인딩
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else {return}
        
        //불러온 데이터를 diaryList에 넣어줘야 한다.
        self.diaryList = data.compactMap{
            //축약 타입으로 딕셔너리에 접근
            guard let uuidString = $0["uuidString"] as? String else {return nil}
            guard let title = $0["title"] as? String else {return nil}
            guard let contents = $0["contents"] as? String else {return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            guard let date = $0["date"] as? Date else {return nil}
            
            //Diary 타입되도록 객체화
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        }
        
        //일기장을 최신순으로 불러오자
        self.diaryList = self.diaryList.sorted(by: {
            //왼쪽 일기의 날짜값과 오른쪽 일기의 날짜값 비교
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    
    //collectionview 속성 정의 메소드
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        //collectionview에 표시되는 컨텐츠의 상하좌우 간격 10 설정
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //segueway로 이동되는 viewController가 뭔지 알 수 있도록!
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController{
            writeDiaryViewController.delegate = self
        }
    }
    
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd(EE)"
//        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

//collectionview에서 datasource는 콜렉션 뷰로 보여주는 컨텐츠 관리 객체
extension ViewController: UICollectionViewDataSource{
    //지정된 섹션에 표시할 셀의 개수 (다이어리 리스트 배열의 개수만큼)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    //collectionview에 지정된 위치에 표시할 셀 요청
    //테이블뷰 구성의 cellForRowAt 메소드와 동일
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //DiaryCell로 다운캐스팅하고 만약 실패하면 빈 UICollectionViewCell 반환
        //ReusabledCell을 사용하면 withReuseIdentifier 파라미터로 전달받은 식별자를 통해 재사용 가능 셀 찾고 이를 반환
        //재사용 셀을 가져오게 되면 이 셀에 일기 제목과 날짜 표시!
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else {return UICollectionViewCell()}
        
        //배열에 저장된 값을 가져옴
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        
        //date타입이므로 문자열로 변환
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    //셀 사이즈 설정 -> 행간 셀 2개
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width/2)-20, height: 200)
    }
}

extension ViewController: WriteDiaryViewDelegate{
    func didSelectRegister(diary: Diary) {
        //작성화면에서 일기 등록될 대마다 일기 배열에 일기 추가!
        self.diaryList.append(diary)
        //일기 리스트 배열에 일기 추가될 때마다 collectionview reload -> 일기 리스트 표시
        self.collectionView.reloadData()
    }
}

//일기장 리스트 화면에서 일기를 선택했을 때, 일기장 상세화면으로 이동
extension ViewController: UICollectionViewDelegate{
    //특정 셀이 선택되었음을 알리는 메소드
    //diaryDetailViewController가 표시되도록 구현
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //스토리보드에 있는 뷰컨트롤러를 객체화
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else {return}
        
        //선택된 행이 뭔지 대입
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
//        viewController.delegate = self
        
        //일기장 상세 화면 푸시
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//extension ViewController:DiaryDetailViewDelegate{
//    func didSelectDelete(indexPath: IndexPath) {
//        self.diaryList.remove(at: indexPath.row) //전달받은 indexPath의 row 값 삭제
//        self.collectionView.deleteItems(at: [indexPath]) //collectionview에 일기가 삭제되도록
//    }
//    //파라미터로 전달된 즐겨찾기 여부를 일기 리스트 배열에 업데이트
//    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
//        self.diaryList[indexPath.row].isStar = isStar //즐겨찾기 여부 업데이트
//    }
//}
