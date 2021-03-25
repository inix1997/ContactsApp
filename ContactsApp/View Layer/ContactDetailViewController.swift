//
//  ContactDetailViewController.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 23/03/2021.
//

import UIKit
import SDWebImage

class ContactDetailViewController: UIViewController {

    var contact: Contact?
    @IBOutlet var name: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favouriteButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        name.text = contact?.name
        companyName.text = contact?.companyName
        if contact?.isFavorite == true {
            favouriteButton.imageView?.image = UIImage(named: "FavoriteTrue.png")
        } else {
            favouriteButton.imageView?.image = UIImage(named: "FavoriteFalse.png")

        }

        if let imageURLString = contact?.largeImageURL {
            let imageURL = URL(string: imageURLString)
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            imageView.sd_setImage(with: imageURL, completed: nil)
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.image = UIImage(named: "UserLarge.png")
        }
    }
}

extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableViewCell()
    }    
}
