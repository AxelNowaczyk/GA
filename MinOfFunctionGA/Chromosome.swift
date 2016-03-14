//
//  Chromosome.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 08.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import Foundation

typealias Gene = Bool
protocol Chromosome{
    var fitness: Double? { get }
}
class SimpleFunctionChromosome: Chromosome,Comparable, CustomStringConvertible {
    var representation: [Gene] = [Gene]()
    
    struct Numbers{
        static let Accuracy: Double = 100
        static let ChromeSize = 10//how many genes is in chromosome discounting sign
        static let MaxVal: Double = 150000
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
    static func funcValAt(point: Double) -> Double{
        return pow(point, 2) + 2*pow((point+5), 4)
    }
    static func fitnessAtPoint(point: Double) -> Double{
        return (Numbers.MaxVal-SimpleFunctionChromosome.funcValAt(point))/20000
    }

    var fitness : Double?{ // max fitness for -4 is 7.4991
        if let X = x {
            return (Numbers.MaxVal-SimpleFunctionChromosome.funcValAt(X))/20000
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

/*
        Complex Function
*/
class ComplexFunctionChromosome: Chromosome, Comparable, CustomStringConvertible {
    var representation: ([Gene],[Gene]) = ([Gene](),[Gene]())
    
    struct Numbers{
        static let Accuracy: Double = 100
        static let ChromeSize = 10//how many genes is in chromosome discounting sign
        static let MaxVal: Double = 5000
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
        self.x = (randomDoubleShifted/Numbers.Accuracy,randomDoubleShifted/Numbers.Accuracy)
    }
    
    init(representation: ([Gene],[Gene])){
        self.representation = representation
    }
    init(number1: Double,number2: Double){
        self.x = (number1,number2)
    }
    
    var x : (Double?,Double?){
        get {
            return (decodeArr(representation.0),decodeArr(representation.1))
        }
        set {
            representation = (encodeArr(newValue.0!),encodeArr(newValue.1!))
        }
    }
    private func decodeArr(arr: [Gene]) -> Double?{
        var rep = arr
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
    private func encodeArr(newX: (Double)) -> [Gene]{
        var sign: Bool = false
        var number = newX
        if newX < 0 {
            sign = true
            number = -newX
        }
        let numberInt = Int(number * Numbers.Accuracy)
        return [sign] + numToRep(numberInt)
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
    static func funcValAt(point: (Double,Double)) -> Double{
        let x1 = point.0
        let x2 = point.1
        let firstPart = x1+2*x2-7
        let secondPart = 2*x1+x2-5
        return pow(firstPart, 2) + pow(secondPart, 2)
    }
    static func fitnessAtPoint(point: (Double,Double)) -> Double{
        return (Numbers.MaxVal-ComplexFunctionChromosome.funcValAt(point))
    }
    var fitness : Double?{
        if  x.0 != nil && x.1 != nil {
            return (Numbers.MaxVal-ComplexFunctionChromosome.funcValAt((x.0!,x.1!)))
        }
        return nil
    }
    var description: String{
        return "\(representation) \(fitness!)"
    }
}
func < (lhs: ComplexFunctionChromosome, rhs: ComplexFunctionChromosome) -> Bool {
    return lhs.fitness < rhs.fitness
}

func == (lhs: ComplexFunctionChromosome, rhs: ComplexFunctionChromosome) -> Bool {
    return lhs.x.0 == rhs.x.0 && lhs.x.1 == rhs.x.1
}



