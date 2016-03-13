//
//  GraphViewController.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 03.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        
        var x = [Double]()
        var y = [Double]()
        let step = 0.01
        for var index = SimpleFunctionChromosome.Numbers.Range.Min;
            index<SimpleFunctionChromosome.Numbers.Range.Max;index+=step{
                x.append(index)
                y.append(SimpleFunctionChromosome.funcValAt(index))
        }
        setChart(x, values: y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(dataPoints: [Double], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Function")
        let lineChartData = LineChartData(xVals: dataPoints.map{"\(round($0*100)/100)"}, dataSet: lineChartDataSet)
        lineChartDataSet.circleRadius = 0
        lineChartView.data = lineChartData
        
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
