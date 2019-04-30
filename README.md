# UberFlickr
iOS App for searching images using Flickr APi

To run the project 
1. open **UberFlickr.xcworkspace**
2. select the build target as **UberFlickr** as there are others targets used as frameworks
3. Run the selected target

**Shortcuts**
1. To save time, dataStores are ignored and instead operations are directly passed to viewModel.

**Documentation**
1. **UberFlickrAssembly**:- Contains the assembling logic for all components like ViewController, ViewModel and operations
2. **JJRemoteImage**- Framework to download and cache images
   1. Prioritizes image download on the basis of image visibility
   2. Deprioritizes image download when a cell disappears from the view
3. **Helpers**:- UberResult to be used as a result object. PropertyBinders used as data binders of viewmodel to views
4. **Models**:- Models folder contains all the models
5. **UberFlickrSearchOperation**:- Makes api call for search query and returns the result
6. **FlickrPhotoSearchViewModel**:- Contains all the business logic
7. **FlickrPhotoSearchViewController**:- ViewController to search images
8. **Extension**:- Extension folder contains some utitlity extensions
9. **ObjectManager**:- To make get calls
