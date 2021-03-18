class Entry {
    // Poster
    String uuid;

    // Instagram
    String id;
    String text;
    String shortcode;
    String imageURL;
    String accessibilityCaption;

    // Weather
    String weatherDescription;
    float tempCurrent;
    float feelsLike;
    float tempMin;
    float tempMax;
    float pressure;
    float humidity;
    float uvIndex;
    float windSpeed;
    float windGust;
    float windDeg;
    String textualWindDir;
    float clouds;
    float rain;

    // Time
    long timestamp;
    String date;
    String time;
    long sunrise;
    long sunset;

    boolean isValid = true;

    /*---------------------------------------------------------------------------*/
    
    // Create an entry
    Entry(JSONObject _instagram, JSONObject _weather) {
        // Poster
        uuid = createUUID();

        // Instagram
        id                      = _instagram.getString("id");
        text                    = _instagram.getString("text");
        text                    = reformatText(text);
        shortcode               = _instagram.getString("short_code");
        imageURL                = _instagram.getString("thumbnail_src");
        isValid                 = (text.length() > 0 && tryURL(imageURL));
        accessibilityCaption    = _instagram.getString("accessibility_caption").toUpperCase();

        // Weather
        weatherDescription      = _weather.getString("description").toUpperCase();
        tempCurrent             = _weather.getJSONObject("temperature").getFloat("temp_current");
        feelsLike               = _weather.getJSONObject("temperature").getFloat("feels_like");
        tempMin                 = _weather.getJSONObject("temperature").getFloat("temp_min");
        tempMax                 = _weather.getJSONObject("temperature").getFloat("temp_max");
        pressure                = _weather.getFloat("pressure");
        humidity                = _weather.getFloat("humidity");
        uvIndex                 = _weather.getFloat("uv_index");
        windSpeed               = _weather.getJSONObject("wind").getFloat("speed");
        windGust                = _weather.getJSONObject("wind").getFloat("gust");
        windDeg                 = _weather.getJSONObject("wind").getFloat("deg");
        textualWindDir          = getTextualDir(windDeg);
        clouds                  = _weather.getFloat("clouds");
        rain                    = _weather.getFloat("rain");

        // Time
        timestamp               = _instagram.getInt("taken_at_timestamp");
        date                    = new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date (timestamp * 1000)).toUpperCase();
        time                    = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date (timestamp * 1000));
        sunrise                 = _weather.getInt("sunrise");
        sunset                  = _weather.getInt("sunset");
    }
}

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

public static final String WESTGATE_GLYPHS =
    "AÁĂẮẶẰẲẴÂẤẬẦẨẪẠÀẢÃBCDĐEÉÊẾỆỀỂỄẸÈẺẼFGHIÍỊÌỈĨJKLMNOÓÔỐỘỒỔỖỌÒỎƠỚỢỜỞỠÕPQRSTUÚỤÙỦƯỨỰỪỬỮŨVWXYÝỴỲỶỸZ" +
    "aáăắặằẳẵâấậầẩẫạàảãbcdđeéêếệềểễẹèẻẽfghiíịìỉĩjklmnoóôốộồổỗọòỏơớợờởỡõpqrstuúụùủưứựừửữũvwxyýỵỳỷỹz" + 
    "0123456789⁄.,:;…!¡?¿·•*#//\\(){}[]-–—_‚„“”‘’«»‹›\u0059\' €¢$£¥+−×÷=><±~^%‰@&©®™°|¦"
;

String reformatText(String str) {


    str = str.replaceAll("\\s+", " ");

    String _str = "";

    int[] deletedChars = new int[0];

    for (int i = 0; i < str.length(); i++) {
        String c = str.substring(i, i + 1);

        if (WESTGATE_GLYPHS.contains(c)) {
            _str += c;
        }
    }

    _str = trim(_str);
    _str = _str.replaceAll("  ", " ");
    _str = _str.replaceAll("  ", " ");

    return _str;
}

/*--------------------------------------------------------------------------------------*/

public static final String BASE_36 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
public static final int uuidLength = 4; 

String createUUID() {
    SecureRandom r = new SecureRandom();

    String uuid = "";

    for (int i = 0; i < uuidLength; i++) {
        uuid += BASE_36.charAt(r.nextInt(36));
    }

    return uuid;
}

/*--------------------------------------------------------------------------------------*/

boolean tryURL(String url) {
    PImage img;

    try {
        img = loadImage(url, "jpg");
    } catch (Exception e) {
        img = null;
    }

    if (img == null) {
        return false;
    }

    return true;
}

/*--------------------------------------------------------------------------------------*/

String getTextualDir(float deg) {
    String[] textualDir = {"↑", "↗",
                           "→", "↘",
                           "↓", "↙",
                           "←", "↖"};

    return (textualDir[(int((deg / 45) + 0.5) % 8)]);
}
