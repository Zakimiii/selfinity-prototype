//
//  MemoFileIndexViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift

@objcMembers
class MemoFileIndexViewController: UIViewController {
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.memoFileTableViewCell(), forCellReuseIdentifier: R.nib.memoFileTableViewCell.name)
            tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
            tableView.estimatedRowHeight = 120
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
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
    
    public var repositories: FolderModel!
    fileprivate var presenter: MemoFileIndexPresenter?
    fileprivate let dataStore =  MemoDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    var index: Int!
    
    func tapClose() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func inject(presenter: MemoFileIndexPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        MemoFileIndexViewControllerBuilder.rebuild(self)
        self.headerView.titileLabel.text = self.repositories.title
        self.headerView.onlyCloseMode()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MemoFileShowViewController, segue.identifier == R.segue.memoFileIndexViewController.toShow.identifier {
            vc.repositories = self.repositories.files[index]
            vc.folderUid = self.repositories.uid
            vc.folderTitle = self.repositories.title
            vc.delegate = self
        }
    }
}

extension MemoFileIndexViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.memoFileTableViewCell.name) as? MemoFileTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = self.repositories.files[indexPath.row].title
        cell.detailLabel.text = self.repositories.files[indexPath.row].text
//        var num = 0
//        var text = ""
//        cell.detailLabel.text = text
//        self.repositories.files[indexPath.row].text.enumerateLines{ line, stop in
//            text += line
//            num += 1
//            if num == 2 {
//                cell.detailLabel.text = text
//                stop = true
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.tapFileCell(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            return nil
        }
        view.titleLabel.text = self.repositories.title
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension MemoFileIndexViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (self.tableView.contentOffset.y <= 84 && self.tableView.contentOffset.y >= 0) {
//            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
//        } else if (self.tableView.contentOffset.y >= 84) {
//            self.tableView.contentInset = UIEdgeInsets(top: -84, left: 0, bottom: 00, right: 0)
//        }
//    }
}

extension MemoFileIndexViewController: MemoFileIndexPresenterInput {
    
        func showLoadingView() {
            self.showIndicator()
            self.tableView.isHidden = true
        }
    
        func hideLoadingView() {
            self.hideIndicator()
            self.tableView.isHidden = false
        }
    
//        func index( didFetchRepositories repositories: HomeIndexesModel) {
//            DispatchQueue.main.async {
//                self.repositories = repositories
//                self.collectionView.reloadData()
//                self.hideLoadingView()
//            }
//        }
    
        func onErrorIndex() {
            fatalError("yeah")
        }
}

extension MemoFileIndexViewController: ActionViewDelegate {
    func tapView() {
        self.repositories.files.insert((self.presenter?.createPreFile(repository: self.repositories))!, at: 0)
        self.tableView?.reloadSections(IndexSet(integer: 0), with: .fade)
    }
}

extension MemoFileIndexViewController: MemoFileShowDelegate{
    func pop(newElement: FileModel, type: CRUD) {
        switch type {
        case .create:
            self.repositories.files.remove(at: index)
            self.repositories.files.insert(newElement, at: 0)
            self.tableView?.reloadSections(IndexSet(integer: 0), with: .fade)
        case .update:
            print(newElement)
            self.repositories.files.remove(value: newElement)
            self.repositories.files.insert(newElement, at: 0)
            self.tableView?.reloadSections(IndexSet(integer: 0), with: .fade)
        default: break
        }
    }
}
