import com.hamoid.*;
import gifAnimation.*;

String exportDir = "export/";

void exportEntry(Entry entry, Poster poster) {
    // JPG
    print("Exporting JPG... ");
    PGraphics exportJPG = createGraphics(WIDTH, HEIGHT);
    exportJPG.beginDraw();
    exportJPG.image(poster.bg, 0, 0);
    exportJPG.image(poster.distortedCaption[0], 0, 0);
    exportJPG.image(poster.clouds, 0, 0);
    exportJPG.image(poster.subtitle, 0, 0);
    exportJPG.endDraw();
    exportJPG.save(exportDir + entry.id + "_thumb.jpg");
    println("Successful.");

    // GIF
    /*
    print("Exporting GIF... ");
    GifMaker exportGIF = new GifMaker(this, exportDir + entry.id + "_file.gif");
    exportGIF.setRepeat(0);
    for (int i = 0; i < DURATION * FRAME_RATE * 2/5; i++) {
        image(poster.bg, 0, 0);
        image(poster.distortedCaption[i], 0, 0);
        image(poster.clouds, 0, 0);
        exportGIF.setQuality(18);
        exportGIF.setDelay(1000 / FRAME_RATE);
        exportGIF.addFrame();
    }
    exportGIF.finish();
    println("Successful.");
    */

    // MP4
    print("Exporting MP4... ");
    VideoExport exportMP4 = new VideoExport(this, exportDir + entry.id + "_web.mp4");
    exportMP4.setFrameRate(FRAME_RATE);
    exportMP4.startMovie();
    for (int i = 0; i < DURATION * FRAME_RATE; i++) {
        image(poster.bg, 0, 0);
        image(poster.distortedCaption[i], 0, 0);
        image(poster.clouds, 0, 0);
        image(poster.subtitle, 0, 0);
        exportMP4.saveFrame();
    }
    exportMP4.endMovie();
    println("Successful.");
}
