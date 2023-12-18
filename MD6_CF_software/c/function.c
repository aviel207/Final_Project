#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "constants.h"
#include "variables.h"


void data_input(void)
{
    M_def();
    d_def();
    K_def();
    L_def();
    r_def();
}

void M_def(void)
{
    printf("Enter the Message: ");
    scanf("%s", M); 
    getchar();
    zero_padding(512,M);
    for (int i = 0; i < 512; i++)
    {
        dec_to_bin(M[i],&M_bin[i*8],8);
    }
}

void K_def(void)
{
    printf("You want to insert the key?(Y/N): ");
    scanf("%c",&qK);
    getchar();
    toupper(qK);
    if(qK == 'Y')
    {
        printf("Enter the key: ");
        scanf("%s",K);
        getchar(); 
        zero_padding(64,K);

    }
    else
    {
        zero_padding(64,K); 
    }
    
    for (int i = 0; i < 64; i++)
    {
        dec_to_bin(K[i],&K_bin[i*8],8);
    }
}

void d_def(void)
{
    printf("Enter the hash length: ");
    scanf("%d",&d);
    getchar();
    dec_to_bin(d, d_bin, 12); 
}

void L_def(void)
{
    printf("You want to insert the mode control?(Y/N): ");
    scanf("%c",&qL);
    getchar();
    toupper(qL);
    if (qL == 'Y')
    {
        printf("Enter the mode control: ");
        scanf("%d",&L);
        getchar();
    }
    else
    {
        L = 64;
    }
    dec_to_bin(L, L_bin, 8);
}

void r_def(void)
{
    printf("You want to insert the number of round?(Y/N): ");
    scanf("%c",&qr);
    getchar();
    toupper(qr);
    if (qr == 'Y')
    {
        printf("Enter the number of round: ");
        scanf("%d",&r);
        getchar();
    }
    else
    {
        r = 40 + d/4;
    }
    dec_to_bin(r, r_bin, 12);
}


void N_def(void)
{   
    Q_to_N();
    K_to_N();
    U_to_N();
    V_to_N();
    B_to_N();
}

void Q_to_N(void)
{
    unsigned char byte;
    for (int i = 0; i < 15; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            byte = (Q[i] >> (56-j*8)); 
            dec_to_bin(byte, &N[i][j*8],8);           
        }
    }
}

void K_to_N(void)
{
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 64; j++)
        {
            N[i+15][j] = K_bin[j+i*64];
        }
    }  
    
}

void U_to_N(void)
{
     Level_def();
     Index_def();
    for (int i = 0; i < 8; i++)
    {
        N[23][i] = Level_bin[i];
    }
    for (int i = 0; i < 56; i++)
    {
        N[23][i+8] = Index_bin[i];
    }
}
       
void V_to_N(void)
{
   //zero
   for (int i = 0; i < 4; i++)
    {
        N[24][i] = 0;
    } 
    //r
   for (int i = 0; i < 12; i++)
    {
        N[24][i+4] = r_bin[i];
    } 
    //L
    for (int i = 0; i < 8; i++)
    {
        N[24][i+16] = L_bin[i];
    } 
    //z
    z_def();
    for (int i = 0; i < 4; i++)
    {
        N[24][i+24] = z_bin[i];
    } 
    //p
    p_def();
    for (int i = 0; i < 16; i++)
    {
        N[24][i+28] = p_bin[i];
    } 
    //Keylen 
    Keylen_def();
    for (int i = 0; i < 8; i++)
    {
        N[24][i+44] = Keylen_bin[i];
    }
    //d
    for (int i = 0; i < 12; i++)
    {
        N[24][i+52] = d_bin[i];
    }
}

void B_to_N(void)
{
    for (int i = 0; i < 4096; i++)
    {
        B_bin[i] = M_bin[i];
    }
    for (int i = 0; i < 64; i++)
    {
        for (int j = 0; j < 64; j++)
        {
            N[i+25][j] = B_bin[j+i*64];
        }
    }    
}

void Level_def(void)
{
    Level = 1;
    dec_to_bin(Level,Level_bin,8);
}

void Index_def(void)
{
    Index = 0;
    dec_to_bin(Index,Index_bin,56);
}

void z_def(void)
{
    z = 1;
    dec_to_bin(z,z_bin,4);
}

void p_def(void)
{
    for (int i = 0; i < 512; i++)
    {
        B[i] = M[i];
    }
    p = 4096 - 8*strlen(B);
    dec_to_bin(p,p_bin,16);
}

void Keylen_def(void)
{
    if(qK == 'Y')
    {
        Keylen = strlen(K);
    }
    else
    {
        Keylen = 0;    
    }
    dec_to_bin(Keylen, Keylen_bin, 8);
}


void CF_def(void)
{
    S_def();
    //A = N
    for (int i = 0; i < 89; i++)
    {
        for (int j = 0; j < 64; j++)
        {
            A[i][j]=N[i][j];
        }
        A[i][64] = '\0';
    }
    //The calculation loop
    for (int i = 0; i < r; i++)
    {
        //Calculation of the 16 new words   
        for (int j = 0; j < 16; j++)
        {
            for (int k = 0; k < 64; k++)
            {
                A_temp[j][k] = S_bin[i][k] ^ A[j][k] ^ A[89+j - t0][k];
                A_temp[j][k] = A_temp[j][k] ^ (A[89+j - t1][k] & A[89+j - t2][k]) ^(A[89+j - t3][k] & A[89+j - t4][k]);
            }   
            memcpy(A_temp_r, A_temp[j], sizeof(A_temp[j]));
            right_shift(A_temp_r,r_shift[j]);
            for (int k = 0; k < 64; k++)
            {
                A_temp[j][k] = A_temp[j][k] ^ A_temp_r[k];
            }
            memcpy(A_temp_l, A_temp[j], sizeof(A_temp[j]));
            left_shift(A_temp_l,l_shift[j]);
            for (int k = 0; k < 64; k++)
            {
                A_temp[j][k] = A_temp[j][k] ^ A_temp_l[k];
            }
        }
        
        //Deleting the first 16 words
        for (int j = 16; j < 89; j++)
        {
            for (int k = 0; k < 64; k++)
            {
                A[j-16][k] = A[j][k];
            }
        }

        //Added the 16 new words
        for (int j = 73; j < 89; j++)
        {
            for (int k = 0; k < 64; k++)
            {
                A[j][k] = A_temp[j-73][k];
            }
        }
    }
    
}

void S_def()
{
    unsigned char byte;
    for (int i = 0; i < 168; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            byte = (S[i] >> (56-j*8)); 
            dec_to_bin(byte, &S_bin[i][j*8],8);           
        }
    }
}

void right_shift(unsigned char arr [], unsigned char shift)
{
    for (int i = 0; i < shift; i++)
    {
        for (int j = 63; j > 0; j--)
        {
            arr[j] = arr[j-1];
        }
        arr[0] = 0;
    }
} 

void left_shift(unsigned char arr [], unsigned char shift)
{
    for (int i = 0; i < shift; i++)
    {
        for (int j = 0; j < 63; j++)
        {
            arr[j] = arr[j+1];
        }
        arr[63] = 0;
    }
} 


void Hash_data(void)
{
    int h = 0;
    for (int i = 81; i < 89; i++)
    {
        for (int j = 0; j < 64; j++)
        {
            Hash[h] = A[i][j];
            h++;
        }
    }
    
    for (int j = 512-d; j <512; j+=4)
    {
        memcpy(hex_hash,&Hash[j],sizeof(hex_hash));
        binary_to_hex(hex_hash);
    }
}


void zero_padding(unsigned int len,unsigned char array[])
{
    int i;
    for(i = strlen(array); i < len; i++)
    {
        array[i] = '\0';
    } 
}

void dec_to_bin(unsigned int value, unsigned char arr[], unsigned int size)

{
    unsigned int val = value;
    for(int i = size-1; i >= 0; i-- )
    {
        arr[i] = val%2;
        val/=2;
    }     
}

void binary_to_hex(unsigned char arr[])
{
    unsigned int value = 8*arr[0] + 4*arr[1] + 2*arr[2] + 1*arr[3]; 
    printf("%x",value);
}