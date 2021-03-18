float[][] translateArray = { {20, 110}, {231, 184}, {445, 112}, {652, 186} };
int[][] sizeArray = { {128, 193}, {131, 196}, {132, 197}, {131, 195} };
float[] rotateArray = {-0.002, 0, 0.009, 0.01};

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

void displayPosters() {
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
            int pressure = int(weather.getFloat("pressure"));
            int humidity = int(weather.getFloat("humidity"));
            int uvIndex = int(weather.getFloat("uv_index"));
            float windSpeed = weather.getJSONObject("wind").getFloat("speed");
            float windDeg = weather.getJSONObject("wind").getFloat("deg");
            String textualWindDir = textualDir[(int((windDeg / 45) + 0.5) % 8)];
            int clouds = int(weather.getFloat("clouds"));

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

void displayCountdown() {
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
