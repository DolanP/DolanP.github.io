import Mouse
import Random
import Window
import Dict

--main = lift asText Mouse.position
main = lift3 (\w h t -> let t' = t/1000 in collage w h <| [filled gray (rect (toFloat w) (toFloat h))] ++ squares w h) Window.width Window.height totalTimeMs

main' = asText <| (concat <| map (repeat <| v*2) [-v..v])

totalTimeMs : Signal Float
totalTimeMs = (foldp (+) (0.0) (lift (\t -> inMilliseconds t) (fps 60)))

grid' : Dict.Dict (Int, Int) Bool
grid' = Dict.empty

aSquare t = rotate t <| outlined (solid darkBlue) (square 50.0)

aSquare' w c = group [filled c (square <| w-10), outlined (solid c) (square w)]

squares w h = let s x y c= move (x, y) <| aSquare' r c
                  --(x', y') = (toFloat  w / 2, toFloat  h / 2)
                  r = toFloat h / n
                  m = min w h - truncate r
              in map (\((x,y), c) -> s (x/v * (toFloat m/2.0)) (y/v * (toFloat m/2.0)) c) grid

v = 20

n = v * 2 + 1

grid = zip cart <| concat (repeat (length cart) [black, white])

cart = let xs = concat <| map (repeat n) [-v..v]
           ys =  concat <| repeat n [-v..v]
       in zip xs ys