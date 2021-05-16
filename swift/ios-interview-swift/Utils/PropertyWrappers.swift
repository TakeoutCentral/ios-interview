//
//  PropertyWrappers.swift
//  Takeout Central Driver App
//
//  Created by Mike on 12/8/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

@propertyWrapper
class RxSignal<Value> {
    var projectedValue: PublishSubject<Value> { subject }
    var wrappedValue: Signal<Value> {
        subject.asObservable()
            .retry() // Ignore errors
            .asSignal(onErrorSignalWith: .never())
    }

    private let subject = PublishSubject<Value>()
}

@propertyWrapper
class RxDriver<Value> {
    var projectedValue: BehaviorSubject<Value> { subject }
    var wrappedValue: Driver<Value> {
        subject.asObservable()
            .retry() // Ignore errors
            .asDriver(onErrorDriveWith: .never())
    }

    private let subject: BehaviorSubject<Value>
    init(_ value: Value) {
        subject = BehaviorSubject(value: value)
    }
}

@propertyWrapper
class AnyPublisher<Value> {
    var projectedValue: PublishSubject<Value> { subject }
    var wrappedValue: Observable<Value> {
        subject.asObservable()
    }

    private let subject = PublishSubject<Value>()
}

@propertyWrapper
class AnyBehavior<Value> {
    var projectedValue: BehaviorSubject<Value> { subject }
    var wrappedValue: Observable<Value> {
        subject.asObservable()
    }

    private let subject: BehaviorSubject<Value>
    init(_ value: Value) {
        subject = BehaviorSubject(value: value)
    }
}
