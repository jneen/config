{-# LANGUAGE OverloadedStrings #-}

import XMonad
import XMonad.Util.Run (safeSpawn)
import XMonad.Hooks.ManageDocks (manageDocks, avoidStruts)
import XMonad.Config.Desktop (desktopConfig)
import XMonad.Config.Gnome (gnomeConfig, gnomeRegister)
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.NoBorders (smartBorders)
import qualified XMonad.StackSet as W
import XMonad.Layout.IM
import XMonad.Layout.ShowWName (showWName', swn_font, SWNConfig)
import XMonad.Layout.Dwindle
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Util.WindowProperties
import XMonad.Actions.PhysicalScreens

import Foreign.C.Types (CLong)
import System.Directory (doesFileExist)
import System.IO (appendFile)
import Control.Monad (forM, msum)
import Data.Maybe (catMaybes, listToMaybe)
import Data.List (dropWhileEnd)
import Data.List.Split (splitOn)
import Data.Char (isSpace)
import Data.Function (on, (&))
import Debug.Trace (traceIO)

import XMonad.Actions.SpawnOn (spawnHere, manageSpawn)
-- import XMonad.Actions.Volume (lowerVolume, raiseVolume, toggleMute)

import XMonad.Hooks.DynamicLog

import Data.Monoid ((<>))
import qualified Data.Map as Map
import Data.Map (Map)

-- instance Show (Dwindle a) where
--   show _ = "dwindle"

myTerminal = "gnome-terminal"

withWindowName = showWName' (def { swn_font = "xft:InputMono-12,M+" })

pidQuery :: Query [Integer]
pidQuery = ask >>= \w -> liftX $
   fmap (maybe [] (fmap toInteger)) $ getProp32s "_NET_WM_PID" w

sticky :: Query (Maybe String)
sticky = do
  pids <- pidQuery

  let sources = [getStickyEnv, getStickyFile]

  let queries = map liftIO $ pids >>= \pid -> map (pid &) sources

  sticky <- fmap msum . sequence . map liftIO $ queries

  -- liftIO $ log $ "sticky: " ++ (show sticky)
  return sticky

  where
    log :: String -> IO ()
    log = appendFile "/tmp/xmonad-debug" . (++ "\n")

    getStickyFile :: Integer -> IO (Maybe String)
    getStickyFile pid = do
      let stickyFname = "/tmp/sticky/" ++ (show pid)
      exists <- doesFileExist stickyFname
      if exists
      then fmap (Just . dropWhileEnd isSpace) $ readFile stickyFname
      else return Nothing

    getStickyEnv :: Integer -> IO (Maybe String)
    getStickyEnv pid = fmap (lookupNullSep "XMONAD_STICKY") $ readFile envFname
      where envFname = "/proc/" ++ (show pid) ++ "/environ"

    lookupNullSep :: String -> String -> Maybe String
    lookupNullSep needle = fmap tryTail . lookup needle . map (break (== '=')) . splitOn "\0"

    tryTail [] = []
    tryTail (_:t) = t


manageSticky config = composeAll $ map makeQuery $ workspaces config
  where
    makeQuery workspace = sticky =? (Just workspace) --> doShift workspace

approxGoldenRatio :: Int -> Rational
approxGoldenRatio n = goldenRatios !! n
  where
    goldenRatios :: [Rational]
    goldenRatios = iterate (\x -> 1/(1+x)) 1


goldenRatio :: Rational
goldenRatio = approxGoldenRatio 10

myLayout = withWindowName $
           avoidStruts $
           onWorkspace "9" (Full ||| tiled) $
           (tiled ||| horiz ||| Full)
  where
    -- default tiling alg partitions the screen into two panes
    -- tiled = spacing pxspacing $ Tall nmaster delta ratio
    -- tiled = spacing pxspacing $ spiral (1 / ratio)
    tiled = spacing pxspacing $ Dwindle R CW ratio ratio
    horiz = spacing pxspacing $ Dwindle D CW ratio ratio

    -- spacing between panes
    pxspacing = 0

    -- The default number of windows in the master pane
    nmaster = 1

    -- default proportion of the screen occupied by the master pane
    ratio = (1 / goldenRatio) :: Rational

myLayoutHook = smartBorders $ myLayout

myStartupHook :: X ()
myStartupHook = do
  gnomeRegister
  startupHook desktopConfig
  safeSpawn "/bin/bash" ["/home/jneen/.xmonad/init.sh"]

shiftedNumerals =
  [ xK_exclam
  , xK_at
  , xK_numbersign
  , xK_dollar
  , xK_percent
  , xK_asciicircum -- wtf
  , xK_ampersand
  , xK_asterisk
  , xK_parenleft
  ]

type KeyMap = Map (ButtonMask, KeySym) (X ())
type Keys = XConfig Layout -> KeyMap
easyKeys :: (KeyMask -> [((ButtonMask, KeySym), X ())]) -> Keys
easyKeys maker = \(XConfig {modMask = mask}) -> Map.fromList (maker mask)

windowKeys :: Keys
windowKeys conf@(XConfig {modMask = passedMask}) = Map.fromList $ do
  let greedyShift i = W.greedyView i . W.shift i
  (op, keyMask) <- [(W.greedyView, 0), (greedyShift, shiftMask)]
  let mask = keyMask .|. passedMask
  (workspace, key) <- zip (workspaces conf) shiftedNumerals
  let action = windows $ op workspace
  return ((mask, key), action)

-- order w, e, r keys by x-coordinate of the rectangle
screenKeys :: Keys
screenKeys = easyKeys $ \mask ->
  do
    (key, screenNumber) <- zip [xK_w, xK_e, xK_r] [0..]
    (f, shift) <- [(viewScreen comp, 0), (sendToScreen comp, shiftMask)]
    return ((mask .|. shift, key), f screenNumber)

  where
    comp :: ScreenComparator
    comp = screenComparatorByRectangle (compare `on` rect_x)

lowerVolumeKey = stringToKeysym "XF86AudioLowerVolume"
raiseVolumeKey = stringToKeysym "XF86AudioRaiseVolume"
muteKey = stringToKeysym "XF86AudioMute"

volumeKeys = easyKeys $ \mask ->
  let
    amix :: [String] -> X ()
    amix args = safeSpawn "amixer" (["-D", "hw:PCH", "set"] ++ args)
  in [ ((0, muteKey), amix ["Master", "toggle"])
     , ((0, lowerVolumeKey), amix ["Master", "2%-"])
     , ((0, raiseVolumeKey), amix ["Master", "2%+"]) ]

brightnessUpKey = stringToKeysym "XF86MonBrightnessUp"
brightnessDownKey = stringToKeysym "XF86MonBrightnessDown"

brightnessKeys = easyKeys $ \mask ->
  [ ((0, brightnessUpKey), safeSpawn "xbacklight" ["+20"])
  , ((0, brightnessDownKey), safeSpawn "xbacklight" ["-20"]) ]

explorerKey = stringToKeysym "XF86Explorer"
searchKey = stringToKeysym "XF86Search"

termKeys = easyKeys $ \mask ->
  [ ((0, xK_F12), safeSpawn myTerminal [])
  , ((0, explorerKey), safeSpawn myTerminal [])
  , ((0, searchKey), safeSpawn myTerminal []) ]

-- Sys_Req is shift-print
-- use it to take a shot of the whole screen (no select)
printKey = stringToKeysym "Print"
sysreqKey = stringToKeysym "Sys_Req"

scrot_s = spawn "sleep 0.2; scrot -s ~/Screenshots/'%Y-%m-%d@%h:%m:%s_$wx$h.png' -e 'echo -n $f | xsel -b' 2>&1 | logger -t scrot"
scrot_u = spawn "sleep 0.2; scrot -u ~/Screenshots/'%Y-%m-%d@%h:%m:%s_$wx$h.png' -e 'echo -n $f | xsel -b' 2>&1 | xsel -bc | logger -t scrot"

screenshotKeys :: Keys
screenshotKeys = easyKeys $ \mask ->
  [ ((0, xK_F10),           scrot_s)
  , ((shiftMask, xK_F10),   scrot_u)
  , ((0, printKey),         scrot_s)
  , ((0, sysreqKey), scrot_u) ]

screenLayout :: String -> X ()
screenLayout name = spawn $ "sleep 0.2; shellfn layout "++name++" 2>&1"

layoutKeys :: Keys
layoutKeys = easyKeys $ \mask ->
 [ ((mask, xK_d), screenLayout "-d")
 , ((mask, xK_f), screenLayout "default") ]

execKeys :: Keys
execKeys = easyKeys $ \mask -> []
  -- [ ((mask, xK_F5), spawnHere $ "discord" )] -- "bash < /tmp/xmonad-exec") ]

myConfig = gnomeConfig
  { modMask = mod4Mask
  , startupHook = myStartupHook
  , terminal = myTerminal
  , manageHook = manageSticky myConfig <+> manageSpawn <+> manageDocks <+> manageHook gnomeConfig
  , layoutHook = myLayoutHook
  , borderWidth = 4
  , normalBorderColor = "#3C3B37" -- dark gray
  , focusedBorderColor = "#68B1D0" -- light gray
  , keys = (termKeys
         <> windowKeys
         <> screenKeys
         <> volumeKeys
         <> screenshotKeys
         <> brightnessKeys
         <> layoutKeys
         <> execKeys
         <> keys gnomeConfig)
  }

main = do
  xmonad =<< xmobar myConfig
