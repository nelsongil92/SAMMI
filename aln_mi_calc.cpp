#include <stdio.h>
#include <string.h>
#include <math.h>
#include <iostream>
#include <cstdlib>
#include <fstream> // ifstream
#include <cstring> // string
#include <stdlib.h> // exit

using namespace std;

int main (int argc, char **argv) {

    char* filename = argv[1];
    int seqcount   = atoi(argv[2]);
    int seqlength  = atoi(argv[3]);
  
    ifstream fin(filename);
    if (!fin.is_open()) {
       cout << "Could not open file " << filename << endl;
        exit(0);
    }

    // READ IN SEQUENCES TO ARRAY
    char *seqarray[seqcount];          
    string buffer;

    getline(fin,buffer);

    int m = 0;
    while (!fin.eof()) {
        seqarray[m] = new char[seqlength];
        strncpy( seqarray[m], buffer.c_str(), seqlength);
        m++;
        getline(fin,buffer);
    }  
    fin.close();
          
    // MUTUAL INFORMATION CALCULATION
    char aalist[20];
    int aa_alpha_size = 20;
    strcpy (aalist,"ACDEFGHIKLMNPQRSTVWY");
       
    for (int col_i = 0; col_i < seqlength; col_i++) {
        
        for (int col_j = col_i + 1; col_j < seqlength; col_j++) {
	        int bFlag = 0;
	        float col_ij_mutual_info = 0;
	        
            for (int aa_symbol_1_index = 0; aa_symbol_1_index < aa_alpha_size && bFlag == 0; aa_symbol_1_index++) {
	            
                for (int aa_symbol_2_index = 0; aa_symbol_2_index < aa_alpha_size; aa_symbol_2_index++) {
	                float aa_symbol_1_count = 0;
	                float aa_symbol_2_count = 0;
	                float aa_symbol_1_AND_2_count = 0;
	       
	                int n_seqs = 0;
	                for (int seqindex = 0; seqindex < seqcount; seqindex++) {
	                    char aa1 = seqarray[seqindex][col_i];
	                    char aa2 = seqarray[seqindex][col_j];

	                    // effective alignment - compare only sequences without gaps
                        // at either column
	                    if (aa1 == '-' || aa2 == '-') {continue;}

	                    n_seqs++;

	                    if (aalist[aa_symbol_1_index] == aa1) {aa_symbol_1_count++;}
	                    if (aalist[aa_symbol_2_index] == aa2) {aa_symbol_2_count++;}
	                    if (aalist[aa_symbol_1_index] == aa1 && aalist[aa_symbol_2_index] == aa2) {aa_symbol_1_AND_2_count++;}
	                } // end for seqindex

                    // move on to next column if less than 50 sequences in effective alignment
	                if (n_seqs < 50) {bFlag = 1; break;} 

	                float aa_symbol_1_freq = aa_symbol_1_count/n_seqs;
	                float aa_symbol_2_freq = aa_symbol_2_count/n_seqs;
                    float aa_symbol_1_AND_2_freq = aa_symbol_1_AND_2_count/n_seqs;

                    // std::cout << aa_symbol_1_freq;
                    // std::cout << " ";
                    // std::cout << aa_symbol_2_freq;
                    // std::cout << " ";
                    // std::cout << aa_symbol_1_AND_2_freq;
                    // std::cout << "\n";

	                if (aa_symbol_1_freq != 0 && aa_symbol_2_freq != 0 && aa_symbol_1_AND_2_freq != 0) {
	                    col_ij_mutual_info += aa_symbol_1_AND_2_freq*log2(aa_symbol_1_AND_2_freq/(aa_symbol_1_freq*aa_symbol_2_freq));
	                    //std::cout << col_ij_mutual_info;
	                    //std::cout << "\n";
	                }
                } // end for aa_symbol_2
	        } // end for aa_symbol_1
	        
            if(bFlag == 0) {
	            //std::cout << col_ij_mutual_info;
	            //std::cout << "\n";
	            std::cout << "ColPair ";
	            std::cout << col_i;
	            std::cout << ":";
	            std::cout << col_j;
	            std::cout << " MI = ";
	            std::cout << col_ij_mutual_info;
	            std::cout << " bits\n";
	        }
        } // end for col_j
    } // end for col_i
     
    // FREE ALLOCATED MEMORY AND CLOSE FILE
    for (int m = 0; m < seqcount; m++) {
        delete [] seqarray[m];
    }
    return 0;
}
