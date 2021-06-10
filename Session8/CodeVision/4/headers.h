#ifndef _headers_INCLUDED_
#define _headers_INCLUDED_

#include <mega16.h>
#include <init.h>
#include <questions.h>
#include <glcd.h>
// Font used for displaying text
// on the graphic display
#include <font5x7.h>
#include <star.h>
#include <math.h>

#define HR_RADIUS 10        //radius of hour hand
#define MIN_RADIUS 30        //radius of minute hand
#define SEC_RADIUS 20        //radius of second hand


extern const unsigned short FK[];
extern GLCDINIT_t glcd_init_data;
extern unsigned long int x;
extern unsigned long int y;
extern unsigned int s;
extern unsigned int m;
extern unsigned int h;
#endif