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
    func crossoverChrom(firstBef: Chromosome,secondBef: Chromosome) -> (Chromosome,Chromosome)
    func crossover()
    func mutateChrom(element: Chromosome) -> Chromosome
    func mutate()
    func initialize()
}

class SimpleFunctionGA: GA {
    private struct Numbers{
        static let maxGeneration = 30
        static let PopSize = 30
        static let crossProb = 0.8
        static let mutProb = 0.1
    }
    var population = [SimpleFunctionChromosome]()
    private var randomPercent: Double{
        return Double(arc4random_uniform(100))/100
    }
    
    func crossoverChrom(firstBef: Chromosome,secondBef: Chromosome) -> (Chromosome,Chromosome){
        
        var better: SimpleFunctionChromosome
        var worse: SimpleFunctionChromosome
        
        if firstBef.fitness > secondBef.fitness{
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
            let randIndex1 = Int(arc4random_uniform(UInt32(currentPop.count)))
            let randIndex2 = Int(arc4random_uniform(UInt32(currentPop.count)))
            if randIndex1 != randIndex2 {
                if randomPercent<Numbers.crossProb{
                    let (better,worse) = crossoverChrom(currentPop[randIndex1], secondBef: currentPop[randIndex2])
                    futurePop.append(better as! SimpleFunctionChromosome)
                    futurePop.append(worse as! SimpleFunctionChromosome)
                } else {
                    futurePop.append(currentPop[randIndex1])
                    futurePop.append(currentPop[randIndex2])
                }
                if randIndex1 > randIndex2 {
                    currentPop.removeAtIndex(randIndex1)
                    currentPop.removeAtIndex(randIndex2)
                } else {
                    currentPop.removeAtIndex(randIndex2)
                    currentPop.removeAtIndex(randIndex1)
                }
            } else if currentPop.count == 1{
                futurePop.append(currentPop[0])
            }
        }
        population = futurePop.sort()
    }
    
    func mutateChrom(element: Chromosome) -> Chromosome{
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
    func mutate(){//dont mutate best
        var mutatedPopulation = [SimpleFunctionChromosome]()
        var addedFirstElement = false// find out better way to do this
        for chrom in population{
            if !addedFirstElement{
                mutatedPopulation.append(chrom)
                addedFirstElement = true
            } else{
                mutatedPopulation.append(mutateChrom(chrom) as! SimpleFunctionChromosome)
            }
        }
        population = mutatedPopulation
    }
    func initialize(){
        var newElement = SimpleFunctionChromosome()
        for _ in 0..<Numbers.PopSize{
            while population.contains(newElement){
                newElement = SimpleFunctionChromosome()
            }
            population.append(newElement)
        }
        population = population.sort()
    }
    static func doGenerations(numberOfGene: Int){
        let sfGA = SimpleFunctionGA()
        sfGA.initialize()
        print(sfGA)
        for index in 0..<numberOfGene{
            sfGA.crossover()
            sfGA.mutate()
            sfGA.population.sortInPlace()
            print("\n Next Generation \(index+1) \n")
            print(sfGA)
        }
    }
    static func doGeneration(){
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