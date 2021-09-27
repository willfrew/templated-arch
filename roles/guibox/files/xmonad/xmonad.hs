import XMonad
import XMonad.Config
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
wkspcs = ["video", "web", "term", "4", "tunes", "6", "7", "8", "9"]

-- Per-program management
manageProgs = composeAll
                [ className =? "Google-chrome" --> viewShift "web",
                  className =? "Firefox"  --> viewShift "web",
                  className =? "Gimp"     --> viewShift "img",
                  className =? "URxvt"    --> viewShift "term",
                  className =? "vlc"      --> viewShift "video",
                  stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat,
                  title =? "Picture-in-picture" --> doFloat
                ]
                where viewShift = doF . liftM2 (.) W.greedyView W.shift

myKeys      = [
                ("M-S-l", spawn "xscreensaver-command --lock"),
                ("M-i", spawn "google-chrome-stable" ),
                ("M-e", spawn "emacsclient -cn"),
                ("<XF86AudioLowerVolume>", spawn "pulsemixer --change-volume -1"),
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

conf      = defaultConfig
            { terminal     = "urxvt -cd \"$(cat /tmp/.last_dir_$UID || echo $HOME)\"",
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
