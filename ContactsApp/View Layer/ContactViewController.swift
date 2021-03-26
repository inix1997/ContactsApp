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
    let detailViewControllerId = "DetailContact"
    let viewCellIdentifier = "viewCell"
    let favouritesContactsLabel = "Favourites Contacts"
    let otherContactsLabel = "Other Contacts"
    let userSmallImage = "UserSmall.png"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateArrays()
        tableView.reloadData()
    }
    
    func updateArrays() {
        UserData.sharedInstance.savedSortedFavouritesResultsArray = UserData.sharedInstance.savedSortedFavouritesResultsArray.sorted(by: { (name1, name2) -> Bool in
            return name1.name ?? "" < name2.name ?? ""
        })
        UserData.sharedInstance.savedSortedResultsArray = UserData.sharedInstance.savedSortedResultsArray.sorted(by: { (name1, name2) -> Bool in
            return name1.name ?? "" < name2.name ?? ""
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        getData()
    }
    
    func getData() {
        showLoading()
        let finalString = Constants.kSearchContactsApiUrl
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
                        UserData.sharedInstance.savedSortedFavouritesResultsArray = self.sortedFavouritesResultsArray
                        UserData.sharedInstance.savedSortedResultsArray = self.sortedResultsArray
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
                self.showAlert(title: nil, message: error.localizedDescription)
            }
        }
    }
}

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewCellIdentifier, for: indexPath) as! TableViewCell
        
        if indexPath.section == 0 {
            let data = UserData.sharedInstance.savedSortedFavouritesResultsArray[indexPath.row]
            setCellData(cell: cell, data: data)
            cell.favouriteButton.isHidden = false
        } else if indexPath.section == 1 {
            let data = UserData.sharedInstance.savedSortedResultsArray[indexPath.row]
            setCellData(cell: cell, data: data)
            cell.favouriteButton.isHidden = true
        }
        return cell
    }
    
    func setCellData(cell: TableViewCell, data: Contact) {
        cell.nameLabel.text = data.name
        cell.companyLabel.text = data.companyName
        if let imageURLString = data.smallImageURL {
            let imageURL = URL(string: imageURLString)
            cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.medium
            cell.userImage.sd_setImage(with: imageURL, completed: nil)
            cell.userImage.contentMode = .scaleAspectFit
        } else {
            cell.userImage?.image = UIImage(named: userSmallImage)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return UserData.sharedInstance.savedSortedFavouritesResultsArray.count
        } else if section == 1 {
            return UserData.sharedInstance.savedSortedResultsArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = UserData.sharedInstance.savedSortedFavouritesResultsArray[indexPath.row]
            navigateToDetail(item: item, indexPath: indexPath)
        } else if indexPath.section == 1 {
            let item = UserData.sharedInstance.savedSortedResultsArray[indexPath.row]
            navigateToDetail(item: item, indexPath: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func navigateToDetail(item: Contact, indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: detailViewControllerId) as? ContactDetailViewController
        vc?.contact = item
        vc?.indexPath = indexPath
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return favouritesContactsLabel
        } else if section == 1 {
            return otherContactsLabel
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
