# Secondary Chat Group

This optional module adds an independent group of chat tabs, useful for placing
Party and Raid on a second side of a wide monitor while leaving General, Combat
Log and Guild in the main dock. It reuses existing chat windows and their filters,
message histories, and Prat formatting.

## Setup

1. In `/prat`, open **Module Control** and enable **SecondaryChatGroup**.
2. Type `/pratgroup`, or open **Display Settings > Secondary Chat Group**.
3. Check the existing windows to include. General and Combat Log are excluded.
4. Drag a tab to move the unlocked group; use the bottom-right grip to resize it.
5. Enable **Lock group position and size** when finished.

Create additional windows through General's normal context menu and set their
channel filters before adding them. The native window limit still applies.

Tabs use Blizzard's chat artwork, selected highlight, gold labels, unread glow
and hover fading. They size to their names and wrap when necessary. Right-click
a tab for its normal chat menu; Shift-click moves it left and Ctrl-click moves it
right. Prat's Tabs and SideTabs modules continue to style the main dock; the new
tab bar manages its own appearance.

Membership, ordering, active tab and geometry are stored per character in the
module's AceDB namespace. Enablement follows the Prat profile. Membership changes
and movement are unavailable during combat; ordinary tab switching remains
available. Temporary whispers, minimized windows and protected frames are excluded.

Uncheck a window to restore its original docking or standalone placement. Use
**Return all windows** to empty the group. Disabling the module restores ordinary
windows but retains membership for later re-enabling. Normal logout and reload
also restore native window placement before saving, then reconstruct the group
on login. This provides a fallback if the module is subsequently disabled.

If migrating from the experimental `Prat-3.0_SecondaryChatGroup` companion addon,
disable that companion before using this built-in module; both register the same
module name. The existing per-character settings use the same namespace.

## Implementation and validation

Inactive windows remain shown under hidden containers. In Forever, directly
hiding a window changes its persisted shown state and can allow its slot to be
closed or reused. Proxy tabs inherit only `ChatTabArtTemplate`, avoiding the main
dock's native drag/minimize scripts. Classic texture keys and missing fullscreen
helpers are handled separately.

Run `npm ci --ignore-scripts` and `npm test` for Lua 5.1 parsing and 29 behavior
checks against each simulated modern and Classic UI API. Set `PRAT_PATH` to an
installed Prat folder to additionally run four tests using its actual Ace
libraries and the current checkout's module loader. Test dependencies and fixtures
are excluded from release packages.

The user has exercised the companion version in WoW Forever. The automated tests
do not replace in-game QA. Retail and Classic, combat transitions, gamepad use,
other UI addons, and the integrated build still need in-game verification.
