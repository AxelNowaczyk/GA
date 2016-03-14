//
//  AnalizeCViewController.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 14.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import UIKit
import Charts

class AnalizeCViewController: UIViewController {
    
    @IBOutlet var chartView: LineChartView!
    var complexFunction = ComplexFunctionGA()
    let maxGeneration = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false;
        
        var generations = [Int]()
        var bestFits = [Double]()
        var worstFits = [Double]()
        var avgFits = [Double]()
        var sum: Double = 0
        var best: Double = complexFunction.population[0].fitness!
        var worst: Double = complexFunction.population[0].fitness!
        for index in 0..<maxGeneration{
            for chrom in complexFunction.population{
                sum+=chrom.fitness!
                if chrom.fitness < worst{
                    worst = chrom.fitness!
                }
                if chrom.fitness > best{
                    best = chrom.fitness!
                }
            }
            generations.append(index)
            bestFits.append(best)
            worstFits.append(worst)
            avgFits.append(sum/Double(complexFunction.population.count))
            complexFunction.doGeneration()
            best = complexFunction.population[0].fitness!
            worst = complexFunction.population[0].fitness!
            sum = 0
        }
        setChart(generations, values1: bestFits, values2: worstFits, values3: avgFits, label1: "Best Fits", label2: "Worst Fits", label3: "Avg Fits", color1: UIColor.blueColor(), color2: UIColor.brownColor(), color3: UIColor.yellowColor())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func prepDataSet(dataPoints: [Int],values: [Double],label: String,color: UIColor) -> LineChartDataSet{
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: label)
        lineChartDataSet.setColor(color)
        lineChartDataSet.circleRadius = 1
        return lineChartDataSet
    }
    
    func setChart(dataPoints: [Int], values1: [Double], values2: [Double], values3: [Double], label1: String, label2: String, label3: String,color1: UIColor,color2: UIColor,color3: UIColor) {
        
        let lineChartDataSet1 = prepDataSet(dataPoints, values: values1, label: label1, color: color1)
        let lineChartDataSet2 = prepDataSet(dataPoints, values: values2, label: label2, color: color2)
        let lineChartDataSet3 = prepDataSet(dataPoints, values: values3, label: label3, color: color3)
        
        let lineChartData = LineChartData(xVals: Array(0...(maxGeneration+1)).map{"\($0)"}, dataSet: lineChartDataSet1)
        lineChartData.addDataSet(lineChartDataSet2)
        lineChartData.addDataSet(lineChartDataSet3)
        chartView.data = lineChartData
    }
}

