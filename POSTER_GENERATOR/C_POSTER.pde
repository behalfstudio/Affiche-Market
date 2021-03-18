String[] WESTGATE_FONTS = new String[5];

class Poster {
    // Colors
    int colorAmount = 6;
    color[] colors = new color[colorAmount];

    // Background
    PGraphics bg;

    // Main text
    PGraphics caption;
    PGraphics[] distortedCaption = new PGraphics[DURATION * FRAME_RATE];

    // Wind
    int windNoise = int(random(MAX_NOISE_SEED));

    // Rain
    int rainNoise = int(random(MAX_NOISE_SEED));
    int rainCol = 0;
    int rainRow = 0;

    // Clouds
    PGraphics clouds;

    // Subtitle
    PGraphics subtitle;

    Poster(Entry entry) {
        // Colors
        colors = colorThief(entry.imageURL, colorAmount);

        // Background
        bg = createBackground(
            colors[0], colors[1],
            entry.tempCurrent,
            entry.pressure - 1000,
            entry.timestamp,
            entry.sunrise,
            entry.sunset
        );

        // Main text
        caption = createCaption(
            entry.text,
            pickFont(
                entry.tempCurrent,
                entry.tempMin,
                entry.tempMax
            ),
            colors[2],
            entry.humidity
        );

        // Wind
        for (int i = 0; i < DURATION * FRAME_RATE; i++) {
            distortedCaption[i] = distortWind(
                caption,
                entry.windSpeed,
                entry.windDeg,
                entry.pressure - 1000,
                windNoise,
                i
            );
        }

        // Rain
        if (entry.weatherDescription.contains("RAIN")) {
            int intensity = 2;
            if (entry.weatherDescription.contains("LIGHT")) { intensity = 1; }
            if (entry.weatherDescription.contains("HEAVY")) { intensity = 3; }

            rainCol = int(pow(2, round(map(random(intensity - 0.5, intensity + 0.5), 0.5, 3.5, 7, 4))));
            rainRow = int(pow(2, round(map(random(intensity - 0.5, intensity + 0.5), 0.5, 3.5, 8, 5))));

            for (int i = 0; i < DURATION * FRAME_RATE; i++) {
                distortedCaption[i] = distortRain(
                    distortedCaption[i],
                    colors[2],
                    rainCol, rainRow,
                    intensity
                );
            }
        }

        // Clouds
        clouds = createClouds(
            colors[3], colors[4], colors[5],
            entry.clouds
        );

        // Subtitle
        subtitle = createSubtitles(entry);
    }
}

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

color[] colorThief(String imgURL, int colorAmount) {
    color[] colors = new color[colorAmount];

    ColorThief thief = new ColorThief();
    PImage imgThief = loadImage(imgURL, "jpg");
    BufferedImage bimg = (BufferedImage) imgThief.getImage();

    int[][] palette = thief.getPalette(bimg, colorAmount);

    for (int i = 0; i < colorAmount; i++) {
        colors[i] = color(palette[i][0], palette[i][1], palette[i][2]);
    }

    return colors;
}

/*--------------------------------------------------------------------------------------*/

String pickFont(float current, float min, float max) {
    return WESTGATE_FONTS[constrain(int(map(current, min, max, 0, 4.99)), 0, 4)];
}
