//
//  BForce.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 14.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import Foundation

class BForce {
    static var min: Double?{
        var min: Double?
        let step = 0.01
        for var index = SimpleFunctionChromosome.Numbers.Range.Min;
            index<SimpleFunctionChromosome.Numbers.Range.Max;index+=step{
                if min == nil || min > SimpleFunctionChromosome.fitnessAtPoint(index){
                    min = SimpleFunctionChromosome.funcValAt(index)
                }
        }
        return min
    }
}

class BForceC {
    static var min: Double?{
        var min: Double?
        let step = 0.01
        for var index = ComplexFunctionChromosome.Numbers.Range.Min;
            index<ComplexFunctionChromosome.Numbers.Range.Max;index+=step{
                for var index2 = ComplexFunctionChromosome.Numbers.Range.Min;
                    index2<ComplexFunctionChromosome.Numbers.Range.Max;index2+=step{
                        if min == nil || min > ComplexFunctionChromosome.fitnessAtPoint((index,index2)){
                            min = ComplexFunctionChromosome.fitnessAtPoint((index,index2))
                        }
                }
        }
        return min
    }
}