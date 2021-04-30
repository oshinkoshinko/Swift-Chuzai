//
//  MessageCell.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/16.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //ロードされたときに表示
    override func awakeFromNib() {
        super.awakeFromNib()

        rightImageView.layer.cornerRadius = 25.0
        leftImageView.layer.cornerRadius = 25.0
        backView.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
