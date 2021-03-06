#!/usr/bin/env stack
-- stack runghc --package reanimate
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ParallelListComp  #-}
module Main(main) where

import           Codec.Picture
import           Codec.Picture.Types
import           Control.Lens               ((&))
import           Control.Monad
import           Graphics.SvgTree           (LineJoin (..))
import           Reanimate
import           Reanimate.Morph.Common
import           Reanimate.Morph.Linear
import           Reanimate.Morph.Rotational

bgColor :: PixelRGBA8
bgColor = PixelRGBA8 252 252 252 0xFF

main :: IO ()
main = reanimate $
  addStatic (mkBackgroundPixel bgColor) $
  mapA (withStrokeWidth defaultStrokeWidth) $
  mapA (withStrokeColor "black") $
  mapA (withStrokeLineJoin JoinRound) $
  mapA (withFillOpacity 1) $
    scene $ do
      _ <- newSpriteSVG $
        withStrokeWidth 0 $ translate (-3) 4 $
        center $ latex "linear"
      _ <- newSpriteSVG $
        withStrokeWidth 0 $ translate (3) 4 $
        center $ latex "rotational"
      forM_ pairs $ uncurry showPair
  where
    showPair from to =
      waitOn $ do
        fork $ play $ mkAnimation 4 (morph linear from to)
          & mapA (translate (-3) (-0.5))
          & signalA (curveS 4)
        fork $ play $ mkAnimation 4 (morph myMorph from to)
          & mapA (translate (3) (-0.5))
          & signalA (curveS 4)
    myMorph = linear{morphTrajectory = rotationalTrajectory origin }
    origin = (0.5, 0.5)
    pairs = zip stages (tail stages ++ [head stages])
    stages = map (lowerTransformations . scale 6 . pathify . center) $ colorize
      [ latex "X"
      , latex "$\\aleph$"
      , latex "Y"
      , latex "$\\infty$"
      , latex "I"
      , latex "$\\pi$"
      , latex "1"
      , latex "S"
      , mkRect 0.5 0.5
      ]

colorize :: [SVG] -> [SVG]
colorize lst =
  [ withFillColorPixel (promotePixel $ parula (n/fromIntegral (length lst-1))) elt
  | elt <- lst
  | n <- [0..]
  ]
