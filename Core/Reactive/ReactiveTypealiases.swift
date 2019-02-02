// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import ReactiveSwift
import Result
import ReactiveCocoa

public typealias Sp<Value> = SignalProducer<Value, NoError>
public typealias SpEr<Value> = SignalProducer<Value, E>

public typealias Si<Value> = Signal<Value, NoError>
public typealias SiEr<Value> = Signal<Value, E>

public typealias Ev<Value> = Signal<Value, NoError>.Event
public typealias EvEr<Value> = Signal<Value, E>.Event

public typealias Ob<Value> = Signal<Value, NoError>.Observer
public typealias ObEr<Value> = Signal<Value, E>.Observer

public typealias Re<Value> = Result<Value, NoError>
public typealias ReEr<Value> = Result<Value, E>

public typealias Pr<Value> = Property<Value>
public typealias Mp<Value> = MutableProperty<Value>

public typealias Di = Disposable
public typealias Cd = CompositeDisposable
