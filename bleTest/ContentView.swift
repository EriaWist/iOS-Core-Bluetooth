//
//  ContentView.swift
//  bleTest
//
//  Created by 阿騰 on 2022/2/14.
//
import SwiftUI
import CoreBluetooth
struct ContentView: View {
    @ObservedObject var bluetoothUIKitConverters = ViewController()
    var body: some View {
        VStack {
            List(bluetoothUIKitConverters.peripheralsArr.keys.sorted().map { String($0)}, id: \.self){i in
                Button(i, action: {
                    bluetoothUIKitConverters.connect(peripheral: bluetoothUIKitConverters.peripheralsArr[i]!)
                })
            }
            
        }.onAppear(perform: {
            bluetoothUIKitConverters.setUP()
        })
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


