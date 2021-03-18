float min = 20;
float max = 45;

float tolerance;

PGraphics bg;
PImage gradient;

PGraphics createBackground(color colorA, color colorB, float tempCurrent, float pressure, long timestamp, long sunrise, long sunset) {
    gradient = createImage(WIDTH, HEIGHT, RGB);
    gradient.loadPixels();

    // Gradient

    noiseSeed(int(random(MAX_NOISE_SEED)));
    noiseDetail(1);

    float inc = map(tempCurrent, min, max, 0, toPx(0.0000070287));

    float xOffset, yOffset;
    float minNoise = 1, maxNoise = 0;

    yOffset = 0;
    for (int y = 0; y < HEIGHT; y++) {
        xOffset = 0;

        for (int x = 0; x < WIDTH; x++) {
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

    yOffset = 0;
    for (int y = 0; y < HEIGHT; y++) {
        xOffset = 0;

        for (int x = 0; x < WIDTH; x++) {
            float n = noise(xOffset, yOffset);
            float inter = map(n, minNoise, maxNoise, 0, 1);

            // gradient
            color c = lerpColor(colorA, colorB, inter);
            gradient.pixels[toIndex(x, y, WIDTH)] = c;

            xOffset += inc;
        }

        yOffset += inc;
    }

    gradient.updatePixels();

    // Quadtree

    tolerance = map(pressure, 0, 30, 15, 1);

    bg = createGraphics(WIDTH, HEIGHT);
    bg.smooth();
    bg.beginDraw();
    bg.background(gradient);
    bg.noStroke();
    quadtree(0, 0, WIDTH, HEIGHT);
    bg.endDraw();

    return bg;
}

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

void quadtree(int x, int y, int w, int h) {
    float[][] rgb = readPixels(x, y, w, h, bg);  //list of red, green and blue values for each pixel on the interval
    float[] m = mean(rgb);  //mean value of each channel
    float v = variation(rgb, m);  //amount of variation on each channel
    
    if (v > tolerance) {
        w /= 2;
        h /= 2;
        
        quadtree(x, y, w, h);           //top-left
        quadtree(x + w, y, w, h);       //top-right
        quadtree(x, y + h, w, h);       //bottom-left
        quadtree(x + w, y + h, w, h);   //bottom-right
    }
    else {
        bg.fill(m[0], m[1], m[2]);
        if (w > 1)  { bg.rect(x, y, w, h); }  //1x1 squares are not drawn, instead the background shows the equivalent color
    }
}

/*--------------------------------------------------------------------------------------*/

float[][] readPixels(int x, int y, int w, int h, PImage bg) {
    float[][] rgb = new float[3][w * h];
    
    int k = 0;
    for (int i = x; i < x + w; i++) {
        for (int j = y; j < y + h; j++) {          
            rgb[0][k] = gradient.pixels[toIndex(i, j, WIDTH)] >> 16 & 0xFF;  // red channel
            rgb[1][k] = gradient.pixels[toIndex(i, j, WIDTH)] >>  8 & 0xFF;  // green channel
            rgb[2][k] = gradient.pixels[toIndex(i, j, WIDTH)]       & 0xFF;  // blue channel
            k++;
        }
    }

    return rgb; 
}

/*---------------------------*/

float[] mean(float[][] rgb) {
    float[] m = new float[3];
    
    for (int j = 0; j < m.length; j++) { 
        m[j] = 0;

        for (int i = 0; i < rgb[j].length; i++) {
            m[j] += rgb[j][i];  //sum the values of each pixels
        }

        m[j] /= rgb[j].length; //divide by the number of pixels
    }
    
    return m;
}

/*---------------------------*/

float variation(float[][] rgb, float[] m) {
    float[] sd = new float[3];
    
    for (int j = 0; j < sd.length; j++) { 
        for (int i = 0; i < rgb[j].length; i++) {
            sd[j] += sq(rgb[j][i] - m[j]);
        }
        sd[j] /= rgb[j].length - 1;
        sd[j] = sqrt(sd[j]);  //standard deviation
    }

    //calculate the variation as the length of a vector where each coordinate is the standard deviation of a channel
    float v = dist(0, 0, 0, sd[0], sd[1], sd[2]);

    return v; 
}
