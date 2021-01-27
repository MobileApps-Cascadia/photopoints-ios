
<h2>Project Definition: Photopoints (iOS)</h2>

**Stakeholders:** David Bain, Friends of North Creek Forest<br/>
**Organization:** Cascadia College<br/>
**Project Manager:** Mike Panitz</br>
**Developers:** Grant Buchannan, Stephen Gomez-Fox, and Clay Suttner</br>

<h3>App Purpose</h3>
Help protect North Creek Forest, North Creek, and local salmon populations using a citizen science approach, allowing users to add their own photos of key environmental features to the scientific record. 

<h3>Product Backlog</h3>

**High Priority**
- Send submission and metadata to the api after photo(s) are obtained
- Upload app photo(s) taken in the app to the server
- Provide a web page for client to view a snapshot of recent submissions
- Remove dependencies on any hard coded data to enable the organization to change the contents of the app without requiring new app releases
  - Items:  Obtain data on first run and check for updates once per session per day
  - Trails and stream paths:  Obtain data on first run and check for updates once per month, as well any time the items data has been updated
  - Images: Retrieve display images appropriately sized for the device


**Medium Priority**


- Enable faster navigation in plant collection view
- Move items with completed surveys to end of list
- Order remaining items based on walking distance from the last item scanned
- Allow users to search for a specific plant
- Implement dynamic questionnaire system to enable collection of textual, yes/no, or option list data to accompany photo data
- Implement a page which allows users to see their past submissions
  - This could potentially be integrated into the app details page


**Low Priority**

- Design a page customized to display creek information instead of plant information 
- Implement a user settings page to customize some aspects of the app
  - Data saver - Upload photos when connected to WiFi
  - Option to delete or retain submitted photos after upload
  - Give users access to an anonymous identifier for recovery of accomplishments after lost devices, etc.
- Incentivize surveying all Photopoints during a visit and frequent participation based on their submissions
  - Earn badges for specific goals
- Allow users to see how an item changes over time


<hr/>

<H3>MVP</h3>

**Description:**

- Organization has control over information presented in the app
- All data obtained by the app is transferred to the server
- Enable further learning on plants represented with Photopoints
 
**What we are trying to learn with this MVP:**

With this MVP we are trying to enable the organization to control the application’s contents as they see fit, and by extension, the data that will be collected by the users. This includes adding and removing photopoints, changing the images that are displayed on the information pages, and updating trail and creek map contents as they evolve over time.

We also aim to learn the best ways to provide incremental improvement of the user experience as new functionality is added to make the app more engaging. We hope this will encourage users to visit the North Creek Forest frequently, fulfilling its promise of providing a rich dataset to the organization.
 
**What data we are collecting:**

Our data collection revolves around the submission functionality included in the application. This data collected consists of photographs of designated items/locations identified by QR codes located on site. Optionally included after each set of photos is obtained by the user, a brief survey will be provided to answer additional questions about the item or its surroundings. Additional data uploaded includes an anonymized user identifier.
 
**How we will use what we learn:**

We will use what we learn to build an app that is intuitive in its operation, interesting to use, and satisfying in the breadth of features provided that users expect. 


<hr/>

**JSON Record Structure from API for Items**
```
{
    "id": "28097",
    "label": "Pacific Willow",
    "enabled": true,
    "qr_code": "https:\/\/www.plantsmap.com\/plants\/28097",
    "type": "plant",
    "location": {
        "latitude": 47.75036,
        "longitude": -122.191449,
        "altitude": 0
    },
    "attributes": {
        "icon": "0de693ef54a38b1224975fad7cac4e39.png",
        "species_name": "Salix lucida ssp. Lasiandra",
        "common_names": "Pacific Willow, Yellow Willow, Waxy Willow",
        "short_description": "Pacific Willow",
        "full_description": "Pacific Willow",
        "category": "Deciduous, Tree",
        "family": "",
        "site": "2",
        "story": "\"The Straits Salish and the Halq'emeylem peeled the bark of [native willow species] in May or June, removed the outer part, split the inner tissue into thin strands, and …”
    },
    "images": [
        {
            "baseFilename": "0de693ef54a38b1224975fad7cac4e39",
            "desc": "",
            "filename": "0de693ef54a38b1224975fad7cac4e39.png",
            "license": "",
            "title": "",
            "type": "full",
            "format": "png",
            "imageType": "full",
            "fileformat": "png",
            "url": "https:\/\/photopoints.gomezfox.net\/images\/0de693ef54a38b1224975fad7cac4e39.png"
        }
    ]
}
```
<hr/>

**Style Guide:** 	

[https://github.com/raywenderlich/swift-style-guide](url)

