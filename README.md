A lightweight library that intelligently adjusts dropdown positioning to ensure it remains fully visible by opening either above or below the trigger button based on available space.

## Features v0.0.1

- The `AppAutoDropdown` widget support data list for not enough space.
- The `parentScrollController` this is ScrollController of screen when scroll auto close dropdown.
- The `DropItem` class has replaced the `DropListWidget` class.
- `onSeleted` has been replaced with `onSeleted`. The `onSeleted` callback is called whenever the selection changes in the dropdown, whether it is selected or deselected.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Preview
| <img src="https://github.com/trungquan2k/quanht_auto_dropper/blob/develop/assets/on_the_top.png?raw=true" width="250px"> | <img src="https://github.com/trungquan2k/quanht_auto_dropper/blob/develop/assets/on_the_bottom.png?raw=true" width="250px"> |

## Usage

### Simple use

### If you want to control auto close dropdown when scroll need to add parentScrollController in widget
### scrollController is a scrollController of screen
TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

List dropitem need to convert like  `DropItem` include `name` and `id` will required
Inaddition, `DropItem` allow add flag prefix in to dropdown

``` dart
  final DropItem listDrop = DropItem(name: '', id: -1);
```

```dart
 AppAutoDropdown(
    items: <DropItem>[],
   label: '$Label',
   hintText: '$Hint text',
   parentScrollController: scrollController,
   onSelected: (output){},
 ),
```
