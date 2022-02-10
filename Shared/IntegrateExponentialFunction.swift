//
//  IntegrateExponential.swift
//  Monte-Carlo-Exponential-Integral
//
//  Created by Yoshinobu Fujikake on 2/4/22.
//

import Foundation

class IntegralCalculator: NSObject, ObservableObject {
    
    @MainActor @Published var aboveData = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var belowData = [(xPoint: Double, yPoint: Double)]()
    @Published var totalGuessesString = ""
    @Published var guessesString = ""
    @Published var integralString = ""
    @Published var enableButton = true
    
    var intervalStart = 0.0
    var intervalEnd = 1.0
    var finalVal = 0.0
    var guesses = 1
    var totalGuesses = 0
    var totalIntegral = 0.0
    var firstTimeThroughLoop = true
    
    @MainActor init(withData data: Bool){
        
        super.init()
        
        aboveData = []
        belowData = []
        
    }
    
    /// calculate the value of the integral
    ///
    /// - Calculates the Value of exponential decay using Monte Carlo Integration
    ///
    /// - Parameter sender: Any
    func calculateIntegralTotal() async {
        
        var maxGuesses: Int = 0
        let boundingBoxCalculator = BoundingBox() ///Instantiates Class needed to calculate the area of the bounding box.
        
        let lengthOfSide1 = (intervalEnd-intervalStart)
        let lengthOfSide2 = exp(-min(intervalStart,intervalEnd))
        
        
        maxGuesses = guesses
        
        let newValue = await calculateMonteCarloIntegral(intervalStart: intervalStart, intervalEnd: intervalEnd, maxGuesses: maxGuesses)
        
        totalIntegral = totalIntegral + newValue
        
        totalGuesses = totalGuesses + guesses
        
        await updateTotalGuessesString(text: "\(totalGuesses)")
        
        //totalGuessesString = "\(totalGuesses)"
        
        ///Calculates the value of π from the area of a unit circle
        
        finalVal = totalIntegral/Double(totalGuesses) * boundingBoxCalculator.calculateSurfaceArea(numberOfDimensions: 2, lengthOfSide1: lengthOfSide1, lengthOfSide2: lengthOfSide2, lengthOfSide3: 0.0)
        
        await updateFinalValString(text: "\(finalVal)")
        
        //piString = "\(pi)"
        
       
        
    }
    
        
    /// calculateMonteCarloIntegral
    /// Parameter: intervalStart, intervalEnd, maxGuesses
    /// Return: itegralValMC
    /// This function integrates the exponential function in a given interval with Monte Carlo using maxGuesses number of guesses
    /*       _
            /  b   - x
     f  =   |    e
           _/  a
     */
    func calculateMonteCarloIntegral (intervalStart: Double, intervalEnd: Double, maxGuesses: Int) async -> Double {
        
        var numberOfGuesses: Int = 0
        var point = (xPoint: 0.0, yPoint: 0.0)
        var xRange: [Double] = [0.0, 0.0]
        var yRange: [Double] = [0.0, 0.0]
        var guessPoint = 0.0
        var pointsBelowFunc: Int = 0
        
        xRange = [intervalStart, intervalEnd]
        yRange = [0.0, exp(-min(intervalStart,intervalEnd))]
        
        var integralVal = 0.0
        var newAbovePoints : [(xPoint: Double, yPoint: Double)] = []
        var newBelowPoints : [(xPoint: Double, yPoint: Double)] = []
        
        while numberOfGuesses < maxGuesses {
            point.xPoint = Double.random(in: xRange[0]...xRange[1])
            point.yPoint = Double.random(in: yRange[0]...yRange[1])
            
            guessPoint = exp(-point.xPoint)
            
            if (point.yPoint <= guessPoint) {
                pointsBelowFunc += 1
                
                newBelowPoints.append(point)
            } else {
                newAbovePoints.append(point)
            }
            
            numberOfGuesses += 1
        }
        
        //Appended from Dr. Terry's code
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        if ((totalGuesses < 500001) || (firstTimeThroughLoop)){
        
//            insideData.append(contentsOf: newInsidePoints)
//            outsideData.append(contentsOf: newOutsidePoints)
            
            var plotAbovePoints = newAbovePoints
            var plotBelowPoints = newBelowPoints
            
            if (newAbovePoints.count > 750001) {
                
                plotAbovePoints.removeSubrange(750001..<newAbovePoints.count)
            }
            
            if (newBelowPoints.count > 750001){
                plotBelowPoints.removeSubrange(750001..<newBelowPoints.count)
                
            }
            
            await updateData(abovePoints: plotAbovePoints, belowPoints: plotBelowPoints)
            firstTimeThroughLoop = false
        }
        
        integralVal = Double(pointsBelowFunc)
        
        return integralVal
    }
    
    
    /// updateData
    /// The function runs on the main thread so it can update the GUI
    /// - Parameters:
    ///   - insidePoints: points inside the circle of the given radius
    ///   - outsidePoints: points outside the circle of the given radius
    @MainActor func updateData(abovePoints: [(xPoint: Double, yPoint: Double)] , belowPoints: [(xPoint: Double, yPoint: Double)]){
        
        aboveData.append(contentsOf: abovePoints)
        belowData.append(contentsOf: belowPoints)
    }
    
    
    /// updateTotalGuessesString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the number of total guesses
    @MainActor func updateTotalGuessesString(text:String){
        
        self.totalGuessesString = text
        
    }
    
    /// updateFinalValString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of the integral
    @MainActor func updateFinalValString(text:String){
        
        self.integralString = text
        
    }
    
    /// setButton Enable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        
        
        if state {
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = true
                }
            }
            
            
                
        }
        else{
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = false
                }
            }
                
        }
        
    }
    
}
