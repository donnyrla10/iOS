//
//  StarViewController.swift
//  MyDiary
//
//  Created by 김영선 on 2021/12/21.
//

import UIKit

//즐겨찾기 탭에 즐겨찾기한 일기만 콜렉션뷰에 나오도록 표시
class StarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        //여기서 수정notification, 즐겨찾기 notification, 삭제 notification 모두 observing되도록!
        self.loadStarDiaryList()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
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
    
    //데이터 동기화되면 불러오는 시점을 viewDidLoad로 변경함!
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.loadStarDiaryList() //이 시점에 이 메소드 호출! 이동될 때마다 즐겨찾기된 일기 불러옴
//    }
    
    private func configureCollectionView(){
        //코드로 콜렉션뷰 레이아웃 구성 -> UICollectionViewFlowLayout() 객체
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //userDefaults에 저장된 일기 리스트 가져온다. 즐겨찾기된 일기만
    private func loadStarDiaryList(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else {return} //일기장 리스트 가져올 것! Any타입으로 리턴되므로 딕셔너리 배열로 타입캐스팅
        self.diaryList = data.compactMap{
            guard let uuidString = $0["uuidString"] as? String else {return nil}
            guard let title = $0["title"] as? String else {return nil}
            guard let contents = $0["contents"] as? String else {return nil}
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        }.filter({                      //필터 함수를 통해 즐겨찾기된 일기만 가져온다
            $0.isStar == true
        }).sorted(by:{                  //날짜 최신순으로 정렬
            $0.date.compare($1.date) == .orderedDescending
        })
//        self.collectionView.reloadData() -> viewDidLoad로 변경했으므로
    }
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd(EE)"
//        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else {return}
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == diary.uuidString}) else {return}

        self.diaryList[index] = diary //수정된 내용 대입
        self.diaryList = self.diaryList.sorted(by:{
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    
    @objc func starDiaryNotification(_ notification: Notification){
        guard let starDiary = notification.object as? [String: Any] else {return}
        guard let diary = starDiary["diary"] as? Diary else {return}
        guard let isStar = starDiary["isStar"] as? Bool else {return}
        guard let uuidString = starDiary["uuidString"] as? String else {return}
//        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else {return} //이 부분은 즐겨찾기를 했을 때, 즐겨찾기 화면에 일기가 추가되지 않을 수 있음. 리턴할게 없으면 return을 통해 함수가 조기종료. 그러므로 삭제(즐겨찾기 해제) 될때만 실행되도록!

        if isStar{
            self.diaryList.append(diary)
            self.diaryList = self.diaryList.sorted(by:{
                $0.date.compare($1.date) == .orderedDescending
            })
            self.collectionView.reloadData()
        }else{ //만약 즐겨찾기 해제하면, 삭제되어야 함
            guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else {return}
            self.diaryList.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification){
        guard let uuidString = notification.object as? String else {return}
        guard let index = self.diaryList.firstIndex(where: {$0.uuidString == uuidString}) else {return}

        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
}

extension StarViewController:UICollectionViewDataSource{
    //즐겨찾기된 일기 리스트 배열 개수만큼 셀 표시되도록 구현할 것이므로 개수 리턴
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else {return UICollectionViewCell()}
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

extension StarViewController:UICollectionViewDelegateFlowLayout{
    //즐쳐찾기한 일기들은 리스트형식으로 보여줄 것이기 때문에!
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width-20, height: 80)
    }
}

extension StarViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else {return}
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
