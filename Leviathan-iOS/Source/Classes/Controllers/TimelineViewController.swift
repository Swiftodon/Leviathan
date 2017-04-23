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
    
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    

    // MARK: - Public Properties
    
    @IBInspectable var timelineId: String = ""
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindControls()
        self.setAvatarImage()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     
        if let _ = object as! Settings? {
            
            if keyPath == "activeAccount" {
            
                self.setAvatarImage()
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func bindControls() {
        
        settings?.addObserver(self, forKeyPath:  "activeAccount", options: [.new], context: nil)
    }
    
    fileprivate func setAvatarImage() {
        
        Do
            .this { this in
            
                guard let avatarData = self.settings?.activeAccount?.avatarData else {
                    
                    this.done()
                    return
                }
                
                self.accountButton.setImage(Toucan(image: UIImage(data: avatarData)!)
                                                //.resize(CGSize(width: 24, height: 24))
                                                .maskWithEllipse()
                                                .image,
                                            for: .normal)
                
                this.done(finished: true)
            }
            .orThis { this in
            
                self.accountButton.setImage(Asset.Ic_account.image, for: .normal)
                this.done()
            }
    }
}
