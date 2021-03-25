//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 23/03/2021.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage

class ContactViewController: UIViewController {
    
    var resultsArray = [Contact]()
    var favouritesResultsArray = [Contact]()
    
    var sortedResultsArray = [Contact]()
    var sortedFavouritesResultsArray = [Contact]()
    
    let viewCellIdentifier = "viewCell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        getData()
        
    }
    
    func getData() {
        let finalString = Constants.kSearchContactsApiUrl
        showLoading()
        AF.request(finalString).responseJSON { response in
            switch response.result {
            case .success(_):
                do {
                    if let data = response.data {
                        let response = try JSONDecoder().decode([Contact].self, from: data)
                        for result in response {
                            if result.isFavorite == true {
                                self.favouritesResultsArray.append(result)
                                self.sortedFavouritesResultsArray = self.favouritesResultsArray.sorted(by: { (name1, name2) -> Bool in
                                    return name1.name ?? "" < name2.name ?? ""
                                })
                            } else {
                                self.resultsArray.append(result)
                                self.sortedResultsArray = self.resultsArray.sorted(by: { (name1, name2) -> Bool in
                                    return name1.name ?? "" < name2.name ?? ""
                                })
                            }
                        }
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                self.hideLoading()
                if self.resultsArray.count == 0 {
                    self.showAlert(title: Constants.errorNoContactsFoundMessage, message: nil)
                }
            case .failure(let error):
                self.hideLoading()
                print(error)
            }
        }
    }
}

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewCellIdentifier, for: indexPath) as! TableViewCell
        
        if indexPath.section == 0 {
            let data = sortedFavouritesResultsArray[indexPath.row]
            cell.nameLabel.text = data.name
            cell.companyLabel.text = data.companyName
            if let imageURLString = data.smallImageURL {
                let imageURL = URL(string: imageURLString)
                cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.medium
                cell.userImage.sd_setImage(with: imageURL, completed: nil)
                cell.userImage.contentMode = .scaleAspectFit
            } else {
                cell.userImage?.image = UIImage(named: "UserSmall.png")
            }
        } else if indexPath.section == 1 {
            let data = sortedResultsArray[indexPath.row]
            cell.nameLabel.text = data.name
            cell.companyLabel.text = data.companyName
            if let imageURLString = data.smallImageURL {
                let imageURL = URL(string: imageURLString)
                cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.medium
                cell.userImage.sd_setImage(with: imageURL, completed: nil)
                cell.userImage.contentMode = .scaleAspectFit
            } else {
                cell.userImage?.image = UIImage(named: "UserSmall.png")
            }
            cell.favouriteButton.isHidden = true
        }
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sortedFavouritesResultsArray.count
        } else if section == 1 {
            return sortedResultsArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = sortedFavouritesResultsArray[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailContact") as? ContactDetailViewController
            vc?.contact = item
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if indexPath.section == 1 {
            let item = sortedResultsArray[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailContact") as? ContactDetailViewController
            vc?.contact = item
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Favourites Contacts"
        } else if section == 1 {
            return "Other Contacts"
        }
        return ""
    }
}


extension ContactViewController {
    
    func showLoading() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = Constants.loading
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
