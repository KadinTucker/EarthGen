module app;

import d2d;
import platemaker;

void main() {
    Display display = new Display(500, 400, SDL_WINDOW_SHOWN, 0, "Plate Maker");
    display.activity = new NetworkDisplay(display, new PlateNetwork(4));
    display.run();
}