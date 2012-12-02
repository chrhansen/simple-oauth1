simple-oauth1
=============

Simple code for authenticating with OAuth 1.0a service providers
Build using blocks on iOS 6 with ARC.

AFNetworking (https://github.com/AFNetworking/AFNetworking) have some awesome methods for handling url parameters, which has been used in the project. Also a nice oauth signature method from OAuthConsumer (http://code.google.com/p/oauthconsumer/) has been used.

Currently URL's are set for LinkedIn API, but has been tested against Twitter and Tumblr.

1. Register and app here: https://www.linkedin.com/secure/developer (or other OAuth 1.0a service) 

2. Insert your Client ID and Client Secret in OAuth1Controller.m (and change the authentication-url and token-url if you're not using LinkedIn API)

4. Run the app. Tap the login button and authorize the app

5. After successfull authentication, tap the "API Request" button to test an API get request. Currently it is set (in ViewController.m) to pull your LinkedIn profile or find an appropriate API call on your OAuth1.0a service provider.

To use the authentication in your own project copy the classes in the "OAuth1" group to your project. Create a new OAuth1Controller object and run the method loginWithWebView:completion: by providing a UIWebView to handle the authorization part where the user puts in his/her credentials. You have to have a strong reference to your OAuth1Controller object

The files inside Crypto are standard files for creating the signature. 

