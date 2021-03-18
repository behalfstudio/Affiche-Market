public static final int WIDTH = 720;
public static final int HEIGHT = 1080;

int DURATION = 5;
int FRAME_RATE = 30;

public static final int MAX_NOISE_SEED = 10000;

void generatePosters() {
    int i = 1;

    for (Entry entry : entries) {
        print("Generating poster " + i++ + "… ");

        if (entry.isValid) {
            // create a Poster object
            Poster poster = new Poster(entry);

            println("Successful.");
            
            exportEntry(entry, poster);
        }
        else {
            println("Unsuccessful.");
        }
        
        println("———");
    }
}

/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------*/

float toPx(float em) { return (em * WIDTH); }

/*---------------------------------------------------------------------------*/

int toIndex(int x, int y, int w) { return (x + y * w); }
