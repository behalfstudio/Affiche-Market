PGraphics cl;

PGraphics createClouds(color colorA, color colorB, color colorC, float clouds) {
    cl = createGraphics(WIDTH, HEIGHT);

    //if (clouds == 0) { return cl; }

    int unit = WIDTH / 16;
    int cloudAmount = int(map(clouds, 0, 100, 0, 30));
    int pxWidth = WIDTH / unit;
    int pxHeight = HEIGHT / unit;
    int maxSize = int(map(clouds, 0, 100, 3, 15));
    int maxW = randomInt(maxSize, maxSize + 5);
    int maxH = randomInt(maxSize, maxSize + 5);

    float alpha = map(clouds, 0, 100, 80, 150);

    color[] colors = new color[3];
    colors[0] = color(red(colorA), green(colorA), blue(colorA), alpha);
    colors[1] = color(red(colorB), green(colorB), blue(colorB), alpha);
    colors[2] = color(red(colorC), green(colorC), blue(colorC), alpha);

    cl.smooth();
    cl.beginDraw();
    cl.noStroke();

    for (int i = 0; i < cloudAmount; i++) {
        cl.fill(colors[int(random(colors.length))]);
        int x = randomInt(0, pxWidth) * unit;
		int y = randomInt(0, pxHeight) * unit;
		int w = randomInt(1, maxW) * unit;
		int h = randomInt(1, maxH) * unit;
		cl.rect(x, y, w, h);
    }

    cl.endDraw();

    return cl;
}

int randomInt(int a, int b) { return floor(random(a, b)); }
