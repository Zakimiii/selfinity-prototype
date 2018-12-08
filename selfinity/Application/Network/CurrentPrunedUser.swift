//
//  CurrentPrunedUser.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

enum PrunedUserType: String {
    case entity = "entity"
    case model = "model"
}

class CurrentPrunedUser: NSObject, NSCoding {
    
    public var uid = ""
    public var displayName = ""
    public var credit = 0
    public var sumCredit = 0
    public var profileImage = NSURL()
    public var backgroundImage = NSURL()
    public var registrationConfirmed = false
    public var permissions = false
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    let userDefaults = UserDefaults.standard
    
    init(uid: String, displayName: String, credit: Int, sumCredit: Int, profileImage: NSURL, backgroundImage: NSURL, registrationConfirmed: Bool, permissions: Bool, `private`: Bool, createdAt: Date, updatedAt: Date) {
        self.uid = uid
        self.displayName = displayName
        self.credit = credit
        self.sumCredit = sumCredit
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        self.registrationConfirmed = registrationConfirmed
        self.permissions = permissions
        self.private = `private`
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String ?? ""
        self.displayName = aDecoder.decodeObject(forKey: "displayName") as? String ?? ""
        self.credit = aDecoder.decodeObject(forKey: "credit") as? Int ?? 0
        self.sumCredit = aDecoder.decodeObject(forKey: "sumCredit") as? Int ?? 0
        self.profileImage = aDecoder.decodeObject(forKey: "profileImage") as? NSURL ?? NSURL()
        self.backgroundImage = aDecoder.decodeObject(forKey: "backgroundImage") as? NSURL ?? NSURL()
        self.registrationConfirmed = aDecoder.decodeObject(forKey: "registrationConfirmed") as? Bool ?? false
        self.permissions = aDecoder.decodeObject(forKey: "permissions") as? Bool ?? false
        self.private = aDecoder.decodeObject(forKey: "private") as? Bool ?? false
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date ?? Date.CurrentDate()
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date ?? Date.CurrentDate()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(displayName, forKey: "displayName")
        aCoder.encode(credit, forKey: "credit")
        aCoder.encode(sumCredit, forKey: "sumCredit")
        aCoder.encode(profileImage, forKey: "profileImage")
        aCoder.encode(backgroundImage, forKey: "backgroundImage")
        aCoder.encode(registrationConfirmed, forKey: "registrationConfirmed")
        aCoder.encode(permissions, forKey: "permissions")
        aCoder.encode(`private`, forKey: "private")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(updatedAt, forKey: "updatedAt")
    }
    
    static func getCurrentPrunedUserModel() -> CurrentPrunedUser? {
        guard let user = Firebase.Auth.auth().currentUser else {
            return nil
        }
        let uid = user.uid
        let userDefaults = UserDefaults.standard
        return CurrentPrunedUser.init(uid: userDefaults.string(forKey: "\(uid)")!,
                                      displayName: userDefaults.string(forKey: "\(uid)/displayName")!,
                                      credit: userDefaults.integer(forKey: "\(uid)/credit"),
                                      sumCredit: userDefaults.integer(forKey: "\(uid)/sumCredit"),
                                      profileImage: NSURL(string: userDefaults.string(forKey: "\(uid)/profileImage")!) ?? NSURL(),
                                      backgroundImage: NSURL(string: userDefaults.string(forKey: "\(uid)/backgroundImage")!) ?? NSURL(),
                                      registrationConfirmed: userDefaults.bool(forKey: "\(uid)/registrationConfirmed"),
                                      permissions: userDefaults.bool(forKey: "\(uid)/permissions"),
                                      private: userDefaults.bool(forKey: "\(uid)/private"),
                                      createdAt: userDefaults.string(forKey: "\(uid)/createdAt")!.getDate()!,
                                      updatedAt: Date.CurrentDate()/*userDefaults.string(forKey: "\(uid)/updatedAt")!.getDate()!*/
        )
    }
    
    static func getCurrentPrunedUserModelFromUid(_ uid: String) -> CurrentPrunedUser? {
        let userDefaults = UserDefaults.standard
        
        return CurrentPrunedUser.init(uid: userDefaults.string(forKey: "\(uid)")!,
                                      displayName: userDefaults.string(forKey: "\(uid)/displayName")!,
                                      credit: userDefaults.integer(forKey: "\(uid)/credit"),
                                      sumCredit: userDefaults.integer(forKey: "\(uid)/sumCredit"),
                                      profileImage: NSURL(string: userDefaults.string(forKey: "\(uid)/profileImage")!) ?? NSURL(),
                                      backgroundImage: NSURL(string: userDefaults.string(forKey: "\(uid)/backgroundImage")!) ?? NSURL(),
                                      registrationConfirmed: userDefaults.bool(forKey: "\(uid)/registrationConfirmed"),
                                      permissions: userDefaults.bool(forKey: "\(uid)/permissions"),
                                      private: userDefaults.bool(forKey: "\(uid)/private"),
                                      createdAt: userDefaults.string(forKey: "\(uid)/createdAt")!.getDate()!,
                                      updatedAt: Date.CurrentDate()/*userDefaults.string(forKey: "\(uid)/updatedAt")!.getDate()!*/
        )
    }
    
    static func getCurrentPrunedUserEntity() -> PrunedUserEntity? {
        guard let user = Firebase.Auth.auth().currentUser else {
            return nil
        }
        let uid = user.uid
        let userDefaults = UserDefaults.standard
        return PrunedUserEntity.init(uid: userDefaults.string(forKey: "\(uid)")!,
                                      credit: userDefaults.integer(forKey: "\(uid)/credit"),
                                      sumCredit: userDefaults.integer(forKey: "\(uid)/sumCredit"),
                                      displayName: userDefaults.string(forKey: "\(uid)/displayName")!,
                                      profileImage: NSURL(string: userDefaults.string(forKey: "\(uid)/profileImage")!) ?? NSURL(),
                                      backgroundImage: NSURL(string: userDefaults.string(forKey: "\(uid)/backgroundImage")!) ?? NSURL(),
                                      registrationConfirmed: userDefaults.bool(forKey: "\(uid)/registrationConfirmed"),
                                      permissions: userDefaults.bool(forKey: "\(uid)/permissions"),
                                      private: userDefaults.bool(forKey: "\(uid)/private"),
                                      createdAt: userDefaults.string(forKey: "\(uid)/createdAt")!.getDate()!,
            updatedAt: Date.CurrentDate()/*userDefaults.string(forKey: "\(uid)/updatedAt")!.getDate()!*/
        )
    }
    
    static func getToCurrentPrunedUserModel() -> PrunedUserModel? {
        guard let user = Firebase.Auth.auth().currentUser else {
            return nil
        }
        let uid = user.uid
        let userDefaults = UserDefaults.standard
        return PrunedUserModel.init(uid: userDefaults.string(forKey: "\(uid)")!,
                                    credit: userDefaults.integer(forKey: "\(uid)/credit"),
                                    sumCredit: userDefaults.integer(forKey: "\(uid)/sumCredit"),
                                     displayName: userDefaults.string(forKey: "\(uid)/displayName")!,
                                     profileImage: NSURL(string: userDefaults.string(forKey: "\(uid)/profileImage")!) ?? NSURL(),
                                     backgroundImage: NSURL(string: userDefaults.string(forKey: "\(uid)/backgroundImage")!) ?? NSURL(),
                                     registrationConfirmed: userDefaults.bool(forKey: "\(uid)/registrationConfirmed"),
                                     permissions: userDefaults.bool(forKey: "\(uid)/permissions"),
                                     private: userDefaults.bool(forKey: "\(uid)/private"),
                                     createdAt: userDefaults.string(forKey: "\(uid)/createdAt")!.getDate()!,
            updatedAt: Date.CurrentDate()/*userDefaults.string(forKey: "\(uid)/updatedAt")!.getDate()!*/
        )
    }
}

extension CurrentPrunedUser: StringDefaultSettable {
    
    enum StringKey : String {
        case uid
        case displayName
        case credit
        case sumCredit
        case profileImage
        case backgroundImage
        case registrationConfirmed
        case permissions
        case `private`
        case createdAt
        case updateAt
    }
}

protocol CurrentPrunedUserProtocol: class {
    func setCurrentPrunedUser(model: PrunedUserModel)
    func setCurrentPrunedUser(enitity: PrunedUserEntity)
}

extension CurrentPrunedUserProtocol {
    func setCurrentPrunedUser(model: PrunedUserModel) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(model.uid, forKey: "\(model.uid)")
        userDefaults.set(model.displayName, forKey: "\(model.uid)/displayName")
        userDefaults.set(model.credit, forKey: "\(model.uid)/credit")
        userDefaults.set(model.sumCredit, forKey: "\(model.uid)/sumCredit")
        userDefaults.set(String(describing: model.profileImage), forKey: "\(model.uid)/profileImage") //TODO
        userDefaults.set(String(describing: model.backgroundImage), forKey: "\(model.uid)/backgroundImage") //TODO
        userDefaults.set(model.registrationConfirmed, forKey: "\(model.uid)/registrationConfirmed")
        userDefaults.set(model.permissions, forKey: "\(model.uid)/permissions")
        userDefaults.set(model.private, forKey: "\(model.uid)/private")
        userDefaults.set(Constant.getNowClockString(), forKey: "\(model.uid)/createdAt")
        userDefaults.set(Constant.getNowClockString(), forKey: "\(model.uid)/updatedAt")
        userDefaults.synchronize()
    }
    
    func setCurrentPrunedUser(enitity: PrunedUserEntity) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(enitity.uid, forKey: "\(enitity.uid)")
        userDefaults.set(enitity.displayName, forKey: "\(enitity.uid)/displayName")
        userDefaults.set(enitity.credit, forKey: "\(enitity.uid)/credit")
        userDefaults.set(enitity.sumCredit, forKey: "\(enitity.uid)/sumCredit")
        userDefaults.set(String(describing: enitity.profileImage), forKey: "\(enitity.uid)/profileImage")
        userDefaults.set(String(describing: enitity.backgroundImage), forKey: "\(enitity.uid)/backgroundImage")
        userDefaults.set(enitity.registrationConfirmed, forKey: "\(enitity.uid)/registrationConfirmed")
        userDefaults.set(enitity.permissions, forKey: "\(enitity.uid)/permissions")
        userDefaults.set(enitity.private, forKey: "\(enitity.uid)/private")
        userDefaults.set(Constant.getNowClockString(), forKey: "\(enitity.uid)/createdAt")
        userDefaults.set(Constant.getNowClockString(), forKey: "\(enitity.uid)/updatedAt")
        userDefaults.synchronize()
    }
}
