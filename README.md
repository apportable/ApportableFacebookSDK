ApportableFacebookSDK
=====================

FacebookSDK for the Apportable platform -- available from https://github.com/apportable/ApportableFacebookSDK

Integrating with your Xcode project
-----------------------------------

Documentation with pictures is available here: XXX

    * First remove the original FacebookSDK.framework from your project
        + Remove it from the Frameworks group/directory in your Project Navigator (left pane of Xcode)
        + Remove it from the linking phase in Project > Build Phases > Link Binary With Libraries
        + Also you should remove any Frameworks Search Paths in the Build Settings of the main project target(s) that
          reference the FacebookSDK
        + When in doubt, git grep from the Terminal to see if there are any other FacebookSDK references in the
          project...

    * From the Mac Finder, drag-n-drop this FacebookSDK.xcodeproj into your Xcode Project Navigator.  NOTE: make sure
      this FacebookSDK.xcodeproj is not open in another Xcode window when you do this!
        + Add libFacebookSDK.a to the linking phase in your Project > Build Phases > Link Binary With Libraries
        + Add FacebookSDK as a target in your Project > Build Phases > Target Dependencies

    * Public headers should be visible to your project after the first build in Xcode

Building with Apportable
------------------------

    * Run 'apportable --generate load' from the Terminal in the directory where YourProject.xcodeproj/ directory is to
      compile and load on your Android device

    * If the initial build has errors, you may need to manually add the "ApportableFacebookSDK/include" directory to the
      YourProject.approj/configuration.json , add_params { header_paths [ ... ] } configuration section.  For example:

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

    http://docs.apportable.com/

Notes on divergences from FacebookSDK
-------------------------------------

    * Code divergences are #ifdef APPORTABLE and similar, generally related to differences in the underlying platform.

    * Blame me for directory/file layout divergence from the canonical FacebookSDK.  This was originally due to
      integrating it with our internal build system.  This is no longer the case, but the layout stuck...  We probably
      should change this going forward...

