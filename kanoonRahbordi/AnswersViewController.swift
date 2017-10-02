//
//  AnswersViewController.swift
//  kanoonRahbordi
//
//  Created by negar on 96/Mordad/10 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit
import PINRemoteImage
import NVActivityIndicatorView
import EFInternetIndicator
class AnswersViewController: UIViewController, NVActivityIndicatorViewable, InternetStatusIndicable  {
    let rColor = UIColor(red: 255/255, green: 89/255, blue: 0/255, alpha: 1.0)
    let size = CGSize(width: 50, height: 50)

    var internetConnectionIndicator:InternetViewIndicator?
    var answersUrl = [String]()
    
    var answerNum = Int()
    
    @IBOutlet weak var warning: UILabel!
    
    @IBOutlet weak var ansImg: UIImageView!
    
    @IBOutlet weak var previousA: UIButton!
    
    @IBOutlet weak var nextA: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startMonitoringInternet(backgroundColor: rColor, style: .StatusLine, textColor:UIColor.white, message:"اینترنت خود را بررسی کنید")

        self.answerNum = 0
        
        previousA.setImage(#imageLiteral(resourceName: "previous"), for: .normal)
        nextA.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        
        self.warning.text = "پاسخ سوال \(self.answerNum+1)"
        self.getImg(imgUrl: answersUrl[answerNum], img: ansImg)
        // Do any additional setup after loading the view.
    }

    @IBAction func previousAnswer(_ sender: UIButton) {
        if self.answerNum>0 {
            self.answerNum -= 1
            self.warning.text = "پاسخ سوال \(self.answerNum+1)"
            self.startAnimating(size, message: "بارگیری پاسخ‌ها...", type: .triangleSkewSpin, color: .orange, textColor: .white)

            self.getImg(imgUrl: answersUrl[answerNum], img: ansImg)
            self.stopAnimating()
        }else {
            self.warning.text = "پاسخ اول است."
        }
    }
    
    @IBAction func nextAnswer(_ sender: UIButton) {
        if self.answerNum<9{
            self.answerNum += 1
            self.warning.text = "پاسخ سوال \(self.answerNum+1)"
            self.startAnimating(size, message: "در حال احراز هویت...", type: .triangleSkewSpin, color: self.rColor, textColor: .white)

            self.getImg(imgUrl: answersUrl[answerNum], img: ansImg)
            self.stopAnimating()

        }else {
            self.warning.text = "پاسخ ها تمام است."
        }
    }
    
    func getImg(imgUrl : String, img: UIImageView) {
        img.pin_setImage(from: URL(string: imgUrl), completion: { (result) in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
