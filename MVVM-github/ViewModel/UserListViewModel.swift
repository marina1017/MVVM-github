//
//  UserListViewModel.swift
//  MVVM-github
//
//  Created by 中川万莉奈 on 2018/10/07.
//  Copyright © 2018年 中川万莉奈. All rights reserved.
//

import Foundation
import UIKit

//現在通信中か 通信が成功したのか 通信が失敗したのかをenumで定義
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

final class UserListViewModel {
    //ViewModelStateをClosureとしてpropertyで保持
    //この変数がViewControllerに対して通知を送る役割を果たす
    
    var stateDidUpdate:((ViewModelState) -> Void)?
    
    // userの配列
    private var users = [User]()
    
    // UserCellViewModelの配列
    var cellViewModels = [UserCellViewModel]()
    
    //Model層で定義したAPIクラスを変数として保持
    let api = API()
    
    //Userの配列を取得する
    func getUsers() {
        // .loading通知を送る
        stateDidUpdate?(.loading)
        users.removeAll()
        
        api.getUser(success: {(users) in
            self.users.append(contentsOf: users)
            for user in users {
                //UserCellViewModelの配列を作成
                let cellViewModel = UserCellViewModel(user: user)
                self.cellViewModels.append(cellViewModel)
                
                //通信が成功したので .finish通知を送る
                self.stateDidUpdate?(.finish)
            }}
            , failure: { (error) in
                //通信が失敗したので .error通知を送る
                self.stateDidUpdate?(.error(error))
        })
    }
    
    //tableViewを表示させるために必要なアウトプット
    //UserListViewModelはtableView全体に対するアウトプットなので
    //tableviewのcountに必要なusers.countがアウトプット
    //tabelViewCellに対するアウトプットはUserCellViewModelが担当
    
    func usersCount() -> Int {
        return users.count
    }
    
    
    
}
