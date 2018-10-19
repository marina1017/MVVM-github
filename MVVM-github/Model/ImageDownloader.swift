//
//  ImageDownloader.swift
//  MVVM-github
//
//  Created by 中川万莉奈 on 2018/10/07.
//  Copyright © 2018年 中川万莉奈. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloader {
    //UIImageをキャッシュするための変数
    var cacheImage: UIImage?
    
    func downloadImage(imageURL: String,
                       success: @escaping(UIImage) -> Void,
                       failure: @escaping(Error) -> Void ){
        
        //もしキャッシュされたUIImageがあればそれをClosureで返す
        if let cacheImage = self.cacheImage {
            success(cacheImage)
        }
        
        //リクエストを作成
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            //Errorがあれば
            guard let error = error else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            //dataがへんだったら
            guard let data  = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            //受け取ったでーたからUIImageを生成できなければ
            guard let imageFromData = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            //imageFromDataをClosureで返す
            DispatchQueue.main.async {
                success(imageFromData)
            }
            
            //画像をキャッシュする
            self.cacheImage = imageFromData
        }
        task.resume()
    }
    
}
