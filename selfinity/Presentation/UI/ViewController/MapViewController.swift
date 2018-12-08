

//
//  MapViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    fileprivate var myLocationManager:CLLocationManager!
    fileprivate var pinByLongPress:MKPointAnnotation!
    var repositories: ReminderModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied {
            return
        }
        if status == CLAuthorizationStatus.notDetermined {
            myLocationManager = CLLocationManager()
            myLocationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            myLocationManager = CLLocationManager()
            myLocationManager.delegate = self
            myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            if #available(iOS 9.0, *) {
                myLocationManager.requestLocation()
                self.configPin()
            }
        }
    }
    
    fileprivate func configPin() {
        if let latitude = self.repositories?.latitude,let longitude = self.repositories?.longitude, latitude != 0.0, longitude != 0.0 {
            pinByLongPress = MKPointAnnotation()
            let center = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(CLLocationDegrees(longitude)))
            pinByLongPress.coordinate = center
            let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(center, mySpan)
            mapView.region = myRegion
            mapView.addAnnotation(pinByLongPress)
            let circle = MKCircle(center: center, radius: 1000)
            mapView.add(circle)
        } else {
            pinByLongPress = MKPointAnnotation()
            let center = CLLocationCoordinate2DMake(CLLocationDegrees(myLocationManager.location?.coordinate.latitude ?? 0), CLLocationDegrees(CLLocationDegrees(myLocationManager.location?.coordinate.longitude ?? 0)))
            pinByLongPress.coordinate = center
            let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(center, mySpan)
            mapView.region = myRegion
            mapView.addAnnotation(pinByLongPress)
            let circle = MKCircle(center: center, radius: 1000)
            mapView.add(circle)
        }
        
    }
    
    @IBAction func longPressMap(_ sender: UILongPressGestureRecognizer) {
        
        if(sender.state != UIGestureRecognizerState.began){
            return
        }
        pinByLongPress = MKPointAnnotation()
        let location:CGPoint = sender.location(in: mapView)
        let longPressedCoordinate:CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(longPressedCoordinate, mySpan)
        mapView.region = myRegion
        pinByLongPress.coordinate = longPressedCoordinate
        mapView.addAnnotation(pinByLongPress)
        let circle = MKCircle(center: longPressedCoordinate, radius: 1000)
        mapView.add(circle)
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        circleRenderer.strokeColor = Constant.chatWaveColor
        circleRenderer.fillColor = UIColor(red: 0, green: 122, blue: 255, alpha: 0.2)
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation === mapView.userLocation {
            (annotation as? MKUserLocation)?.title = nil
            return nil
        } else {
            let identifier = "annotation"
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
                return annotationView
            } else {
                let myPinIdentifier = "PinAnnotationIdentifier"
                let pinByLongPress = MKPointAnnotation()
                let annotationView = MKPinAnnotationView(annotation: pinByLongPress, reuseIdentifier: myPinIdentifier)
                annotationView.animatesDrop = true
                
                return annotationView
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 許可を求めるコードを記述する（後述）
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            self.repositories.longitude = CGFloat(location.coordinate.longitude)
            self.repositories.latitude = CGFloat(location.coordinate.latitude)
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse:
//            // 位置情報の取得開始
//            myLocationManager.startUpdatingLocation()
//            break
//
//            // ・・・省略・・・
//        }
//   }
}
