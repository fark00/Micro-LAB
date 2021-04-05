#ifndef __func5_INCLUDE__
#define __func5_INCLUDE__

/*
* Function: func5
* ------------------
* Read the number on PINA A and subtract 10% of the selected step every 100 milliseconds to zero.
* 
* step: subtract 10% of the step every 100 ms (ex: if step = 2 => 8 -> 7.8 -> 7.6 -> ... -> 0)
*
* returns: nothing
*/
void func5(char step);

#endif