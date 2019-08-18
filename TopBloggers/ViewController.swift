//
//  ViewController.swift
//  TopBloggers
//
//  Created by IMCS on 8/6/19.
//  Copyright © 2019 IMCS. All rights reserved.
//

import UIKit
import WebKit

import Foundation
import SystemConfiguration


class ViewController: UIViewController {
    
    var receiveBlog = BlogStruct()
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TitleLabel.text = receiveBlog.title
        webView.loadHTMLString(receiveBlog.content, baseURL: nil)
    }


}



//AIzaSyCrrMwzVeV2Br8VpLiS0cZwrXaK4ImpYlI
