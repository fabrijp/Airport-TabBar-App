# Airport-TabBar-App
I have been tasked to create an UIKit project without Storyboard using MapKit to simulate an Flight Tracker that gives information about different airports that can be reached on a given day from Schiphol Airport.

It's a multi-tab iOS application. On the first tab we should see a map that shows all the airports. When a user then taps on one of the airports the app will navigate to the airport details screen.
The airport details screen should display the following:
● The specifications of this airport. (id, latitude, longitude, name, city and countryId).
● The nearest airport and its distance (in kilometers).
On the second tab we would see a list of airports that could be reached directly from Schiphol Airport that day, sorted by the distance (in kilometers) from Schiphol Airport, ascending.

● The app needs to run on iOS 14 and above.
● The UI has to be built programmatically. Storyboards and SwiftUI are not permitted.

Bonus points
● Add unit tests
● Highlight the two airports on the map that are the furthest away from each other
● A third tab with settings where you can change the distance unit from kilometers to
miles.
● Use asynchronous web requests to retrieve the two JSON files.
