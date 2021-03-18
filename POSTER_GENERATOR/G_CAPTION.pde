PGraphics createCaption(String str, String fontDir, color c, float humidity) {
    PGraphics caption = createGraphics(WIDTH, HEIGHT);

    int bleed = int(WIDTH / 8);
    float leading = map(humidity, 0, 100, 2, 0.7);
    float size = sqrt(3000000 / (str.length() * leading));

    PFont font = createFont(fontDir, size, true);

    caption.smooth();
    caption.beginDraw();
    caption.fill(c);
    caption.noStroke();

    caption.textFont(font);
    caption.textAlign(CENTER, CENTER);
    caption.textLeading(leading * size);

    float x = random(-bleed, bleed);
    float y = random(-bleed, bleed);
    float w = random(WIDTH + bleed * 2, WIDTH - bleed);
    float h = random(HEIGHT + bleed * 2, HEIGHT - bleed);

    caption.text(str, x, y, w, h);

    caption.endDraw();

    return caption;
}
