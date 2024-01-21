//
//  TodoListViewController.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 11/26/23.
//

import UIKit
import SnapKit

final class TodoListViewController: UIViewController {
    private let todoManager = TodoManager.shared
    
    var expiredTodos: [Todo] = []
    var upcomingTodos: [Todo] = []
    var todayTodos: [Todo] = []
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setLayout()
        configureTableView()
        configureScrollViewInset()
                        
        Task {
            do {
                try await TodoAPI.fetchAllTodo.performRequest()
                
                let todos = todoManager.todoAllDataSource
                
                expiredTodos = todos.filter { $0.section == .expire }
                upcomingTodos = todos.filter { $0.section == .upcoming }
                todayTodos = todos.filter { $0.section == .today }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch{
                print("error: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            do {
                try await TodoAPI.fetchAllTodo.performRequest()
                
                let todos = todoManager.todoAllDataSource
                
                expiredTodos = todos.filter { $0.section == .expire }
                upcomingTodos = todos.filter { $0.section == .upcoming }
                todayTodos = todos.filter { $0.section == .today }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch{
                print("error: \(error)")
            }
        }
    }
    
// MARK: - UI
    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
    
        return tableView
    }()
    
    private lazy var registerView: RegisterView = {
        let view = RegisterView()
        view.delegate = self

        return view
    }()
        
// MARK: - layout
    private func setLayout() {
        view.addSubview(tableView)
        view.addSubview(registerView)
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        registerView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
    }
    
    private func configureScrollViewInset() {
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
}

// MARK: - UITableView extension
extension TodoListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoTableViewCell.identifier,
            for: indexPath
        ) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        var todo : Todo?
    
        switch indexPath.section {
        case 0:
            todo = todayTodos[indexPath.row]
        case 1:
            todo = upcomingTodos[indexPath.row]
        case 2:
            todo = expiredTodos[indexPath.row]
        default:
            return UITableViewCell()
        }
        
        cell.prepareLabel(
            todoListLabel:todo?.title
        )
        
        cell.delegate = self
        cell.selectionStyle = .none
        
        let successOrNot = todo?.isFinished
        
        if successOrNot ?? true { cell.complete() }
        else { cell.unComplete() }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countSectionList = 0
            
        switch section {
        case 0:
            countSectionList = todayTodos.count
        case 1:
            countSectionList = upcomingTodos.count
        case 2:
            countSectionList = expiredTodos.count
        default:
            return countSectionList
        }
        return countSectionList
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let todoTableViewHeaderView = SectionHeaderView()
        
        switch section {
        case 0:
            todoTableViewHeaderView.sectionNameLabel.text = "today"
        case 1:
            todoTableViewHeaderView.sectionNameLabel.text = "upcoming"
        case 2:
            todoTableViewHeaderView.sectionNameLabel.text = "expire"
        default:
            return todoTableViewHeaderView
        }
        return todoTableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let todoTableViewHeaderView = SectionHeaderView()
        
        let intrinsicHeight = todoTableViewHeaderView.intrinsicContentSize.height
        
        return intrinsicHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var id = 0
        
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                id = todayTodos[indexPath.row].id
                todayTodos.remove(at: indexPath.row)
            case 1:
                id = upcomingTodos[indexPath.row].id
                upcomingTodos.remove(at: indexPath.row)
            case 2:
                id = expiredTodos[indexPath.row].id
                expiredTodos.remove(at: indexPath.row)
            default:
                print("인덱스 없음")
            }
            
            Task {
                try await TodoAPI.deleteTodo(id: id).performRequest()
                try await TodoAPI.fetchAllTodo.performRequest()
            }
                        
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // cell 클릭시 detailVC 로 이동 -> 상세내용 보기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var todoData = Todo(id: 0, title: "", isFinished: false)

        switch indexPath.section {
        case 0:
            todoData = todayTodos[indexPath.row]
        case 1:
            todoData = upcomingTodos[indexPath.row]
        case 2:
            todoData = expiredTodos[indexPath.row]
        default:
            print("인덱스 없음")
        }

        let detailVC = DetailViewController()
        let date : Date = .now
        
        let nowToString = date.toString()
        
        detailVC.delegate = self
        
        detailVC.detailViewTitle.text = todoData.title
        detailVC.IDNumber = todoData.id
        detailVC.descriptionTextView.text = todoData.description
        detailVC.endDate = todoData.endDate ?? nowToString
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - ButtonTappedDelegate extension
extension TodoListViewController : ButtonTappedDelegate {
    // 수정
    func tapFinishButton(forCell cell: TodoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var todoData = Todo(id: 0, title: "", isFinished: false)

        switch indexPath.section {
        case 0:
            todoData = todayTodos[indexPath.row]
        case 1:
            todoData = upcomingTodos[indexPath.row]
        case 2:
            todoData = expiredTodos[indexPath.row]
        default:
            print("인덱스 없음")
        }
            
        let id = todoData.id
        
        let successOrNot = todoData.isFinished
        
        if !successOrNot {
            print(id,successOrNot)

            cell.complete()
            switch indexPath.section {
            case 0:
                todayTodos[indexPath.row].isFinished = true
            case 1:
                upcomingTodos[indexPath.row].isFinished = true
            case 2:
                expiredTodos[indexPath.row].isFinished = true
            default:
                print("인덱스 없음")
            }
            
            Task{
                try await TodoAPI.modifyTodoSuccess(id: id).performRequest()
                try await TodoAPI.fetchAllTodo.performRequest()
            }
        }
        
        else {
            print(id,successOrNot)

            cell.unComplete()
            switch indexPath.section {
            case 0:
                todayTodos[indexPath.row].isFinished = false
            case 1:
                upcomingTodos[indexPath.row].isFinished = false
            case 2:
                expiredTodos[indexPath.row].isFinished = false
            default:
                print("인덱스 없음")
            }
            
            Task{
                try await TodoAPI.modifyTodoSuccess(id: id).performRequest()
                try await TodoAPI.fetchAllTodo.performRequest()
            }
        }
    }
    
    
    // 수정
    func tapDeleteButton(forCell cell: TodoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell),
           indexPath.section < todoManager.todoAllDataSource.count {
            var id = 0
            
            switch indexPath.section {
            case 0:
                id = todayTodos[indexPath.row].id
                todayTodos.remove(at: indexPath.row)
            case 1:
                id = upcomingTodos[indexPath.row].id
                upcomingTodos.remove(at: indexPath.row)
            case 2:
                id = expiredTodos[indexPath.row].id
                expiredTodos.remove(at: indexPath.row)
            default:
                print("인덱스 없음")
            }
            
            print(id)
            Task{
                try await TodoAPI.deleteTodo(id: id).performRequest()
                try await TodoAPI.fetchAllTodo.performRequest()
            }
                
            tableView.deleteRows(at: [indexPath], with: .fade)
                
            cell.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.todoListLabel.textColor = .black
                
            cell.deleteButton.setImage(nil, for: .normal)
        }
    }
}

// MARK: - PlusListButtonDelegate extension
extension TodoListViewController : PlusListButtonDelegate {
    // 수정
    func tabAddTodoButton(forView view: RegisterView) {
        if let text = view.registerTextField.text {
            let date = Date.now
            let dateToString = date.toString()
            
            let requestBody = RequestDTO(
                title: text,
                description: "",
                endDate: dateToString
            )

            Task{
                try await TodoAPI.createTodo(requestBody).performRequest(with: requestBody)
                try await TodoAPI.fetchAllTodo.performRequest()
                
                let todos = todoManager.todoAllDataSource
                todayTodos = todos.filter { $0.section == .today }
                
                self.tableView.reloadData()
            }
            view.registerTextField.text = ""
        }
    }
}

extension TodoListViewController : DetailViewControllerDelegate {
    func didUpdateTodo() {
        Task {
            do {
                try await TodoAPI.fetchAllTodo.performRequest()

                let todos = todoManager.todoAllDataSource

                expiredTodos = todos.filter { $0.section == .expire }
                upcomingTodos = todos.filter { $0.section == .upcoming }
                todayTodos = todos.filter { $0.section == .today }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("error : \(error)")
            }
        }
    }
}


