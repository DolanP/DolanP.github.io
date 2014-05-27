import Haste
import Haste.Graphics.Canvas
import Control.Wire
import Prelude hiding ((.), id)



getWidth :: IO String
getWidth = withElem "canvas" (`getProp` "width")

getHeight :: IO String
getHeight = withElem "canvas" (`getProp` "height")

getClientWidth :: IO String
getClientWidth = withElem "MAIN_HTML" (`getProp` "clientWidth")

getClientHeight :: IO String
getClientHeight = withElem "MAIN_HTML" (`getProp` "clientHeight")

--setCanvasSize :: (Int, Int) -> IO ()


-- IO (Width, Height)
adjustSize :: IO (Double, Double)
adjustSize = do
  Just cWidth <- (return . fromString) =<< getClientWidth :: IO (Maybe Double)
  Just cHeight <- (return . fromString) =<< getClientHeight :: IO (Maybe Double)
  setCanvasSize (floor (cWidth * 0.9), floor (cHeight * 0.9))
  Just width <- (return . fromString) =<< getWidth :: IO (Maybe Double)
  Just height <- (return . fromString) =<< getHeight :: IO (Maybe Double)
  return (width, height)
  where
    setCanvasSize :: (Int, Int) -> IO ()
    setCanvasSize (cW, cH) = do
      withElem "canvas" (\e -> setProp e "width" $ toString cW)
      withElem "canvas" (\e -> setProp e "height" $ toString cH)

circleShape :: Double -> Picture ()
circleShape r = -- do
  --translate (-r, -r) $ stroke $ circle (0, 0) r
  stroke $ circle (0, 0) r

--(width, height) = (320, 320)

hGraph :: (Double, Double) -> Double -> Picture ()
hGraph (w, h) t = do
  translate (w*0.3,h*0.3) $ scale (1.0, -1.0) $ stroke $ do
    --line (x0, y0) (x1, y1)
    line (x0, y0) (x2, y2)
    line (0.0, 0.1*h) (0.6*w,0.1*h)
  where 
    (x0, y0) = (0.0, 0.0)
    (x1, y1) = (0.6*w, 0.0)
    (x2, y2) = (0.0, 0.2*h)

vGraph :: (Double, Double) -> Double -> Picture ()
vGraph (w, h) t = do
  translate (0.2*w-0.1*h,0.5*h) $ scale (1.0, -1.0) $ stroke $ do
    line (x0, y0) (x1, y1)
    --line (x0, y0) (x2, y2)
    line (0.1*h, 0.0) (0.1*h, -0.4*h)
  where 
    (x0, y0) = (0.0, 0.0)
    (x1, y1) = (0.2*h, 0.0)
    (x2, y2) = (0.0, -0.4*h)  




main :: IO ()
main = do
  Just canvas <- getCanvasById "canvas"
  adjustSize >>= (\(w,h) -> animate'' canvas (w,h) animWire)

timeStep :: Int
timeStep = 10

text' s = color (RGBA 0 0 0 0.5) . font "20px Bitstream Vera" $ do
  text (0.0, 0.0) s

animate' :: Canvas -> Double -> (Double, Double) -> IO ()
animate' c t (w, h) = animate c (w, h) t

-- Cancas -> (Width, Height) -> Time -> IO ()
animate :: Canvas -> (Double, Double) -> Double -> IO ()
animate canvas (w, h) t = do
  render canvas $ do
    hGraph (w, h) t
    vGraph (w, h) t
    translate (w*0.2,h*0.2) $ do
      circleShape r 
      stroke $ line (0, 0) (lx, ly)
      stroke $ line (lx, ly) (0.1*w, ly)
      stroke $ line (lx, ly) (lx, 0.3*h)
    --translate (w/2, h/2) $ rotate (t/100.0) $ text' ("" ++ show w ++ ", " ++ show h)
  setTimeout timeStep $ adjustSize >>= animate' canvas (t + (fromIntegral timeStep))
  where
    t' = t / 1000.0
    s = 1.0 - (sin t')
    r = h * 0.1
    (lx, ly) = (r * cos t', r * sin t')
    m = min w h

--type WireP = Wire s 

animate'' :: Canvas -> (Double, Double) -> Wire (Timed NominalDiffTime ()) () IO () (Picture ()) -> IO ()
animate'' canvas (w, h) wire = do
  (Right output, newWire) <- stepWire wire (Timed 10 ()) (Right ())
  render canvas output
  setTimeout timeStep $ adjustSize >>= (\(w,h) -> animate'' canvas (w, h) newWire)
  --return ()

animWire :: Wire (Timed NominalDiffTime ()) () IO () (Picture ())
animWire = mkConst $ Right $ circleShape 10.0 






--get time run t and create Timed t ()
--call stepWire

