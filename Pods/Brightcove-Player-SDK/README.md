# Brightcove Player SDK for iOS, version 5.0.7.433

Supported Platforms
===================

iOS 7.0 and above.  
tvOS 9.0 and above.

Installation
============
The Brightcove Player SDK provides two installation packages for iOS, a static library framework and a dynamic framework. The static library target supports deployment on iOS 7 while the dynamic framework only supports iOS 8 and above.

The Brightcove Player SDK provides a dynamic framework to support tvOS 9.0 and above.

CocoaPods
--------------

You can use [CocoaPods][cocoapods] to add the Brightcove Player SDK to your project. You can find the latest `Brightcove-Player-SDK` podspec [here][podspecs]. The podspec supports both iOS and tvOS. CocoaPods 0.39 or newer is required.

Specifying the default pod `Brightcove-Player-SDK` will install the static library framework. To install the dynamic framework, declare the pod with the `dynamic` subspec: `Brightcove-Player-SDK/dynamic`

Static Framework example:

    pod 'Brightcove-Player-SDK'
    
Dynamic Framework example:

    pod 'Brightcove-Player-SDK/dynamic'    

Manual
--------------

To add the Brightcove Player SDK to your project manually:

1. Download the latest zipped release from our [release page][release].
2. Add the `BrightcovePlayerSDK.framework` to your project.
3. On the "Build Settings" tab of your application target, ensure that the "Framework Search Paths" include the path to the framework. This should have been done automatically unless the framework is stored under a different root directory than your project.
4. On the "General" tab of your application target, add the following to the "Link
    Binary With Libraries" section:
    * `AVFoundation`
    * `CoreMedia`
    * `MediaPlayer`
    * `BrightcovePlayerSDK.framework`  
5. (Dynamic Framework only) On the "General" tab of your application target, add 'BrightcovePlayerSDK.framework' to the "Embedded Binary" section.
6. (Dynamic Framework only) On the "Build Phases" tab, add a "Run Script" phase with the command `bash ${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/BrightcovePlayerSDK.framework/strip-frameworks.sh`. Check "Run script only when installing". This will remove unneeded architectures from the build, which is important for App Store submission. ([rdar://19209161][19209161])
7. (Static Framework only) On the "Build Settings" tab of your application target, add `-ObjC` to the "Other Linker Flags" build setting.

Imports
--------------
The Brightcove Player SDK for iOS can be imported into code a few different ways; `@import BrightcovePlayerSDK;`, `#import <BrightcovePlayerSDK/BrightcovePlayerSDK.h>` or `#import <BrightcovePlayerSDK/[specific class].h>`.
    
[cocoapods]: https://cocoapods.org
[podspecs]: https://github.com/CocoaPods/Specs/tree/master/Specs/Brightcove-Player-SDK
[release]: https://github.com/brightcove/brightcove-player-sdk-ios/releases
[19209161]: https://openradar.appspot.com/19209161

Quick Start
===========
Playing video with the Brightcove Player SDK for iOS, in less than 20 lines of code:

    NSString *token;      // (Brightcove Media API token with URL access)
    NSString *playlistID; // (ID of the playlist you wish to use)
    
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
    id<BCOVPlaybackController> controller = [manager createPlaybackControllerWithViewStrategy:nil];
    self.controller = controller; //store this to a strong property
    [self.view addSubview:controller.view];  
     
    BCOVCatalogService *catalog = [[BCOVCatalogService alloc] initWithToken:token];
    [catalog findPlaylistWithPlaylistID:playlistID
                         parameters:nil
                         completion:^(BCOVPlaylist *playlist,
                                      NSDictionary *jsonResponse,
                                      NSError      *error) {
                                      
                             [controller setVideos:playlist];
                             [controller play];
                             
                         }];

If you're using ARC, you need to keep the controller from being automatically released at the end of the method. A common way to do this is to store a pointer to the controller in an instance variable.

Architectural Overview
======================
![Architectural Overview 1](architecture01.png)

The entry point to the Brightcove Player SDK for iOS is the [`BCOVPlayerSDKManager`][manager] singleton object. This Manager handles registration of plugin components and some other housekeeping tasks, but it primarily serves as an object factory. Your app's view controller obtains a reference to the Manager, and uses it to create a [`BCOVPlaybackController`][controller]. The playback controller's `view` property exposes a UIView containing the AVPlayerLayer object that ultimately presents your video content on the screen. The playback controller also accepts a [`BCOVPlaybackControllerDelegate`][delegate], which you can implement to respond to various video playback events.

The playback controller offers methods and properties to affect playback of the current video. However, internally, the playback controller delegates to a [`BCOVPlaybackSession`][session] object. Playback sessions do the actual work of preparing and playing video content, and contain the video's metadata and AVPlayer. The playback controller has mechanisms to advance from the current playback session to the next playback session, either automatically at the end of a video, or manually with a method call. Once the playback controller has advanced to a new session, the previous session is discarded and cannot be used again.

There are two other elements of the playback controller: a [`BCOVPlaybackSessionProvider`][provider], and a list of [`BCOVPlaybackSessionConsumer`][consumer]s. As the name would suggest, the playback session provider is responsible for creating playback sessions and delivering them to the playback controller. The playback controller then delivers the session to each of the playback session consumers in the list. Both the session provider and session consumer APIs are designed for use by plugin developers, and are not detailed in this document.

In addition to the playback functionality provided by the classes described above, there are a handful of value classes. These are used to hold data specific to the Player SDK for iOS. There are also [`BCOVCatalogService`][catalog] and [`BCOVMediaRequestFactory`][requestfactory], which offer functionality for querying content remotely stored in your Brightcove Video Cloud account. Each of these is described in more detail in its own section below.

[manager]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlayerSDKManager.h
[controller]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlaybackController.h
[session]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlaybackSession.h
[provider]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlaybackSessionProvider.h
[catalog]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVCatalogService.h
[requestfactory]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVMediaRequestFactory.h

Play, Pause, and Seek
-------------------------------
The Brightcove Player SDK for iOS provides play, pause, and seek methods on the `BCOVPlaybackController`. **It is important to use these methods instead of using the AVPlayer equivalent.** In their default implementations, these objects forward the calls directly to the corresponding method on the AVPlayer. However, if you are using plugins, they may override the default behavior to add functionality. For example, if using an advertising plugin, calling `[BCOVPlaybackController play]` the first time might cause pre-roll to play before starting the content. To find out more about how a plugin may override the default behavior, please refer to each plugin README.md or by checking for a category extension on `BCOVSessionProviderExtension` that the plugin may add.

*Calling play, pause, or seek on the AVPlayer directly may cause undefined behavior.*

Preloading videos
-------------------------------
The Brightcove Player SDK for iOS provides the ability to preload upcoming videos in a playlist. By default, this functionality is disabled because of the large amount of memory preloading may use. You can turn on preloading to help ensure futures videos load quickly, however you might want to take into account the amount of memory available on the client's device and speed of their connection. If they are not on Wifi, preloading a video may affect the current video's network resources.

[`BCOVBasicSessionProviderOptions`][options] and [`BCOVBasicSessionLoadingPolicy`][loadingpolicy] provide two factory methods to modify preloading behavior that are described below:

* `+sessionPreloadingNever` This method returns a session preloading policy that never preloading videos. This is the default setting. 
* `+sessionPreloadingWithProgressPercentage:` This method returns a session preloading policy that preloads the next video in a playlist after the provided percentage of the current video has been reached. If a value below 0 or greater than 100 is used, then `sessionPreloadingNever` is used. Some plugins may ignore this setting.

An example:

         BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
     [1] BCOVBasicSessionLoadingPolicy *policy = [BCOVBasicSessionLoadingPolicy sessionPreloadingWithProgressPercentage:50];     
          BCOVBasicSessionProviderOptions *options = [[BCOVBasicSessionProviderOptions alloc] init];
          options.sessionPreloadingPolicy = policy;
          id<BCOVPlaybackSessionProvider> provider = [manager createBasicSessionProviderWithOptions:options];

1. Create a session preloading policy which starts preloading of an upcoming session when the current session reaches 50% of progress. 

[options]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVBasicSessionProvider.h#L108-L126

[loadingpolicy]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVBasicSessionProvider.h#L78-L99

Source Selection (HLS, MP4, HTTP/HTTPs)
---------------------------------------
The Brightcove Player SDK for iOS provides clients the ability to attach multiple url and delivery types (`BCOVSource`) to a single video (`BCOVVideo`). For example, if your videos are being retrieved by the catalog or playback service, there may be a mix of HLS or MP4 renditions for a single video, along with HTTP and HTTPs versions.  Which one of these sources that get selected is determined by a source selection block. The default source selection policy will select the first HLS `BCOVSource` on each `BCOVVideo`, regardless of scheme. 

Source selection can be overridden by creating a `BCOVBasicSessionProviderOptions` and using it to create a `BCOVBasicSessionProvider`. For example:

    BCOVPlayerSDKManager *sdkManager = [BCOVPlayerSDKManager sharedManager];
    
    BCOVBasicSessionProviderOptions *options = [[BCOVBasicSessionProviderOptions alloc] init];    
    options.sourceSelectionPolicy = <policy>
    
    id<BCOVPlaybackSessionProvider> provider = [sdkManager createBasicSessionProviderWithOptions:options];
    id<BCOVPlaybackController> playbackController = [sdkManager createPlaybackControllerWithSessionProvider:provider viewStrategy:nil];


If this default selection policy does not work for you, there are a few alternatives to selecting a source:

* If retrieving videos from Video Cloud via the catalog service or playback service, before calling `-[BCOVPlaybackController setVideos:]`, use the update method on the `BCOVVideo` to only contain the source you want (see the "Values" section for more info).

* If you prefer HTTPs HLS, `[BCOVBasicSourceSelectionPolicy sourceSelectionHLSWithScheme:kBCOVSourceURLSchemeHTTPS]` allows you to prefer a specific scheme. This will not convert non HTTP urls to HTTPs urls. If you choose to select HTTPs, ensure that your CDN is configured for HTTPs. If the CDN is configured for HTTPs, use `BCOVPlaybackService` instead of `BCOVCatalogService` to retrieve video/playlist metadata.

* Similar to updating the video object, you may also implement your own source selection block.
        
        options.sourceSelectionPolicy = ^ BCOVSource *(BCOVVideo *video) {
        
           <Check video.sources for source>
           <return source>

        };

Please be aware there are App store limitations regarding the use of MP4 videos.


Obtaining Content and Ad playback Information
--------------------------------------
The Brightcove Player SDK for iOS provides two mechanisms for obtaining playback information. The playback controller provides a delegate property that implements [`BCOVPlaybackControllerDelegate`][delegate]. A delegate can implement these optional methods to get notified of playback metadata like progress, duration changes, and other events. If an ad plugin is installed, it may also use this delegate to provide information about [ad playback][adplayback]. The [lifecycle event][lifecycle] delegate method provides events to signal changes in playback state. For example, when a player goes from the paused state to the playing state, the lifecycle event delegate method will be called with the `kBCOVPlaybackSessionLifecycleEventPlay` event. The default Lifecycle events are declared in [`BCOVPlaybackSession`][lifecycleevents]. Plugins provided by Brightcove add additional lifecycle events which are defined in each plugin.

[adplayback]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVAdvertising.h#L120-L192
[lifecycle]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlaybackController.h#L342-L353
[lifecycleevents]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlaybackSession.h

The playback controller allows for a single delegate. In many cases, this will be enough to retrieve information; the delegate implementations can disseminate values and events to different parts of the app as necessary. In cases where multiple delegates would be required, as is the case when developing a plugin, the [`BCOVPlaybackSessionConsumer`][consumer] delegates provide equivalent functionality to the [`BCOVPlaybackControllerDelegate`][delegate] methods, including [ad data][adconsumer].

[consumer]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlaybackController.h#L259-L367
[adconsumer]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVAdvertising.h#L195-L259
[delegate]: https://github.com/brightcove/brightcove-player-sdk-ios/blob/master/ios/dynamic/BrightcovePlayerSDK.framework/Headers/BCOVPlaybackController.h#L379-L495

Here is an example of how one might use `BCOVPlaybackSessionConsumer` to create an analytics plugin:

    @interface XYZAnalytics : NSObject <BCOVPlaybackSessionConsumer>
    @end

    @implementation XYZAnalytics

    - (void)playbackSession:(id<BCOVPlaybackSession>)session didProgressTo:(NSTimeInterval)progress
    {
        //react to progress event
    }

    @end

To use the plugin:

    BCOVPlayerSDKManager *sdkManager = [BCOVPlayerSDKManager sharedManager];
    id<BCOVPlaybackController> controller = [sdkManager createPlaybackController];
    XYZAnalytics *analytics = [[XYZAnalytics alloc] init];
    [controller addSessionConsumer:analytics];
    
Handling network interruptions and slowdowns
--------------------------------------------

When the application experiences network interruptions, the AVPlayer used by the the BCOVPlaybackController may stop attempting to recover if the interruption lasts too long. If this occurs, the lifecycle delegate method will be called with a `kBCOVPlaybackSessionLifecycleEventFailedToPlayToEndTime` event. When this event occurs, playback **will not** recover automatically. In order to recover from this event, you will need to detect when the network recovers in your client code.  

Once you have determined that the network has recovered, you can use `- [BCOVPlaybackController resumeVideoAtTime:withAutoPlay:` to re-initialize the player. You will need to keep track of where you want to resume to. The player will make its best effort to suppress lifecycle events and progress events, in order to prevent ads from replaying or from analytics being interfered with.

Upon calling `- [BCOVPlaybackController resumeVideoAtTime:withAutoPlay:`, the player will send a lifecycle event of type `kBCOVPlaybackSessionLifecycleEventResumeBegin`. `kBCOVPlaybackSessionLifecycleEventResumeComplete` will be sent if this action succeeds, otherwise `kBCOVPlaybackSessionLifecycleEventResumeFail` will be sent.

You must wait before calling `- [BCOVPlaybackController resumeVideoAtTime:withAutoPlay:` a second time until you have received either `kBCOVPlaybackSessionLifecycleEventResumeComplete` or `kBCOVPlaybackSessionLifecycleEventResumeFail` from the previous call. You may wish to impose a retry limit, before giving the user a message that their network is too unstable.

When the AVPlayer is still able to access the network, but the video stalls because the network is too slow, the lifecycle delegate method will be called with a `kBCOVPlaybackSessionLifecycleEventPlaybackStalled` event. When playback is able to resume, the lifecycle delegate method will be called with a `kBCOVPlaybackSessionLifecycleEventPlaybackRecovered` event. These events only cover the case where normal playback stopped and does not cover buffering that occurs during a seek or initial load of the video.

When the video is initially loading, when a seek occurs, or when playback stalls due to a slow network, the lifecycle delegate method will be called with a `kBCOVPlaybackSessionLifecycleEventPlaybackBufferEmpty` event.  When playback is able to resume,  the lifecycle delegate method will be called with a `kBCOVPlaybackSessionLifecycleEventPlaybackLikelyToKeepUp` event. You may wish to implement a loading spinner in this case.

A Word on Subclassing
---------------------
Except where explicitly documented otherwise, none of the classes in the Player SDK for iOS are designed to be subclassed. Creating a subclass of any SDK class that is not explicitly designed to be subclassed, especially any of the value classes, could result in unpredictable behavior.

Values
------
Also known as "model objects", these classes (`BCOVPlaylist`, `BCOVVideo`, `BCOVSource`, `BCOVCuePoint`, `BCOVCuePointCollection`) are used to represent data in the Player SDK for iOS. It is crucial to understand that these data types are treated as *values*, rather than *identities*. By this, we mean that if you have two instances of a value class which have the exact same data, they represent the same idea or value, even though they are technically two different objects at separate memory addresses. In other words, neither SDK code nor your client code should ever use identity comparisons ("pointer equality") with value objects. Instead, each value class implements `-isEqual:` and provides a class-specific equality method overload, either of which should be used instead.

This is bad:

    if (myVideo == session.video) // Could lead to bugs!
    
These are good (and functionally equivalent):

    if ([myVideo isEqualToVideo:session.video])
    if ([myVideo isEqual:session.video])

The internals of the Player SDK for iOS may do such things as memoize values or make defensive copies, so relying on the pointer address to check for equality will end up causing you pain.

Another quality of value classes in the Player SDK for iOS is that they are *immutable*. Once you have an instance of a value, you should not try to subvert this immutability in any way, as it may lead to unpredictable behavior. If in your code you wish to "modify" a value in some fashion, your only recourse is to create a new value. As a convenience to help clients obtain "modified" values, each of the value classes offers an `-update:` method which takes a block that allows you to operate on a mutable copy of the original value.

Here is an example of using this method to create a "modified" version of an existing video object, but with different properties:

    BCOVVideo *video1; // (properties include a key "foo" whose value is "bar")
    BCOVVideo *video2 = [video1 update:^(id<BCOVMutableVideo> mutable) {
        
        mutable.properties = @{ @"foo": @"quux" };
        
    }];
    
	NSLog(@"foo is %@", video1.properties[@"foo"]); // prints "foo is bar"
    NSLog(@"foo is %@", video2.properties[@"foo"]); // prints "foo is quux"
    
    // Both video1 and video2 are still immutable objects:
    video1.properties = otherDictionary; // causes compiler error
    video2.properties = otherDictionary; // causes compiler error


As you can see in the example, `video1` has not been changed by the `-update` method call. Instead, this method returns a copy of `video1`, except with the modifications made in the body of the block. You should never allow the mutable copy to escape the block (such as by assigning it to a `__block` variable), instead use the immutable object returned by the `-update` method after you have made your modifications.

(Thanks to [Jon Sterling][js] for publishing the Objective-C implementation of this pattern.)

[js]: http://www.jonmsterling.com/posts/2012-12-27-a-pattern-for-immutability.html

Retrieving Brightcove Assets
------------------------
To retrieve Brightcove assets you can rely on either playback service classes or catalog classes. The functionality of these two classes are similar but not completely equal. You will need to choose one depending on your needs. 

###Playback Service

The playback service classes provide functionality for retrieving information about your Brightcove video assets via the [Brightcove Playback API][PlaybackAPI]. For most purposes, `BCOVPlaybackService` provides sufficient functionality to obtain videos and playlists with more rich meta information than catalog classes such as text tracks. The following is an example shows how to retrieve a video with a video ID. Note that there is also a method that can retrieve a video with that video's reference ID.

    [1] NSString *policyKey;  // (Brightcove Playback API policy Key)
        NSString *videoID;    // (ID of the video you wish to use)
        NSString *accountId;  // (account id)

        BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];
        id<BCOVPlaybackController> controller = [manager createPlaybackControllerWithViewStrategy:nil];
        [self.view addSubview:controller.view];  
     
        BCOVPlaybackService *playbackService = [[BCOVPlaybackService alloc] initWithAccountId:accoundId policyKey:policyKey];
        [playbackService findVideoWithVideoID:videoID
                                   parameters:nil
                                   completion:^(BCOVVideo *video,
                                                NSDictionary *jsonResponse,
                                                NSError      *error) {

                                       [controller setVideos:@[ video ]];
                                       [controller play];

                                   }];

1. The playback service requests **policy key** for authentication. To learn more about policy key and how to obtain one, please check [policy key documentation][PolicyKey].

If for some reason you need to customize the request that the playback service sends to the Brightcove Playback API, you may find `BCOVPlaybackServiceRequestFactory` helpful. This utility, which is used by the playback service, generates parameterized Brightcove CMS API NSURLRequest objects, which you can use in your own HTTP communication.

[PlaybackAPI]: http://docs.brightcove.com/en/video-cloud/playback-api/index.html
[PolicyKey]: http://docs.brightcove.com/en/video-cloud/player-management/guides/policy-key.html
###Catalog

The catalog classes provide functionality for retrieving information about your Brightcove assets via the [Brightcove Media API][MediaAPI]. For most purposes, `BCOVCatalogService` provides sufficient functionality to obtain value class instances from input data such as playlist or video IDs, or reference IDs.

If for some reason you need to customize the request that the catalog sends to the Brightcove Media API, you may find `BCOVMediaRequestFactory` helpful. This utility, which is used by the catalog service, generates parameterized Brightcove Media API NSURLRequest objects, which you can use in your own HTTP communication.

[MediaAPI]: http://docs.brightcove.com/en/video-cloud/media/index.html
View Strategy
-------------
`BCOVPlaybackController` objects are constructed with a **view strategy**, which allows you, as the client of the SDK, to define the exact UIView object that is returned from the playback controller's `view` property. This is important when using plugins that affect the playback controller's view, such as an advertising plugin that overlays the video view with an ad view. Imagine trying to integrate custom controls with such a plugin: normally, custom controls are just regular UIView objects in the view hierarchy that float above the playback controller's video view. But with an advertising plugin, you generally want the ads to float over your custom controls. How to accomplish this without having in-depth knowledge of the structure of the playback controller's view hierarchy? The solution is to construct a view strategy that composes the video view, your custom controls, and the advertising view in a hierarchy of your choosing. The playback controller will call this view strategy the first time you access its `view` property. The final UIView object returned from the strategy will serve as its view permanently (until the controller is destroyed).

Many apps will have no need to create a view strategy, and can simply pass `nil` when creating a new playback controller. This will create a standard video view in the playback controller. However, for apps that do need the control offered by a view strategy, we provide a more detailed explanation here.

The `BCOVPlaybackControllerViewStrategy` typedef aliases (and documents) this more complex block signature:

    UIView *(^)(UIView *view, id<BCOVPlaybackController> playbackController);

This signature describes an Objective-C block that returns a UIView and takes two parameters: a UIView and a playback controller. The return value is easy to understand: it is the UIView object that you want the playback controller's `view` property to point to. But what about the parameters to the block; what is the UIView that is passed as the first parameter? And why is the playback controller passed as the second parameter?

The first parameter is a UIView that *would* have become the playback controller's `view` property, if your view strategy didn't exist to specify otherwise. To illustrate, you could create a pointless no-op view strategy by implementing the block to return its `view` parameter directly:

    BCOVPlaybackControllerViewStrategy viewStrategy =
            ^ UIView *(UIView *videoView, id<BCOVPlaybackController> playbackController) {

        return videoView;

    };

This has the same effect as passing a `nil` view strategy when creating the playback controller.

The second parameter is the same playback controller object to which the view strategy has been given. Why would the view strategy need to reference its playback controller? In many cases, it probably doesn't, and the second parameter can be safely ignored. But some apps might need a view strategy that adds a session consumer to the playback controller. For example, to update custom controls every time the controller advances to a new playback session, you need to be notified of new sessions. The playback controller is made available in the second parameter to the block, so that the view strategy can add any necessary session consumers.

It is very important not to retain this reference to the playback controller. That is, it is safe to use within the block if you need, but don't try to assign it to a `__block` variable or global variable so that you can access it later. The parameter is passed in only because there is no playback controller reference that can be closed-over within the block at the time the view strategy is defined.

Here's an example of a more sensible view strategy implementation:

    BCOVPlaybackControllerViewStrategy viewStrategy =
            ^(UIView *videoView, id<BCOVPlaybackController> playbackController) {

        // Create some custom controls for the video view,
        // and compose both into a container view.
        UIView<BCOVPlaybackSessionConsumer> *myControlsView = [[MyControlsView alloc] init];
        UIView *controlsAndVideoView = [[UIView alloc] init];
        [controlsAndVideoView addSubview:videoView];
        [controlsAndVideoView addSubview:myControlsView];

        // Compose the container with an advertising view
        // into another container view.
        UIView<BCOVPlaybackSessionConsumer> *adView = [[SomeAdPluginView alloc] init];
        UIView *adAndVideoView = [[UIView alloc] init];
        [adAndVideoView addSubview:controlsAndVideoView];
        [adAndVideoView addSubview:adView];

        [playbackController addSessionConsumer:myControlsView];
        [playbackController addSessionConsumer:adView];

        // This container view will become `playbackController.view`.
        return adAndVideoView;

    };

Let's review what this view strategy does in detail: first, it creates a custom controls view that conforms to the `BCOVPlaybackSessionConsumer` protocol. (Note that custom views are not required to conform to this protocol; some other non-view object could have been added as a session consumer instead. This just makes the example easier to follow.) Notice how the view hierarchy is composed in this view strategy block: a container view is created to hold both the video view and the controls. These views are added in an order such that the controls will appear *over* the video view. Next, a container view is created to hold the ad view and the first container view. They are added in an order such that the ad view will appear over the container with the custom controls and video view. Finally, the custom controls and the ad view are registered as session consumers, so that when a new playback session is delivered to the playback controller, these views can subscribe to the appropriate events on the session.

Again, for most use cases it should suffice to not use a view strategy at all. Just add the playback controller's view to a view hierarchy, and compose custom controls on top of it. But for more nuanced cases such as when using certain plugins, it helps to have an opportunity to take control of the composition of the playback controller's view, and that's exactly why you can pass a view strategy to the `BCOVPlayerSDKManager` when creating a new playback controller.

There is one caveat to using a view strategy: you must not access the playback controller's `view` property from within the view strategy block. Since the block is being called *because* the playback controller's `view` property was accessed for the first time, accessing the `view` property again *within* the view strategy block could cause a rip in the fabric of space and time, and your program will crash.

Playing Video In The Background (and a special note about PiP)
-------------
By default, when an iOS application is sent to the background, or the device is locked, iOS will pause any video that is playing. To change this behavior, set the `allowsBackgroundAudioPlayback` property of the `BCOVPlaybackController` object to `YES`. (The default value is `NO`, indicating playback will pause in the background.)

You should also follow the guidelines set by Apple in [Technical Q&A QA1668][tqa1668] to set the proper background modes and audio session category for your app.

It's important that the AVPlayerLayer be detached from the AVPlayer before the app is switched to the background (and reattached when the app returns to the foreground). The Brightcove Player SDK will handle this for you when `allowsBackgroundAudioPlayback` is set to `YES`.

Finally, when playing background videos (and particularly when using playlists), you should use the iOS `MPRemoteCommandCenter` API to give the user playback control on the lock screen and in the control center. Note that `MPRemoteCommandCenter` is only available in iOS 7.1 and later; if you need to support iOS 7.0, you should use `UIApplication`'s `beginReceivingRemoteControlEvents` and `endReceivingRemoteControlEvents`.

**Important PiP Note:** When you want to support background audio and Picture in Picture on the same player, you must update the `pictureInPictureActive` property on `BCOVPlaybackController` with the Picture in Picture status. If you are using `AVPlayerViewController`, you can use the `playerViewControllerDidStartPictureInPicture:` and `playerViewControllerDidStopPictureInPicture:` delegate methods to update this property. If you are using the `AVPictureInPictureController`, you can use the `pictureInPictureControllerDidStartPictureInPicture:` and `pictureInPictureControllerDidStopPictureInPicture:` delegate methods to update this property.

**Important AVPlayerViewController Note:** When using AVPlayerViewController, you must set `allowsBackgroundAudioPlayback` to `YES` on the `BCOVPlaybackController` and must also separate the `AVPlayerViewController` from the `AVPlayer` when entering the background and reattach it when the app becomes active.

[tqa1668]: https://developer.apple.com/library/ios/qa/qa1668

Frequently Asked Questions
==========================
**My content won't load. Is there an easy way to test whether the URL points to a valid video?**

If the content is packaged as MP4, you can paste the URL directly into most web browsers, and the video should play (or download to your filesystem, where you can play it locally). If the content is packaged as HLS, you can use QuickTime Player to test it: select `File -> Open Location…` and paste in the `.m3u8` playlist URL, and the video should play.

**I can hear the audio track playing, but the video freezes for a few seconds sporadically. What's happening?**

This is a common symptom of having called a main thread-only UIKit or AVFoundation method from a non-main thread. The delegate methods on `BCOVPlaybackControllerDelegate` are always called on the main thread.

**How do I customize the controls?**

The `BCOVPlayerSDKManager` provides a view strategy that creates rudimentary controls for development purposes, but they are not designed for extension or modification. To differentiate your app and ensure a unique user experience, we recommend that you use the [BCOVPlayerUI project][playerui] or create your own custom controls from scratch. In custom cases, you can add the `BCOVPlaybackController.view` to a UIView behind your own custom controls, and implement the `BCOVPlaybackControllerDelegate` methods to update the controls in response to various playback events. If your needs are more complex (such as if you are integrating with an advertising plugin) then you can implement a view strategy as described in the section on view strategies, above.

[playerui]: https://github.com/brightcove/brightcove-player-sdk-ios-player-ui

**How do I retrieve data from the Brightcove Media API for which there is no `BCOVCatalogService` or `BCOVPlaybackService` method?**

The catalog and playback services offers methods for the most common Brightcove Media API operations, but there are [other operations][media] available. To leverage them, you will need to issue an HTTP request and then process the response. You can use a standard NSURLRequest to do this, or you can leverage a [3rd-party HTTP API][afnet] if you find that easier. In either case, when you receive the response, you can use a standard JSON parser (like NSJSONSerialization) to convert the response into a NSDictionary, and then construct the appropriate value classes from the data in the NSDictionary.

[media]: http://docs.brightcove.com/en/video-cloud/media/
[afnet]: http://afnetworking.com

**Why do I see a message in the log indicating that no source has been found?**

This message indicates that the default source selection policy can't figure which source to pick. The default policy selects the first source whose `deliveryMethod` is `kBCOVSourceDeliveryHLS` ("HLS"). If no HLS source is found, its fallback behavior will select the first source whose `deliveryMethod` is `kBCOVSourceDeliveryMP4` ("MP4"). If no source with a `deliveryMethod` of "HLS" or "MP4" exists on the video, the policy will select the video's first source (regardless of `deliveryMethod`). If you aren't happy with its selection, you can use `-[BCOVPlayerSDKManager createBasicSessionProviderWithOptions:]` and pass in an instance of `BCOVBasicSessionProviderOptions` with a custom `sourceSelectionPolicy` property set. When creating videos and sources manually, ensure that the sources are created with the appropriate `deliveryMethod`.

**[Apple recommends][audioguidelines] that apps which play video should still play audio even when the device is muted. Why doesn't the Brightcove Player SDK for iOS respect these guidelines?**

The API which controls whether an app emits audio in iOS apps is the [AVAudioSession API][avaudiosessionapi]. An audio session is global to an app, which means that its configuration affects both the sounds that are emitted by the AVPlayers created by the Player SDK, as well as other sounds that an app may produce. Since the Player SDK cannot know how the app wants the audio session configured for those other sounds, it doesn't affect the audio session at all. This means that unless you explicitly configure your app's audio session otherwise, you inherit the default behavior of suppressing any and all audio when the device is muted, including audio emitted by AVPlayers. To conform to Apple's recommendations regarding audio playback, you (the app developer) must configure the audio session according to your app's specific needs.

[audioguidelines]: https://developer.apple.com/Library/ios/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/AudioGuidelinesByAppType/AudioGuidelinesByAppType.html
[avaudiosessionapi]: https://developer.apple.com/Library/ios/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007875-CH1-SW1
