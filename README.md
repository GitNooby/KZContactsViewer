# KZContactsViewer
MSFT UI challenge

Maintainer: Kai Zou

Introduction:
I'm a software engineer currently working at Apple.
My role involves building internal tools used by crossfunctional teams for their testing needs.
These internal tools are often iOS/tvOS apps which are designed to exercies the public APIs that Apple released to public developers.
Occasionally the tools also includes setting up and maintaining automation infrastructures.
I started working as an app developer on the Android and iOS platform starting in 2013 at ModiFace after graduating from the University of Toronto with a bachelor's in electrical and computer engineering.

About this app (KZContactsViewer):
This app is an implementation of the app challenging provided by Microsoft's Mobile team.
The original estimated time for completion is 6-8hours; I've tried to cover this over the course of two nights.
I've tried to implement this app as closely as to the video that was provided to me.

Here are some caveats which I think I could've covered further if I had more time:
1. Smoother page-locking:
  The current page-locking is implemented by taking advantage of UITableView's built in paging and scroll animation.
  However, the result of this is that page-locking is not very smooth; it feels like a quick jerk.
  I believe the best way to implement smoother scroll for the page-locking is implementing the scroll view's delegate functions where velocity is provided to the developer.
  Once a velocity vector is available, we can implement our own page-locking spring/damper physics (by leveraging UIKit's physics engine) for better scrolling experience.
2. App architecture:
  The app's architecture is fairly simple and straight forward,
  I didn't feel the need to structure it to be "scalable" (i.e. trying to anticipate what other functionality, views, or view contollers might be introduced later).
  This is why a lot of the app's logic is within KZCVViewController (the only VC in the app)
3. UI or unit testing:
  The app doesn't maintain complicated data structures, set of shared resources, or complex computation.
  I chose to forgo unit testing due to this and in the interest of keeping this within 2 nights.
  UI testing was manual through the simulators.
4. Simulator only (no device testing):
  I didn't deploy to a device, this is because my job forbids me from creating an actual devloper account.
  I do have access to my team's account which I use as part of my work to deploy to devices, but I don't feel comfortable doing this on my team's work account.
5. Documentation:
  The interfaces for the objects I made are pretty straight forward. I tried to let the implementations self-document as much as possible.
