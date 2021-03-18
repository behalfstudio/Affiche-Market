PGraphics rain;

PGraphics distortRain(PGraphics t, color c, int col, int row, int intensity) {
    PImage t1 = t.get();
    t1.loadPixels();
    //println(t1.pixels);
    //_t.save("export-test/rain/" + k + ".png");

    float colW = WIDTH * 1.0/ col;
    float rowH = HEIGHT * 1.0 / row;

    rain = createGraphics(WIDTH, HEIGHT);
    rain.smooth();
    rain.beginDraw();
    rain.rectMode(CENTER);

    rain.fill(c);
    rain.noStroke();

    for (int y = 0; y < row; y++) {
        for (int x = 0; x < col; x++) {
            float avg = 0;
            float sum = 0;

            for (int j = int(y * rowH); j < (y + 1) * rowH; j++) {
                for (int i = int(x * colW); i < (x + 1) * colW; i++) {
                    sum += alpha(t1.pixels[toIndex(i, j, WIDTH)]);
                }
            }

            avg = sum / (rowH * colW);

            rain.rect(
                ceil(x * colW + colW / 2),
                ceil(y * rowH + rowH / 2),
                map(avg, 0, 255, 0.5, colW),
                ceil(rowH)
            );
        }
    }

    rain.endDraw();

    return rain;
}