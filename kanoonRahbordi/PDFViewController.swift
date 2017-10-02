//
//  PDFViewController.swift
//  kanoonRahbordi
//
//  Created by Tara Tandel on 4/31/1396 AP.
//  Copyright © 1396 negar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EFInternetIndicator

class PDFViewController: UIViewController,UIWebViewDelegate, NVActivityIndicatorViewable, InternetStatusIndicable {

    let rColor = UIColor(red: 255/255, green: 89/255, blue: 0/255, alpha: 1.0)
    var teacherName = String()
    
    @IBOutlet weak var nameOftheTeacher: UILabel!

    var internetConnectionIndicator:InternetViewIndicator?
    var webView: UIWebView!
    var url = String()
    override func viewDidLoad() {

        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let size = CGSize(width: 50, height: 50)
        
        self.startAnimating(size, message: "بارگیری خلاصه دروس...", type: .triangleSkewSpin, color: self.rColor, textColor: .white)

        nameOftheTeacher.text = teacherName
        let heightOption = (self.navigationController?.navigationBar.bounds.size.height)! + (nameOftheTeacher.bounds.size.height)
        
        let frameSize = CGRect(x: CGFloat(0), y:heightOption, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - heightOption)
        self.startMonitoringInternet(backgroundColor: rColor, style: .StatusLine, textColor:UIColor.white, message:"اینترنت خود را بررسی کنید")
        let urlstr : URL! = URL(string: url)
        webView = UIWebView(frame: frameSize)
        webView.delegate = self
        view.addSubview(webView)
        webView.loadRequest(URLRequest(url: urlstr))

//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(shareTapped))
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        webView.scrollView.contentInset = UIEdgeInsets.zero;

    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        let size = CGSize(width: 50, height: 50)

        self.startAnimating(size, message: "بارگیری خلاصه دروس...", type: .triangleSkewSpin, color: self.rColor, textColor: .white)

    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        nameOftheTeacher.text = "خطایی رخ داده دوباره امتحان کنید."
        self.stopAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

