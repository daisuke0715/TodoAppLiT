//
//  FirstViewTableViewCell.swift
//  TodoAppLiT
//
//  Created by 河村大介 on 2021/09/10.
//

import UIKit

class FirstViewTableViewCell: UITableViewCell {

    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(memo: String, date: String) {
        self.memoLabel.text = memo
        self.dateLabel.text = date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
