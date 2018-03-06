//
//  TrailerViewController.swift
//  MovieTranslator
//
//  Created by Никита on 23.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class TrailerViewController : UIViewController , NSURLConnectionDataDelegate, UIWebViewDelegate , YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    var videoKey : String?
    
    override func viewDidLoad() {
        showLoading()
        initialSetup(key: videoKey)
    }
    
    //MARK: - Private
    private func initialSetup(key : String?) {
        guard let movieKey = key else {return}
        playerView.delegate = self
        playerView.load(withVideoId: movieKey)
    }
    
    //MARK: - YoutoubePlayerViewDelegate
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        hideLoading()
    }
    
    
}

