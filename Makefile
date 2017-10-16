CC=g++
#CFLAGS=-O3 -funroll-loops -fstrict-aliasing
CFLAGS=-O3 
EXECUTABLE=aln_mi_calc_exe
PREFIX=/usr/local
SOURCE=aln_mi_calc.cpp
PERL_HELPER1=aln_fasta_seqs_only_no_gaps_query.pl
PERL_HELPER2=aln_fasta_seqs_only_no_gaps_query_colshuffle_v2.pl
PERL_HELPER3=aln_fasta_return_length.pl
PERL_HELPER4=aln_mi_colpair_diff.pl

all: aln_mi_calc.cpp
	$(CC) -o $(EXECUTABLE) $(SOURCE) $(CFLAGS)

.PHONY: test
test: 
	./$(EXECUTABLE) test.sequence.aln 84 132 

.PHONY: install
install: 
	install -m 0755 $(EXECUTABLE) $(PREFIX)/bin
	install -m 0755 $(PERL_HELPER1) $(PREFIX)/bin
	install -m 0755 $(PERL_HELPER2) $(PREFIX)/bin
	install -m 0755 $(PERL_HELPER3) $(PREFIX)/bin
	install -m 0755 $(PERL_HELPER4) $(PREFIX)/bin

.PHONY:clean
clean:
	rm $(EXECUTABLE)
