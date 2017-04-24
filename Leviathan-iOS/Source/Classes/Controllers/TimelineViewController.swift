//
//  TimelineViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 17.04.17.
//
//

import UIKit
import RxCocoa
import RxSwift
import Toucan
import DoThis



@IBDesignable
class TimelineViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private var accountButton: UIButton!
    
    @objc private let settings = Globals.injectionContainer.resolve(Settings.self)
    

    // MARK: - Public Properties
    
    @IBInspectable var timelineId: String = ""
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindControls()
        self.setAvatarImage()
    }
    
    @objc override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     
        if let _ = object as! Settings? {
            
            if keyPath == "activeAccount" {
            
                self.setAvatarImage()
            }
        }
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func showAccountMenu(sender: UIButton) {
        
        let width = self.view.frame.width * 0.8
        let accountMenu = AccountMenu(width: width)
        
        accountMenu.show(fromView: self.accountButton)
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func bindControls() {
        
        settings?.addObserver(self, forKeyPath: #keyPath(Settings.activeAccount), options: [.new], context: nil)
    }
    
    fileprivate func setAvatarImage() {
        
        Do
            .this { this in
            
                guard let avatarData = self.settings?.activeAccount?.avatarData else {
                    
                    this.done()
                    return
                }
                
                self.accountButton.setImage(Toucan(image: UIImage(data: avatarData)!)
                                                .maskWithEllipse()
                                                .image,
                                            for: .normal)
                
                this.done(finished: true)
            }
            .orThis { this in
            
                self.accountButton.setImage(Asset.icAccount.image, for: .normal)
                this.done()
            }
    }
}
