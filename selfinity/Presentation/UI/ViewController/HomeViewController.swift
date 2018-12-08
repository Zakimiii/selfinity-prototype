//
//  HomeViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/05.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import SCLAlertView
import Toaster

@objcMembers
class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var repositories: HomeIndexesModel! {
        didSet {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
            layout.minimumLineSpacing = CGFloat(0)
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
            collectionView.isPagingEnabled = true
            collectionView.register(R.nib.mainHeaderCollectionReusableView(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: R.nib.mainHeaderCollectionReusableView.name)
            collectionView.register(R.nib.homeTableCollectionViewCell(), forCellWithReuseIdentifier: R.nib.homeTableCollectionViewCell.name)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    var alertViewResponder: SCLAlertViewResponder!
    fileprivate var presenter: HomePresenter?
    fileprivate let dataStore =  UserDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    public var cache: GoalModel! {
        didSet {
        }
    }
    
    func inject(presenter: HomePresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeViewControllerBuilder.rebuild(self)
        self.presenter?.index()
        self.showLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.checkLogin()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.cache != nil {
            self.slideShow()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.cache = nil
    }
    
    fileprivate func slideShow() {
        self.repositories.items.append(HomeIndexTranslator.translateForModel(cache))
        self.collectionView.reloadData()
        UIView.animate(eachBlockDuration: 0.3, eachBlockDelay: 0, eachBlockOptions: .curveEaseInOut, animationBlocks:
            { self.collectionView.scrollToItem(at: IndexPath(row: self.repositories.items.count - 1, section: 0), at: .right, animated: true) },
            { self.alertForRemindGenerator() }/*,
            { self.collectionView.waveColorCenter(color: Constant.chatWaveColor, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: 60)) }*/
        )
    }
    
    fileprivate func alertForRemindGenerator() {
        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            shouldAutoDismiss: false)
        )
        alertView.addButton(R.string.localizable.next(), target:self, selector: #selector(self.tapNextButton(_:)))
        alertView.addButton(R.string.localizable.cancel(), backgroundColor: Constant.baseColor, textColor: Constant.mainColor, target:self, selector: #selector(self.tapCancelButton(_:)))
        alertViewResponder = alertView.showSuccess(
            R.string.localizable.congratulation(),
            subTitle: R.string.localizable.forRemindGenerateText(),
            colorStyle: 0xFFA500,
            colorTextButton: 0xFFFFFF
        )
    }
    
    func tapNextButton(_ sender: SCLButton) {
        self.scheduleVC?.cache = self.cache
        alertViewResponder.close()
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[3]
    }
    
    func tapCancelButton(_ sender: SCLButton) {
        self.cache = nil
        alertViewResponder.close()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositories.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeTableCollectionViewCell.name, for: indexPath) as? HomeTableCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CollectionCell.")
        }
        cell.setData(repository: self.repositories.items[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: HomePresenterInput {
    func showLoadingView() {
        self.showIndicator()
        self.collectionView.isHidden = true
    }
    
    func hideLoadingView() {
        self.hideIndicator()
        self.collectionView.isHidden = false
    }
    
    func index( didFetchRepositories repositories: HomeIndexesModel) {
        DispatchQueue.main.async {
            self.repositories = repositories
            self.collectionView.reloadData()
            self.hideLoadingView()
        }
    }
    
    func onErrorIndex() {
    }
}

extension HomeViewController: HomeTableCollectionViewCellDelegate {
    func tapNext(_ cell: HomeTableCollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        indexPath.row < self.repositories.items.count - 1 ?
            self.collectionView.scrollToItem(at: IndexPath(row: indexPath.row + 1, section: 0), at: .right, animated: true) :
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: true)
    }
    
    func tapBack(_ cell: HomeTableCollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        indexPath.row > 0 ?
            self.collectionView.scrollToItem(at: IndexPath(row: indexPath.row - 1, section: 0), at: .left, animated: true) :
            self.collectionView.scrollToItem(at: IndexPath(row: self.repositories.items.count - 1, section: 0), at: .left, animated: true)
    }
}
