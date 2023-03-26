{-# OPTIONS_GHC -Wno-deprecations #-}
import Prelude
import XMonad
import XMonad.Actions.FloatSnap
import XMonad.Config
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (docks, manageDocks, avoidStruts, docksEventHook)
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.ExtensibleState as XS

import System.IO
import Control.Monad (liftM2)
import qualified XMonad.StackSet as W

main =
  xmonad =<< xmobar (docks conf)

-- Named (and un-named) workspaces.
wkspcs = ["video", "web", "term", "4", "tunes", "6", "7", "8", "9"]

-- Per-program management
manageProgs = composeAll [
  className =? "Google-chrome" --> viewShift "web",
    className =? "Firefox"  --> viewShift "web",
    className =? "Gimp"     --> viewShift "img",
    className =? "URxvt"    --> viewShift "term",
    className =? "vlc"      --> viewShift "video",
    stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat,
    title =? "Picture-in-picture" --> doFloat,
    title =? "Minibuffer" --> doIgnore
  ]
  where viewShift = doF . liftM2 (.) W.greedyView W.shift


--handleMinibuffer :: ManageHook
--handleMinibuffer = ask >>= \window -> liftX

newtype MinibufferState = MinibufferState (Maybe Window)
noMinibuffer :: MinibufferState
noMinibuffer = MinibufferState Nothing

instance ExtensionClass MinibufferState where
  initialValue = MinibufferState Nothing

setMinibuffer :: Window -> X ()
setMinibuffer w = XS.put (MinibufferState (Just w))

keybindings = [
  ("M-S-l", spawn "xscreensaver-command --lock"),
    ("M-i", spawn "google-chrome-stable" ),
    ("M-e", spawn "emacsclient -cn"),
    ("M-r", spawn "emacsclient --eval '(wf/focus-minibuffer)'"),
    ("<XF86AudioLowerVolume>", spawn "pulsemixer --change-volume -1"),
    ("<XF86AudioRaiseVolume>", spawn "pulsemixer --change-volume +1"),
    ("<XF86AudioMute>", spawn "pulsemixer --toggle-mute"),
    ("<XF86MonBrightnessUp>", spawn "( F=/sys/class/backlight/intel_backlight/brightness; awk '{print($1+500)}' $F > /tmp/.bklght; cat /tmp/.bklght > $F)"),
    ("<XF86MonBrightnessDown>", spawn "( F=/sys/class/backlight/intel_backlight/brightness; awk '{print($1-500)}' $F > /tmp/.bklght; cat /tmp/.bklght > $F)")
  ]
  ++ -- Stop greedyViewing on multiple screens
  [(otherModMasks ++ "M-" ++ [key], action tag)
   | (tag, key) <- zip wkspcs "123456789"
   , (otherModMasks, action) <- [ ("", windows . W.view)
                               , ("S-", windows . W.shift)]
  ]

conf = defaultConfig {
  terminal = "urxvt -cd \"$(cat /tmp/.last_dir_$UID || echo $HOME)\"",
    modMask = mod4Mask, -- Windows key
    borderWidth = 1,        -- 1 pixel window borders
    normalBorderColor = "#515151",
    focusedBorderColor = "#00aeba",
    workspaces = wkspcs,
    manageHook = manageProgs <+> manageHook defaultConfig,
    layoutHook  = avoidStruts (Tall 1 (3/100) (1/2)) ||| noBorders Full,
    handleEventHook = handleEventHook defaultConfig
  }
       `additionalKeysP` keybindings
