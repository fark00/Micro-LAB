#include <mega16.h>
#include <alcd.h>
#include <stdio.h>
#include <init_ports.h>
#include <init_timer.h>
#include <routins.h>

extern int temp_counter;
extern int rpm_counter;
extern int direction;               
extern int speed;
extern char temp_str[17];