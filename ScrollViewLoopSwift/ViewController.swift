//
//  ViewController.swift
//  ScrollViewLoopSwift
//
//  Created by Nero Zuo on 15/7/31.
//  Copyright (c) 2015年 Nero Zuo. All rights reserved.
//

import UIKit

func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        delay(seconds: 5) { () -> () in
            println("where is the view")
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let scorllView = NScrollViewLoop(frame: CGRect(x: 0.0, y: 200.0, width: screenWidth, height: 90))
        let model0 = NScrollImageModel()
        model0.image = UIImage(named: "0");
        let model1 = NScrollImageModel()
        model1.image = UIImage(named: "1")
        let model2 = NScrollImageModel()
        model2.image = UIImage(named: "2");
        view.addSubview(scorllView)
        scorllView.layoutViewInScoreViewWithImages([model0, model1, model2])
        scorllView.show()
        scorllView.didSelectItem = { index in
            println("\(index)")
        }
    }


}

