# LOTs

<a href="https://itunes.apple.com/us/app/lots/id1439182743?l=zh&ls=1&mt=8"><img src="https://imgurl.org/temp/1811/79e15d026616cee0.png" width="200"></a>

## Introduction

As a foodie, is always interested in others' meals and restaurant pocket lists.
To collect and organize list conveniently, LOTs was born.
Stands for "Lunch Of Today", aim to inspire users to explore more dining idea.

## Outline


* Main Page
* Inspire Page
* Post Page
* Like Collection Page
* Detail Page


## Key Features

* Custom UICollection Layout
  * Pinterest Style
  * Instagram Style
* Animation / Transition
* Custom Camera
* Notification Update

#### Custom UICollection Layout

  * Pinterest Style: Here are key elements to implement the dynamic effect.

    * `CollectionViewLayout` CollectionView apply the `Flow` layout as default,
     implement customized layout in `Custom` Class.   

    * `LayoutDelegate` Define height and width for photos as a protocol blueprint.

    * `MainLayout` Customize to set up `numberOfColumns`, `cache`, `prepare()`, in this Class.
      * `prepare()`:
       * Cell Frame: Asks the delegate (conform to `LayoutDelegate`) for the width and height of photos to calculate.
       * Attributes: Create an UICollectionViewLayoutItem with the frame and add to the cache so that speed up loading pictures.
       * Note: To avoid the conflict of indexPath number, suggest `cache.removeAll()` at the beginning of `prepare()`.
      * `layoutAttributesForElements`: Override this function to loop the cache for items.

    * `MainViewController` Extension to conform `LayoutDelegate` to implement function to set the size of Cell according to indexPath.

* Instagram Style:




## Libraries

* Crashlytics
* DatePickerDialog
* Fabric
* Firebase SDK
* Facebook SDK
* IQKeyboardManagerSwift
* KeychainSwift
* Kingfisher
* Lottie
* MCPicker
* SwiftLint

## Screenshot


## Requirement

* iOS 11.3 +
* XCode 10.0

## Version

* 1.1 - 2018/11/01
  * Apply camera feature
  * Fix the report and block function


* 1.0 - 2018/10/23
  * Released first verision

## Contacts
**Nia Fan**
niafan0128@gmail.com
