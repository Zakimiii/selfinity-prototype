//
//  SearchBar.swift
//  salomee-ios
//
//  Created by noriki.iwamatsu on 2018/06/04.
//  Copyright © 2018年 Personize Inc. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: class {
    func searchBar(_ searchBar: SearchBar, searched keyword: String?)
    func searchBar(_ searchBar: SearchBar, accessoryButtonTapped keyword: String?) -> Bool
    func searchBarDidBeginEditing()
    func searchBarDidEndEditing()
}

extension SearchBarDelegate where Self: UIViewController {
    func searchBar(_ searchBar: SearchBar, searched keyword: String?) {}
    func searchBar(_ searchBar: SearchBar, accessoryButtonTapped keyword: String?) -> Bool { return true }
    func searchBarDidBeginEditing() {}
    func searchBarDidEndEditing() {}
}
@IBDesignable
class SearchBar: UIView {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var accessoryButton: UIButton!
    @IBOutlet weak var searchViewTrailingToSafeAreaTrailingConstraint: NSLayoutConstraint!

    weak var delegate: SearchBarDelegate?

    @IBInspectable
    var buttonText: String? {
        get {
            return accessoryButton?.titleLabel?.text
        }
        set {
            accessoryButton.setTitle(newValue, for: .normal)
        }
    }
    var placeholder: String? {
        get {
            return searchField.placeholder
        }
        set {
            searchField.text = newValue
        }
    }
    var keyword: String? {
        get {
            return searchField.text
        }
        set {
            searchField.text = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    @IBAction func accessoryButtonTapped(_ sender: Any) {
        if self.delegate?.searchBar(self, accessoryButtonTapped: self.searchField.text) ?? true {
            self.endEditing(true)
        }
    }

    override func becomeFirstResponder() -> Bool {
        self.searchField.becomeFirstResponder()
        return true
    }

    private func loadNib() {
        guard let view = Bundle(for: type(of: self)).loadNibNamed("SearchBar", owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    private func showAccessoryButton() {
        self.searchViewTrailingToSafeAreaTrailingConstraint.constant = 103
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.accessoryButton.isHidden = false
            self.layoutIfNeeded()
        }, completion: nil)
    }

    private func hideAccessoryButton() {
        self.searchViewTrailingToSafeAreaTrailingConstraint.constant = 10
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.accessoryButton.isHidden = true
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

extension SearchBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showAccessoryButton()
        self.delegate?.searchBarDidBeginEditing()
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        hideAccessoryButton()
        self.delegate?.searchBarDidEndEditing()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.delegate?.searchBar(self, searched: textField.text)
        return true
    }
}
