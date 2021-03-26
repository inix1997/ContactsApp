//
//  ContactDetailViewController.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 23/03/2021.
//

import UIKit
import SDWebImage

class ContactDetailViewController: UIViewController {
    
    let viewCellIdentifier = "detailViewCell"
    let favouriteTrueImage = "FavoriteTrue.png"
    let favouriteFalseImage = "FavoriteFalse.png"
    let userLargeImage = "UserLarge.png"
    let phoneLabel = "PHONE:"
    let homeLabel = "Home"
    let mobileLabel = "Mobile"
    let workLabel = "Work"
    let addressLabel = "ADDRESS:"
    let birthdateLabel = "BIRTHDATE:"
    let emailLabel = "EMAIL:"
    var contact: Contact?
    var indexPath: IndexPath?
    var array = [Any]()
    
    @IBOutlet var name: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favouriteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func favouriteContactAction(_ sender: Any) {
        if contact?.isFavorite == true {
            if let index = indexPath, let contact = contact {
                UserData.sharedInstance.savedSortedFavouritesResultsArray.remove(at: index.row)
                var newContact = contact
                newContact.isFavorite = false
                UserData.sharedInstance.savedSortedResultsArray.append(newContact)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            if let index = indexPath, let contact = contact {
                UserData.sharedInstance.savedSortedResultsArray.remove(at: index.row)
                var newContact = contact
                newContact.isFavorite = true
                UserData.sharedInstance.savedSortedFavouritesResultsArray.append(newContact)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupView() {
        name.text = contact?.name
        companyName.text = contact?.companyName
        if contact?.isFavorite == true {
            favouriteButton.imageView?.image = UIImage(named: favouriteTrueImage)
        } else {
            favouriteButton.imageView?.image = UIImage(named: favouriteFalseImage)
        }
        loadImage()
    }
    
    func loadImage() {
        if let imageURLString = contact?.largeImageURL {
            let imageURL = URL(string: imageURLString)
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            imageView.sd_setImage(with: imageURL, completed: nil)
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.image = UIImage(named: userLargeImage)
        }
    }
}

extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewCellIdentifier, for: indexPath) as! DetailTableViewCell
        if indexPath.section == 0 {
            cell.typeLabel.text = phoneLabel
            if let homeNumber = contact?.phone?.home {
                cell.detailLabel.text = "(\(homeNumber.prefix(3))) \(homeNumber.suffix(8))"
            }
            cell.phoneType.text = homeLabel
        } else if indexPath.section == 1 {
            cell.typeLabel.text = phoneLabel
            if let homeNumber = contact?.phone?.mobile {
                cell.detailLabel.text = "(\(homeNumber.prefix(3))) \(homeNumber.suffix(8))"
            }
            cell.phoneType.text = mobileLabel
        } else if indexPath.section == 2 {
            cell.typeLabel.text = phoneLabel
            if let homeNumber = contact?.phone?.work {
                cell.detailLabel.text = "(\(homeNumber.prefix(3))) \(homeNumber.suffix(8))"
            }
            cell.phoneType.text = workLabel
        } else if indexPath.section == 3 {
            cell.typeLabel.text = addressLabel
            if let street = contact?.address?.street, let city = contact?.address?.city, let state = contact?.address?.state, let zipCode = contact?.address?.zipCode, let country = contact?.address?.country {
                cell.detailLabel.text = "\(street)\n\(city), \(state) \(zipCode), \(country)"
            }
            cell.phoneType.text = ""
            cell.phoneType.isHidden = true
        } else if indexPath.section == 4 {
            cell.typeLabel.text = birthdateLabel
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
            if let finalDate = contact?.birthdate, let date = dateFormatterGet.date(from: finalDate) {
                cell.detailLabel.text = dateFormatterPrint.string(from: date)
            } else {
                cell.detailLabel.text = contact?.birthdate
            }
            cell.phoneType.text = ""
            cell.phoneType.isHidden = true
        } else if indexPath.section == 5 {
            cell.typeLabel.text = emailLabel
            cell.detailLabel.text = contact?.emailAddress
            cell.phoneType.text = ""
            cell.phoneType.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 110
        } else if indexPath.section == 0, contact?.phone?.home != nil, contact?.phone?.home != "" {
            return 85
        } else if indexPath.section == 1, contact?.phone?.mobile != nil, contact?.phone?.mobile != "" {
            return 85
        } else if indexPath.section == 2, contact?.phone?.work != nil, contact?.phone?.work != "" {
            return 85
        } else if indexPath.section == 4 || indexPath.section == 5 {
            return 85
        }
        return 0
    }
}
