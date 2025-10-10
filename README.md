# AH-Assessment
Albert Heijn assessment for iOS Software Engineer post. The idea is to have a small app with two screens, one to list arts in possession of the Rijks Museum and a second to show the details of a selected art.

The project has been done using XCode 26 and Swift 6.2 with latest version of concurrency.

## Planning
Please go to the [Planning document](Planning/Planning.md) to read the basic planning before starting implementation.

For this planning I have used the help of ChatGPT, if you are interested in checking my conversation with ChatGPT, please go to: [ChatGPT Chat](https://chatgpt.com/share/68e642a7-28f4-8011-b986-a5cf6f636cd5)

### Time expended
I will try to work in a time contrained mmaner, during two days. The time expended in the assessment has gone to:
* Planning and Rijks Museum understanding: 3-4 hours
* Development: TBD
* Testing: TBD

## Arquitecture and code guidelines
I have used MVVM with a Coordinator for the exercise implementation. Here are the main whys:
* Being a small app with two screens it is better to use an easy and direct architecture.
* I do not need any complex networking layer so the ViewModel can handle that.
* Navigation is quite strightforward so one Cordinator for the whole app is good enough.

The arquitecture will follow these patterns:
* Coordinator will handle all app navigation
* ViewModel does not knows about Coordinator or about View
* View will react to the changes on the ViewModel.
	* For SwiftUI this is the normal behaviour.
	* For UIKit we need to introduce Observations so that the communication can be done this way.
* Coordinator will be the delegate of any ViewModel that needs navigation.


For maintaining a basic code quality I have used SwiftLint in the project.

## External frameworks
* SwiftlintPlugin added as Xcode package dependency


## Techdebt
Please go to the [TECHDEBT document](TECHDEBT.md) to read missing implementations and fixes, 

### Personal comments
Understanding the Rijks Museum has been a little tricky, and the implementation of the data loading has been a first for me. I am used to REST APIs that return the data in a plain json without any need of complex asynchronous load for some fields.

For the balance of UIKit - SwiftUI in the code base, I usually go for using the oldest API/Framework patterns. So in this case as UIKit is the older UI framework, I have used Controllers and the SWiftUI View has been injected as an UIHostingController.

Creating the parsing of the Detail has been difficult, the json is quite complex and making something clear and easy to understand has been tricky. I think the final result is so so. It is difficult to understand some parts of the decoding function, and I think I should have used another solution for parsing the URL ids type fields. To be honest it is my first time working with an API like this one.

