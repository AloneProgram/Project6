//
//  ViewController.swift
//  Project6
//
//  Created by iKnet on 16/7/11.
//  Copyright © 2016年 zzj. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLab: UILabel!
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //允许程序进行定位请求
        locationManager.requestAlwaysAuthorization()
       
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    @IBAction func foundLocation(sender: AnyObject) {
       
        //请求位置
        locationManager.requestLocation()
        //开始更新位置
        locationManager.startUpdatingLocation()
    }

    //定位失败
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationLab.text = "Error while updating location" + error.localizedDescription
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->
            Void in
            
            if(error != nil){  //反编码失败
                self.locationLab.text = "Reverse geocoder failed with error" + error!.localizedDescription
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
            }else {   //接收编码数据失败
                self.locationLab.text = "Problem with the data received from geocoder"
            }
        
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        
        //对地址进行编码
        if let containsPlacemark = placemark {
            //stop updating location to save battery life  停止更新位置节约电量
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            self.locationLab.text = country! +  administrativeArea! +  postalCode! + locality!
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

