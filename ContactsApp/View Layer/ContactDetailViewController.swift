//
//  ContactDetailViewController.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 23/03/2021.
//

import UIKit

class ContactDetailViewController: UIViewController {

    var contact: Contact?
    
    init(detail: Contact) {
        super.init(nibName: nil, bundle: nil)
        self.contact = detail
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
