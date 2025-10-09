# TECHDEBT

* Update the white background launch screen that is shown at the start of the app, before the List screen for something more aligned with the app style.
* Is there a need to add @concurrent to the doRequest function in the Api file? I have read that URLSession handles its operation in a background thread, so there should not be any need to add @concurrent. Check if it affects performance.
* Using Observations for the ViewModel-View communication. Make sure it works fine, if not go to the old delegation pattern.
* The parsing of DetailModel needs a re-review to make sure parsing is legible and easy to understand.