#!/usr/bin/env stack
-- stack runghc --package reanimate
{-# LANGUAGE OverloadedStrings #-}
module Main ( main ) where

-- import           Data.Matrix
import           Graphics.SvgTree
import           Reanimate
import           Reanimate.Builtin.Documentation
import           Reanimate.LaTeX
import           Reanimate.Morph.Common
import           Reanimate.Morph.Linear
import           Reanimate.Morph.Rotational
import           Reanimate.Transform

customDuration = 1

main :: IO ()
main = reanimate
  $ docEnv
  $ testExampelRotation

testExampelRotation = playThenReverseA $ pauseAround 0.5 0.5 $ mkAnimation 3 $ \t ->
  withStrokeLineJoin JoinRound $
  let src = scale 8 $ center $ latex "X"
      dst = scale 8 $ center $ latex "H"
  in morph rawLinear src dst t

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
