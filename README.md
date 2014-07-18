ApportableFacebookSDK
=====================

FacebookSDK for the Apportable platform -- available from https://github.com/apportable/ApportableFacebookSDK

* This will integrate with the Apportable implementation of the Accounts framework (if that framework is present in
  your Apportable SDK).  This primarily allows login through the installed Facebook app.

* Integrates ApportableWebViewController as a git subtree
  (https://github.com/apportable/ApportableWebViewController).  This is an Android WebView/Dialog backing for
  FBSession and FBDialog.
    * For session login, it is used in the case where the Facebook App is not installed on device and/or the Accounts framework is not available in the Apportable SDK)
    * You may elect to not use this, in which case the fallback is to go through the device browser/Chrome

Integrating with your Xcode project
-----------------------------------

* First remove the original FacebookSDK.framework from your project
    * Remove it from the Frameworks group/directory in your Project Navigator (left pane of Xcode)
    * Remove it from the linking phase in Project > Build Phases > Link Binary With Libraries
    * Also you should remove any Frameworks Search Paths in the Build Settings of the main project target(s) that reference the FacebookSDK
    * When in doubt, git grep from the Terminal to see if there are any other FacebookSDK references in the project...

* From the Mac Finder, drag-n-drop this FacebookSDK.xcodeproj into your Xcode Project Navigator.  NOTE: make sure
  this FacebookSDK.xcodeproj is not open in another Xcode window when you do this!
    * Add libFacebookSDK.a to the linking phase in your Project > Build Phases > Link Binary With Libraries
    * Add FacebookSDK as a target in your Project > Build Phases > Target Dependencies

* Public headers should be visible to your project after the first build in Xcode

Building with Apportable from the Terminal
------------------------------------------

* Run 'apportable --generate load' from the Terminal in the directory where YourProject.xcodeproj/ directory is to
  compile and load on your Android device

* If the initial build has errors, you may need to manually add the "ApportableFacebookSDK/include" directory to the
  YourProject.approj/configuration.json , add\_params { header\_paths [ ... ] } configuration section.  For example:

        ...
        "add_params": {
            ...
            "header_paths": [
                "ApportableFacebookSDK/include",
                ... ,
            ]
            ...
        }

More Apportable documentation
-----------------------------

* http://docs.apportable.com/

* Apportable forum : http://forum.apportable.com/

* Sample apps using ApportableFacebookSDK : https://github.com/apportable/Spin/tree/facebook-sdk

* And also, don't forget http://stackoverflow.com/ posts tagged as `apportable` =)

Notes on divergences from FacebookSDK
-------------------------------------

* Code divergences from canonical FacebookSDK are `#ifdef APPORTABLE` or `#ifdef ANDROID`

* Directory/file layout diverges from canonical FacebookSDK due to originally integrating this with our internal
  build system.  This probably should be fixed at some point (possibly by you!).  _Consider contributing to
  development_ by sending us a pull request through Github =)

