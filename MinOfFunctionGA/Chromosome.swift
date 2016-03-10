//
//  Chromosome.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 08.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import Foundation

typealias Gene = Bool

protocol Chromosome {
    /*
        representes as first bit - sign 
        and the rest is represented as int that is equal to bottom of number * accuracy
    */
    var representation : [Gene] { get set }
    var fitness : Double? { get }
    var x : Double? { get set }
}

class SimpleFunctionChromosome: Chromosome {
    var representation: [Gene] = [Gene]()
    
    private struct Constants{
        static let Accuracy: Double = 100
        static let ChromeSize = 10//how many genes is in chromosome discounting sign
    }
    
    init(representation: [Gene]){
        self.representation = representation
    }
    init(number: Double){
        self.x = number
    }
    
    var x : Double?{
        get {
            var rep = representation
            if !rep.isEmpty{
                let sign = rep.first
                rep.removeFirst()
                if sign == true{
                    return Double(-repToNum(rep)!)/Constants.Accuracy
                }
                return Double(repToNum(rep)!)/Constants.Accuracy
            }
            return nil
        }
        set {
            var sign: Bool = false
            var number = newValue
            if newValue < 0 {
                sign = true
                number = -newValue!
            }
            let numberInt = Int(number! * Constants.Accuracy)
            representation = [sign] + numToRep(numberInt)
        }
    }
    private func numToRep(number: Int) -> [Gene]{
        var representation = [Gene]()
        let numStr = String(number, radix: 2)
        for bit in numStr.characters{
            if bit == "0"{
                representation.append(false)
            } else {
                representation.append(true)
            }
        }
        /*
            to make all of the representations the same size
        */
        for _ in 0..<(Constants.ChromeSize-representation.count){
            representation.insert(false, atIndex: 0)
        }
        return representation
    }
    private func repToNum(rep: [Gene]) -> Int?{
        var stringRep = ""
        var representation = rep
        if representation.count < 1{
            return nil
        }
        while !representation.isEmpty {
            if representation.first == true{
                stringRep+="1"
            } else {
                stringRep+="0"
            }
            representation.removeFirst()
        }
        return Int(strtoul(stringRep, nil, 2))
    }
    var fitness : Double?{
//          returns the value of the function for this x
        if let X = x {
            return pow(X, 2) + 2*pow((X+5), 4)
        }
        return nil
    }
}