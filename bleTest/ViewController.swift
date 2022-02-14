//
//  UIViewViewController.swift
//  bleTest
//
//  Created by 阿騰 on 2022/2/14.
//

import UIKit
import CoreBluetooth
class ViewController: UIViewController,ObservableObject {
    var centralManager:CBCentralManager!
    @Published var peripheralsArr=[String:CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        // Do any additional setup after loading the view.
    }
    
    func setUP(){
        centralManager = CBCentralManager(delegate: self, queue: nil) //
    }
    func starScan(){
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true]) //
    }
    func stop(){
        self.centralManager.stopScan() //
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
    
    
}
