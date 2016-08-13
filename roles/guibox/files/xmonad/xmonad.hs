import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)
import System.IO
import Control.Monad (liftM2)
import qualified XMonad.StackSet as W


main =
  xmonad =<< xmobar conf

-- Named (and un-named) workspaces.
wkspcs = ["code", "web", "term", "skype", "tunes", "6", "7", "8", "9"]

-- Per-program management
manageProgs = composeAll
                [ className =? "chromium" --> viewShift "web",
                  className =? "Firefox"  --> viewShift "web",
                  className =? "Brackets" --> viewShift "code",
                  className =? "Atom"     --> viewShift "code",
                  stringProperty "WM_NAME" =? "Eclipse"  --> viewShift "code",
                  className =? "Gimp"     --> viewShift "img",
                  className =? "URxvt"    --> viewShift "term",
                  className =? "Skype"    --> viewShift "skype",
                  stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
                ]
                where viewShift = doF . liftM2 (.) W.greedyView W.shift

myKeys      = [
                ("M-S-l", spawn "xscreensaver-command --lock"),
                ("M-i", spawn "chromium" ),
                ("<XF86AudioRaiseVolume>", spawn "amixer set Master 1+"),
                ("<XF86AudioLowerVolume>", spawn "amixer set Master 1-"),
                ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10"),
                ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10"),
                ("<XF86AudioMute>", spawn "amixer set Master toggle"),
                -- asus specific binds
                -- TODO: work out how to set keys per machine.
                ("<XF86KbdBrightnessUp>", spawn "asus-kbd-backlight up"),
                ("<XF86KbdBrightnessDown>", spawn "asus-kbd-backlight down")
              ]
              ++ -- Stop greedyViewing on multiple screens
              [(otherModMasks ++ "M-" ++ [key], action tag)
                | (tag, key) <- zip wkspcs "123456789"
                , (otherModMasks, action) <- [ ("", windows . W.view)
                                                , ("S-", windows . W.shift)]
              ]

conf      = defaultConfig
            { terminal     = "urxvt -cd \"$(cat /tmp/.last_dir || echo $HOME)\"",
              modMask      = mod4Mask, -- Windows key
              borderWidth  = 1,        -- 1 pixel window borders
              normalBorderColor = "#515151",
              focusedBorderColor = "#00aeba",
              workspaces = wkspcs,
              manageHook = manageProgs <+> manageDocks <+> manageHook defaultConfig,
              layoutHook   = avoidStruts $ Tall 1 (3/100) (1/2) ||| noBorders Full,
              handleEventHook = docksEventHook <+> handleEventHook defaultConfig
            }
          `additionalKeysP` myKeys

