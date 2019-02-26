//
//  IdeaTableCell.swift
//  MyIdeaPool
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit

protocol IdeaTableCellDelegate {
    func didSelectedEdit (idea : Idea) -> Void
}

class IdeaTableCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblImpact: UILabel!
    @IBOutlet weak var lblEase: UILabel!
    @IBOutlet weak var lblConfidence: UILabel!
    @IBOutlet weak var lblAvg: UILabel!
    
    var idea : Idea!
    var delegate : IdeaTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(data : Idea) {
        idea = data
        
        lblContent.text = idea.content
        lblImpact.text = "\(idea.impact!)"
        lblEase.text = "\(idea.ease!)"
        lblConfidence.text = "\(idea.confidence!)"
        lblAvg.text = String(format: "%.1f", idea.average_score!)
        
        viewContent.layer.cornerRadius = 10.0
        viewContent.layer.borderColor = UIColor.init(red: 151/255, green: 151/255, blue: 151/255, alpha: 0.17).cgColor
        viewContent.layer.borderWidth = 1.0
        viewContent.layer.shadowColor = UIColor.black.cgColor
        viewContent.layer.shadowOpacity = 0.33
        viewContent.layer.shadowRadius = 3
        viewContent.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        viewContent.layer.masksToBounds = false
        
    }

    @IBAction func actionEdit(_ sender: Any) {
        delegate?.didSelectedEdit(idea: idea)
    }
}
