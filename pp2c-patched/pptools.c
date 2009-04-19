#include <aterm2.h>
#include <string.h>
#include <stdlib.h>
#include <srts/stratego.h>
#include <stratego-lib/stratego-lib.h>

ATerm xtc_new_file_0_0(StrSL, ATerm);

enum dirs {H, V};

struct position {
  enum dirs direction;
  int is;
  int vs;
  int hs;
  int indent;
  int has_something;
  struct position *previous;
};

static
int hpos;

static
AFun AltFun;
static
AFun SomeFun;
static
AFun NoneFun;
static
AFun AmbFun;

static
FILE *stream;

static int printed;

static
struct position *current;

static
void next(void)
{
  int i;
  struct position *last = current;

  while (!last->has_something) {
    last->has_something = 1;
    if (last->previous != NULL) {
      last->indent += last->is;
      last = last->previous;
    }
  }

  if (last->direction == V)  {
    for (i = 0; i <= last->vs; ++i)
      fputc('\n', stream);
    for (i = 0; i < last->indent; ++i)
      fputc(' ', stream);
    hpos = last->indent;
  }
  else if (last->direction == H) {
    for (i = 0; i < last->hs; ++i)
      fputc(' ', stream);
    hpos += last->hs;
  }
}

static
void print_string(char *str)
{
  next();
  hpos += fprintf(stream, "%s", str);
}

static
void print_int(int i)
{
  next();
  hpos += fprintf(stream, "%d", i);
}

static
void print_real(double i)
{
	next();
	hpos += fprintf(stream, "%f", i);
}

static
void init_cons(void);

static
void init_stack(void)
{
  current->indent = 0;
  current->previous = NULL;
  current->is = 0;
  current->vs = 0;
  current->hs = 0;
  current->has_something = 0;
  hpos = 0;
}

static
void init(void)
{
  current = malloc(sizeof(struct position));

  AltFun = ATmakeAFun("alt", 2, ATfalse);
  ATprotectAFun(AltFun);
  SomeFun = ATmakeAFun("Some", 1, ATfalse);
  ATprotectAFun(SomeFun);
  NoneFun = ATmakeAFun("None", 0, ATfalse);
  ATprotectAFun(NoneFun);
  AmbFun = ATmakeAFun("amb", 1, ATfalse);
  ATprotectAFun(AmbFun);
  init_cons();
}

static
void push_box(enum dirs direction, int is, int vs, int hs)
{
  struct position *newpos = malloc(sizeof(struct position));

  newpos->indent = ((direction == V) && (current->direction == H))
                     ?hpos:current->indent;
  newpos->direction = direction;
  newpos->is = is;
  newpos->vs = vs;
  newpos->hs = hs;
  newpos->has_something = 0;
  newpos->previous = current;
  current = newpos;
}

static
void pop_box(void)
{
  struct position *old = current;
  current = current->previous;
  free(old);
}

static
void unexpected(ATerm tree, int n, char *str)
{
  ATfprintf(stderr,
   "The %dth argument was expected to be %s\n%a\n", n, str, ATgetAFun(tree));
  exit(1);
}
