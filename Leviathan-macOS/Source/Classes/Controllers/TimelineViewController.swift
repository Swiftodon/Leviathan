//
//  TimelineViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 13.04.17.
//
//

import MAIKit

@IBDesignable
class TimelineViewController: MAIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private var _tv: MAITableView!
    private var _tableView: MAITableViewProtocol! {
        return self._tv as MAITableViewProtocol
    }
    

    // MARK: - Public Properties
    
    @IBInspectable var timelineId: String = ""
}
