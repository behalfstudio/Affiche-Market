String JSON_LINK = "http://ec2-52-77-232-138.ap-southeast-1.compute.amazonaws.com:8080/posts?limit=";

/*---------------------------------------------------------------------------*/

PImage[][] POSTERS = new PImage[POSTER_AMOUNT][0];
int[] maxFrames = new int[POSTER_AMOUNT];
int[] currentFrame = new int[POSTER_AMOUNT];

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/

void updatePosters() {
    currentPosters = loadJSONObject(JSON_LINK + POSTER_AMOUNT).getJSONObject("data").getJSONArray("posts");

    for (int i = 0; i < POSTER_AMOUNT; i++) {
        addPoster(currentPosters.getJSONObject(i).getString("generated_video_web"), i);
    }
}

/*---------------------------------------------------------------------------*/

void addPoster(String url, int pos) {
    PImage[] newPoster = Gif.getPImages(this, url.substring(0, url.length() - 7) + "file.gif");
    POSTERS[pos] = newPoster;
    maxFrames[pos] = POSTERS[pos].length;
    currentFrame[pos] = 0;
    
    println("Position " + pos + " loaded successfully. Total frames: " + maxFrames[pos]);
}