//
//  ManageSectionViewController.swift
//  todoAPP
//
//  Created by Bowon Han on 11/10/23.
//

import UIKit
import SnapKit

class ManageSectionViewController : UIViewController {
    private let saveData = SaveData.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setLayout()
    }
    
    private lazy var sectionTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self 
        
        return tableView
    }()
    
//    var sectionName : UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
//        
//        return label
//    }()
    
    private func setLayout() {
        view.addSubview(sectionTableView)
        
        sectionTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
    }
}


// MARK: - UITableView extension

extension ManageSectionViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = saveData.dataSource[indexPath.section]
                
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SectionTableViewCell.identifier,
            for: indexPath
        ) as? SectionTableViewCell else {
            fatalError("Failed to dequeue a cell.")
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
