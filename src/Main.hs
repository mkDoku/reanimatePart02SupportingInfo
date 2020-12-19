#!/usr/bin/env stack
-- stack runghc --package reanimate

module Main ( main ) where

import           Reanimate
import           Reanimate.Builtin.Documentation

customDuration = 1

main :: IO ()
main = reanimate
  $ docEnv
  $ staticFrame customDuration
  $ staticStar

-- A static 'SVG' by using 'mkLinePathClosed'
--
-- with 'mkLinePathClosed' the last point will
-- be connected to the first point
staticStar :: SVG
staticStar =
  mkLinePathClosed
    [ leftBottom
      , middleTop
      , rightBottom
      , leftCustom
      , rightCustom
    ]

-- Some coordinates
leftBottom   = (screenLeft, screenBottom)
middleTop    = (0, screenTop)
rightBottom  = (screenRight, screenBottom)
customHeigth = 1
leftCustom   = (screenLeft, customHeigth)
rightCustom  = (screenRight, customHeigth)
