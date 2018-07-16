## [8.0.1.4] - 2018-07-15 ##
### Added ###

  * Communities UI skin

### Fixed ###

  * Dropdown checkboxes had misaligned textures



## [8.0.1.3] - 2018-07-07 ##
### Fixed ###

  * Bags were not using the proper alpha value.
  * The custom highlight setting would not persist.




## [8.0.1.2] - 2018-06-27 ##
### Added ###

  * Azerite reforge skin

### Changed ###

  * Updated dropdowns for BfA.

### Fixed ###

  * A minor incompaibitlty with Kaliel's Tracker.
  * Missed a patch check for garrison tooltips.



## [8.0.1.1] - 2018-06-23 ##
### Added ###

  * Channels UI skin

### Changed ###

  * More Garrison updates.
  * Wardrobe skin updated.

### Fixed ###

  * Scenario progress bar would not show.
  * Wardrobe sets selection was not static.
  * OrderHall tabs were overlapping.



## [v8.0.1.0] - 2017-10-16 ##
### Added ###

  * Zone Ability skin
  * PvP Timer skin
  * Objective tracker skin
  * OrderhallUI skin - still WIP
  * Compatibility with BfA beta

### Changed ###

  * Updated StaticPopup skin.
  * Updated TrainerUI skin.
  * Updated MacroUI skin.
  * Updated quest log skins.
  * Updated TalentUI skin.

### Fixed ###

  * Raid frame manager taint
  * The text layout for the Artifact history lore was off.
  * Icon borders in the BMAH were not properly skinned.
  * Bags now have the proper opacity.

### API ###
  * API is now alpha 0.3
  * The use of explicit RGB values for Base.SetBackdrop and Base.SetBackdropColor has been deprecated. Use a color object instead.
  * API Pre and Post hooks have been deprecated. Hooks should be created manually by the layout.




## [v7.3.5.1] - 2017-10-16 ##
### Fixed ###

  * Typo caused an error in raid manager skin.



## [v7.3.5.0] - 2018-01-16 ##
### Added ###

  * Pet Battle UI skin
  * Primary Action bar skin
  * Warboard UI
  * Raid Frame manager skin

### Changed ###

  * Updated QuestChoiceFrame skin.
  * Tweak PvP score frame skin.

### Fixed ###

  * Added a workaround if ApplySnapshot fails.



## [v7.3.0.5] - 2017-10-16 ##
### Changed ###

  * Added ExtraActionBar skin.
  * Updated PvP score frame skin.

### Fixed ###

  * Opening the Reagent Bank with a quest item in it would produce an error.
  * Bagnon item buttons would be darker than usual.
  * Controlling two carts at once in Silvershard Mines would produce an error.
  * An error would occur for some users with very high resolutions.
  * The reputation frame may produce an error if there are not enough factions to list.



## [v7.3.0.4] - 2017-09-24 ##
### Changed ###

  * Updated error frame skin.
  * Main Menu Bar skins are now disabled by default.

### Fixed ###

  * The paragon rep status bar was not positioned correctly.
  * Certain global fonts would still be skinned even with the option disabled.



## v7.3.0.3 - 2017-09-06 ##
### Changed ###

  * Updated MerchantFrame skin.
  * Updated chat bubble skin.
  * Updated tooltip skins.

### Fixed ###

  * Error due to a conflict with Overachiever.
  * Some tooltips would still be skinned even when disabled.



## v7.3.0.2 - 2017-09-01 ##
### Fixed ###

  * Tootips would not obey alpha setting.
  * Relic borders were not positioned properly.
  * Clicking on a quest reward would result in an error.



## v7.3.0.1 - 2017-08-29 ##
### Fixed ###

  * Custom class colors would not initialize properly.



## v7.3.0.0 - 2017-08-29 ##
### Changed ###

  * Updated QuestInfo skin.
  * Updated PetStable skin.
  * Updated CharacterFrame skin.
  * Updated GossipFrame skin.
  * Added custom class colors.

### Fixed ###

  * Fixed another possible map taint trigger.
  * Misc bugs due to changes in 7.3.



## v7.2.5.1 - 2017-06-19 ##
### Changed ###

  * Minor tweaks to the mail box skin.

### Fixed ###

  * Fixed a possible map taint trigger.
  * An error would sometimes pop up when viewing the talents frame.



## v7.2.5.0 - 2017-06-02 ##
### Changed ###

  * Various updates for patch 7.2.5.
  * Added new option to show names in chat bubbles.
  * Improved loot frame skin.
  * Improved auction house skin.
  * Improved battlefield minimap skin.
  * Improved help frame skin.
  * Completely new spellbook skin.

### Fixed ###

  * Many item icons now have proper quality coloring. (WIP)

[Unreleased]: https://github.com/Haleth/Aurora/compare/master...develop
[8.0.1.4]: https://github.com/Haleth/Aurora/compare/8.0.1.3...8.0.1.4
[8.0.1.3]: https://github.com/Haleth/Aurora/compare/8.0.1.2...8.0.1.3
[8.0.1.2]: https://github.com/Haleth/Aurora/compare/8.0.1.1...8.0.1.2
[8.0.1.1]: https://github.com/Haleth/Aurora/compare/v8.0.1.0...8.0.1.1
[v8.0.1.0]: https://github.com/Haleth/Aurora/compare/v7.3.5.1...v8.0.1.0
[v7.3.5.1]: https://github.com/Haleth/Aurora/compare/v7.3.5.0...v7.3.5.1
[v7.3.5.0]: https://github.com/Haleth/Aurora/compare/v7.3.0.5...v7.3.5.0
[v7.3.0.5]: https://github.com/Haleth/Aurora/compare/v7.3.0.4...v7.3.0.5
[v7.3.0.4]: https://github.com/Haleth/Aurora/compare/v7.3.0.3...v7.3.0.4
