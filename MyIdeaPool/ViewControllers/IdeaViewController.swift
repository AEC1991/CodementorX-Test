//
//  IdeaViewController.swift
//  MyIdeaPool
//
//  Created by Star on 2/26/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {

    @IBOutlet weak var txtviewContent: UITextView!
    @IBOutlet weak var lblImpact: UILabel!
    @IBOutlet weak var lblEase: UILabel!
    @IBOutlet weak var lblConfidence: UILabel!
    @IBOutlet weak var lblAvg: UILabel!
    
    var idea : Idea?
    
    // MARK: ----------------- VC Life Cycle ----------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initialize()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: -------------------- Private Methods --------------------
    func initialize() -> Void {
        txtviewContent.text = idea?.content ?? ""
        lblImpact.text = "\(idea?.impact ?? 10 )"
        lblEase.text = "\(idea?.ease ?? 10 )"
        lblConfidence.text = "\(idea?.confidence ?? 10 )"
        lblAvg.text = "\(((idea?.average_score) != nil) ? String(format: "%.1f", idea!.average_score!) : "10" )"
    }
    
    private func isValid() -> Bool {
        var result = true
        var message = ""
        
        let content = txtviewContent.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let impact = Int(lblImpact.text ?? "0")
        let ease = Int(lblEase.text ?? "0")
        let confidence = Int(lblConfidence.text ?? "0")

        if content == "" || content.count > 255 {
            message = "The content must be at least minimum 1 character, maximum 255 characters."
            result = false
        }
        if result == true, (impact! < 1 || impact! > 10) {
            message = "The impact must be at least integer between 1 to 10, 10 being the highest impact"
            result = false
        }
        if result == true, (ease! < 1 || ease! > 10) {
            message = "The ease must be at least integer between 1 to 10, 10 being the easiest ease"
            result = false
        }
        if result == true, (confidence! < 1 || confidence! > 10) {
            message = "The confidence must be at least integer between 1 to 10, 10 being the most confidence"
            result = false
        }

        
        if result == false {
            self.showAlert(message: message)
        }
        return result
    }

    
    
    // MARK: -------------------- Action Handlers --------------------
    @IBAction func actionSave(_ sender: Any) {
        
        guard isValid() == true else { return }

        let idea = self.idea ?? Idea()
        idea.content = txtviewContent.text?.trimmingCharacters(in: .whitespaces)
        idea.impact = Int(lblImpact.text!)
        idea.ease = Int(lblEase.text!)
        idea.confidence = Int(lblConfidence.text!)
        
        API.shared.updateIdea(idea: idea) { (newIdea, err) in
            if err == nil {
                idea.setWith(idea: newIdea)
                self.actionBack(self)
            }else {
                self.showAlert(message: err!)
            }
        }
        
    }
    @IBAction func actionCancel(_ sender: Any) {
        self.actionBack(self)
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
