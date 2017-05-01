//
//  CLLocationManager+Rx.swift
//  RxExample
//
//  Created by Carlos García on 8/7/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

final class RxCLLocationManagerDelegateProxy: DelegateProxy, CLLocationManagerDelegate, DelegateProxyType {

    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let locationManager: CLLocationManager = object as! CLLocationManager
        return locationManager.delegate
    }

    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let locationManager: CLLocationManager = object as! CLLocationManager
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
}

extension Reactive where Base: CLLocationManager {

    /**
     Reactive wrapper for `delegate`.

     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var delegate: DelegateProxy {
        return RxCLLocationManagerDelegateProxy.proxyForObject(base)
    }

    // MARK: Responding to Location Events

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didUpdateLocations: Observable<[CLLocation]> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { item in
                return try castOrThrow([CLLocation].self, item[1])
        }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFailWithError: Observable<NSError> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:)))
            .map { item in
                return try castOrThrow(NSError.self, item[1])
        }
    }

    #if os(iOS) || os(macOS)
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishDeferredUpdatesWithError: Observable<NSError?> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFinishDeferredUpdatesWithError:)))
            .map { item in
                return try castOptionalOrThrow(NSError.self, item[1])
        }
    }
    #endif

    #if os(iOS)

    // MARK: Pausing Location Updates

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didPauseLocationUpdates: Observable<Void> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidPauseLocationUpdates(_:)))
    .map { _ in
    return ()
    }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didResumeLocationUpdates: Observable<Void> {
    return delegate.methodInvoked( #selector(CLLocationManagerDelegate.locationManagerDidResumeLocationUpdates(_:)))
    .map { _ in
    return ()
    }
    }

    // MARK: Responding to Heading Events

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didUpdateHeading: Observable<CLHeading> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateHeading:)))
    .map { item in
    return try castOrThrow(CLHeading.self, item[1])
    }
    }

    // MARK: Responding to Region Events

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didEnterRegion: Observable<CLRegion> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didEnterRegion:)))
    .map { item in
    return try castOrThrow(CLRegion.self, item[1])
    }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didExitRegion: Observable<CLRegion> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didExitRegion:)))
    .map { item in
    return try castOrThrow(CLRegion.self, item[1])
    }
    }

    #endif

    #if os(iOS) || os(macOS)

    /**
     Reactive wrapper for `delegate` message.
     */
    @available(OSX 10.10, *)
    public var didDetermineStateForRegion: Observable<(state: CLRegionState, region: CLRegion)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didDetermineState:for:)))
            .map { item in
                let stateNumber = try castOrThrow(NSNumber.self, item[1])
                let state = CLRegionState(rawValue: stateNumber.intValue) ?? CLRegionState.unknown
                let region = try castOrThrow(CLRegion.self, item[2])
                return (state: state, region: region)
        }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var monitoringDidFailForRegionWithError: Observable<(region: CLRegion?, error: NSError)> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:monitoringDidFailFor:withError:)))
            .map { item in
                let region = try castOptionalOrThrow(CLRegion.self, item[1])
                let error = try castOrThrow(NSError.self, item[2])
                return (region: region, error: error)
        }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didStartMonitoringForRegion: Observable<CLRegion> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didStartMonitoringFor:)))
            .map { item in
                return try castOrThrow(CLRegion.self, item[1])
        }
    }

    #endif

    #if os(iOS)

    // MARK: Responding to Ranging Events

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didRangeBeaconsInRegion: Observable<(beacons: [CLBeacon], region: CLBeaconRegion)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didRangeBeacons:in:)))
    .map { item in
    let beacons = try castOrThrow([CLBeacon].self, item[1])
    let region = try castOrThrow(CLBeaconRegion.self, item[2])
    return (beacons: beacons, region: region)
    }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var rangingBeaconsDidFailForRegionWithError: Observable<(region: CLBeaconRegion, error: NSError)> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:rangingBeaconsDidFailFor:withError:)))
    .map { item in
    let region = try castOrThrow(CLBeaconRegion.self, item[1])
    let error = try castOrThrow(NSError.self, item[2])
    return (region: region, error: error)
    }
    }

    // MARK: Responding to Visit Events

    /**
     Reactive wrapper for `delegate` message.
     */
    @available(iOS 8.0, *)
    public var didVisit: Observable<CLVisit> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didVisit:)))
    .map { item in
    return try castOrThrow(CLVisit.self, item[1])
    }
    }

    #endif

    // MARK: Responding to Authorization Changes

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { item in
                let number = try castOrThrow(NSNumber.self, item[1])
                return CLAuthorizationStatus(rawValue: Int32(number.intValue)) ?? .notDetermined
        }
    }

}

fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}

fileprivate func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }

    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
