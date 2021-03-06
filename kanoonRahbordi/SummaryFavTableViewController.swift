//
//  SummaryFavTableViewController.swift
//  kanoonRahbordi
//
//  Created by Tara Tandel on 5/10/1396 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import EFInternetIndicator

class SummaryFavTableViewCell : UITableViewCell{
    @IBOutlet weak var topicOfTheFavedSummary: UILabel!
    
    @IBOutlet weak var PDFImage: UIImageView!
}

class SummaryFav {
    var Rid = Int()
    var TeacherName = String()
    var LessonSummaryTitle = String()
}

class SummaryFavTableViewController: UITableViewController, NVActivityIndicatorViewable, InternetStatusIndicable {
    
    
    let rColor = UIColor(red: 255/255, green: 89/255, blue: 0/255, alpha: 1.0)
    
    var internetConnectionIndicator:InternetViewIndicator?
    var sumcrsid = Int()
    var sumsbjid = Int()
    var groupCode = Int()
    var id: Int = 0
    var favList = [SummaryFav]()
    var currentIndexPath = Int()
    
    @IBOutlet var favSumList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: 50, height: 50)
        self.startMonitoringInternet(backgroundColor: rColor, style: .StatusLine, textColor:UIColor.white, message:"اینترنت خود را بررسی کنید")

        let url = "http://www.kanoon.ir/Amoozesh/api/Document/GetFavoriteLessonSummaryNbA?userId=\(id)&groupcode=\(groupCode)&sumcrsid=\(sumcrsid)&sumsbjid=\(sumsbjid)"
        self.startAnimating(size, message: " بارگیری خلاصه‌های مورد علاقه...", type: .triangleSkewSpin, color: self.rColor, textColor: .white)
        getFavInfo(URl: url){
            response, error in
            if response != nil{
                self.favList.append(response!)
                self.favSumList.reloadData()
                self.stopAnimating()
            }
            self.stopAnimating()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summfav", for: indexPath) as! SummaryFavTableViewCell
        
        cell.PDFImage?.image = #imageLiteral(resourceName: "pdf")
        cell.topicOfTheFavedSummary?.text = "\(favList[indexPath.row].TeacherName) \n \(favList[indexPath.row].LessonSummaryTitle)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath.row
        performSegue(withIdentifier: "webView", sender: self)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func getFavInfo (URl : String , completionHandler : @escaping (SummaryFav?, Error?) -> ()){
        Alamofire.request(URl).responseJSON{
            response in
            switch response.result{
            case .success(let value):
                let jsonValue = JSON(value)
                if let jsonArray = jsonValue.array{
                    for items in jsonArray {
                        let faveInfo = SummaryFav()
                        faveInfo.Rid = items["Rid"].int!
                        faveInfo.LessonSummaryTitle = items["LessonSummaryTitle"].string!
                        faveInfo.TeacherName = items["TeacherName"].string!
                        completionHandler(faveInfo, nil )
                    }
                }
            case . failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webView"{
            let pdfView = segue.destination as! PDFViewController
            pdfView.url = "http://www.kanoon.ir/Amoozesh/Films/Download?id=\(favList[currentIndexPath].Rid)&type=1"
            pdfView.nameOftheTeacher.text = "\(favList[currentIndexPath].TeacherName)"
        }
    }
    
    
}
