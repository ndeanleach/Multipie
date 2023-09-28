//
//  ContentView.swift
//  Multipie
//
//  Created by Nathan Leach on 1/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @FocusState private var isFocused
    
    @State private var animationAmount = 0.0
    
    @State private var x = 2
    @State private var y = Int.random(in: 2...12)
    
    @State private var score = 0
    
    @State private var questions = [5, 10, 20]
    @State private var qAmount = 5
    @State private var qAsked = 0
    
    @State private var qAnswer = 0
    
    @State private var settings = true
    
    @State private var alertTitle = ""
    @State private var message = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView{
            ZStack{
                RadialGradient(colors: [.blue, .green], center: .bottom, startRadius: 100, endRadius: 350)
                    .ignoresSafeArea()
                VStack {
                    Section{
                        if settings{
                            Text("What number are you multiplying?")
                            Picker("Choose a number", selection: $x){
                                ForEach(2..<13, id: \.self){num in
                                    Text("\(num)")
                                }
                            }
                            .pickerStyle(.segmented)
                            .transition(.asymmetric(insertion: .scale, removal: .scale))
                            Text("How many questions would you like?")
                            Picker("How many questions would you like?", selection: $qAmount){
                                ForEach(questions, id: \.self){num in
                                    Text("\(num)")
                                }
                            }
                            .pickerStyle(.segmented)
                            .transition(.asymmetric(insertion: .scale, removal: .scale))
                        }
                    }
                    
                    Spacer()
                    
                    Section{
                        Button(settings ? "Start New Game" : "Reset"){
                            withAnimation{
                                settings.toggle()
                                score = 0
                                qAsked = 0
                            }
                        }
                            .frame(width: 130, height: 40)
                            .background(.cyan)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 20)
                        
                        if !settings{
                            HStack{
                                Text("Score")
                                Text("\(score)")
                                    .font(.system(size: 30).bold())
                                    .foregroundColor(.blue)
                            }
                            Text("What is \(x) * \(y)?")
                                .frame(width:250, height: 150)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .font(.system(size: 30).bold())
                                .shadow(radius: 20)
                                .transition(.asymmetric(insertion: .scale, removal: .scale))
                            HStack{
                                TextField("000", value: $qAnswer, formatter: NumberFormatter())
                                    .padding(10)
                                    .frame(width: 110, height: 65)
                                    .background(.thinMaterial)
                                    .font(.system(size: 45))
                                    .clipShape(RoundedRectangle(cornerRadius: 40))
                                    .keyboardType(.numberPad)
                                    .focused($isFocused)
                                    .shadow(radius: 20)
                                    .transition(.asymmetric(insertion: .scale, removal: .scale))
                                Button(action: {
                                    onAnswerSubmit(qAnswer)
                                    withAnimation{
                                        animationAmount += 360
                                    }
                                }){
                                    VStack{
                                        Image("frog")
                                            .renderingMode(.original)
                                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                                        Text("Check")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .navigationTitle("MultiPie")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        isFocused = false
                    }
                }
            }
            .alert(alertTitle, isPresented: $showingAlert){
                Button("Continue", action: onResetContinue)
            } message: {
                Text("\(message)")
            }
        }
    }
    
    func onAnswerSubmit (_ number: Int){
        showingAlert = true
        
        if qAsked ==  qAmount{
            alertTitle = "Game Over!"
            message = """
            Your score is \(score).
            Press continue to play again!
            """
            score = 0
            withAnimation{
                settings = true
            }
        }else if qAnswer == x * y {
            alertTitle = "Correct"
            message = "Score + 1"
            score += 1
        } else {
            alertTitle = "Sorry, that's not correct."
            message = "Score is still \(score)"
        }
    }
    
    func onResetContinue () {
        y = Int.random(in: 1...12)
        qAnswer = 0
        qAsked += 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
