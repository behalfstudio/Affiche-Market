public int totalEntryCount = 0;
public Entry[] entries = new Entry[0];
public int newEntryCount;

public static final String jsonLink = "http://ec2-52-77-232-138.ap-southeast-1.compute.amazonaws.com:8080/instagram?";
//String jsonLink = "data/test.json";
public static final String[] HASHTAG_ARRAY = {"benthanhmarket", "chobenthanh", "benthanh"};

void fetchData() {
    entries = new Entry[0];
    newEntryCount = 0;

    for (int i = 0; i < HASHTAG_ARRAY.length; i++) {
        print("Fetching #" + HASHTAG_ARRAY[i] + "… ");

        JSONArray entriesJSONArray = loadJSONArray(   
            jsonLink +
            "hashtag=" + HASHTAG_ARRAY[i] + "&" +
            "from_timestamp=" + lastUpdateUNIX
        );
        println("Found " + entriesJSONArray.size() + " new entries under #" + HASHTAG_ARRAY[i] + ".");

        entries = Arrays.copyOf(entries, entries.length + entriesJSONArray.size());

        for (int k = 0; k < entriesJSONArray.size(); k++) {
            JSONObject entry = entriesJSONArray.getJSONObject(k);

            // Instagram
            JSONObject instagram = entry.getJSONObject("instagram");

            // Weather
            JSONObject weather = entry.getJSONObject("weather");

            String id = instagram.getString("id");

            Entry tempEntry = new Entry(instagram, weather);
            entries[entries.length - k - 1] = tempEntry;

            if (!isDuplicate(id, ids)) {
                ids = Arrays.copyOf(ids, ids.length + 1);
                ids[ids.length - 1] = id;
                newEntryCount++;
            }
            else {
                entries[entries.length - k - 1].isValid = false;
            }
            
            if (entries.length - k - 1 == 34) {
                entries[entries.length - k - 1].isValid = false;
            }
        }
    }

    println("Total new entries: " + newEntryCount + "\n");
    totalEntryCount += newEntryCount;

    lastUpdateUNIX = nowUNIX();

    currentUpdate = new JSONObject();
    currentUpdate.setLong("timestamp", lastUpdateUNIX);
    currentUpdate.setString("readableTimestamp", new java.text.SimpleDateFormat("dd/MM/yy HH:mm:ss").format(new java.util.Date (lastUpdateUNIX * 1000)) + "+7");
    currentUpdate.setInt("newEntryCount", newEntryCount);
    currentUpdate.setInt("totalEntryCount", totalEntryCount);
}

boolean isDuplicate(String id, String[] ids) {
    for (int i = 0; i < ids.length; i++) {
        if (id.equals(ids[i])) {
            return true;
        }
    }

    return false;
}
