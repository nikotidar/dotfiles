import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import Graphics.X11.ExtraTypes.XF86
import Data.Default
import Data.Monoid
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map as M

myTerminal :: [Char]
myBorderWidth :: Dimension
myNormalBorderColor :: [Char]
myFocusedBorderColor :: [Char]
myXmobarHlColor :: [Char]
myXmobarTitleColor :: [Char]
myFocusFollowsMouse :: Bool
myModMask :: KeyMask
myTerminal = "urxvt"
myBorderWidth = 4
myNormalBorderColor = "#4c5356"
myFocusedBorderColor = "#607a86"
myXmobarHlColor = "#607a86"
myXmobarUrgentColor = "#89757e"
myXmobarTitleColor = "#deded6"
myFocusFollowsMouse = True
myModMask = mod4Mask

-- ideally i wouldn't have to do this but nixos doesn't support
-- not using a display manager so i just use the xsession
myStartupHook :: X ()
myStartupHook = do
  spawn "xset +fp /home/betmen/.fonts"
  spawn "xset fp rehash"
  spawn "hsetroot -solid '#282936'"
  spawn "compton --config /home/betmen/.config/compton/compton.conf"
  spawn "wmname LG3d"

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.1
    w = 1
    t = 1 - h
    l = 1 - w

myManageHook :: ManageHook
myManageHook =
  manageDocks <+>
  manageScratchPad

myLogHook :: Handle -> X ()
myLogHook xmproc =
  dynamicLogWithPP xmobarPP {
    ppCurrent = xmobarColor myXmobarHlColor ""
  , ppUrgent = xmobarColor myXmobarUrgentColor ""
  , ppHidden = xmobarColor myXmobarTitleColor "" . (\ws -> if ws == "NSP" then "" else ws)
  , ppOutput = hPutStrLn xmproc
  , ppSep = xmobarColor myXmobarHlColor "" " / ", ppTitle = xmobarColor myXmobarTitleColor "".shorten 50
  }

myLayout =
  spacing 5 $
  gaps [(U, 20)] $
  avoidStruts $
  tiled ||| Mirror tiled ||| three ||| spiral (6/7) ||| Full
  where
    tiled = ResizableTall nmaster delta ratio slaves
    three = ThreeCol nmaster delta threeRatio
    nmaster = 1
    ratio = 1/2
    delta = 3/100
    slaves = []
    threeRatio = 1/3

myHandleEventHook :: Event -> X All
myHandleEventHook =
  handleEventHook def

scratchpad :: X ()
scratchpad = scratchpadSpawnActionTerminal "urxvt"
newKeys XConfig {XMonad.modMask = modMask} =
  [ ((modMask, xK_u), scratchpad)
  , ((modMask, xK_a), sendMessage MirrorExpand)
  , ((modMask, xK_z), sendMessage MirrorShrink)
  , ((modMask, xK_d), spawn "gmrun")
  , ((modMask, xK_q), recompile True >> restart "xmonad" True)
  , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume 0 +5%")
  , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume 0 -5%")
  , ((0, xF86XK_AudioMute), spawn "pactl set-sink-volume 0 toggle")
  , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 5")
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
  , ((0, xK_Print), spawn "scrot")
  , ((shiftMask, xK_Print), spawn "scrot -s")
  , ((0, xK_End), spawn "slock")
  ]
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys x = M.union (M.fromList (newKeys x)) (keys def x)

main :: IO ()
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/betmen/.xmonad/xmobarrc"
  xmonad $ def
    { borderWidth = myBorderWidth
    , terminal = myTerminal
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , focusFollowsMouse = myFocusFollowsMouse
    , manageHook = myManageHook
    , layoutHook = myLayout
    , logHook = myLogHook xmproc
    , handleEventHook = myHandleEventHook
    , startupHook = myStartupHook
    , modMask = myModMask
    , keys = myKeys
    }
