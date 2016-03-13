//
//  GenesViewController.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 03.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import UIKit
import Charts

class GenerationsViewController: UIViewController {

    @IBOutlet weak var generationsView: LineChartView!
    var simpleFunction = SimpleFunctionGA()
    let maxGeneration = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var generations = [Int]()
        var values = [Double]()
        for index in 0..<maxGeneration{
            for chrom in simpleFunction.population{
                generations.append(index)
                values.append(chrom.fitness!)
            }
            print(simpleFunction)
            simpleFunction.doGeneration()
        }
        setChart(generations, values: values)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(dataPoints: [Int], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
        let lineChartData = LineChartData(xVals: Array(0...(maxGeneration+1)), dataSet: lineChartDataSet)
        generationsView.data = lineChartData
    }
}
