//
//  ViewController.swift
//  MVVM-github
//
//  Created by 中川万莉奈 on 2018/09/26.
//  Copyright © 2018年 中川万莉奈. All rights reserved.
//

import UIKit
import Foundation
import SafariServices

final class TimeLineViewController: UIViewController {

    fileprivate var viewModel: UserListViewModel!
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewを生成
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        //UIRefreshControlを生成しれリフレッシュした時に呼ばれるメソッドを定義しtableView.refreshControlにセットしている
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        //UserListViewModelを生成し通知を受け取ったときの処理を定義している
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = {[weak self] state in
            switch state {
            case .loading:
                //通信中だったらtableViewを操作不能にしている
                self?.tableView.isUserInteractionEnabled = false
                break
            case .finish:
                //通信が完了したらtableViewを操作可能にし、tableViewを更新
                //またrefreshControl.endRefreshingをよんでいる
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                break
            case .error(let error):
                //ErrorだったらtableViewを操作可能にし　またrefreshControl.endRefreshingをよんでいる
                //その後ErrorメッセージAlertを表示
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                
                let alerController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alerController.addAction(alertAction)
                self?.present(alerController,animated: true,completion: nil)
                break
            }
        }
        
        //ユーザー一覧を取得
        viewModel.getUsers()
    }
    
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        //リフレッシュしたときユーザー一覧を取得している
        viewModel.getUsers()
    }

}

extension TimeLineViewController:UITableViewDelegate, UITableViewDataSource {
    // viewModel.usersCount()をtableViewのCellの数として定義している
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timelineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            //そのcellのUserCellViewModelを取得し timelineCellにたいしてnickNameとiconをセットしている
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timelineCell.setNickName(nickName: cellViewModel.nickName)
            
            cellViewModel.downloadImage(progress: { (progress) in
                switch progress {
                case .loading(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .finish(let image):
                    timelineCell.setIcon(icon: image)
                    break
                case .error:
                    break
                }
            })
            return timelineCell
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //そのCellのUserCellViewModelを取得し そのユーザーのGithubページへ画面遷移敷いている
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webURL = cellViewModel.webURL
        let webViewController = SFSafariViewController(url: webURL)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
