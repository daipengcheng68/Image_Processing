PImage img;
size(268, 196);
img = loadImage("sig1.jpg");
loadPixels(); 
img.loadPixels();

// shapring filtering

float[][] filter = {{ -1,  -1,  -1 }, 
                    { -1,   9,  -1 }, 
                    { -1,  -1,  -1 }};

for (int y = 1; y < img.height-1; y++){ 
  for (int x = 1; x < img.width-1; x++) {
    float gx = 0;
    for (int ky = -1; ky <= 1; ky++) 
      for (int kx = -1; kx <= 1; kx++) {
        int index = (y + ky) * img.width + (x + kx);
        float r = brightness(img.pixels[index]);
        gx += filter[ky+1][kx+1] * r;
      }
    pixels[y*img.width + x] = color(gx);
  }
}  
// thresholding
float th = 50;
for (int y = 0; y < img.height; y++){
  for (int x = 0; x < img.width; x++){
    int imgIndex = x + y * img.width;
    int r = int (brightness(img.pixels[imgIndex]));
    if (r<= th)
      pixels[imgIndex]=color(0);
    else
      pixels[imgIndex]=color(255);
  }
}

updatePixels();

save("sig-1.jpg");
