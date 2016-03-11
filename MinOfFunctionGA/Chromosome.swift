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

class SimpleFunctionChromosome: Chromosome, Comparable, CustomStringConvertible {
    var representation: [Gene] = [Gene]()
    
    private struct Numbers{
        static let Accuracy: Double = 100
        static let ChromeSize = 10//how many genes is in chromosome discounting sign
        struct Range {
            static let Max: Double = 10
            static let Min: Double = -10
        }
    }
    
    /*
        init with random number from range
    */
    init(){
        let range = (Numbers.Range.Max-Numbers.Range.Min)
        let randomInt = arc4random_uniform(UInt32(range * Numbers.Accuracy))
        let randomDoubleShifted = Double(randomInt) - (range*Numbers.Accuracy/2)
        self.x = randomDoubleShifted/Numbers.Accuracy
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
                    return Double(-repToNum(rep)!)/Numbers.Accuracy
                }
                return Double(repToNum(rep)!)/Numbers.Accuracy
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
            let numberInt = Int(number! * Numbers.Accuracy)
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
        for _ in 0..<(Numbers.ChromeSize-representation.count){
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
        if let X = x {
            return pow(X, 2) + 2*pow((X+5), 4)
        }
        return nil
    }
    var description: String{
        return "\(representation) \(fitness!)"
    }
}
func < (lhs: SimpleFunctionChromosome, rhs: SimpleFunctionChromosome) -> Bool {
    return lhs.fitness < rhs.fitness
}

func == (lhs: SimpleFunctionChromosome, rhs: SimpleFunctionChromosome) -> Bool {
    return lhs.x == rhs.x
}