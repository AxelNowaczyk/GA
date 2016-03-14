//
//  UserInterfaceViewController.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 02.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import UIKit

class UserInterfaceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private struct Seques{
        static let ShowSimpleFunction = "ShowSimpleFunction"
        static let ShowComplexFunction = "ShowComplexFunction"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier{
                
            case Seques.ShowSimpleFunction:
                print("Switch ShowSimpleFunction")
//                if let vc = segue.destinationViewController as? GenerationsViewController{
//                    
//                }
            case Seques.ShowComplexFunction:
                print("Switch ShowComplexFunction")
//                if let vc = segue.destinationViewController as? GenerationsViewController{
//                    
//                }
            default: break
            }
        }
    }
}
