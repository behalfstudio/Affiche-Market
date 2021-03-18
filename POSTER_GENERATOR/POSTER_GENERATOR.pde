import de.androidpit.colorthief.*;
import java.awt.image.BufferedImage;

import processing.pdf.*;

import java.text.SimpleDateFormat;
import java.util.Date;

import java.util.Arrays;

import java.security.SecureRandom;

/*---------------------------------------------------------------------------*/

public static final String HASH_DIVIDER = "#####################################################\n";
public static final String DASH_DIVIDER = "——————————————\n";

/*---------------------------------------------------------------------------*/
/* SET TIME */
long nowUNIX() {
    Date now = new Date();
    return now.getTime() / 1000L;
}

long toTimezone(long timestamp, int timezoneDiff) {
    return timestamp + timezoneDiff * 60 * 60;
}

long lastUpdateUNIX;
public static final int DELAY_TIME = 60 * 60; // 60 minutes
int relativeDelayTime = 0;

boolean isTimeUp(long last, long current) {
    if (current - last >= relativeDelayTime) {
        return true;
    }
    else {
        return false;
    }
}

/*---------------------------------------------------------------------------*/
/* SETUP */
void setup() {
    size(720, 1080, P2D);
    background(255);
    
    frameRate(1);

    loadFonts();

    lastUpdateUNIX = openCallLog();
    if (lastUpdateUNIX == -1) {
        lastUpdateUNIX = nowUNIX() - DELAY_TIME;
    }

    println(HASH_DIVIDER);
    println("Program is now running...\n");
}

void loadFonts() {
    String westgateFontsDir = "fonts/Westgate/Westgate-";
    WESTGATE_FONTS[0] = westgateFontsDir + "Thin.otf";
    WESTGATE_FONTS[1] = westgateFontsDir + "Light.otf";
    WESTGATE_FONTS[2] = westgateFontsDir + "Regular.otf";
    WESTGATE_FONTS[3] = westgateFontsDir + "Semibold.otf";
    WESTGATE_FONTS[4] = westgateFontsDir + "Bold.otf";

    subtitleFont1 = createFont("fonts/SpaceGrotesk/SpaceGrotesk-Medium.otf", 15, true);
    subtitleFont2 = createFont("fonts/SpaceGrotesk/SpaceGrotesk-Medium.otf", 25, true);
}

/*---------------------------------------------------------------------------*/
/* DRAW */
void draw() {
    /*
    if (hour() >= 9 && hour() < 21) {
        relativeDelayTime = DELAY_TIME;
    }
    else {
        relativeDelayTime = DELAY_TIME * 4;
    }
    */
    relativeDelayTime = DELAY_TIME;

    if (isTimeUp(lastUpdateUNIX, nowUNIX())) {
        println(HASH_DIVIDER);
        println("Current time: " + 
            new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date (nowUNIX() * 1000)) + "+7"
        );
        println("Last update: " + 
            new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date (lastUpdateUNIX * 1000)) + "+7" +
            "\n"
        );

        openIDLog();

        fetchData();

        println(DASH_DIVIDER);

        generatePosters();

        saveCallLog();
        saveIDLog();

        println("This call has been logged successfully.");
        println("Time: " +
            new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date (lastUpdateUNIX * 1000)) + "+7"
        );
        println("Standby " +
            relativeDelayTime / 60 +
            " minutes...\n"
        );
    }
}
