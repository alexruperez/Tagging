# 🏷 Tagging
[![Twitter](https://img.shields.io/badge/contact-@alexruperez-0FABFF.svg?style=flat)](http://twitter.com/alexruperez)
[![Swift](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://swift.org)
[![Swift Package Manager Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)

Welcome to **Tagging**, a small library that makes it easy to create *type-safe tags* in Swift.
Categorization are often very useful for our models, so leveraging the compiler to ensure that they're used in a correct manner can go a long way to making the model layer of an app or system more robust.

This library is **strongly** inspired by [JohnSundell](https://github.com/JohnSundell)/[🆔 Identity](https://github.com/JohnSundell/Identity) and [mbleigh](https://github.com/mbleigh)/[acts-as-taggable-on](https://github.com/mbleigh/acts-as-taggable-on), for theoretical information, check out *["Type-safe identifiers in Swift"](https://www.swiftbysundell.com/posts/type-safe-identifiers-in-swift)* on [Swift by Sundell](https://www.swiftbysundell.com).

## Making types taggable

All you have to do to use Tagging is to make a model conform to `Taggable`, and give it an `tags` property, like this:

```swift
struct Article: Taggable {
    let tags: [Tag<Article>]
    let title: String
}
```

And just like that, the above `Article` tags are now type-safe! Thanks to Swift’s type inference capabilities, it’s also possible to implement an `Taggable` type’s `tags` simply by using `Tags` as its type:

```swift
struct Article: Taggable {
    let tags: Tags
    let title: String
}
```

The `Tags` type alias is automatically added for all `Taggable` types, which also makes it possible to refer to `[Tag<Article>]` as `Article.Tags`.

## Customizing the raw type

`Tag` values are backed by strings by default, but that can easily be customized by giving an `Taggable` type a `RawTag`, but must be at least `Hashable`:

```swift
struct Article: Taggable {
    typealias RawTag = UUID

    let tags: Tags
    let title: String
}
```

The above `Article` tags are now backed by a `UUID` instead of a `String`.

## Conveniences built-in

Even though Tagging is focused on type safety, it still offers several conveniences to help reduce verbosity. For example, if a `Tag` is backed by a raw value type that can be expressed by a `String` literal, so can the tags:

```swift
let article = Article(tags: ["foo", "bar"], title: "Example")
```

The same is also true for tags that are backend by a raw value type that can be expressed by `Int` literals:

```swift
let article = Article(tags: [7, 9], title: "Example")
```

`Tag` also becomes `Codable`, `Hashable` and `Equatable` whenever its raw value type conforms to one of those protocols.

## Type safety

So how exactly does Tagging make tags more type-safe? First, when using Tagging, it no longer becomes possible to accidentally pass a tag for one type to an API that accepts an tag for another type. For example, this code won't compile when using Tagging:

```swift
articleManager.articles(withTags: user.tags)
```

The compiler will give us an error above, since we're trying to pass an `[Tag<User>]` value to a method that accepts an `[Tag<Article>]` - giving us much stronger type safety than when using plain values, like `String` or `Int`, as tag types.

Tagging also makes it impossible to accidentally declare `tags` properties of the wrong type. So the following won't compile either:

```swift
struct User: Tagging {
    let tags: [Tag<Article>]
}
```

The reason the above code will fail to compile is because `Taggable` requires types conforming to it to declare tags that are bound to the same type as the conformer, again providing an extra level of type safety.

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

## Installation

Since Tagging is implemented within a [single file](https://github.com/alexruperez/Tagging/blob/master/Tagging/Tagging.swift)!, the easiest way to use it is to simply drag and drop it into your Xcode project.

But if you wish to use a dependency manager, you can use the [Swift Package Manager](https://github.com/apple/swift-package-manager) by declaring Tagging as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/alexruperez/Tagging", from: "0.1.0")
```

*For more information, see [the Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).*

## Contributions & support

Tagging is developed completely in the open, and your contributions are more than welcome.

Before you start using Tagging in any of your projects, it’s highly recommended that you spend a few minutes familiarizing yourself with its documentation and internal implementation (it all fits [in a single file](https://github.com/alexruperez/Tagging/blob/master/Tagging/Tagging.swift)!), so that you’ll be ready to tackle any issues or edge cases that you might encounter.

To learn more about the principles used to implement Tagging, check out *["Type-safe identifiers in Swift"](https://www.swiftbysundell.com/posts/type-safe-identifiers-in-swift)* on [Swift by Sundell](https://www.swiftbysundell.com).

This project does not come with GitHub Issues-based support, and users are instead encouraged to become active participants in its continued development — by fixing any bugs that they encounter, or improving the documentation wherever it’s found to be lacking.

If you wish to make a change, [open a Pull Request](https://github.com/alexruperez/Tagging/pull/new) — even if it just contains a draft of the changes you’re planning, or a test that reproduces an issue — and we can discuss it further from there.

Hope you’ll enjoy using **Tagging**! 😀
