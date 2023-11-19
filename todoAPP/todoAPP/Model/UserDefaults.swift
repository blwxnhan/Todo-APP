//
//  UserDefaults.swift
//  todoAPP
//
//  Created by Bowon Han on 11/16/23.
//

import Foundation

class SaveData {
    static let shared = SaveData()
    let todoList = "todoList"
    
    var dataSource : [SettingSection] = []
    
//    var dataSource : [SettingSection] = [] {
//        didSet{
//            self.saveAllData()
//        }
//    }

    let userDefaults = UserDefaults.standard
    
    private init() {}

    func saveAllData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(dataSource){
            userDefaults.set(encoded, forKey: todoList)
        }
    }
            
    func loadAllData() {
        if let savedData = userDefaults.object(forKey: todoList) as? Data{
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SettingSection].self, from: savedData){
                dataSource = savedObject
                print(dataSource)
            }
        }
    }
}
