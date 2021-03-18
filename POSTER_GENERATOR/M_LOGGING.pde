public static final String callLogDir = "log/callLog.json";

public JSONArray currentCallLog = new JSONArray();
public JSONObject currentUpdate;

long openCallLog() {
    try {
        currentCallLog = loadJSONArray(callLogDir);
    } catch (Exception e) {
        println("File '" + callLogDir + "' is missing or inaccessible.");
        currentCallLog = null;
    }

    if (currentCallLog == null) {
        currentCallLog = new JSONArray();
        return -1;
    }
    else {
        totalEntryCount = currentCallLog.getJSONObject(currentCallLog.size() - 1).getInt("totalEntryCount");
        return currentCallLog.getJSONObject(currentCallLog.size() - 1).getInt("timestamp");
    }
}

void saveCallLog() {
    int logSize = currentCallLog.size();
    currentCallLog.setJSONObject(logSize, currentUpdate);

    saveJSONArray(currentCallLog, callLogDir);
}

/*---------------------------------------------------------------------------*/

public static final String idLogDir = "log/idLog.txt";
String[] ids = new String[0];

void openIDLog() {
    ids = loadStrings(idLogDir);

    if (ids == null) {
        ids = new String[0];
        println("File '" + idLogDir + "' is missing or inaccessible.");
    }
}

void saveIDLog() {
    saveStrings(idLogDir, ids);
}
