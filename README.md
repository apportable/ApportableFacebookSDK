ApportableFacebookSDK
=====================

FacebookSDK for the Apportable platform

Adding, compiling, loading
--------------------------

Documentation with pictures is available here: XXX

    * First remove the original FacebookSDK.framework from your project
        + Remove it from the Frameworks group/directory in your project files listing in the left tab
        + Remove it from the linking phase in Project > Build Phases > Link Binary With Libraries

    * Drag-n-drop this FacebookSDK.xcodeproj into your Xcode project as a subproject (make sure this
      FacebookSDK.xcodeproj is not open in Xcode when you do this!)
        + Add libFacebookSDK.a to the linking phase in your Project > Build Phases > Link Binary With Libraries
        + Add FacebookSDK as a target in your Project > Build Phases > Target Dependencies

    * Public headers should be visible to your project after the first build in Xcode

    * Run 'apportable --generate load' from the Terminal in the directory where YourProject.xcodeproj/ directory is to
      compile and load on your Android device

More Apportable documentation
-----------------------------

    http://docs.apportable.com/

Notes on divergences from FacebookSDK
-------------------------------------

    * Code divergences are #ifdef APPORTABLE and similar, generally related to differences in the underlying platform.

    * Blame me for directory/file layout divergence from the canonical FacebookSDK.  This was originally due to
      integrating it with our internal build system.  This is no longer the case, but the layout stuck...  We probably
      should change this going forward...

