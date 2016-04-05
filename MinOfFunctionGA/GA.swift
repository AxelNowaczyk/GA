//
//  GA.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 10.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//
import Foundation

protocol GA: CustomStringConvertible{
    var description: String{ get }
    func crossover()
    func mutate()
    init()
}

class SimpleFunctionGA: GA {
    private struct Numbers{
        static let PopSize = 10
        static let crossProb = 0.75
        static let mutProb = 0.15
    }
    var population = [SimpleFunctionChromosome]()
    private var randomPercent: Double{
        return Double(arc4random_uniform(100))/100
    }
    
    private func crossoverChrom(firstBef: SimpleFunctionChromosome,secondBef: SimpleFunctionChromosome) -> (SimpleFunctionChromosome,SimpleFunctionChromosome){
        
        var better: SimpleFunctionChromosome
        var worse: SimpleFunctionChromosome
        
        if firstBef.fitness < secondBef.fitness{
            worse = firstBef
            better = secondBef
        } else {
            better = firstBef
            worse = secondBef
        }
        let crossPoint = Int(arc4random_uniform(UInt32(firstBef.representation.count)))
        let betterToReturn = SimpleFunctionChromosome(representation: better.representation)
        better.representation.removeRange(0..<crossPoint)
        worse.representation.replaceRange(crossPoint..<betterToReturn.representation.count, with: better.representation)
        return (betterToReturn, worse)
    }
    func crossover() {
        var currentPop = population
        var futurePop = [SimpleFunctionChromosome]()
        while(!currentPop.isEmpty){
            let randIndex1 = ruletteWheelSelection(currentPop)
            let randIndex2 = ruletteWheelSelection(currentPop)

            if randIndex1 != randIndex2 {
                futurePop.append(SimpleFunctionChromosome(representation: currentPop[randIndex1!].representation))
                futurePop.append(SimpleFunctionChromosome(representation: currentPop[randIndex2!].representation))
                if randomPercent<Numbers.crossProb{
                    let (better,worse) = crossoverChrom(currentPop[randIndex1!], secondBef: currentPop[randIndex2!])
                    futurePop.append(better)
                    futurePop.append(worse)
                }
                if randIndex1 > randIndex2 {
                    currentPop.removeAtIndex(randIndex1!)
                    currentPop.removeAtIndex(randIndex2!)
                } else {
                    currentPop.removeAtIndex(randIndex2!)
                    currentPop.removeAtIndex(randIndex1!)
                }
            } else if currentPop.count == 1{
                futurePop.append(currentPop[0])
            }
            
        }
        futurePop = futurePop.sort().reverse()
        futurePop.removeRange(Numbers.PopSize..<futurePop.count) // select best after crossover
        population = futurePop
    }
    func ruletteWheelSelection(population: [SimpleFunctionChromosome]) -> Int?{
        var sum = 0
        for i in population{
            sum += Int(i.fitness!)
        }
        let rand = Int(arc4random_uniform(UInt32(sum)))
        sum = 0
        for i in 0..<population.count{
            sum += Int(population[i].fitness!)
            if sum > rand {
                return i
            }
        }
        return nil
    }
    private func mutateChrom(element: SimpleFunctionChromosome) -> SimpleFunctionChromosome{
        var representation = [Bool]()
        for bit in element.representation{
            if(randomPercent<Numbers.mutProb){
                representation.append(!bit)
            } else {
                representation.append(bit)
            }
        }
        return SimpleFunctionChromosome(representation: representation)
    }
    func mutate(){
        var mutatedPopulation = [SimpleFunctionChromosome]()
        for chrom in population{
            mutatedPopulation.append(mutateChrom(chrom))
            
        }
        population = mutatedPopulation
    }
    required init(){
        var newElement = SimpleFunctionChromosome()
        for _ in 0..<Numbers.PopSize{
            while population.contains(newElement){
                newElement = SimpleFunctionChromosome()
            }
            population.append(newElement)
        }
        population = population.sort().reverse()
    }
    func doGenerations(numberOfGene: Int){
        for _ in 0..<numberOfGene{
            self.crossover()
            self.mutate()
            self.population = population.sort().reverse()
        }
    }
    func doGeneration(){
        doGenerations(1)
    }
    var description: String{
        var str = ""
        for chrom in population{
            str+=chrom.description+"\n"
        }
        return str
    }
}
class ComplexFunctionGA: GA {
    private struct Numbers{
        static let PopSize = 10
        static let crossProb = 0.75
        static let mutProb = 0.15
    }
    var population = [ComplexFunctionChromosome]()
    private var randomPercent: Double{
        return Double(arc4random_uniform(100))/100
    }
    
    private func crossoverChrom(firstBef: ComplexFunctionChromosome,secondBef: ComplexFunctionChromosome) -> (ComplexFunctionChromosome,ComplexFunctionChromosome){
        
        var better: ComplexFunctionChromosome
        var worse: ComplexFunctionChromosome

        if firstBef.fitness < secondBef.fitness{
            worse = firstBef
            better = secondBef
        } else {
            better = firstBef
            worse = secondBef
        }
        let choiceOfSelection = Int(arc4random_uniform(3))
        let betterToReturn = ComplexFunctionChromosome(representation: better.representation)
        if choiceOfSelection == 0 || choiceOfSelection == 2{
            let crossPoint = Int(arc4random_uniform(UInt32(firstBef.representation.0.count)))
            better.representation.0.removeRange(0..<crossPoint)
            worse.representation.0.replaceRange(crossPoint..<betterToReturn.representation.0.count, with: better.representation.0)
        }
        if choiceOfSelection == 1 || choiceOfSelection == 2{
            let crossPoint = Int(arc4random_uniform(UInt32(firstBef.representation.1.count)))
            better.representation.1.removeRange(0..<crossPoint)
            worse.representation.1.replaceRange(crossPoint..<betterToReturn.representation.1.count, with: better.representation.1)
        }
        return (betterToReturn, worse)
    }
    func crossover() {
        var currentPop = population
        var futurePop = [ComplexFunctionChromosome]()
        while(!currentPop.isEmpty){
            let randIndex1 = ruletteWheelSelection(currentPop)
            let randIndex2 = ruletteWheelSelection(currentPop)
            
            if randIndex1 != randIndex2 {
                futurePop.append(ComplexFunctionChromosome(representation: currentPop[randIndex1!].representation))
                futurePop.append(ComplexFunctionChromosome(representation: currentPop[randIndex2!].representation))
                if randomPercent<Numbers.crossProb{
                    let (better,worse) = crossoverChrom(currentPop[randIndex1!], secondBef: currentPop[randIndex2!])
                    futurePop.append(better)
                    futurePop.append(worse)
                }
                if randIndex1 > randIndex2 {
                    currentPop.removeAtIndex(randIndex1!)
                    currentPop.removeAtIndex(randIndex2!)
                } else {
                    currentPop.removeAtIndex(randIndex2!)
                    currentPop.removeAtIndex(randIndex1!)
                }
            } else if currentPop.count == 1{
                futurePop.append(currentPop[0])
            }
            
        }
        futurePop = futurePop.sort().reverse()
        futurePop.removeRange(Numbers.PopSize..<futurePop.count) // select best after crossover
        population = futurePop
    }
    func ruletteWheelSelection(population: [ComplexFunctionChromosome]) -> Int?{
        var sum = 0
        for i in population{
            sum += Int(i.fitness!)
        }
        let rand = Int(arc4random_uniform(UInt32(sum)))
        sum = 0
        for i in 0..<population.count{
            sum += Int(population[i].fitness!)
            if sum > rand {
                return i
            }
        }
        return nil
    }
    private func mutateChrom(element: ComplexFunctionChromosome) -> ComplexFunctionChromosome{
        var representation = ([Bool](),[Bool]())
        for bit in element.representation.0{
            if(randomPercent<Numbers.mutProb){
                representation.0.append(!bit)
            } else {
                representation.0.append(bit)
            }
        }
        for bit in element.representation.1{
            if(randomPercent<Numbers.mutProb){
                representation.1.append(!bit)
            } else {
                representation.1.append(bit)
            }
        }
        return ComplexFunctionChromosome(representation: representation)
    }
    func mutate(){
        var mutatedPopulation = [ComplexFunctionChromosome]()
        for chrom in population{
            mutatedPopulation.append(mutateChrom(chrom))
            
        }
        population = mutatedPopulation
    }
    required init(){
        var newElement = ComplexFunctionChromosome()
        for _ in 0..<Numbers.PopSize{
            while population.contains(newElement){
                newElement = ComplexFunctionChromosome()
            }
            population.append(newElement)
        }
        population = population.sort().reverse()
    }
    func doGenerations(numberOfGene: Int){
        for _ in 0..<numberOfGene{
            self.crossover()
            self.mutate()
            self.population = population.sort().reverse()
        }
    }
    func doGeneration(){
        doGenerations(1)
    }
    var description: String{
        var str = ""
        for chrom in population{
            str+=chrom.description+"\n"
        }
        return str
    }
}