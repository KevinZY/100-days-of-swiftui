//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 张洋 on 2022/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State var correctAnswer = Int.random(in: 0...2)
    
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var showingAlert = false
    @State var gameEnd = false
    @State var score = 0
    @State var round = 1
    let limit = 3
    
    @State var flagDegrees:Double = 0
    @State var tappedFlagNumber = -1
    
    func nextRound(){
        round += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tappedFlagNumber = -1
    }
    
    fileprivate func flagTapped(_ number: Int) {
        flagDegrees += 360
        tappedFlagNumber = number
        computingScore(tappedIndex: number)
        if round >= limit {
            gameEnd = true
            alertTitle = "GG"
            alertMessage = "Your final score is: \(score)"
        }else{
            if(number == correctAnswer) {
                alertTitle = "Correct"
                alertMessage = "Congratulation!"
            }else{
                alertTitle = "Wrong, that's the flag of \(countries[number])"
                alertMessage = "The correct answer is No.\(correctAnswer + 1)"
            }
        }
        showingAlert = true
    }
    
    func computingScore(tappedIndex number: Int){
        if(number == correctAnswer) {
            score += 1
        }else{
            score -= 1
        }
    }
    
    var body: some View {
        ZStack {
//            Color.blue.ignoresSafeArea()
//            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
//            RadialGradient(stops: [.init(color: .blue, location: 0.3), .init(color: .black, location: 0.3)], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag").font(.largeTitle.weight(.bold)).foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        //使用.weight来控制字重
                        Text("Tap the flag. Round \(round)/\(limit)").font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
//                    .foregroundColor(.white)
                    //使用.foregroundStyle(.secondary)可以透出一点底色
                    .foregroundStyle(.secondary)
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countries[number])
                        }.alert(alertTitle, isPresented: $showingAlert) {
                            //⚠️alert 放在哪都没关系，只和监听的isPresented有关
                            //TODO: 重构一下发牌和新游戏逻辑
                            Button(role: .cancel) {
                                if gameEnd {
                                    round = 0
                                    gameEnd = false
                                    score = 0
                                    gameEnd = false
                                }
                                nextRound()
                            } label: {
                                if gameEnd{
                                    Text("New Game")
                                }else{
                                    Text("OK")
                                }
                                
                            }
                        } message: {
                            Text(alertMessage)
                        }
                        .opacity((tappedFlagNumber == -1 || tappedFlagNumber == number) ? 1 : 0.25)
                        .animation(.easeIn, value: tappedFlagNumber)
                        .rotation3DEffect(Angle.degrees(flagDegrees), axis: (x: 0, y: 1, z: 0))
                        .animation(tappedFlagNumber == number ? .easeIn : nil, value: flagDegrees)
                        .scaleEffect((tappedFlagNumber == -1 || tappedFlagNumber == number) ? 1 : 0.75, anchor: .center)
                        .animation(.interpolatingSpring(stiffness: 10, damping: 1).speed(10), value: tappedFlagNumber)
                        

                    }
                }
                //⚠️使用.frame来控制Stack的外形
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                //⚠️多个Spacer会平均分配剩余空间，使用连续两个来控制占位
                Spacer()
                Spacer()
                Text("Score \(score)").prominentTitle(.white)
                Spacer()
            }.padding()
        }
    }
}



extension View {
    func prominentTitle(_ color: Color) -> some View{
        modifier(ProminentTitle(color))
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
