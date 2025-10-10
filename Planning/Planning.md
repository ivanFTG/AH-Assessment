# AH Assessment Planning
I need to create a small with two screens. The data for those screens comes from the Rijks Museum API.

* First screen will be a list of elements taken from the search enpoint.
    * The List screen should be implemented in UIKit and using a UICollectionView.

* Second screen will be a detail of the data of one of the elements in the list screen.
    * The Detail screen should be implemented in SwiftUI and I will need a ScrollView.

I need also to implement navigation for moving between List and Detail. As the List screen is UIKit, I will use a UIHostingController for the Detail screen, and implement the navigation with a UINavigationController. This controller will go into a Coordinator to standarise and organise the navigation and dependency injection.

## Rijks Museum API
I have three endpoints:
1. https://data.rijksmuseum.nl/search/collection returns a list of urls to get data from.
    * The list of urls come with the value: https://id.rijksmuseum.nl/200107942
    * Each url contains the data of the art we want to show.
    * See RijksSearchExample.json.
2. The id type url https://id.rijksmuseum.nl/[id] returns the art data.
    * Problem is the json is too difficult to read.
    * I need to use data models that will parse the json and extract the correct information I want.
    * Be ware of the app language.
    * See the RijksDetailExample.json.
3. The endpoint to load images. This is not a direct url I can call, I need to:
	* First in the art data there would be a VisualItem element that has another id type url.
	* Inside that id type url I need to look for the DigitalObject element, that will have an other id type url.
	* Now finally I can call to the url from DigitalObject and call it with the size I want.
	* See first RijksVisualObject.json and second RijksDigitalObject.json.

### API implementation
I ned to create some kind of network manager. To not complicate things, and as majority the urls are already built in the responses I receive I will use directly URLSession and create a small routing layer on top of it.

## Data Models
I will need to main data models:
* ListModel: This model will be buildt from the parsing of the Search endpoint response. The response json is just a list of url. One per each art listed.
	* The elements in the ListModel will contain some kind of asynchronous loading to allow the load of the data from each id type url.
	* The loading should be done into a DetailModel.
* DetailModel: This model will be the built from the parsing of the id type url. The response json has many fields and I will need to retrieve only the data needed for my UI.
	* Create a set of Data models to parse directly the values from the json.
	* From these data models I need to put the values for the UI into the DetailModel.
	* There is one problem, some of the values are not stored in the "detail" response json I receive.
	* Some values will have another id type url value. And this means they need to be loaded.
	* So DetailModel will have values that are of direct access, and other values that are of asynchronous access (trough functions).

## Architecture
I will use basic MVVM for the example as I only need two screens and will show basic data.
* View: A ViewController for the List screen and a View for the Detail screen.
* ViewModel: A normal class for the List screen and an @Observable class for the Detail screen.
* Mdodel: Of type ListModel or DetailModel depending on the ViewModel to use.

## Navigation
I will need to create some pattern to handle navigation. A Coordinator pattern will be nice here. For simplicity I will only have one coordinator for the whole flow (as the app only has one navigation controller, there is no need to over complicate).
* Coordinator will be the delegate of each ViewModel.

## List Screen
This screen will contain:
* The collection view with the list of cells for the loaded json response.
	* The cell needs to be shown with a background of rijks museum and a loader as each element is loaded from another url.
* A search bar to search and filter out elements in the list.

## Detail Screen
This screen will contain:
* An image header with the art image. This image needs to be loaded, so it needs a place holder and some kind of loading indicator.
* A list of texts (use some kind of default section with fields) with the data related to the art





