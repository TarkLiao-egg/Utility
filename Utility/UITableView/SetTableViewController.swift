//
//  SetTableViewController.swift
//  Utility
//
//  Created by 廖力頡 on 2022/4/23.
//

import UIKit

class SetTableViewController: UIViewController {
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var datas = [0, 1, 2, 3]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.forSelf {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.configure(datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        datas.append(datas.count)
//        datas.remove(at: 0)
        
//        tableView.beginUpdates()
//        let indexPaths = [IndexPath(row: datas.count - 1, section: 0)]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//        tableView.endUpdates()
        tableView.performBatchUpdates {
            let indexPaths = [IndexPath(row: datas.count - 1, section: 0)]
            tableView.insertRows(at: indexPaths, with: .automatic)
//            let indexPaths = [IndexPath(row: -, section: 0)]
//            tableView.deleteRows(at: indexPaths, with: .automatic)
        } completion: { [unowned self] _ in
            print("tark complete")
            refreshControl.endRefreshing()
        }

    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let sport = sports[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [unowned self] (action, view, resultClosure) in
            //TODO action
            resultClosure(true)
        }
        deleteAction.backgroundColor = .clear
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        for subView in tableView.subviews {
            if NSStringFromClass(subView.classForCoder) == "UISwipeActionPullView" {
                if let btn = subView.subviews.first as? UIButton {
                    btn.backgroundColor = .clear
                    if let buttonView = btn.subviews.first {
                        //TODO buttonView
                    }
                }
            } else if NSStringFromClass(subView.classForCoder) == "_UITableViewCellSwipeContainerView" {
                // iOS13.0
                subView.backgroundColor = .clear
                for sub in subView.subviews {
                    sub.backgroundColor = .clear
                    if NSStringFromClass(sub.classForCoder) == "UISwipeActionPullView" {
                        sub.subviews.last?.backgroundColor = .clear
                        if let btn = sub.subviews.first as? UIButton {
                            btn.backgroundColor = .clear
                            if let buttonView = btn.subviews.first {
                                //TODO buttonView
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SetTableViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
    }
}
