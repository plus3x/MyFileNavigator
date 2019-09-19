# My File Navigator

## Issue

Write application based on UITabBarController, which will be have two screens.

First screen("Documents") must contains table with rows having name of document and them size.
By the tapping on row must be open preview page of file(QLPreviewController).

Second screen("Upload") must contains table with rows having name of document.
By the tapping on row must upload document(Data(contentsOf:)).
Table contains stubbed data with diffirent types of data, small and big sizes.

### Reguqurements:

- we can upload many files in same time
- after uploading file "Documents" screen must be updated online(NotificationCenter)
- when aplication upload any files we can use all


## Issue Extension(personal initiative)

Add new third screen("Settings") which contains:
- "Clean all documents" - with button "clean", by the tapping must clean all user data and files
- "Uploading Type" - choose(UIPickerView) type of uploading beetween "DataContentsOf" and "URLSessionDataTask"

### Requirements:

- add way to choose "Uploading Type"
- implement both types(Data(contentsOf), URLSessionDataTask) of uploading
- when we upload file using URLSessionDataTask we must show progress bar on "Upload" screen
