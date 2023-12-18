//name_file: MD6_hash
//update date: 27/09/23

#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include "constants.h"
#include "variables.h"
#include "function.c"


int main()
{
    //clock_t start, end;
    struct timeval start, end;
    data_input();
    N_def();
        if (gettimeofday(&start, NULL) == -1)
    {
        perror("gettimeofday");
        return 1;
    }
    
    CF_def();
    
    if (gettimeofday(&end, NULL) == -1)
    {
        perror("gettimeofday");
        return 1;
    }

    Hash_data();
    
    long long elapsed_ns = (end.tv_sec - start.tv_sec) * 1000000LL + (end.tv_usec - start.tv_usec) * 1000LL;
    printf("Elapsed time: %lld nanoseconds\n", elapsed_ns);
    
    return 0;
}
//996000ns = 996us 
//9063000ns = 9.063ms
//22389000ns = 22.389ms