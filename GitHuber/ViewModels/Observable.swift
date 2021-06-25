//
//  Observable.swift
//  GitHuber
//
//  Created by Lukas Adomavicius on 6/25/21.
//

import Foundation

class Observable<T> {

    typealias Closure = ((T)->())
    var value: T {
        didSet {
            DispatchQueue.main.async { [value] in
                self.binder?(value)
            }
        }
    }

    private var binder: Closure?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ binding: @escaping Closure) {
        binding(value)
        self.binder = binding
    }
}
