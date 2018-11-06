# LOTs

<a href="https://itunes.apple.com/us/app/lots/id1439182743?l=zh&ls=1&mt=8"><img src="https://imgurl.org/temp/1811/79e15d026616cee0.png" width="200"></a>

## Introduction

As a foodie, is always interested in others' meals and restaurant pocket lists.
To collect and organize list conveniently, LOTs was born.
Stands for "Lunch Of Today", aim to inspire users to explore more dining idea.

![](https://imgurl.org/temp/1811/b6f42b3ce148ad92.png)

## Outline


* Main Page
* Inspire Page
* Post Page
* Like Collection Page
* Detail Page


## Key Features

<!-- * Custom UICollection Layout
* Animation / Transition
* Custom Camera
* Notification Update -->

#### Custom UICollectionView Layout
> CollectionView apply the `Flow` layout as default, customize layout in `Custom` Class.
Here are key elements to implement the dynamic effect.

  * Pinterest Style:

    * `LayoutDelegate` Define height and width for photos as a protocol blueprint.

    * `MainLayout` Customize to set up `numberOfColumns`, `cache`, `prepare()`
      * `prepare()`:
         * Cell Frame: Asks the delegate (conform to `LayoutDelegate`) for the width and height of photos to calculate.
         * Attributes: Create an UICollectionView Layout Item with the frame and add to the cache so that speed up loading pictures.
         * Note: To avoid the conflict of indexPath number, suggest `cache.removeAll()` at the beginning of `prepare()`.
      * `layoutAttributesForElements`: Override this function to loop the cache for items.

    * `MainViewController` Extension to conform `LayoutDelegate` to implement function to set the size of Cell according to indexPath.

* Instagram Style:

  As the CollectionView should be set frame individually. To simplfy and reuse the frame structure, calculate the first `6 cells` as a group to storage `InspireSize` in `dictionary` way.

  * `prepare()`

      ```
      for index in 0 ... 5 {

        var x = CGFloat(index % 3) * (itemSize.width + 10) + 10
        var y = CGFloat(index / 3) * (itemSize.height + 10) + 10

        switch index {

            case 0:
            let inspireSize = InspireSize(x: x,
                                          y: y,
                                          width: itemSize.width * 2 + 10,
                                          height: itemSize.height * 2 + 10)
            dictionary[0] = inspireSize
            ....
        }

      }
      ```




  * `InspireCollectionViewLayout`
  * `layoutAttributesForElements`



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

## Requirement

* iOS 11.3 +
* XCode 10.0

## Version

* 1.1 - 2018/11/01
  * Apply camera feature
  * Fix the report and block function


* 1.0 - 2018/10/23
  * Released first verision

## Reference


## Contacts
**Nia Fan**
niafan0128@gmail.com
