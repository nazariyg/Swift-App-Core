// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: API.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

public struct APIError {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var errorID: String {
    get {return _errorID ?? String()}
    set {_errorID = newValue}
  }
  /// Returns true if `errorID` has been explicitly set.
  public var hasErrorID: Bool {return self._errorID != nil}
  /// Clears the value of `errorID`. Subsequent reads from it will return its default value.
  public mutating func clearErrorID() {self._errorID = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _errorID: String? = nil
}

public struct APIResult {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var type: APIResult.ResultType {
    get {return _storage._type ?? .success}
    set {_uniqueStorage()._type = newValue}
  }
  /// Returns true if `type` has been explicitly set.
  public var hasType: Bool {return _storage._type != nil}
  /// Clears the value of `type`. Subsequent reads from it will return its default value.
  public mutating func clearType() {_uniqueStorage()._type = nil}

  public var result: OneOf_Result? {
    get {return _storage._result}
    set {_uniqueStorage()._result = newValue}
  }

  public var payload: Data {
    get {
      if case .payload(let v)? = _storage._result {return v}
      return SwiftProtobuf.Internal.emptyData
    }
    set {_uniqueStorage()._result = .payload(newValue)}
  }

  public var error: APIError {
    get {
      if case .error(let v)? = _storage._result {return v}
      return APIError()
    }
    set {_uniqueStorage()._result = .error(newValue)}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public enum OneOf_Result: Equatable {
    case payload(Data)
    case error(APIError)

  #if !swift(>=4.1)
    public static func ==(lhs: APIResult.OneOf_Result, rhs: APIResult.OneOf_Result) -> Bool {
      switch (lhs, rhs) {
      case (.payload(let l), .payload(let r)): return l == r
      case (.error(let l), .error(let r)): return l == r
      default: return false
      }
    }
  #endif
  }

  public enum ResultType: SwiftProtobuf.Enum {
    public typealias RawValue = Int
    case success // = 1
    case failure // = 2

    public init() {
      self = .success
    }

    public init?(rawValue: Int) {
      switch rawValue {
      case 1: self = .success
      case 2: self = .failure
      default: return nil
      }
    }

    public var rawValue: Int {
      switch self {
      case .success: return 1
      case .failure: return 2
      }
    }

  }

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

#if swift(>=4.2)

extension APIResult.ResultType: CaseIterable {
  // Support synthesized by the compiler.
}

#endif  // swift(>=4.2)

public struct APIPayloadlessResult {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var type: APIPayloadlessResult.ResultType {
    get {return _storage._type ?? .success}
    set {_uniqueStorage()._type = newValue}
  }
  /// Returns true if `type` has been explicitly set.
  public var hasType: Bool {return _storage._type != nil}
  /// Clears the value of `type`. Subsequent reads from it will return its default value.
  public mutating func clearType() {_uniqueStorage()._type = nil}

  public var error: APIError {
    get {return _storage._error ?? APIError()}
    set {_uniqueStorage()._error = newValue}
  }
  /// Returns true if `error` has been explicitly set.
  public var hasError: Bool {return _storage._error != nil}
  /// Clears the value of `error`. Subsequent reads from it will return its default value.
  public mutating func clearError() {_uniqueStorage()._error = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public enum ResultType: SwiftProtobuf.Enum {
    public typealias RawValue = Int
    case success // = 1
    case failure // = 2

    public init() {
      self = .success
    }

    public init?(rawValue: Int) {
      switch rawValue {
      case 1: self = .success
      case 2: self = .failure
      default: return nil
      }
    }

    public var rawValue: Int {
      switch self {
      case .success: return 1
      case .failure: return 2
      }
    }

  }

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

#if swift(>=4.2)

extension APIPayloadlessResult.ResultType: CaseIterable {
  // Support synthesized by the compiler.
}

#endif  // swift(>=4.2)

public struct APIBool {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var value: Bool {
    get {return _value ?? false}
    set {_value = newValue}
  }
  /// Returns true if `value` has been explicitly set.
  public var hasValue: Bool {return self._value != nil}
  /// Clears the value of `value`. Subsequent reads from it will return its default value.
  public mutating func clearValue() {self._value = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _value: Bool? = nil
}

public struct APIString {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var value: String {
    get {return _value ?? String()}
    set {_value = newValue}
  }
  /// Returns true if `value` has been explicitly set.
  public var hasValue: Bool {return self._value != nil}
  /// Clears the value of `value`. Subsequent reads from it will return its default value.
  public mutating func clearValue() {self._value = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _value: String? = nil
}

public struct APIInt {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var value: Int64 {
    get {return _value ?? 0}
    set {_value = newValue}
  }
  /// Returns true if `value` has been explicitly set.
  public var hasValue: Bool {return self._value != nil}
  /// Clears the value of `value`. Subsequent reads from it will return its default value.
  public mutating func clearValue() {self._value = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _value: Int64? = nil
}

public struct APIDouble {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var value: Double {
    get {return _value ?? 0}
    set {_value = newValue}
  }
  /// Returns true if `value` has been explicitly set.
  public var hasValue: Bool {return self._value != nil}
  /// Clears the value of `value`. Subsequent reads from it will return its default value.
  public mutating func clearValue() {self._value = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _value: Double? = nil
}

public struct APIUser {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var userID: String {
    get {return _userID ?? String()}
    set {_userID = newValue}
  }
  /// Returns true if `userID` has been explicitly set.
  public var hasUserID: Bool {return self._userID != nil}
  /// Clears the value of `userID`. Subsequent reads from it will return its default value.
  public mutating func clearUserID() {self._userID = nil}

  public var name: String {
    get {return _name ?? String()}
    set {_name = newValue}
  }
  /// Returns true if `name` has been explicitly set.
  public var hasName: Bool {return self._name != nil}
  /// Clears the value of `name`. Subsequent reads from it will return its default value.
  public mutating func clearName() {self._name = nil}

  public var email: String {
    get {return _email ?? String()}
    set {_email = newValue}
  }
  /// Returns true if `email` has been explicitly set.
  public var hasEmail: Bool {return self._email != nil}
  /// Clears the value of `email`. Subsequent reads from it will return its default value.
  public mutating func clearEmail() {self._email = nil}

  public var measurementSystem: String {
    get {return _measurementSystem ?? String()}
    set {_measurementSystem = newValue}
  }
  /// Returns true if `measurementSystem` has been explicitly set.
  public var hasMeasurementSystem: Bool {return self._measurementSystem != nil}
  /// Clears the value of `measurementSystem`. Subsequent reads from it will return its default value.
  public mutating func clearMeasurementSystem() {self._measurementSystem = nil}

  public var alterUserIds: [String] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _userID: String? = nil
  fileprivate var _name: String? = nil
  fileprivate var _email: String? = nil
  fileprivate var _measurementSystem: String? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension APIError: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIError"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "error_id"),
  ]

  public var isInitialized: Bool {
    if self._errorID == nil {return false}
    return true
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self._errorID)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._errorID {
      try visitor.visitSingularStringField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIError, rhs: APIError) -> Bool {
    if lhs._errorID != rhs._errorID {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension APIResult: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIResult"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "type"),
    2: .same(proto: "payload"),
    3: .same(proto: "error"),
  ]

  fileprivate class _StorageClass {
    var _type: APIResult.ResultType? = nil
    var _result: APIResult.OneOf_Result?

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _type = source._type
      _result = source._result
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public var isInitialized: Bool {
    return withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._type == nil {return false}
      if case .error(let v)? = _storage._result, !v.isInitialized {return false}
      return true
    }
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularEnumField(value: &_storage._type)
        case 2:
          if _storage._result != nil {try decoder.handleConflictingOneOf()}
          var v: Data?
          try decoder.decodeSingularBytesField(value: &v)
          if let v = v {_storage._result = .payload(v)}
        case 3:
          var v: APIError?
          if let current = _storage._result {
            try decoder.handleConflictingOneOf()
            if case .error(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._result = .error(v)}
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._type {
        try visitor.visitSingularEnumField(value: v, fieldNumber: 1)
      }
      switch _storage._result {
      case .payload(let v)?:
        try visitor.visitSingularBytesField(value: v, fieldNumber: 2)
      case .error(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      case nil: break
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIResult, rhs: APIResult) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._type != rhs_storage._type {return false}
        if _storage._result != rhs_storage._result {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension APIResult.ResultType: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "SUCCESS"),
    2: .same(proto: "FAILURE"),
  ]
}

extension APIPayloadlessResult: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIPayloadlessResult"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "type"),
    2: .same(proto: "error"),
  ]

  fileprivate class _StorageClass {
    var _type: APIPayloadlessResult.ResultType? = nil
    var _error: APIError? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _type = source._type
      _error = source._error
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public var isInitialized: Bool {
    return withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._type == nil {return false}
      if let v = _storage._error, !v.isInitialized {return false}
      return true
    }
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularEnumField(value: &_storage._type)
        case 2: try decoder.decodeSingularMessageField(value: &_storage._error)
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._type {
        try visitor.visitSingularEnumField(value: v, fieldNumber: 1)
      }
      if let v = _storage._error {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIPayloadlessResult, rhs: APIPayloadlessResult) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._type != rhs_storage._type {return false}
        if _storage._error != rhs_storage._error {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension APIPayloadlessResult.ResultType: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "SUCCESS"),
    2: .same(proto: "FAILURE"),
  ]
}

extension APIBool: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIBool"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public var isInitialized: Bool {
    if self._value == nil {return false}
    return true
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularBoolField(value: &self._value)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._value {
      try visitor.visitSingularBoolField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIBool, rhs: APIBool) -> Bool {
    if lhs._value != rhs._value {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension APIString: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIString"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public var isInitialized: Bool {
    if self._value == nil {return false}
    return true
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self._value)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._value {
      try visitor.visitSingularStringField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIString, rhs: APIString) -> Bool {
    if lhs._value != rhs._value {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension APIInt: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIInt"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public var isInitialized: Bool {
    if self._value == nil {return false}
    return true
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt64Field(value: &self._value)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._value {
      try visitor.visitSingularInt64Field(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIInt, rhs: APIInt) -> Bool {
    if lhs._value != rhs._value {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension APIDouble: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIDouble"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public var isInitialized: Bool {
    if self._value == nil {return false}
    return true
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularDoubleField(value: &self._value)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._value {
      try visitor.visitSingularDoubleField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIDouble, rhs: APIDouble) -> Bool {
    if lhs._value != rhs._value {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension APIUser: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "APIUser"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "user_id"),
    2: .same(proto: "name"),
    3: .same(proto: "email"),
    4: .standard(proto: "measurement_system"),
    5: .standard(proto: "alter_user_ids"),
  ]

  public var isInitialized: Bool {
    if self._userID == nil {return false}
    if self._name == nil {return false}
    if self._measurementSystem == nil {return false}
    return true
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self._userID)
      case 2: try decoder.decodeSingularStringField(value: &self._name)
      case 3: try decoder.decodeSingularStringField(value: &self._email)
      case 4: try decoder.decodeSingularStringField(value: &self._measurementSystem)
      case 5: try decoder.decodeRepeatedStringField(value: &self.alterUserIds)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._userID {
      try visitor.visitSingularStringField(value: v, fieldNumber: 1)
    }
    if let v = self._name {
      try visitor.visitSingularStringField(value: v, fieldNumber: 2)
    }
    if let v = self._email {
      try visitor.visitSingularStringField(value: v, fieldNumber: 3)
    }
    if let v = self._measurementSystem {
      try visitor.visitSingularStringField(value: v, fieldNumber: 4)
    }
    if !self.alterUserIds.isEmpty {
      try visitor.visitRepeatedStringField(value: self.alterUserIds, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: APIUser, rhs: APIUser) -> Bool {
    if lhs._userID != rhs._userID {return false}
    if lhs._name != rhs._name {return false}
    if lhs._email != rhs._email {return false}
    if lhs._measurementSystem != rhs._measurementSystem {return false}
    if lhs.alterUserIds != rhs.alterUserIds {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
