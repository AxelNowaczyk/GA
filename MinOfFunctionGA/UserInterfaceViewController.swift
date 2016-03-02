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

        // Do any additional setup after loading the view.
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
                if let vc = segue.destinationViewController as? DetailViewController{
                        print("Switch view")
                }
            case Seques.ShowComplexFunction:
                if let vc = segue.destinationViewController as? DetailViewController{
                    print("Switch view")
                }
            default: break
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
