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
        cell.configure(data: datas[indexPath.row])
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
