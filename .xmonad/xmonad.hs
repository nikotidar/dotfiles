{-# OPTIONS_GHC -Werror #-}
{-# OPTIONS_GHC -fwarn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

import           Data.List
import           XMonad
import           XMonad.Actions.MessageFeedback
import           XMonad.Actions.Promote
import           XMonad.Config.Desktop
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Layout.BinarySpacePartition
import           XMonad.Layout.Decoration
import           XMonad.Layout.Gaps
import           XMonad.Layout.Named
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.SubLayouts
import           XMonad.Layout.Tabbed
import           XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet                    as W
import           XMonad.Util.EZConfig               (additionalKeysP)
import           XMonad.Util.Paste                  as P
import           XMonad.Util.Run

main = do
  xmproc <- spawnPipe myBar
  xmonad
    $ addKeys myKeys
    $ defaults xmproc

outerGaps = 5

myFont    = "xft:Iosevka:style=Regular:pixelsize=180:hinting=true"
myBar     = "xmobar -x0 $HOME/.xmonad/xmobar.conf"
myGaps    = gaps [(U, outerGaps), (R, outerGaps), (L, outerGaps), (D, outerGaps)]
myLayout  = smartBorders $ threeCol
mySpacing = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#f9ee98"
orange  = "#cb4b16"
red     = "#cf6a4c"
magenta = "#9b859d"
violet  = "#6c71c4"
blue    = "#7587a6"
cyan    = "#afc4db"
green   = "#8f9d6a"

active       = blue
activeWarn   = red
inactive     = base02
focusColor   = blue
unfocusColor = base02

topbar = 10

defaults p = desktopConfig
  { terminal           = "termite"
  , modMask            = mod4Mask
  , borderWidth        = 1
  , focusedBorderColor = "#5f5a60"
  , normalBorderColor  = "#5f5a60"
  , manageHook         = manageDocks <+> manageHook desktopConfig
  , layoutHook         = myLayout
  , logHook            = myLogHook p
  }

threeCol = named "ThreeCol"
  $ avoidStruts
  $ myGaps
  $ mySpacing
  $ addTabs shrinkText myTabTheme
  $ ThreeColMid 1 (1/20) (1/2)

topBarTheme = def
    { inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = active
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = topbar
    }

myTabTheme = def
    { fontName              = myFont
    , activeColor           = active
    , inactiveColor         = base02
    , activeBorderColor     = active
    , inactiveBorderColor   = base02
    , activeTextColor       = base03
    , inactiveTextColor     = base00
    }

myKeys =
  [ ("M-w",        spawn "firefox &")
  , ("M-<Return>", spawn "termite")
  , ("M-e",        spawn "emacsclient -c")
  , ("M-d",        spawn "rofi -matching fuzzy -modi combi -show combi -combi-modi drun -show-icons -theme sidebar")
  , ("M-g",        withFocused (sendMessage . UnMerge))
  , ("M-S-g",      withFocused (sendMessage . MergeAll))
  , ("M-<Tab>",    sendMessage NextLayout)
  , ("M-b",        promote)
  , ("M-m",        bindOn LD [("Tabs", windows W.focusDown), ("", onGroup W.focusDown')])
  , ("M-n",        bindOn LD [("Tabs", windows W.focusUp),   ("", onGroup W.focusUp')])
  , ("C-m",        windows W.swapDown)
  , ("C-n",        windows W.swapUp)
  , ("M-S-f",      fullScreen)
  ]
  where
    fullScreen = sequence_
      [ P.sendKey P.noModMask xK_F11
      , tryMsgR (ExpandTowards L) Shrink
      , tryMsgR (ExpandTowards R) Expand ]

myLogHook h =
  dynamicLogWithPP $ def
    { ppOrder           = \(ws:l:t:_) -> [ws,l,t]
    , ppCurrent         = xmobarColor red      "" . const "●"
    , ppVisible         = xmobarColor base0    "" . const "⦿"
    , ppUrgent          = xmobarColor magenta  "" . const "●"
    , ppHidden          = xmobarColor base0    "" . const "●"
    , ppHiddenNoWindows = xmobarColor base0    "" . const "○"
    , ppTitle           = xmobarColor active   ""
    , ppLayout          = xmobarColor yellow   ""
    , ppSep             = "  "
    , ppWsSep           = " "
    , ppOutput          = hPutStrLn h
    }

-- addTopBar = noFrillsDeco shrinkText topBarTheme
addKeys keys conf@(XConfig {XMonad.modMask = modMask}) = additionalKeysP conf keys
tryMsgR x y = sequence_ [(tryMessageWithNoRefreshToCurrent x y), refresh]

data XCond = WS | LD

-- | Choose an action based on the current workspace id (WS) or
-- layout description (LD).
chooseAction :: XCond -> (String->X()) -> X()
chooseAction WS f = withWindowSet (f . W.currentTag)
chooseAction LD f = withWindowSet (f . description . W.layout . W.workspace . W.current)

-- | If current workspace or layout string is listed, run the associated
-- action (only the first match counts!) If it isn't listed, then run the default
-- action (marked with empty string, \"\"), or do nothing if default isn't supplied.
bindOn :: XCond -> [(String, X())] -> X()
bindOn xc bindings =
  chooseAction xc $ chooser where
    chooser xc = case find ((xc==).fst) bindings of
        Just (_, action) -> action
        Nothing -> case find ((""==).fst) bindings of
            Just (_, action) -> action
            Nothing          -> return ()
