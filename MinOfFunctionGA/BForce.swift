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
        var index = SimpleFunctionChromosome.Numbers.Range.Min
        repeat{
            if min == nil || min > SimpleFunctionChromosome.fitnessAtPoint(index){
                min = SimpleFunctionChromosome.funcValAt(index)
            }
            index+=step
        } while index < SimpleFunctionChromosome.Numbers.Range.Max
        return min
    }
}

class BForceC {
    static var min: Double?{
        var min: Double?
        let step = 0.01
        var index = ComplexFunctionChromosome.Numbers.Range.Min
        repeat{
            
            var index2 = ComplexFunctionChromosome.Numbers.Range.Min
            repeat{
                if min == nil || min > ComplexFunctionChromosome.fitnessAtPoint((index,index2)){
                    min = ComplexFunctionChromosome.fitnessAtPoint((index,index2))
                }
                index2+=step
            } while index2 < ComplexFunctionChromosome.Numbers.Range.Max
            
            index+=step
        } while index < ComplexFunctionChromosome.Numbers.Range.Max
        
        return min
    }
}