//
//  MeasurementTableViewCell.swift
//  CodeSample
//
//  Created by Alexandre Laurin on 12/9/17.
//  Copyright © 2017 Snacktime. All rights reserved.
//

import UIKit

class MeasurementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var measurementView: MeasurementView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
