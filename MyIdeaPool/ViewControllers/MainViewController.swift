//
//  MainViewController.swift
//  MyIdeaPool
//
//  Created by Star on 2/25/19.
//  Copyright © 2019 TopStar. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainViewController: UIViewController {

    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var viewIdeas: UIView!
    @IBOutlet weak var tableviewIdeas: UITableView!
    
    var ideas = [Idea]()
    var lastPage : Int = 1
    
    // MARK: ------------ VC Life Cycle ----------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllPages()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: ------------ Private Methods --------------
    func initialize () {
        tableviewIdeas.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 150, right: 0)
    }
    
    func getAllPages() {
        struct Holder {
            static var page = 1
        }
        SVProgressHUD.show()
        API.shared.getIdeas(page: Holder.page, progressHUD: false) { (newIdeas, err) in
            if newIdeas != nil {
                newIdeas!.forEach({ (item) in
                    if let existIdea = self.ideas.filter({ (idea) -> Bool in
                        if idea.id == item.id {
                            return true
                        }else {
                            return false
                        }
                    }).first {
                        existIdea.setWith(idea: item)
                    }else {
                        self.ideas.append(item)
                    }
                })
                if Holder.page == self.lastPage {
                    SVProgressHUD.dismiss()
                    self.refresh()
                    Holder.page = 1
                }else {
                    Holder.page += 1
                    self.getAllPages()
                }
            }else if err != nil {
                SVProgressHUD.dismiss()
                self.showAlert(message: err!)
                Holder.page = 1
            }
        }

    }
    func getPage(page: Int, progressHUD : Bool? = true) {
        
        API.shared.getIdeas(page: page, progressHUD: progressHUD) { (newIdeas, err) in
            if newIdeas != nil {
                newIdeas!.forEach({ (item) in
                    if let existIdea = self.ideas.filter({ (idea) -> Bool in
                        if idea.id == item.id {
                            return true
                        }else {
                            return false
                        }
                    }).first {
                        existIdea.setWith(idea: item)
                    }else {
                        self.ideas.append(item)
                    }
                })
            }else if err != nil {
                self.showAlert(message: err!)
            }
            self.refresh()
        }
    }
    
    
    func refresh() {
        if ideas.count > 0 {
            // Sorting by created date
            self.ideas.sort(by: { (first, second) -> Bool in
                if first.created_at! > second.created_at! {
                    return true
                }else {
                    return false
                }
            })
            
            // Sorting by average score
            self.ideas.sort(by: { (first, second) -> Bool in
                if first.average_score! > second.average_score! {
                    return true
                }else {
                    return false
                }
            })

            viewEmpty.isHidden = true
            viewIdeas.isHidden = false

        }else {
            viewEmpty.isHidden = false
            viewIdeas.isHidden = true
        }
        
        lastPage = ideas.count / 10 + (ideas.count % 10 == 0 ? 0 : 1)
        if lastPage < 1 {
           lastPage = 1
        }
        tableviewIdeas.reloadData()
    }


    // MARK: ------------ Action Handlers ---------------

    @IBAction func actionLogout(_ sender: Any) {
        API.shared.logout { (error) in
            if error == nil {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                    AppDelegate.shared.naviVC?.setViewControllers([vc], animated: true)
                    UserManager.shared.isLogined = false
                }
            }else {
                self.showAlert(message: error!)
            }
        }
        
    }
    @IBAction func actionPlus(_ sender: Any) {
    }
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        if let ideaCell = tableView.dequeueReusableCell(withIdentifier: "IdeaTableCell", for: indexPath) as? IdeaTableCell {

            ideaCell.setUp(data: ideas[indexPath.row])
            ideaCell.delegate = self
            cell = ideaCell
        }
        return cell ?? UITableViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        //Bottom Refresh
        if scrollView == tableviewIdeas{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                getPage(page: lastPage + 1, progressHUD: false)
            }
        }
    }
}

extension MainViewController : IdeaTableCellDelegate {
    
    func didSelectedEdit(idea: Idea) {
        let alertController = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        let editButton = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "IdeaViewController") as? IdeaViewController {
                vc.idea = idea
                self.navigationController?.show(vc, sender: self)
            }
        })
        
        let  deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.showAlertYesNo(message: "This idea will be permanently deleted.",
                                title: "Are you sure?",
                                titleYes: "OK", actionYes: {
                                    
                                    API.shared.deletIdea(idea: idea, complete: { (err) in
                                        if err == nil {
                                            if let index = self.ideas.firstIndex(of: idea) {
                                                self.ideas.remove(at: index)
                                                self.refresh()
                                            }
                                        }else {
                                            self.showAlert(message: err!)
                                        }
                                    })
                                    
            }, titleNo: "Cancel", actionNo: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(editButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
