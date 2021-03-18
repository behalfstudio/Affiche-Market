public static final String CALL_LOG_DIR = "../POSTER_GENERATOR/log/callLog.json";
public JSONArray currentCallLog = new JSONArray();

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

long latestUpdate() {
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

int totalEntryCount() {
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