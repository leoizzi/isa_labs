#include<stdio.h>
#include<stdlib.h>

#define N 2 /// order of the filter
#define NB 12  /// number of bits
#define INT_REPR 1 /// increment it for reducing internal bit width, decrement it for increasing internal bit width

const int b0 = 423; /// coefficient b0
const int b[N]={846, 423}; /// b array
const int a[N]={-757, 401}; /// a array
//const int b_lookahead[N+1] = {-320211, -640422, -320211}; /// a1b0, a1b1, a1b2
//const int a_lookahead[N+1] = {-757, 573049, -303557}; /// a0a1, a1a1, a1a2

/// Perform fixed point filtering assuming direct form II
///\param x is the new input sample
///\return the new output sample
int myfilter(int x)
{
    static int sw[N+1]; /// w shift register
    static int first_run = 0; /// for cleaning the shift register
    int i; /// index
    int w; /// intermediate value (w)
    int y; /// output sample
    int fb, ff; /// feed-back and feed-forward results
    int b_arr[6];
    int a_arr[4];

    /// form the a and b arr
    a_arr[0] = (1*a[0]); // a0*a1
    a_arr[1] = (a[0]*a[0]) >> (NB + INT_REPR - 1); // a1*a1
    a_arr[2] = a[1]; // a2
    a_arr[3] = (a[0]*a[1]) >> (NB + INT_REPR - 1); // a1*a2

    b_arr[0] = b0; // b0
    b_arr[1] = (a[0]*b0) >> (NB + INT_REPR - 1); // a1*b0
    b_arr[2] = b[0]; // b1
    b_arr[3] = (a[0]*b[0]) >> (NB + INT_REPR - 1); // a1*b1
    b_arr[4] = b[1]; // b2
    b_arr[5] = (a[0]*b[1]) >> (NB + INT_REPR - 1); // a1*b2

    /// clean the buffer
    if (first_run == 0)
    {
        first_run = 1;
        for (i=0; i<N; i++)
            sw[i] = 0;
    }

    /// compute feed-back and feed-forward
    fb = 0;
    ff = 0;
    fb -= sw[0]*a_arr[0] >> (NB + INT_REPR - 1);
    fb -= sw[1]*a_arr[1] >> (NB + INT_REPR - 1);
    fb -= sw[1]*a_arr[2] >> (NB + INT_REPR - 1);
    fb -= sw[2]*a_arr[3] >> (NB + INT_REPR - 1);

    ff += sw[0]*b_arr[1] >> (NB + INT_REPR - 1);
    ff += sw[0]*b_arr[2] >> (NB + INT_REPR - 1);
    ff += sw[1]*b_arr[3] >> (NB + INT_REPR - 1);
    ff += sw[1]*b_arr[4] >> (NB + INT_REPR - 1);
    ff += sw[2]*b_arr[5] >> (NB + INT_REPR - 1);

    /// compute intermediate value (w) and output sample
    w = x + fb;
    y = (w*b0) >> (NB + INT_REPR -1);
    y += ff;

    /// update the shift register
    for (i=N; i>0; i--)
        sw[i] = sw[i-1];
    sw[0] = w;

    return y;
}

int main (int argc, char **argv)
{
    FILE *fp_in;
    FILE *fp_out;

    int x;
    int y;

    /// check the command line
    if (argc != 3)
    {
        printf("Use: %s <input_file> <output_file>\n", argv[0]);
        exit(1);
    }

    /// open files
    fp_in = fopen(argv[1], "r");
    if (fp_in == NULL)
    {
        printf("Error: cannot open %s\n");
        exit(2);
    }
    fp_out = fopen(argv[2], "w");

    /// get samples and apply filter
    fscanf(fp_in, "%d", &x);
    do{
        y = myfilter(x);
        fprintf(fp_out,"%d\n", y);
        fscanf(fp_in, "%d", &x);
    } while (!feof(fp_in));

    fclose(fp_in);
    fclose(fp_out);

    return 0;

}