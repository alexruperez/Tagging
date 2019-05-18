# 🏷 Tagging
[![Twitter](https://img.shields.io/badge/contact-@alexruperez-0FABFF.svg?style=flat)](http://twitter.com/alexruperez)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://swift.org)
[![Swift Package Manager Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)

**Tagging** is a library that makes it easy to create *type-safe tags* in Swift.

Categorization is sometimes necessary in our models, so the compiler should be used to help us avoid mistakes.

This library extends [JohnSundell](https://github.com/JohnSundell)/[Identity](https://github.com/JohnSundell/Identity) and is inspired by [mbleigh](https://github.com/mbleigh)/[acts-as-taggable-on](https://github.com/mbleigh/acts-as-taggable-on).

## 🐒 Usage

### The Taggable Protocol

Just conform `Taggable` protocol, and add a `tags` property:

```swift
struct Model: Taggable {
    let tags: [Tag<Article>]
}
```

You can also use `Tags` type alias as type:

```swift
struct Model: Taggable {
    let tags: Tags
}
```

You can also refer to `[Tag<Model>]` as `Model.Tags`.

### The RAW Type

A `Tag` is a String by default, but you can customize it with any `Hashable` type:

```swift
struct IntModel: Taggable {
    typealias RawTag = Int
    let tags: Tags
}
```

### Initialization

You can initialize `Tags` with the raw value:

```swift
let model = Model(tags: ["foo", "bar"])
let intModel = IntModel(tags: [7, 9])
```

`Tag` also becomes `Codable`, `Hashable` and `Equatable` whenever its raw value type conforms to one of those protocols.

### Finding most or least used tags

You can find the most or least used tags by using:

```swift
taggableCollection.mostUsedTags()
taggableCollection.leastUsedTags()
```

You can also filter the results by passing the method a limit, however the default limit is 20.

```swift
taggableCollection.mostUsedTags(10)
taggableCollection.leastUsedTags(10)
```

Or directly get the raw values.

```swift
taggableCollection.mostUsedRawTags()
taggableCollection.leastUsedRawTags()
```

### Finding tagged objects
##### NOTE: By default, find objects tagged with any of the specified tags.

```swift
taggableCollection.tagged(with: "foo")
taggableCollection.tagged(with: ["foo"])
taggableCollection.tagged(with: ["foo", "bar"])
taggableCollection.tagged(with: taggable.tags)
```

### Find tagged objects that matches all given tags
##### NOTE: This only matches tagged objects that have the exact set of specified tags. If a tagged object has additional tags, they are not returned.

```swift
taggableCollection.tagged(with: ["foo", "bar"], match: .all)
taggableCollection.tagged(with: taggable.tags, match: .all)
```

### Find tagged objects that have not been tagged with given tags
```swift
taggableCollection.tagged(with: ["foo", "bar"], match: .none)
taggableCollection.tagged(with: taggable.tags, match: .none)
```

## 📲 Installation

Drag and drop [Tagging.swift](https://github.com/alexruperez/Tagging/blob/master/Sources/Tagging/Tagging.swift) into your Xcode project.

#### Or install it with [Swift Package Manager](https://github.com/apple/swift-package-manager/tree/master/Documentation):

```swift
dependencies: [
    .package(url: "https://github.com/alexruperez/Tagging", from: "0.1.0")
]
```

## ❤️ Etc.

* Contributions are very welcome.
* Attribution is appreciated (let's spread the word!), but not mandatory.

## 👨‍💻 Authors

[JohnSundell](https://github.com/JohnSundell)

[alexruperez](https://github.com/alexruperez)

## 👮‍♂️ License

Tagging and Identity are available under the MIT license. See the LICENSE file for more info.
