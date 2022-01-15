//
//  UserTableViewCell.swift
//  GithubRepo
//
//  Created by Gilang Persada on 13/01/2022.
//

import UIKit
import RxSwift
import RxCocoa

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
//    var imageData:Data?{
//        didSet{
//            if let imageData = imageData{
//                avatarView.image = UIImage(data: imageData)
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.cornerRadius = avatarView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
