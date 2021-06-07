public static  float gx = 0;  // Pixel's gradient in x-axis
public static  float gy = 0;  // Pixel's gradient in y-axis
public static  float g;       // Length of pixel's gradient vector
public static  float ga0[][] = new float[52529][9];  // Gradient vectors of origin signature
public static  float ga1[][] = new float[52529][9];  // Gradient vectors of compared signature
public static  float ang;    // Angles for each pixel's gradient
public static  float e0=0, e1=0, e2=0, e3=0, e4=0, e5=0, e6=0, e7=0,
                     ae0=0, ae1=PI/4, ae2=PI/2, ae3= 3*PI/4, ae4=PI,
                     ae5=5*PI/4 , ae6=3*PI/2 , ae7=7*PI/4;            // Set 8 vectors and set the vectors' angles

public static  float con0[][] = new float[33][9];  // Blocks' gradients of origin signature
public static  float con1[][] = new float[33][9];  // Blocks' gradients of compared signature
public static  float sim;  // Similarity

void setup(){
// input image
  size(268, 196);  // Images' size
  PImage sig0 = loadImage("sig.jpg");  // Load the origin signature
  loadPixels();
  sig0.loadPixels(); 
  ga0 = grad(sig0);  // Call function for gradient and return the whole image pixels' vectors of origin signature form the return matrix
  con0 = block(sig0,ga0);  // Call function for dividing blocks and return the blocks' vectors of origin signature form the return matrix
  

  PImage sig = loadImage("sig-1.jpg");  // Load the compared signature (sig-0 to sig-4)
  loadPixels();
  sig.loadPixels(); 
  ga1 = grad(sig);  //Call function for gradient and return the whole image pixels' vectors of compared signature form the return matrix
  con1 = block(sig, ga1);  // Call function for dividing blocks and return the blocks' vectors of compared signature form the return matrix


  float r = compare();  // Call the function for comparing two matrix, get the result of similarity
  println("The similarity is",r); 
  if (r>0.9){  // Check the similarity for compared signature is ture or not
    println("The signature is TRUE!!");    
  }else{
    println("The signature is WRONG!!!");
  }
}

// Function for Gradients, 268 * 196, total 52528 pixels
float[][] grad(PImage img){  
  float ga[][] = new float[52529][9];  // matrix for storing the pixels' vectors
  for (int i=0; i<52529;i++){ // clear matrixs' values
    for(int j=0; j<9;j++){
      ga[i][j]=0;
    }
  }
// Sobel filter for x-axis
  float[][] filterx = {{ -1, 0, 1},                 
                       { -2, 0, 2},
                       { -1, 0, 1}};
// Sobel filter for y-axis
  float[][] filtery = {{ -1, -2, -1},
                       {  0,  0,  0},
                       {  1,  2,  1}}; 
                       
// Calculating the gradient vector and angle
  for (int y = 1; y < img.height-1; y++)
    for (int x = 1; x < img.width-1; x++) {
      gx = 0;  // Clear gx and gy 
      gy = 0;
      for (int ky = -1; ky <= 1; ky++){ 
        for (int kx = -1; kx <= 1; kx++) {
          
          int index = (y + ky) * img.width + (x + kx);
          float r = brightness(img.pixels[index]);
          gx += filterx[ky+1][kx+1] * r;
          gy += filtery[ky+1][kx+1] * r;
       }
     }
          g= sqrt(sq(gx)+sq(gy));
          ang = atan2(gy,gx);
          if(ang<0){
            ang=ang+2*PI; 
          }
          if (ang<ae1 && ang>=ae0){
            e0=g;
          }else if(ang<ae2){
            e1=g;
                  }else if(ang<ae3){
            e2=g;
          }else if(ang<ae4){
            e3=g;
          }else if(ang<ae5){
            e4=g;
          }else if(ang<ae6){
            e5=g;
          }else if(ang<ae7){
            e6=g;
          }else if(ang>ae7){
            e7=g;
          }
// storing 8 tupples of each pixel's vector    
          ga[y*img.width + x][0] = e0;
          ga[y*img.width + x][1] = e1;
          ga[y*img.width + x][2] = e2;
          ga[y*img.width + x][3] = e3;
          ga[y*img.width + x][4] = e4;
          ga[y*img.width + x][5] = e5;
          ga[y*img.width + x][6] = e6;
          ga[y*img.width + x][7] = e7;    
  }
  return ga;
}
   
// Function for dividing blocks, 67*24 = 1608 pixels for one of 4*8 = 32 blocks
float[][] block(PImage img, float[][] ga){  

  float b[][] = new float[33][9];  // matrix for storing the blocks' vectors
  for (int i=0; i<32;i++){  // clear matrixs' values
   for(int j=0; j<8;j++){
     b[i][j]=0;
   }
  }
// Calculating the tupples of blocks' vectors by sum of pixels' tupples in the block
  for (int yb = 0; yb < 8; yb++){
    for (int xb = 0; xb < 4; xb++){

      for(int y = yb*24; y < (yb+1)*24 && y< img.height-1; y++){
        for(int x = xb*67; x < (xb+1)*67 && x< img.width-1; x++){  

          b[yb*4+xb][0] += ga[y*67 + x][0];
          b[yb*4+xb][1] += ga[y*67 + x][1];
          b[yb*4+xb][2] += ga[y*67 + x][2];
          b[yb*4+xb][3] += ga[y*67 + x][3];
          b[yb*4+xb][4] += ga[y*67 + x][4];
          b[yb*4+xb][5] += ga[y*67 + x][5];
          b[yb*4+xb][6] += ga[y*67 + x][6];
          b[yb*4+xb][7] += ga[y*67 + x][7];
        }
      }
    }
  }
    return b;
}

// Function for comparing, calculating cosine of two matrix to get the similarity, and return the result 
float compare(){  

  float mul1=0,sqr1 = 0,sqr2 = 0;    
  for (int i=0; i<32;i++) 
    for (int j=0; j<8; j++){
      mul1+=con0[i][j]*con1[i][j];
      sqr1 += con0[i][j]*con0[i][j];
      sqr2 += con1[i][j]*con1[i][j];
    }
  float result;
  if (sqr1==0 || sqr2==0){
    result=0; 
  }
  else{
    result=mul1/sqrt(sqr1*sqr2);
    
  }
    return result;
}
