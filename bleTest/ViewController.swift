//
//  UIViewViewController.swift
//  bleTest
//
//  Created by 阿騰 on 2022/2/14.
//

import UIKit
import CoreBluetooth
class ViewController: NSObject,ObservableObject {
    var centralManager:CBCentralManager!
    @Published var peripheralsArr=[String:CBPeripheral]()
    
    func setUP(){
        centralManager = CBCentralManager(delegate: self, queue: nil) //
    }
    func starScan(){ //不要直接啟動，在 centralManagerDidUpdateState 確認 central.state 為 .poweredOn 時呼叫
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true]) //
    }
    func stop(){
        self.centralManager.stopScan() //停止掃描、當 centralManagerDidUpdateState 的 central.state 為 .poweredOff
    }
    func connect(peripheral: CBPeripheral){
        centralManager.connect(peripheral, options: nil) //nil連接不指定 UUID
    }
}
extension ViewController:CBCentralManagerDelegate{
    //peripheral
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // 藍芽狀態判斷
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
            stop()
        case .poweredOn:
            print("poweredOn")
            starScan()
        @unknown default:
            fatalError()
        }
        
    }
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        //當偵測到東西
        if(peripheral.name == nil || peripheral.name?.count == 0)
        {
            return
        }
        //        print(peripheral.name as! String)
        peripheralsArr[peripheral.name!] = peripheral
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        //連接成功時呼叫
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("連接失敗")
        print(error)
    }
    
}

extension ViewController:CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //連接的裝置有發好 Services
        print(peripheral.services)
    }
}
