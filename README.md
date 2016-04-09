#On The Map

On The Map allows users to share their location and a URL with fellow students. On The Map uses a map with pins for location and pin annotations for student names and URLs, allowing students to place themselves on the map.

---

### Building

Before building the project please retrieve dependencies with carthage:

~~~
carthage upgrade --platform iOS
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