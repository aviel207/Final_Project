//#include "constants.h"
#ifndef _VARIABLES_H
#define _VARIABLES_H

void data_input(void);
void M_def(void);
void d_def(void);
void K_def(void);
void L_def(void);
void r_def(void);

void N_def(void);
void Q_to_N(void);
void K_to_N(void);
void U_to_N(void);
void V_to_N(void);
void B_to_N(void);

void Level_def(void);
void Index_def(void);
void z_def(void);
void Keylen_def(void);
void p_def(void);

void CF_def(void);
void S_def(void);
void right_shift(unsigned char [], unsigned char);
void left_shift(unsigned char [], unsigned char);

void Hash_data(void);

void zero_padding(unsigned int, unsigned char []);
void dec_to_bin(unsigned int, unsigned char [], unsigned int);
void binary_to_hex(unsigned char []);



unsigned char M[512];
unsigned char K[64];
unsigned int d;
unsigned int L;
unsigned int r;

unsigned char B[512];
unsigned int Keylen;
unsigned int Level;
unsigned int Index;
unsigned int z;
unsigned int p;


char qK;
char qL;
char qr;

unsigned char M_bin[4096];
unsigned char K_bin[512];
unsigned char d_bin[12];
unsigned char L_bin[8];
unsigned char r_bin[12];

unsigned char Keylen_bin[8];
unsigned char Level_bin[8];
unsigned char Index_bin[56];
unsigned char z_bin[4];
unsigned char p_bin[16];
unsigned char B_bin[4096];

unsigned char N[89][64];
unsigned char S_bin[168][64];
unsigned char A[89][64];
unsigned char A_temp[16][64];
unsigned char A_temp_r[64];
unsigned char A_temp_l[64];

unsigned char Hash[512];
unsigned char hex_hash[4];
#endif