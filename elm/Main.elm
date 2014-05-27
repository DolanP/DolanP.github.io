import Mouse
import Random
import Window

--main = lift asText Mouse.position
main = let aPath t = traced (solid red) (path [(0, 0), (100 * sin t, 200 * cos t)])
           aSquare t = rotate t <| outlined (solid darkBlue) (square 50.0)
        in 
           lift3 (\w h t -> let t' = t/1000 in collage w h [aPath t', aSquare (t')]) Window.width Window.height totalTimeMs

totalTimeMs : Signal Float
totalTimeMs = let ms = lift (\t -> inMilliseconds t) (fps 60)
              in
                  (foldp (+) (0.0) (ms))
--grid = let 
{-
	Signal 

-}        