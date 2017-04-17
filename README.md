# Lingo
Swift code generation for Localizable.strings files

Xcode has great support for localizing text in apps. However, one little typo can easily prevent your localized text from being shown. What's worse—you won't get a compile time error. You have to ready all the text in your app at runtime to verify if everything worked correctly.

*Localizable.strings*

```
"SettingsViewController.Title" = "Settings";
```

*SettingsViewController.swift*

```
init() {
	...
	title = NSLocalizedString("SettingsViewController.Title", comment: "")
}
```
If you accidentally typed `title = NSLocalizedString("SettingsViewController.itle", comment: "")` then at runtime your title would display as `SettingsViewController.itle`, not `Settings` like you expected.

We can do better!

Lingo is a super small & fast command line app that you setup in Xcode to run before the compile phase. It will parse your `Localizable.strings` file and generate a `Lingo.swift` file, that contains namespaced constants that you can use, in place of `NSLocalizedString(:comment:)`, and have full compiletime errors, as well as autocompletion.

`title = NSLocalizedString("SettingsViewController.Title", comment: "")` becomes `title = Lingo.SettingsViewController.title`.

## How does it work?
Lingo reads your *Localizable.strings* file and generates a Swift code file, that has constants that call the correct `NSLocalizedString(:comment:)` for each. So if your *Localizable.strings* looks like the one at the top of this readme, your *Lingo.swift* would look like:

```
// This file is autogenerated by Lingo from your localized strings file.

import Foundation

struct Lingo {
    struct SettingsViewController {
        /// "Settings"
        static let title = NSLocalizedString("SettingsViewController.Title", comment:"")
    }
}
```

The localized value that a constant represents is in the comments for each constant, so you can easily tell what a constant will produce just by Option-Clicking on it.

In your `Localizable.strings` file, you need to namespace your keys in the format `<SomeGrouping>.<Key>`. When you do this, all keys with the same `SomeGrouping` will be put into a struct together. The main restriction is that you should choose grouping & key values that can be represented in Swift as a struct name and variable name. Currently Lingo doesn't sanatize names before generating the Swift (PRs welcome). Since everything is done at compile time, you will know immeadiately if something didn't work.

# Installation
Download the [latest release](https://github.com/Mobelux/Lingo/releases/latest), or grab the source and build it your self. While you can just install the Lingo CLI tool locally, it's better if all develpers & CI that access your repo have access to it. So we recommend making a folder in your repo for shared tooling, and placing Lingo in there.

Open your app in Xcode, select the app's target, and go to `Build Phases`. Tap the +  at the top left of the build phases and choose `New Run Script Phase`. Give the script a descriptive name like `Lingo: Generate structs from Localizable.strings`, then drag the phase so that it is somewhere before `Compile Sources (x items)`. Inside the main script area you should put something like `./<Path to Lingo>/Lingo --input Hub/en.lproj/Localizable.strings --output Hub/Lingo.swift`, where you should use the `Localizable.strings` that you use for your development language. 

# Contributing
Checkout our [contribution guide](https://github.com/Mobelux/Lingo/master/CONTRIBUTING.md)
