# Monte Carlo estimate of π

![demo](demo.gif)

## Usage

```
$ luarocks install lua-sdl2 argparse
$ lua montepi.lua -h
$ lua montepi.lua
```

## Method

In a 1 by 1 square, put a circle with radian 1.
Generate random points between -0.5 and 0.5, record if each point falls in or out of the circle.

The area of a circle is `πr^2`.

* `#in_point / #points = πr^2`
* `#in_point / #points = π0.25`, `r = 0.5`
* `4 * (#in_point / #points) = π`

(I'm not sure that's how you get it, please correct me if I'm wrong).
