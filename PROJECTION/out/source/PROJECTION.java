import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.text.SimpleDateFormat; 
import java.util.Date; 
import java.util.Arrays; 
import gifAnimation.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PROJECTION extends PApplet {








/*---------------------------------------------------------------------------*/

public static final String HASH_DIVIDER = "#####################################################\n";
public static final String DASH_DIVIDER = "——————————————\n";

public static final int POSTER_AMOUNT = 4;

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/* SET TIME */

public long nowUNIX() {
    Date now = new Date();
    return (now.getTime() / 1000L);
}

public static final int OFFSET_TIME = 80; // 80 seconds
public static final int DELAY_TIME = 15 * 60; // 15 minutes
public static final int REFRESH_TIME = 10; // 10 seconds

long LATEST_UPDATE_UNIX;
long LATEST_REFRESH_UNIX;

public boolean timeToUpdate(long current, long last, long gap) {
    return (current - last >= gap);
}

int TOTAL_ENTRY_COUNT;

boolean firstRun;
boolean pending;

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/* SETUP */

public void setup() {
    
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

public void loadFonts() {
    subtitleFont = createFont("fonts/SpaceGrotesk/SpaceGrotesk-Medium.otf", 11, true);

    textAlign(LEFT, TOP);
}

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/* DRAW */
public void draw() {
    background(0);

    if (firstRun || timeToUpdate(nowUNIX(), LATEST_REFRESH_UNIX, REFRESH_TIME)) {
        firstRun = false;

        if (LATEST_UPDATE_UNIX != latestUpdate()) {
            LATEST_UPDATE_UNIX = latestUpdate();
            TOTAL_ENTRY_COUNT = totalEntryCount();
        }

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

public long timeLeft() {
    return DELAY_TIME - (nowUNIX() - LATEST_UPDATE_UNIX - OFFSET_TIME);
}

public String countdown() {
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
float[][] translateArray = { {20, 110}, {231, 184}, {445, 112}, {652, 186} };
int[][] sizeArray = { {128, 193}, {131, 196}, {132, 197}, {131, 195} };
float[] rotateArray = {-0.002f, 0, 0.009f, 0.01f};

int PADDING = 5;

String[] textualDir = {
    "↑", "↗",
    "→", "↘",
    "↓", "↙",
    "←", "↖"
};

JSONArray currentPosters = new JSONArray();

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

public void displayPosters() {
    float x1, x2, y1, y2;
    boolean fromTop1, fromTop2;

    for (int i = 0; i < POSTER_AMOUNT; i++) {
        pushMatrix();
            translate(translateArray[i][0], translateArray[i][1]);
            rotate(rotateArray[i]);

            // Poster
            POSTERS[i][currentFrame[i]].resize(sizeArray[i][0], sizeArray[i][1]);
            image(POSTERS[i][currentFrame[i]], 0, 0);

            if (currentFrame[i] < maxFrames[i] - 1) {
                currentFrame[i]++;
            }
            else {
                currentFrame[i] = 0;
            }
            
            switch (i) {
                case 0:
                    x1 = sizeArray[i][0] + PADDING;
                    y1 = 0;
                    x2 = 0;
                    y2 = sizeArray[i][1] + PADDING;
                    fromTop1 = true;
                    fromTop2 = true;
                    break;
                case 1:
                    x1 = 0;
                    y1 = -PADDING;
                    x2 = sizeArray[i][0] + PADDING;
                    y2 = 0;
                    fromTop1 = false;
                    fromTop2 = true;
                    break;
                case 2:
                    x1 = sizeArray[i][0] + PADDING;
                    y1 = sizeArray[i][1];
                    x2 = 0;
                    y2 = sizeArray[i][1] + PADDING;
                    fromTop1 = false;
                    fromTop2 = true;
                    break;
                default:
                    x1 = 0;
                    y1 = -PADDING;
                    x2 = 0;
                    y2 = sizeArray[i][1] + PADDING;
                    fromTop1 = false;
                    fromTop2 = true;
            }

            // Text
            if (fromTop1) {
                textAlign(LEFT, TOP);
            }
            else {
                textAlign(LEFT, BOTTOM);
            }

            textFont(subtitleFont);
            long timestamp = currentPosters.getJSONObject(i).getInt("taken_at_timestamp");
            String date = new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date (timestamp * 1000)).toUpperCase();
            String time = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date (timestamp * 1000));

            text(
                time + "\n" + date,
                x1,
                y1
            );

            if (fromTop2) {
                textAlign(LEFT, TOP);
            }
            else {
                textAlign(LEFT, BOTTOM);
            }

            textFont(subtitleFont, 8);
            JSONObject weather = currentPosters.getJSONObject(i).getJSONObject("weather");
            String weatherDescription = weather.getString("description").toUpperCase();
            float tempCurrent = weather.getJSONObject("temperature").getFloat("temp_current");
            int pressure = PApplet.parseInt(weather.getFloat("pressure"));
            int humidity = PApplet.parseInt(weather.getFloat("humidity"));
            int uvIndex = PApplet.parseInt(weather.getFloat("uv_index"));
            float windSpeed = weather.getJSONObject("wind").getFloat("speed");
            float windDeg = weather.getJSONObject("wind").getFloat("deg");
            String textualWindDir = textualDir[(PApplet.parseInt((windDeg / 45) + 0.5f) % 8)];
            int clouds = PApplet.parseInt(weather.getFloat("clouds"));

            text(
                weatherDescription + "\n\n" +
                "TEMP. " + tempCurrent + " °C" + "\n" +
                "PRES. " + pressure + " hPa" + "\n" +
                "HUMID. " + humidity + " %" + "\n" +
                "UVI " + uvIndex + "\n" +
                "WIND " + windSpeed + " m/s " + textualWindDir + "\n" +
                "CLOUDS " + clouds + " %"
                ,
                
                x2,
                y2,

                95,
                170
            );
        popMatrix();
    }
}

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

float translateX = 20;
float translateY = 480;

float headingPadding = 15;
float sectionPadding = 30;

/*---------------------------------------------------------------------------*/

public void displayCountdown() {
    pushMatrix();
        translate(translateX, translateY);

        textFont(subtitleFont);
        text(
            countdown(),
            0, 0
        );

        textFont(subtitleFont, 8);
        text(
            "UNTIL NEXT UPDATE",
            0, headingPadding
        );

        /*---------------------------------------------------------------------------*/

        textFont(subtitleFont);
        text(
            TOTAL_ENTRY_COUNT,
            0, headingPadding + sectionPadding
        );

        textFont(subtitleFont, 8);
        text(
            "TOTAL POSTERS GENERATED",
            0, headingPadding + sectionPadding + headingPadding
        );
    popMatrix();
}
public static final String CALL_LOG_DIR = "../POSTER_GENERATOR/log/callLog.json";
public JSONArray currentCallLog = new JSONArray();

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

public long latestUpdate() {
    try {
        currentCallLog = loadJSONArray(CALL_LOG_DIR);
    } catch (Exception e) {
        println("File '" + CALL_LOG_DIR + "' is missing or inaccessible.");
        currentCallLog = null;
    }

    if (currentCallLog == null) {
        currentCallLog = new JSONArray();
        return -1;
    }
    else {
        return currentCallLog.getJSONObject(currentCallLog.size() - 1).getInt("timestamp");
    }
}

/*---------------------------------------------------------------------------*/

public int totalEntryCount() {
    try {
        currentCallLog = loadJSONArray(CALL_LOG_DIR);
    } catch (Exception e) {
        println("File '" + CALL_LOG_DIR + "' is missing or inaccessible.");
        currentCallLog = null;
    }

    if (currentCallLog == null) {
        currentCallLog = new JSONArray();
        return -1;
    }
    else {
        return currentCallLog.getJSONObject(currentCallLog.size() - 1).getInt("totalEntryCount");
    }
}
String JSON_LINK = "http://ec2-52-77-232-138.ap-southeast-1.compute.amazonaws.com:8080/posts?limit=";

/*---------------------------------------------------------------------------*/

PImage[][] POSTERS = new PImage[POSTER_AMOUNT][0];
int[] maxFrames = new int[POSTER_AMOUNT];
int[] currentFrame = new int[POSTER_AMOUNT];

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

public void updatePosters() {
    currentPosters = loadJSONObject(JSON_LINK + POSTER_AMOUNT).getJSONObject("data").getJSONArray("posts");

    for (int i = 0; i < POSTER_AMOUNT; i++) {
        addPoster(currentPosters.getJSONObject(i).getString("generated_video_web"), i);
    }
}

/*---------------------------------------------------------------------------*/

public void addPoster(String url, int pos) {
    PImage[] newPoster = Gif.getPImages(this, url.substring(0, url.length() - 7) + "file.gif");
    POSTERS[pos] = newPoster;
    maxFrames[pos] = POSTERS[pos].length;
    currentFrame[pos] = 0;
    
    println("Position " + pos + " loaded successfully. Total frames: " + maxFrames[pos]);
}
  public void settings() {  fullScreen(2); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PROJECTION" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
