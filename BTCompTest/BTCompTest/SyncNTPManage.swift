//
//  SyncNTPManage.swift
//  BTCompTest
//
//  Created by blacktea on 2022/6/9.
//

import Foundation

import NHNetworkTime

@objc class SyncNTPManage : NSObject {
    static let shared = SyncNTPManage()
    var vm: PlayerViewModel?
    private override init() {
    }
    
    func fire() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncCompleteNotification(objct:)), name: NSNotification.Name.init(rawValue: "kNHNetworkTimeSyncCompleteNotification"), object: nil)
        NHNetworkClock.shared().synchronize()
    }
    
    /*
     NTP algorithm
     t1 client request time
     t2 server receive request time
     t3 server response time
     t4 client receive response time
     two way delay = (t2-t1)+(t4-t3)
     offset = ((t2-t1)+(t3-t4))/2
     
     case:
     service time 11;client time 9;offset 2:one way delay 1
     t1 9
     t2 12
     t3 13
     t4 12
     two way delay=(12-9)+(12-13)=2
     offset=((12-9)+(13-12))/2=2

     */
    @objc func syncCompleteNotification(objct : Any) {
        self.vm?.timeOffset = UserDefaults.standard.double(forKey: "kTimeOffsetKey")
        print("timeOffset=",self.vm?.timeOffset ?? "unknow")
    }
}
