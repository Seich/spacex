# Code Test

## Installation

```sh
$ git clone git@github.com:Seich/spacex.git
$ cd spacex
$ bundle
```

## Task 1

You can invoke `ruby task_1.rb [latitude] [longitude] [N]` with a coordinate set
to get a list of the closest N satellites.

Example:

```sh
$ ./task_1.rb 47.1923146 -114.0890228 10

#       Id                              Distance
0       5eed7714096e590006985654        539389.11m
1       5eed7716096e590006985823        580332.52m
2       5eed7716096e590006985810        638252.93m
3       5f98848bfb51fa0006ab75b7        650887.50m
4       5eed7716096e590006985800        668692.28m
5       5eed7715096e5900069856f9        674711.00m
6       5eed7714096e5900069856c8        678115.41m
7       5eed7714096e59000698565b        688471.98m
8       5f487be7d76203000692e597        720868.18m
9       5f98848bfb51fa0006ab75df        782410.03m
```

### Notes

I originally did the distance calculations using Ractors to spread out the
calculations on multiple cores. The performance hit is negligible so I've
removed it in favor of simpler code.

Tests can be run using `ruby starlink_test.rb`.

## Task 2

You can start the api server using `ruby task_2.rb`. This should start a server
at your localhost. This server has a `/v1/satellites` endpoint that accepts a
`latitude`, `longitude` and a `n` as query parameters (where n is the number of
results expected).

Example:

```
curl "http://localhost:4567/v1/satellites?n=2&latitude=47.1923146&longitude=-114.0890228"

[
  {
    "id": "5eed7715096e5900069857a0",
    "latitude": 47.15470158120542,
    "longitude": -120.62269968609459
  },
  {
    "id": "5eed7715096e590006985783",
    "latitude": 51.80035258327829,
    "longitude": -116.2009675479924
  }
]

```

### Notes
There's a couple of things I'd do differently in here. Rather than request the
list of satellites whenever a request comes through I'd put them in a cache that
would expire every couple of minutes. This would let us control what the
max amount of requests we make are. This could be done in memory, or in a
separate service a-la redis.

The [`beau.yml`](https://beaujs.com/) file I was using for testing is included.
You can test the satellites endpoint using `beau request -i`. You can also test
multiple latitudes, longitudes, and amounts using `beau request satellites
--param="n=2" --param="latitude=12" --param="longitude=12"` all params being
optional.

## Task 3

The server we started as part of the second task is also serving the frontend.
By visiting [http://localhost:4567/](http://localhost:4567/) a globe is
displayed, showing a dot in yellow that we are using as our start location and
multiple red dots showing where the closest 30 satellites are located.

![Screenshot showing a globe with red and yellow dots](/media/screenshot.png)

### Notes

I didn't write any tests for the frontend. Since the only things I can test are
external dependencies I'll have to trust them to work reliably. If this were a
real app, I'd probably add a test validating that rendering succeed but nothing
else.

I am including a built version of the frontend in the repo for ease of use. The
build folder would normally be gitignore'd and I'd build the frontend on a
pipeline right on time for deployment.
