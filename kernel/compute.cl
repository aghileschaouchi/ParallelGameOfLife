__kernel void scrollup (__global unsigned * in, __global unsigned *out)
{
  int x = get_global_id (0);
  int y = get_global_id (1);

  
          int compteur=0;
            if(in[(y-1) * DIM + (x - 1)] == 0xFFFF00FF)
              compteur++;
            if(in[y * DIM + (x - 1)] == 0xFFFF00FF)
              compteur++;
            if(in[(y +1) * DIM + ( x - 1)] == 0xFFFF00FF)
              compteur++;

            if(in[(y - 1) * DIM + x] == 0xFFFF00FF)
              compteur++;
            if(in[(y + 1) * DIM + x] == 0xFFFF00FF)
              compteur++;

            if(in[(y - 1) * DIM + ( x + 1)] == 0xFFFF00FF)
              compteur++;
            if(in[(y * DIM) + (x + 1)] == 0xFFFF00FF)
              compteur++;
            if(in[(y + 1) * DIM + (x + 1)] == 0xFFFF00FF)
              compteur++;   
          
          if(in[y * DIM + x] == 0xFFFF00FF){
            if(compteur == 0 || compteur == 1)
              out[y * DIM + x] = 0x0;
            if(compteur == 2 || compteur == 3)
              out[y * DIM + x] = 0xFFFF00FF;
            if(compteur > 3)
             out[y * DIM + x] = 0x0;
          }
 
          if(in [y * DIM + x] == 0x0 && compteur == 3)
            out [y * DIM + x] = 0xFFFF00FF;

          if(in [y * DIM + x] == 0x0 && compteur != 3)
            out [y * DIM + x] = 0x0;
    }

// NE PAS MODIFIER
static float4 color_scatter (unsigned c)
{
  uchar4 ci;

  ci.s0123 = (*((uchar4 *) &c)).s3210;
  return convert_float4 (ci) / (float4) 255;
}

// NE PAS MODIFIER: ce noyau est appelé lorsqu'une mise à jour de la
// texture de l'image affichée est requise
__kernel void update_texture (__global unsigned *cur, __write_only image2d_t tex)
{
  int y = get_global_id (1);
  int x = get_global_id (0);
  int2 pos = (int2)(x, y);
  unsigned c;

  c = cur [y * DIM + x];

  write_imagef (tex, pos, color_scatter (c));
}

