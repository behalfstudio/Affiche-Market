import java.text.SimpleDateFormat;
import java.util.Date;

import java.util.Arrays;

import gifAnimation.*;

/*---------------------------------------------------------------------------*/

public static final String HASH_DIVIDER = "#####################################################\n";
public static final String DASH_DIVIDER = "——————————————\n";

public static final int POSTER_AMOUNT = 4;



/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/* SET TIME */

long nowUNIX() {
    Date now = new Date();
    return (now.getTime() / 1000L);
}

public static final int OFFSET_TIME = 80; // 80 seconds
public static final int DELAY_TIME = 15 * 60; // 15 minutes
public static final int REFRESH_TIME = 10; // 10 seconds

long LATEST_UPDATE_UNIX;
long LATEST_REFRESH_UNIX;

boolean timeToUpdate(long current, long last, long gap) {
    return (current - last >= gap);
}

int TOTAL_ENTRY_COUNT;

boolean firstRun;
boolean pending;

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/* SETUP */

void setup() {
    fullScreen(2);
    //size(1024, 768);
    noCursor();

    loadFonts();

    fill(255);
    noStroke();

    frameRate(15);

    LATEST_UPDATE_UNIX = latestUpdate();
    LATEST_REFRESH_UNIX = nowUNIX();
    TOTAL_ENTRY_COUNT = totalEntryCount();

    firstRun = true;

    println(HASH_DIVIDER);
    println("Program is now running…");
    println("Current time: " + 
        new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date (nowUNIX() * 1000)) + " GMT+7"
    );
    println("Latest update (with offset): " + 
        new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date (LATEST_UPDATE_UNIX * 1000)) + " GMT+7"
    );
    
    updatePosters();
}

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/* FONTS */
PFont subtitleFont;

void loadFonts() {
    subtitleFont = createFont("fonts/SpaceGrotesk/SpaceGrotesk-Medium.otf", 11, true);

    textAlign(LEFT, TOP);
}

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/* DRAW */
void draw() {
    background(0);

    if (firstRun || timeToUpdate(nowUNIX(), LATEST_REFRESH_UNIX, REFRESH_TIME)) {
        firstRun = false;

        if (LATEST_UPDATE_UNIX != latestUpdate()) {
            LATEST_UPDATE_UNIX = latestUpdate();
            TOTAL_ENTRY_COUNT = totalEntryCount();

            // Check log file
            if (timeToUpdate(nowUNIX(), LATEST_UPDATE_UNIX, OFFSET_TIME)) {
                println("\n" + DASH_DIVIDER);
            
                updatePosters();

                println("Latest update: " + 
                    new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date (LATEST_UPDATE_UNIX * 1000)) + " GMT+7"
                );

                println("Standby " +
                    DELAY_TIME / 60 +
                    " minutes..."
                );

                println("\n" + DASH_DIVIDER);
            }
        }

        LATEST_REFRESH_UNIX = nowUNIX();

        println("Sleep " +
            REFRESH_TIME +
            " seconds until next refresh..."
        );
    }

    displayPosters();
    displayCountdown();
}

/*---------------------------------------------------------------------------*/

long timeLeft() {
    return DELAY_TIME - (nowUNIX() - LATEST_UPDATE_UNIX - OFFSET_TIME);
}

String countdown() {
    if (timeLeft() >= 0) {
        return new java.text.SimpleDateFormat("mm:ss").format(new java.util.Date (timeLeft() * 1000));
    }
    else {
        String waiting = "ANY MOMENT";

        for (int i = 0; i < (1 - timeLeft()) % 4; i++) {
            waiting += ".";
        }

        return waiting;
    }
    
}
