//
//  ViewController.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/14/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = .blackTranslucent
        navBar?.tintColor = UIColor.white

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

