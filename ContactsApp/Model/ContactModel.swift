//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Ignacio Segui on 25/03/2021.
//

import Foundation


public struct Contact: Codable {
    
    // MARK: - Properties
    var name: String?
    var id: String?
    var companyName: String?
    var isFavorite: Bool?
    var smallImageURL: String?
    var largeImageURL: String?
    var emailAddress: String?
    var birthdate: String?
    var phone: Phone?
    var address: Address?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case companyName = "companyName"
        case isFavorite = "isFavorite"
        case smallImageURL = "smallImageURL"
        case largeImageURL = "largeImageURL"
        case emailAddress = "emailAddress"
        case birthdate = "birthdate"
        case phone = "phone"
        case address = "address"


    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        companyName = try values.decodeIfPresent(String.self, forKey: .companyName)
        isFavorite = try values.decodeIfPresent(Bool.self, forKey: .isFavorite)
        smallImageURL = try values.decodeIfPresent(String.self, forKey: .smallImageURL)
        largeImageURL = try values.decodeIfPresent(String.self, forKey: .largeImageURL)
        emailAddress = try values.decodeIfPresent(String.self, forKey: .emailAddress)
        birthdate = try values.decodeIfPresent(String.self, forKey: .birthdate)
        phone = try values.decodeIfPresent(Phone.self, forKey: .phone)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
    }
}


struct Phone: Codable {
    
    // MARK: - Properties
    var work: String?
    var home: String?
    var mobile: String?
    
    enum CodingKeys: String, CodingKey {
        case work = "work"
        case home = "home"
        case mobile = "mobile"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        work = try values.decodeIfPresent(String.self, forKey: .work)
        home = try values.decodeIfPresent(String.self, forKey: .home)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
    }
}

struct Address: Codable {
    
    // MARK: - Properties
    var street: String?
    var city: String?
    var state: String?
    var country: String?
    var zipCode: String?
    
    enum CodingKeys: String, CodingKey {
        case street = "street"
        case city = "city"
        case state = "state"
        case country = "country"
        case zipCode = "zipCode"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        street = try values.decodeIfPresent(String.self, forKey: .street)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
    }
}
