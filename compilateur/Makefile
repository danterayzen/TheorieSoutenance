CC=gcc
LEX=flex
YACC=bison
CFLAGS=
LDFLAGS=-ll -lm
EXEC=minipseud

all: $(EXEC)

minipseud: minipseud.l.o minipseud.y.o minipseudtree.o minipseudeval.o minipseudvartable.o
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

minipseud.l.c: minipseud.l minipseud.h
	$(LEX) $< && mv lex.yy.c $@

minipseud.y.c: minipseud.h

minipseud.h: minipseud.y
	$(YACC) -d $< && mv minipseud.tab.h $@ && mv minipseud.tab.c minipseud.y.c

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: clean mrproper

clean:
	rm *.o minipseud.*.c minipseud.h minipseud

mrproper: clean
	rm $(EXEC)
