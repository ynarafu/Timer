//
//  ContentView.swift
//  MyTimer
//
//  Created by 楢府佑 on 2023/07/04.
//

import SwiftUI

struct ContentView: View {
    // タイマーの変数
    @State var timerHandler : Timer?
    // カウントの変数
    @State var count = 0
    // 永続化する秒数設定
    @AppStorage("timer_value") var timerValue = 10
    // アラート表示有無
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("backgroundTimer")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                VStack(spacing: 30.0){
                    // テキストの表示
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)
                    HStack {
                        Button {
                            // カウントダウン開始
                            startTimer()
                        } label: {
                            Text("スタート")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("startColor"))
                                .clipShape(Circle())
                        } // スタートボタンここまで
                        Button {
                            // timerhandlerをアンラップしてunwrapedTimerHandlerに代入
                            if let unwrapedTimerHandler = timerHandler{
                                // タイマーが実行中なら停止
                                if unwrapedTimerHandler.isValid == true {
                                    // タイマー停止
                                    unwrapedTimerHandler.invalidate()
                                }
                            }
                        } label: {
                            Text("ストップ")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("stopColor"))
                                .clipShape(Circle())
                        } // ストップボタンここまで
                    } // HStackここまで
                } // VStackここまで
            } // ZStackここまで
            // 画面が表示される時に実行される
            .onAppear{
                // カウントの変数を初期化
                count = 0
            } // onAppearここまで
            // Navigationにボタンを追加
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink{
                        SettingView()
                    } label: {
                        Text("秒数設定")
                    }
                }
            } // toolbarここまで
            // 状態変数showAlertがtrueになった時に表示
            .alert("終了", isPresented: $showAlert){
                Button("OK"){
                    print("OKタップされました")
                }
            } message: {
                Text("タイマー終了時間です")
            }// Alertここまで
        } // NavigationStackここまで
        
    } // bodyここまで
    func countDownTimer(){
        // countをインクリメント
        count += 1
        
        // 残り時間が0以下の時、タイマーを止める
        if timerValue - count <= 0{
            timerHandler?.invalidate()
            
            // アラートの表示
            showAlert = true
        }
    }// countDownTimerここまで
    
    // タイマーをカウントダウン開始する関数
    func startTimer() {
        //timerHandlerをアンラップしてunwrapedTimerHandlerに代入
        if let unwrapedTimerHandler = timerHandler {
            // タイマーが実行中ならスタートしない
            if unwrapedTimerHandler.isValid == true {
                return
            }
        }
        
        //残り時間が0以下の時、countを0に初期化する
        if timerValue - count <= 0 {
            count = 0
        }
        
        //タイマースタート
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            // タイマー実行時に呼び出される
            // 一秒ごとに実行さえてカウントダウンする関数を実行する
            countDownTimer()
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
