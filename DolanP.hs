import Haste
import Haste.Graphics.Canvas
--import Control.Wire

squareShape :: Shape ()
squareShape = do
  rect (-20, -20) (20, 20)

circleShape = do
  translate (-x/2.0, -y/2.0) $ stroke $ circle (x, y) r
  stroke $ circle (x, y) r
  where
    (x, y) = (20, 20)
    r = 20

square :: Picture ()
square = stroke squareShape

main :: IO ()
main = do
  Just canvas <- getCanvasById "canvas"
  animate canvas 0

time :: Int
time = 10

animate :: Canvas -> Double -> IO ()
animate canvas t = do
  render canvas $ do
    translate (160, 160) $ do
      --scale (s, s) circleShape
      circleShape
  setTimeout time $ animate canvas (t + (fromIntegral time))
  where
    t' = t / 1000.0
    s = 1.0 - (sin t')

