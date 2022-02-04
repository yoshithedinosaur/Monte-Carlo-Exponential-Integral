//
//  IntegrateExponential.swift
//  Monte-Carlo-Exponential-Integral
//
//  Created by Yoshinobu Fujikake on 2/4/22.
//

import Foundation

class IntegralCalculator: ObservableObject {
    
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
        let boundingBoxCalculator = BoundingBox() /// Instantiates class needed to calculate the integral
        
        var integralValMC = 0.0
        
        
        
        return integralValMC
    }
    
}
