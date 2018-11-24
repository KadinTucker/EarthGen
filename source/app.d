module app;

import d2d;
import platemaker;

void main() {
    Display display = new Display(800, 400, SDL_WINDOW_SHOWN, 0, "Plate Maker");
    PlateNetwork network = new PlateNetwork(1);
    display.activity = new NetworkDisplay(display, network);
    display.run();
}