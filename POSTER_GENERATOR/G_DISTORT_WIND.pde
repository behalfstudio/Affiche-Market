PImage _wind;
PGraphics wind;

PGraphics distortWind(PGraphics t, float speed, float deg, float pressure, int seed, int currentFrame) {
    noiseDetail(1);
    noiseSeed(seed);

    float _deg = map(deg, 0, 360, 90, -270);

    int tileSize = int(sin(currentFrame * 0.1) * WIDTH / 200 + map(speed, 0, 12, 0, WIDTH / 3));
    int col = floor(WIDTH / tileSize) + 1;
    int row = floor(HEIGHT / tileSize) + 1;

    float inc = map(pressure, 0, 25, 0, toPx(0.001));

    float xOffset, yOffset;

    float minNoise = 1;
    float maxNoise = 0;

    yOffset = 0;
    for (int y = 0; y < row; y++) {
        xOffset = 0;
        for (int x = 0; x < col; x++) {
            float r = noise(xOffset, yOffset);
            if (r < minNoise) {
                minNoise = r;
            }
            if (r > maxNoise) {
                maxNoise = r;
            }
            xOffset += inc;
        }
        yOffset += inc;
    }

    float maxVel = map(speed, 0, 12, 0, WIDTH / 4);

    _wind = createImage(WIDTH, HEIGHT, ARGB);
    PImage _t = t.get();
    
    yOffset = 0;
    for (int y = 0; y < row; y++) {
        xOffset = 0;
        for (int x = 0; x < col; x++) {
            float r = noise(xOffset, yOffset);

            float vel = maxVel * map(r, minNoise, maxNoise, 0.01, 1);

            int diffx = int(vel*sin(radians(_deg)));
            int diffy = int(vel*cos(radians(_deg)));

            int sx = x * tileSize + diffx;
            int sy = y * tileSize + diffy;

            int dx = x * tileSize;
            int dy = y * tileSize;

            //PImage _t = copy(t, sx, sy, tileSize, tileSize, dx, dy, tileSize, tileSize);
            for (int j = 0; j < tileSize; j++) {
                for (int i = 0; i < tileSize; i++) {
                    if (toIndex(i + sx, j + sy, WIDTH) == constrain(toIndex(i + sx, j + sy, WIDTH), 0, WIDTH * HEIGHT - 1)) {
                        color c = _t.pixels[toIndex(i + sx, j + sy, WIDTH)];
                        _wind.pixels[constrain(toIndex(i + dx, j + dy, WIDTH), 0, WIDTH * HEIGHT - 1)] = c;
                    }
                }
            }
            xOffset += inc;
        }
        yOffset += inc;
    }

    wind = createGraphics(WIDTH, HEIGHT);
    wind.smooth();
    wind.beginDraw();
    wind.background(_wind);
    wind.endDraw();
    
    return wind;
}
