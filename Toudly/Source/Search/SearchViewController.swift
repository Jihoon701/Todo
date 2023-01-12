//
//  SearchViewController.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/17.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchTableView: UITableView!
    
    let realm = try! Realm()
    var searchlist: Results<TodoList>!
    
    @IBAction func BackToHomeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        SearchTextField.layer.cornerRadius = 10
        SearchTextField.font = .NanumSR(.bold, size: 14)
        SearchTextField.setupLeftImage(imageName: "search")
        SearchTextField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
        super.viewDidLoad()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchlist = realm.objects(TodoList.self).filter("todoContent CONTAINS[c] %@", SearchTextField.text ?? "").sorted(byKeyPath: "todoContent", ascending: true)
        SearchTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(TodoList.self).filter("todoContent CONTAINS[c] %@", SearchTextField.text ?? "").sorted(byKeyPath: "todoContent", ascending: true).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        searchlist = realm.objects(TodoList.self).filter("todoContent CONTAINS[c] %@", SearchTextField.text ?? "").sorted(byKeyPath: "todoContent", ascending: true)
        cell.contentLabel.text = searchlist[indexPath.row].todoContent
        cell.dateLabel.text = searchlist[indexPath.row].date
        cell.selectionStyle = .none
        return cell
    }
}
