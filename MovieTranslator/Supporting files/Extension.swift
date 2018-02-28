//
//  Extension.swift
//  MovieTranslator
//
//  Created by Никита on 12.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

extension UIViewController {
    func showLoading() {
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.show()
    }
    
    @objc func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    
    func setImage(withImageURL imageURL : String?) {
        if let imageUrl = imageURL {
            self.sd_setImage(with: URL(string: imageUrl) , placeholderImage: #imageLiteral(resourceName: "noimage"), options: .continueInBackground, completed: nil)
        }
    }
    
}

extension MovieModel {
    static func setGenre(ofMovie movie: MovieModel, toLabel label: UILabel) {
        guard let movieGenres = movie.genres else { return }
        let genreString = (movieGenres as NSArray).componentsJoined(by: ",")
        label.text = genreString.count < 1 ?  "No genre" : genreString
    }
    
    static func setGenres(genres: [GenreModel], forMovie movie: MovieModel) {
        for i in 0..<genres.count {
            for j in 0..<(movie.genreIDs?.count)! {
                if movie.genreIDs![j] == genres[i].id {
                    movie.genres?.append(genres[i].name!)
                }
            }
        }
    }
    
    static func getString(ofMovieDuration duration: Int) -> String {
        var durationString = ""
        let countMinutesInHour = 60
        let hoursCount = duration/countMinutesInHour
        let minutesCount = duration - hoursCount*countMinutesInHour
            if duration == 0 {
                durationString = "No duration"
            } else {
                if duration > countMinutesInHour {
                    if hoursCount < 2 {
                        durationString = String(format:"\(hoursCount) hour \(minutesCount) min")
                    } else {
                        durationString = String(format:"\(hoursCount) hours \(minutesCount) min")
                    }
                }
                else {
                    durationString = String(format:"\(duration) min")
                }
        }
        return durationString
    }
    
    static func getPrefixBeforeCharacter(character: String, fromString string: String) -> String {
        let array = (string as NSString).components(separatedBy: character)
        return array[0]
    }
}
