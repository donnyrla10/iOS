//
//  ViewController.swift
//  MyToDoList
//
//  Created by 김영선 on 2022/01/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task](){
        didSet{ //Tasks 배열에 할일(task)가 추가되면 바로 saveTasks()로 할일을 저장한다.
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tabDoneButton))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    
    @objc func tabDoneButton(){
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    
    //edit 버튼 누르면 editing 모드로 넘어가기
    @IBAction func tabEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else {return} //비어있으면 return
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tabAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "✏️TODOLIST", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else {return} //title에 textField의 text 넣기
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "할 일을 적어주세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveTasks(){
        let data = self.tasks.map{ //할일을 dictionary 형태로 변한
            [
                "title": $0.title,
                "done" : $0.done
            ]
        }
        let userDefault = UserDefaults.standard
        userDefault.set(data, forKey: "tasks") //key-value 쌍으로 userDefault에 저장
    }
    
    func loadTasks(){
        let userDefault = UserDefaults.standard
        guard let data = userDefault.object(forKey: "tasks") as? [[String: Any]] else {return}
        
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else {return nil}
            guard let done = $0["done"] as? Bool else {return nil}
            return Task(title: title, done: done)
        }
    }
}


extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        //cell에 check 표시
        if task.done{ //done == true  -> checkmark
            cell.accessoryType = .checkmark
        }else{        //done == false -> none
            cell.accessoryType = .none
        }
        return cell
    }
    
    //삭제-버튼 누르면 삭제됨
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty{ //만약 할일이 없다면, 편집모드에서 빠져나오도록!
            self.tabDoneButton()
        }
    }
    
    //셀 움직일 수 있도록 하기
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //셀 움직이기
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row] //현재 셀의 task를 task에 넣기
        tasks.remove(at: sourceIndexPath.row) //옮길 task를 tasks에서 삭제하기
        tasks.insert(task, at: destinationIndexPath.row) //task를 원하는 위치(목적지)에 삽입해주기
        self.tasks = tasks //덮어씌우기
    }
    
    
}

extension ViewController:UITableViewDelegate{
    //cell을 선택했을 때, 어떤 cell을 선택했는지 알려주는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택된 셀의 task 가져오기
        var task = self.tasks[indexPath.row]
        //만약 task done = true <-> false
        task.done = !task.done
        //덮어씌우기
        self.tasks[indexPath.row] = task
        //reload
        self.tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
}
