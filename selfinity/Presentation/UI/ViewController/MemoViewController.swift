//
//  MemoViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift
import SCLAlertView
import Toaster
import SwiftDate
import Firebase

@objcMembers
class MemoViewController: UIViewController {
    var alertTextField: UITextField!
    var alertViewResponder: SCLAlertViewResponder!
    var refreshControl:UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionView: ActionView! {
        didSet {
            actionView.layer.shadowColor = Constant.baseStringColor.cgColor
            actionView.layer.shadowColor = Constant.baseStringColor.cgColor
            actionView.layer.shadowOpacity = 0.2
            actionView.layer.shadowOffset = CGSize.zero
            actionView.layer.shadowRadius = actionView.bounds.width / 2
            actionView.layer.shadowPath = UIBezierPath(roundedRect: actionView.bounds, cornerRadius: 10).cgPath
            actionView.layer.shouldRasterize = true
            actionView.layer.rasterizationScale = UIScreen.main.scale
            actionView.delegate = self
        }
    }
    var repositories: MemoModel! {
        didSet {
            tableView.register(R.nib.folderTableViewCell(), forCellReuseIdentifier: R.nib.folderTableViewCell.name)
            tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
            tableView.estimatedRowHeight = 84
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
            self.refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
            tableView.refreshControl = refreshControl
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    fileprivate var presenter: MemoPresenter?
    fileprivate let dataStore =  MemoDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    var index: Int!
    
    enum FolderRow: Int {
        case all   = 0
        case count = 1
        
        var string: String {
            switch self {
            case .all: return R.string.localizable.alL()
            default: return ""
            }
        }
    }
    
    func inject(presenter: MemoPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        MemoViewControllerBuilder.rebuild(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter?.index()
        self.showLoadingView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MemoFileIndexViewController, segue.identifier == R.segue.memoViewController.toFile.identifier {
            if index == -1 {
                var files = [FileModel]()
                for folder in self.repositories.folders {
                    for file in folder.files {
                        files.append(file)
                    }
                }
                vc.repositories = FolderModel.init(uid: Constant.allFolderPrefix + Firebase.Auth.auth().currentUser!.uid, files: files, title: R.string.localizable.alL(), owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!, private: false, createdAt: Date.CurrentDate(), updatedAt: Date.CurrentDate())
            } else {
                vc.repositories = folderRemoveFromAll()[index]
            }
        }
    }
    
    func refresh(){
        self.presenter?.index()
    }
    
    func tapTitleSaveButton(_ sender: SCLButton) {
        guard let text = self.alertTextField.text, text != "" else {
            Toast(text: R.string.localizable.newFolderPlaceholder()).show()
            return
        }
        self.presenter?.createFolder(title: text)
        alertViewResponder.close()
    }
    
    func tapCancelButton(_ sender: SCLButton) {
        alertViewResponder.close()
    }
    
    func countFolderRemoveFromAll() -> Int {
        return self.repositories.folders.filter { !$0.uid.contains(Constant.allFolderPrefix) }.count
    }
    
    func folderRemoveFromAll() -> [FolderModel] {
        return self.repositories.folders.filter { !$0.uid.contains(Constant.allFolderPrefix) }
    }
}

extension MemoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countFolderRemoveFromAll() + FolderRow.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.folderTableViewCell.name) as? FolderTableViewCell else {
            fatalError("This row is not exist")
        }
        if indexPath.row == FolderRow.all.rawValue {
            cell.titleLabel.textColor = Constant.subColor
            cell.titleLabel.text = R.string.localizable.alL()
            cell.numberLabel.text =  String(describing: repositories.folders.reduce(0) { $0 + $1.files.count })
        } else {
            cell.titleLabel.text = folderRemoveFromAll()[indexPath.row - FolderRow.count.rawValue].title
            print(folderRemoveFromAll()[indexPath.row - FolderRow.count.rawValue])
            cell.numberLabel.text = String(describing: folderRemoveFromAll()[indexPath.row - FolderRow.count.rawValue].files.count)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter!.tapFolderCell(row: indexPath.row - FolderRow.count.rawValue)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            return nil
        }
        view.titleLabel.text = R.string.localizable.mainTabText2()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
}

extension MemoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 84 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 84) {
            self.tableView.contentInset = UIEdgeInsets(top: -84, left: 0, bottom: 00, right: 0)
        }
    }
}

extension MemoViewController: MemoPresenterInput {
    func showLoadingView() {
        self.showIndicator()
        self.tableView.isHidden = true
    }

    func hideLoadingView() {
        self.hideIndicator()
        self.tableView.isHidden = false
        if let control = self.refreshControl {
            control.endRefreshing()
        }
    }

    func index( didFetchRepositories repositories: MemoModel) {
        self.hideLoadingView()
        self.repositories = repositories
        self.tableView.reloadData()
        self.hideLoadingView()
    }
    
    func createFolder(didCreateRepositories repositories: FolderModel) {
        self.repositories.folders.insert(repositories, at: 0)
        self.tableView?.reloadSections(IndexSet(integer: FolderRow.all.rawValue), with: .fade)
    }

    func onErrorIndex() {
        fatalError("yeah")
    }
}

extension MemoViewController: ActionViewDelegate {
    func tapView() {
        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            shouldAutoDismiss: false)
        )
        self.alertTextField = alertView.addTextField(R.string.localizable.name())
        alertView.addButton(R.string.localizable.save(), target:self, selector: #selector(self.tapTitleSaveButton(_:)))
        alertView.addButton(R.string.localizable.cancel(), backgroundColor: Constant.baseColor, textColor: Constant.mainColor, target:self, selector: #selector(self.tapCancelButton(_:)))
        alertViewResponder = alertView.showEdit(
            R.string.localizable.newFolder(),
            subTitle: R.string.localizable.newFolderPlaceholder(),
            colorStyle: 0xFFA500,
            colorTextButton: 0xFFFFFF
        )
    }
}
