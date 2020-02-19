# StockMarketTrading
A fun app made with to demonstrate some examples of MVVM pattern + RxSwift in Swift using **clean architecture**, **SOLID principles** code organisation, loose coupling, **unit testing** and some of the best practices used in modern iOS programming using `Swift`. It displays a simple order placement ticket, showing real-time updating Bitcoin prices.

## App Goal:
 - It Receive Bitcoin price updates (BUY and SELL) and update the BUY and SELL prices and SPREAD*  value on order ticket accordingly.
 - Allow the user to input units (in Bitcoins) or amount (in GBP) into the units / amount text input fields mentioned above:
    - If the user types in a value in the units field, the app calculate the correct amount and populate the amount field also (BUY price * units value).
    - If the user types in a value in the amount field, the app calculate the correct units value and populate the units field also (amount value / BUY price).
- The confirm button should be disabled when the units and amount fields are empty, and enabled once a value has been input and the keyboard has been dismissed.

## Implementation:
 - For price updates, app polls the following URL every 15 seconds: [Blockchain ticker](https://blockchain.info/ticker) 
 - This will return prices in JSON format. For more information [API documentation](https://www.blockchain.com/en/api)
 - When the price service has a completed polling the URL and received a response, It update the UI with the new bitcoin price (in GBP) and flash the BUY and SELL prices GREEN (whether it has changed or not) with an animation.
 - Units and amount input fields accept update only valid numbers and numbers with up to two decimal places.
 - On the price labels, numbers after the decimal point is smaller than numbers before the decimal point.
 - Text input fields have a blue border when focussed, and no border when not focussed and have curved edges.
 - Confirm button text and colour is dimmed in disabled state.
 - It Calculate the spread by subtracting the SELL price from the BUY price.

## Installation

- Xcode **11.3**(required)
- Clean `/DerivedData` folder if any
- Run the pod install `pod install`
- Then clean and build the project in Xcode

## 3rd Party Libraries
- **`RxSwift`** - [ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift) is  used to make `Reactive` binding of API call and response
- **`SwiftLint`** - [realm/SwiftLint](https://github.com/realm/SwiftLint) A tool to enforce Swift style and conventions. 
- **`Pecker`** - [woshiccm/Pecker](https://github.com/woshiccm/Pecker) Pecker is a tool to automatically detect unused Swift code.
- **`SwiftGen`** - [SwiftGen/SwiftGen](https://github.com/SwiftGen/SwiftGen) swift code generator for your assets, storyboards, Localizable.strings. \
- **`SwiftRichString`** - [malcommac/SwiftRichString](https://github.com/malcommac/SwiftRichString) Elegant, easy and swift-like way to create Attributed Strings
- **`CrossroadRegex`** - [crossroadlabs/Regex](https://github.com/crossroadlabs/Regex) Regex library to handell regular expressions for Swift in more swift-like way
- **`PKHUD`** - [pkluz/PKHUD](https://github.com/pkluz/PKHUD) Swift based reimplementation of the Apple HUD
- **`Quick`** - [Quick/Quick](https://github.com/Quick/Quick) is testing framework in swift
- **`Nimble`** - [Quick/Nimble](https://github.com/Quick/Nimble) is Matcher Framework for Swift to pair with Quick
- **`Cuckoo`** - [Brightify/Cuckoo](https://github.com/Brightify/Cuckoo) is tasty mocking framework for unit tests in swift

 ## TODO:
 - Persist between launches
 - Flexible Design for multiple screen sizes.
 - Update UI for buy or sale button click action
 - Improve UI for good user interface, Keep the interface simple.
 - Cover edge case in Unit test
 - Add UI test

## Design patterns:
### MVVM:
MVVM stands for Model,View,ViewModel in which controllers, views and animations take place in View and Business logics, api calls take place in ViewModel. In fact this layer is interface between model and View and its going to provide data to View as it wants. 

![Alt text](/ScreenShots/MVVM.jpeg?raw=true)
 
#### App Demo
 - A sell price panel featuring the sell price in the top left.
 - A buy price panel featuring the buy price in the top right.
 - A units text input field and amount text input field (with units / amount heading labels).

 ![](/ScreenShots/StockMarketTrading.gif "")
  

 
 
