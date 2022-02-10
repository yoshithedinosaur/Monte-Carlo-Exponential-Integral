//
//  ContentView.swift
//  Shared
//
//  Created by Yoshi Fujikake on 2/10/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var finalVal = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var intervalStart = 0.0
    @State var intervalEnd = 1.0
    @State var guessString = "23458"
    @State var totalGuessString = "0"
    @State var integralString = "0.0"
    
    
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var monteCarlo = IntegralCalculator(withData: true)
    
    //Setup the GUI View
    var body: some View {
        HStack{
            
            VStack{
                
                VStack(alignment: .center) {
                    Text("Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Guesses", text: $guessString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("Total Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Total Guesses", text: $totalGuessString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("Integral output")
                        .font(.callout)
                        .bold()
                    TextField("# output", text: $integralString)
                        .padding()
                }
                
                Button("Cycle Calculation", action: {Task.init{await self.calculateIntegralVal()}})
                    .padding()
                    .disabled(monteCarlo.enableButton == false)
                
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    .disabled(monteCarlo.enableButton == false)
                
                if (!monteCarlo.enableButton){
                    
                    ProgressView()
                }
                
                
            }
            .padding()
            
            Spacer()
            
        }
    }
    
    func calculateIntegralVal() async {
        
        
        monteCarlo.setButtonEnable(state: false)
        
        monteCarlo.guesses = Int(guessString)!
        monteCarlo.intervalStart = intervalStart
        monteCarlo.intervalEnd = intervalEnd
        monteCarlo.totalGuesses = Int(totalGuessString) ?? Int(0.0)
        
        await monteCarlo.calculateIntegralTotal()
        
        totalGuessString = monteCarlo.totalGuessesString
        
        integralString =  monteCarlo.integralString
        
        monteCarlo.setButtonEnable(state: true)
        
    }
    
    func clear(){
        
        guessString = "23458"
        totalGuessString = "0.0"
        integralString =  ""
        monteCarlo.totalGuesses = 0
        monteCarlo.totalIntegral = 0.0
        monteCarlo.aboveData = []
        monteCarlo.belowData = []
        monteCarlo.firstTimeThroughLoop = true
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 
