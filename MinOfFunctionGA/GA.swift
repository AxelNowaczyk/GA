//
//  GA.swift
//  MinOfFunctionGA
//
//  Created by Axel Nowaczyk on 10.03.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//


/*
https://www.youtube.com/watch?v=I2heTejQP58&list=PLea0WJq13cnARQILcbHUPINYLy1lOSmjH

*/


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
    
    private func crossoverChrom(firstBef: Chromosome,secondBef: Chromosome) -> (Chromosome,Chromosome){
        
        var better: SimpleFunctionChromosome
        var worse: SimpleFunctionChromosome
        
        if firstBef.fitness < secondBef.fitness{
            worse = firstBef as! SimpleFunctionChromosome
            better = secondBef as! SimpleFunctionChromosome
        } else {
            better = firstBef as! SimpleFunctionChromosome
            worse = secondBef as! SimpleFunctionChromosome
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
                    futurePop.append(better as! SimpleFunctionChromosome)
                    futurePop.append(worse as! SimpleFunctionChromosome)
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
    private func mutateChrom(element: Chromosome) -> Chromosome{
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
            mutatedPopulation.append(mutateChrom(chrom) as! SimpleFunctionChromosome)
            
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