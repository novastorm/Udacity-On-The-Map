#On The Map

On The Map allows users to share their location and a URL with fellow students. On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves on the map.

---

### Building

Before building the project please retrieve dependencies with carthage:

~~~
carthage bootstrap --platform iOS
~~~

The project uses the following frameworks:

* [Reachability.swift](https://github.com/ashleymills/Reachability.swift)  
Monitor the network state of an iOS device. (Replacement for Apple's Reachability sample, re-written in Swift.)
  
Carthage is used to manage project dependencies. Install carthage via homebrew:

~~~
brew install carthage
~~~

### Resource authorization

Add the appropriate API Key and ApplicationId to the file:

~~~
On the Map/UdacityParseClientConstants.swift
~~~

~~~
extension UdacityParseClient {

struct Constants {
// MARK: API Key
static let APIKey = "REST API Key"

// MARK: Application Id
static let ApplicationId = "Parse Application ID"
~~~

### Swift concepts utilized

* NSNotifications  
  Decouple classes using notifications. Messages used to notify changes replace hard coded dependencies between classes.

* Concurrency  
  Much of the project quietly uses concurrency to fetch data from remote resources. This project presented the challenge of managing tasks in background queues and when to update on the main queue.
  
* Customized UI Elements  
  Some UI Elements needed customizing beyond what the UI Builder provides. Custom configurations allow for expansion upon UI Elements beyond the basic view.

* Navigation Stack Manipulation  
  Customized stack manipulation is used to simulate one view replacing another in the navigation stack.

* External Framework Management  
  Leverages carthage to manage external frameworks.

* Error Management  
  Utilize NSError for error management in callbacks.

* Swift Singletons  
  Utilize Swift Singleton expression.
  
~~~
class UdacityClient {

    // MARK: Shared Instance
    static let sharedInstance = UdacityClient()
    private init() {} // Disable default initializer
    
    ...
}
~~~
  

* if let and guard statements  
  Used to flatten pyramids of doom.

* LLDB  
  Utilize LLDB debugging features to troublshoot project.

* MapView and annotations  
  Configure and display maps with custom annotations and annotation interactions.

* Model and Collection Structures  
  Utilize structs to provide base object data interaction.

* External Resource Interaction  
  Manage remote resource communication and common CRUD interactions with NSURLSession.
  
* Closures and callbacks  
  Closures encapsulate self contained blocks of code within a larger function. Closures passed to functions allow the called function to call back and communicate to the calling funciton.
  
* typealias  
  Abstracts internal variable types to simplify downcasting. Utilized in models to simplify interactions with properties.