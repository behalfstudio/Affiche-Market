PGraphics subtitle;
int MARGIN = 15;

PFont subtitleFont1, subtitleFont2;

PGraphics createSubtitles(Entry entry) {
    long _sunrise = 0;
    long _timestamp = entry.timestamp - entry.sunrise;
    long _sunset = entry.sunset - entry.sunrise;

    subtitle = createGraphics(WIDTH, HEIGHT);
    subtitle.smooth();
    subtitle.fill(0);
    subtitle.beginDraw();
    subtitle.textAlign(LEFT, TOP);

    // Timestamp
    int timestampX = 0;
    int timestampY = 0;
    switch(floor(random(0, 11.99))) {
        case 0:
            timestampX = 0;
            timestampY = 0;
            break;
        case 1:
            timestampX = WIDTH / 4;
            timestampY = 0;
            break;
        case 2:
            timestampX = WIDTH / 2;
            timestampY = 0;
            break;
        case 3:
            timestampX = WIDTH / 4 * 3;
            timestampY = 0;
            break;
        case 4:
            timestampX = WIDTH / 4 * 3;
            timestampY = HEIGHT / 4;
            break;
        case 5:
            timestampX = WIDTH / 4 * 3;
            timestampY = HEIGHT / 2;
            break;
        case 6:
            timestampX = WIDTH / 4 * 3;
            timestampY = HEIGHT / 4 * 3;
            break;
        case 7:
            timestampX = WIDTH / 2;
            timestampY = HEIGHT / 4 * 3;
            break;
        case 8:
            timestampX = WIDTH / 4;
            timestampY = HEIGHT / 4 * 3;
            break;
        case 9:
            timestampX = 0;
            timestampY = HEIGHT / 4 * 3;
            break;
        case 10:
            timestampX = 0;
            timestampY = HEIGHT / 2;
            break;
        case 11:
            timestampX = 0;
            timestampY = HEIGHT / 4;
            break;
        default :
            timestampX = 0;
            timestampY = 0;
        break;	
    }

    if (_sunrise <= _timestamp && _timestamp <= _sunset) {
        switch(floor(map(_timestamp, _sunrise, _sunset, 0, 7.99))) {
            case 0:
                timestampX = 0;
                timestampY = HEIGHT / 2;
                break;
            case 1:
                timestampX = 0;
                timestampY = HEIGHT / 4;
                break;
            case 2:
                timestampX = 0;
                timestampY = 0;
                break;
            case 3:
                timestampX = WIDTH / 4;
                timestampY = 0;
                break;
            case 4:
                timestampX = WIDTH / 2;
                timestampY = 0;
                break;
            case 5:
                timestampX = WIDTH / 4 * 3;
                timestampY = 0;
                break;
            case 6:
                timestampX = WIDTH / 4 * 3;
                timestampY = HEIGHT / 4;
                break;
            case 7:
                timestampX = WIDTH / 4 * 3;
                timestampY = HEIGHT / 2;
                break;
        }
    }
    
    if (_timestamp > _sunset) {
        switch(int(map(_timestamp, _sunset, _sunset + 6 * 60 * 60, 0, 1.99))) {
            case 0:
                timestampX = WIDTH / 4 * 3;
                timestampY = HEIGHT / 4 * 3;
                break;
            case 1:
                timestampX = WIDTH / 2;
                timestampY = HEIGHT / 4 * 3;
                break;
        }
    }
    
    if (_timestamp < _sunrise) {
        switch(int(map(_timestamp, _sunrise - 6 * 60 * 60, _sunrise, 0, 1.99))) {
            case 0:
                timestampX = WIDTH / 4;
                timestampY = HEIGHT / 4 * 3;
                break;
            case 1:
                timestampX = 0;
                timestampY = HEIGHT / 4 * 3;
                break;
        }
    }

    subtitle.textFont(subtitleFont2);
    subtitle.pushMatrix();
        subtitle.translate(timestampX, timestampY);
        subtitle.text(
            entry.time + "+7" + "\n" +
            entry.date,

            MARGIN,
            MARGIN
        );
    subtitle.popMatrix();

    // ID
    subtitle.textFont(subtitleFont1);

    int idX = timestampX;
    int idY = -1;

    if (timestampY == 0) { idY = HEIGHT / 4 * 3;}
    else {
        if (timestampY == HEIGHT / 4 * 3) { idY = 0;}
        else {
            switch(round(random(1))) {
                case 0:
                    idY = HEIGHT / 4 * 3;
                    break;
                case 1:
                    idY = 0;
                    break;
            }
        }
    }

    subtitle.textFont(subtitleFont1);
    subtitle.pushMatrix();
        subtitle.translate(idX, idY);
        subtitle.text(
            "POSTER ID" + "\n" +
            entry.uuid,

            MARGIN,
            MARGIN
        );
    subtitle.popMatrix();

    // Weather
    int weatherX = -1;
    int weatherY = timestampY;

    if (timestampX == 0) { weatherX = WIDTH / 4 * 3;}
    else {
        if (timestampX == WIDTH / 4 * 3) { weatherX = 0;}
        else {
            switch(round(random(1))) {
                case 0:
                    weatherX = WIDTH / 4 * 3;
                    break;
                case 1:
                    weatherX = 0;
                    break;
            }
        }
    }
    
    subtitle.pushMatrix();
        subtitle.translate(weatherX, weatherY);
        subtitle.text(
            "WEATHER" + "\n" +
            entry.weatherDescription + "\n" +
            "\n" +
            "TEMPERATURE " + round(entry.tempCurrent) + " °C" + "\n" +
            "PRESSURE " + round(entry.pressure) + " hPa" + "\n" +
            "HUMIDITY " + round(entry.humidity) + "%" + "\n" +
            //"UV INDEX " + round(entry.uvIndex) + "\n" +
            "WIND " + entry.windSpeed + " m/s " + entry.textualWindDir + "\n" +
            "CLOUDS " + round(entry.clouds) + "%"
            ,

            MARGIN,
            MARGIN,

            WIDTH / 4 - MARGIN * 2,
            HEIGHT / 4 - MARGIN * 2
        );
    subtitle.popMatrix();

    subtitle.endDraw();

    return subtitle;
}
