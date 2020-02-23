//
//  Copyright © 2020 Schnaub. All rights reserved.
//

import Foundation

struct MemoryCache<Key: Hashable, Value> {

  private let backingCache = NSCache<WrappedKey, Entry>()

  subscript(key: Key) -> Value? {
    get {
      value(forKey: key)
    }
    set {
      guard let value = newValue else {
        removeValue(forKey: key)
        return
      }
      insert(value, forKey: key)
    }
  }

  init(name: String = "") {
    backingCache.name = name
  }

  func clear() {
    backingCache.removeAllObjects()
  }

  private func insert(_ value: Value, forKey key: Key) {
    backingCache.setObject(Entry(value: value), forKey: WrappedKey(key: key))
  }

  private func value(forKey key: Key) -> Value? {
    let entry = backingCache.object(forKey: WrappedKey(key: key))
    return entry?.value
  }

  private func removeValue(forKey key: Key) {
    backingCache.removeObject(forKey: WrappedKey(key: key))
  }

}

extension MemoryCache {

  private class WrappedKey: NSObject {

    private let key: Key

    override var hash: Int {
      key.hashValue
    }

    init(key: Key) {
      self.key = key
    }

    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else {
        return false
      }
      return value.key == key
    }
  }

  private class Entry {

    let value: Value

    init(value: Value) {
      self.value = value
    }

  }

}