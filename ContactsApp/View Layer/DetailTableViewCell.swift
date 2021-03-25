//
//  DetailTableViewCell.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 25/03/2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var phoneType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
