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
  //printf("print_string: %s\n",str);
}

static
void print_int(int i)
{
  next();
  //occurs with namedescape in string e.g. "\"" produced 34
  //hpos += fprintf(stream, "%d", i);
  hpos += fprintf(stream, "%c", i);
  //printf("print_int: %d\n",i);
}

static
void print_real(double d)
{
	next();
	hpos += fprintf(stream, "%f", d);
    //printf("print_real: %f\n",d);
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
static AFun var_cons_Parenthetical;
static AFun var_cons_String;
static AFun var_cons_Chars;
static AFun var_cons_None;
static AFun var_cons_Some;
static AFun var_cons_NamedEscape;
static AFun var_cons_OctaEscape1;
static AFun var_cons_OctaEscape2;
static AFun var_cons_OctaEscape3;
static AFun var_cons_Assign;
static AFun var_cons_AssignMul;
static AFun var_cons_AssignDiv;
static AFun var_cons_AssignRemain;
static AFun var_cons_AssignPlus;
static AFun var_cons_AssignMinus;
static AFun var_cons_AssignLeftShift;
static AFun var_cons_AssignRightShift;
static AFun var_cons_AssignURightShift;
static AFun var_cons_AssignAnd;
static AFun var_cons_AssignExcOr;
static AFun var_cons_AssignOr;
static AFun var_cons_InstanceOf;
static AFun var_cons_Mul;
static AFun var_cons_Div;
static AFun var_cons_Remain;
static AFun var_cons_Plus2;
static AFun var_cons_Minus2;
static AFun var_cons_LeftShift;
static AFun var_cons_RightShift;
static AFun var_cons_URightShift;
static AFun var_cons_Lt;
static AFun var_cons_Gt;
static AFun var_cons_LtEq;
static AFun var_cons_GtEq;
static AFun var_cons_Eq;
static AFun var_cons_NotEq;
static AFun var_cons_LazyAnd;
static AFun var_cons_LazyOr;
static AFun var_cons_And;
static AFun var_cons_ExcOr;
static AFun var_cons_Or;
static AFun var_cons_Cond;
static AFun var_cons_Plus1;
static AFun var_cons_Minus1;
static AFun var_cons_PreIncr;
static AFun var_cons_PreDecr;
static AFun var_cons_Complement;
static AFun var_cons_Not;
static AFun var_cons_CastPrim;
static AFun var_cons_CastRef;
static AFun var_cons_PostIncr;
static AFun var_cons_PostDecr;
static AFun var_cons_Invoke;
static AFun var_cons_Method1;
static AFun var_cons_Method3;
static AFun var_cons_SuperMethod;
static AFun var_cons_QSuperMethod;
static AFun var_cons_GenericMethod;
static AFun var_cons_ArrayAccess;
static AFun var_cons_Field;
static AFun var_cons_SuperField;
static AFun var_cons_QSuperField;
static AFun var_cons_NewArray;
static AFun var_cons_UnboundWld;
static AFun var_cons_Dim1;
static AFun var_cons_Dim0;
static AFun var_cons_NewInstance;
static AFun var_cons_QNewInstance;
static AFun var_cons_Lit;
static AFun var_cons_Class;
static AFun var_cons_VoidClass;
static AFun var_cons_This;
static AFun var_cons_QThis;
static AFun var_cons_PackageDec;
static AFun var_cons_TypeImportDec;
static AFun var_cons_TypeImportOnDemandDec;
static AFun var_cons_StaticImportDec;
static AFun var_cons_StaticImportOnDemandDec;
static AFun var_cons_AnnoDec;
static AFun var_cons_AnnoDecHead;
static AFun var_cons_AnnoMethodDec;
static AFun var_cons_Semicolon;
static AFun var_cons_DefaultVal;
static AFun var_cons_AbstractMethodDec;
static AFun var_cons_DeprAbstractMethodDec;
static AFun var_cons_ConstantDec;
static AFun var_cons_InterfaceDec;
static AFun var_cons_InterfaceDecHead;
static AFun var_cons_ExtendsInterfaces;
static AFun var_cons_EnumDec;
static AFun var_cons_EnumDecHead;
static AFun var_cons_EnumBody;
static AFun var_cons_EnumConst;
static AFun var_cons_EnumBodyDecs;
static AFun var_cons_ConstrDec;
static AFun var_cons_ConstrDecHead;
static AFun var_cons_ConstrBody;
static AFun var_cons_AltConstrInv;
static AFun var_cons_SuperConstrInv;
static AFun var_cons_QSuperConstrInv;
static AFun var_cons_StaticInit;
static AFun var_cons_InstanceInit;
static AFun var_cons_Empty;
static AFun var_cons_Labeled;
static AFun var_cons_ExprStm;
static AFun var_cons_If2;
static AFun var_cons_If3;
static AFun var_cons_AssertStm1;
static AFun var_cons_AssertStm2;
static AFun var_cons_Switch;
static AFun var_cons_SwitchBlock;
static AFun var_cons_SwitchGroup;
static AFun var_cons_Case;
static AFun var_cons_Default;
static AFun var_cons_While;
static AFun var_cons_DoWhile;
static AFun var_cons_For;
static AFun var_cons_ForEach;
static AFun var_cons_Break;
static AFun var_cons_Continue;
static AFun var_cons_Return;
static AFun var_cons_Throw;
static AFun var_cons_Synchronized2;
static AFun var_cons_Try2;
static AFun var_cons_Try3;
static AFun var_cons_Catch;
static AFun var_cons_LocalVarDecStm;
static AFun var_cons_LocalVarDec;
static AFun var_cons_Block;
static AFun var_cons_ClassDecStm;
static AFun var_cons_MethodDec;
static AFun var_cons_MethodDecHead;
static AFun var_cons_DeprMethodDecHead;
static AFun var_cons_Void;
static AFun var_cons_Param;
static AFun var_cons_VarArityParam;
static AFun var_cons_ThrowsDec;
static AFun var_cons_NoMethodBody;
static AFun var_cons_ArrayInit;
static AFun var_cons_Anno;
static AFun var_cons_SingleElemAnno;
static AFun var_cons_MarkerAnno;
static AFun var_cons_ElemValPair;
static AFun var_cons_ElemValArrayInit;
static AFun var_cons_FieldDec;
static AFun var_cons_VarDec1;
static AFun var_cons_VarDec2;
static AFun var_cons_ArrayVarDecId;
static AFun var_cons_ClassDec;
static AFun var_cons_ClassBody;
static AFun var_cons_ClassDecHead;
static AFun var_cons_SuperDec;
static AFun var_cons_ImplementsDec;
static AFun var_cons_CompilationUnit;
static AFun var_cons_PackageName;
static AFun var_cons_AmbName1;
static AFun var_cons_AmbName2;
static AFun var_cons_TypeName1;
static AFun var_cons_TypeName2;
static AFun var_cons_ExprName1;
static AFun var_cons_ExprName2;
static AFun var_cons_MethodName1;
static AFun var_cons_MethodName2;
static AFun var_cons_PackageOrTypeName1;
static AFun var_cons_PackageOrTypeName2;
static AFun var_cons_TypeArgs;
static AFun var_cons_Wildcard;
static AFun var_cons_WildcardUpperBound;
static AFun var_cons_WildcardLowerBound;
static AFun var_cons_TypeParam;
static AFun var_cons_TypeBound;
static AFun var_cons_TypeParams;
static AFun var_cons_ClassOrInterfaceType;
static AFun var_cons_ClassType;
static AFun var_cons_InterfaceType;
static AFun var_cons_Member;
static AFun var_cons_TypeVar;
static AFun var_cons_ArrayType;
static AFun var_cons_Boolean;
static AFun var_cons_Byte;
static AFun var_cons_Short;
static AFun var_cons_Int;
static AFun var_cons_Long;
static AFun var_cons_Char;
static AFun var_cons_Float0;
static AFun var_cons_Double;
static AFun var_cons_Null;
static AFun var_cons_Bool;
static AFun var_cons_True;
static AFun var_cons_False;
static AFun var_cons_Float1;
static AFun var_cons_Deci;
static AFun var_cons_Hexa;
static AFun var_cons_Octa;
static AFun var_cons_Public;
static AFun var_cons_Private;
static AFun var_cons_Protected;
static AFun var_cons_Abstract;
static AFun var_cons_Final;
static AFun var_cons_Static;
static AFun var_cons_Native;
static AFun var_cons_Transient;
static AFun var_cons_Volatile;
static AFun var_cons_Synchronized0;
static AFun var_cons_StrictFP;
static AFun var_cons_Id;
static void init_cons (void)
{
var_cons_Parenthetical = ATmakeAFun("Parenthetical", 1, ATfalse);
ATprotectAFun(var_cons_Parenthetical);
var_cons_String = ATmakeAFun("String", 1, ATfalse);
ATprotectAFun(var_cons_String);
var_cons_Chars = ATmakeAFun("Chars", 1, ATfalse);
ATprotectAFun(var_cons_Chars);
var_cons_None = ATmakeAFun("None", 0, ATfalse);
ATprotectAFun(var_cons_None);
var_cons_Some = ATmakeAFun("Some", 1, ATfalse);
ATprotectAFun(var_cons_Some);
var_cons_NamedEscape = ATmakeAFun("NamedEscape", 1, ATfalse);
ATprotectAFun(var_cons_NamedEscape);
var_cons_OctaEscape1 = ATmakeAFun("OctaEscape1", 1, ATfalse);
ATprotectAFun(var_cons_OctaEscape1);
var_cons_OctaEscape2 = ATmakeAFun("OctaEscape2", 1, ATfalse);
ATprotectAFun(var_cons_OctaEscape2);
var_cons_OctaEscape3 = ATmakeAFun("OctaEscape3", 1, ATfalse);
ATprotectAFun(var_cons_OctaEscape3);
var_cons_Assign = ATmakeAFun("Assign", 2, ATfalse);
ATprotectAFun(var_cons_Assign);
var_cons_AssignMul = ATmakeAFun("AssignMul", 2, ATfalse);
ATprotectAFun(var_cons_AssignMul);
var_cons_AssignDiv = ATmakeAFun("AssignDiv", 2, ATfalse);
ATprotectAFun(var_cons_AssignDiv);
var_cons_AssignRemain = ATmakeAFun("AssignRemain", 2, ATfalse);
ATprotectAFun(var_cons_AssignRemain);
var_cons_AssignPlus = ATmakeAFun("AssignPlus", 2, ATfalse);
ATprotectAFun(var_cons_AssignPlus);
var_cons_AssignMinus = ATmakeAFun("AssignMinus", 2, ATfalse);
ATprotectAFun(var_cons_AssignMinus);
var_cons_AssignLeftShift = ATmakeAFun("AssignLeftShift", 2, ATfalse);
ATprotectAFun(var_cons_AssignLeftShift);
var_cons_AssignRightShift = ATmakeAFun("AssignRightShift", 2, ATfalse);
ATprotectAFun(var_cons_AssignRightShift);
var_cons_AssignURightShift = ATmakeAFun("AssignURightShift", 2, ATfalse);
ATprotectAFun(var_cons_AssignURightShift);
var_cons_AssignAnd = ATmakeAFun("AssignAnd", 2, ATfalse);
ATprotectAFun(var_cons_AssignAnd);
var_cons_AssignExcOr = ATmakeAFun("AssignExcOr", 2, ATfalse);
ATprotectAFun(var_cons_AssignExcOr);
var_cons_AssignOr = ATmakeAFun("AssignOr", 2, ATfalse);
ATprotectAFun(var_cons_AssignOr);
var_cons_InstanceOf = ATmakeAFun("InstanceOf", 2, ATfalse);
ATprotectAFun(var_cons_InstanceOf);
var_cons_Mul = ATmakeAFun("Mul", 2, ATfalse);
ATprotectAFun(var_cons_Mul);
var_cons_Div = ATmakeAFun("Div", 2, ATfalse);
ATprotectAFun(var_cons_Div);
var_cons_Remain = ATmakeAFun("Remain", 2, ATfalse);
ATprotectAFun(var_cons_Remain);
var_cons_Plus2 = ATmakeAFun("Plus", 2, ATfalse);
ATprotectAFun(var_cons_Plus2);
var_cons_Minus2 = ATmakeAFun("Minus", 2, ATfalse);
ATprotectAFun(var_cons_Minus2);
var_cons_LeftShift = ATmakeAFun("LeftShift", 2, ATfalse);
ATprotectAFun(var_cons_LeftShift);
var_cons_RightShift = ATmakeAFun("RightShift", 2, ATfalse);
ATprotectAFun(var_cons_RightShift);
var_cons_URightShift = ATmakeAFun("URightShift", 2, ATfalse);
ATprotectAFun(var_cons_URightShift);
var_cons_Lt = ATmakeAFun("Lt", 2, ATfalse);
ATprotectAFun(var_cons_Lt);
var_cons_Gt = ATmakeAFun("Gt", 2, ATfalse);
ATprotectAFun(var_cons_Gt);
var_cons_LtEq = ATmakeAFun("LtEq", 2, ATfalse);
ATprotectAFun(var_cons_LtEq);
var_cons_GtEq = ATmakeAFun("GtEq", 2, ATfalse);
ATprotectAFun(var_cons_GtEq);
var_cons_Eq = ATmakeAFun("Eq", 2, ATfalse);
ATprotectAFun(var_cons_Eq);
var_cons_NotEq = ATmakeAFun("NotEq", 2, ATfalse);
ATprotectAFun(var_cons_NotEq);
var_cons_LazyAnd = ATmakeAFun("LazyAnd", 2, ATfalse);
ATprotectAFun(var_cons_LazyAnd);
var_cons_LazyOr = ATmakeAFun("LazyOr", 2, ATfalse);
ATprotectAFun(var_cons_LazyOr);
var_cons_And = ATmakeAFun("And", 2, ATfalse);
ATprotectAFun(var_cons_And);
var_cons_ExcOr = ATmakeAFun("ExcOr", 2, ATfalse);
ATprotectAFun(var_cons_ExcOr);
var_cons_Or = ATmakeAFun("Or", 2, ATfalse);
ATprotectAFun(var_cons_Or);
var_cons_Cond = ATmakeAFun("Cond", 3, ATfalse);
ATprotectAFun(var_cons_Cond);
var_cons_Plus1 = ATmakeAFun("Plus", 1, ATfalse);
ATprotectAFun(var_cons_Plus1);
var_cons_Minus1 = ATmakeAFun("Minus", 1, ATfalse);
ATprotectAFun(var_cons_Minus1);
var_cons_PreIncr = ATmakeAFun("PreIncr", 1, ATfalse);
ATprotectAFun(var_cons_PreIncr);
var_cons_PreDecr = ATmakeAFun("PreDecr", 1, ATfalse);
ATprotectAFun(var_cons_PreDecr);
var_cons_Complement = ATmakeAFun("Complement", 1, ATfalse);
ATprotectAFun(var_cons_Complement);
var_cons_Not = ATmakeAFun("Not", 1, ATfalse);
ATprotectAFun(var_cons_Not);
var_cons_CastPrim = ATmakeAFun("CastPrim", 2, ATfalse);
ATprotectAFun(var_cons_CastPrim);
var_cons_CastRef = ATmakeAFun("CastRef", 2, ATfalse);
ATprotectAFun(var_cons_CastRef);
var_cons_PostIncr = ATmakeAFun("PostIncr", 1, ATfalse);
ATprotectAFun(var_cons_PostIncr);
var_cons_PostDecr = ATmakeAFun("PostDecr", 1, ATfalse);
ATprotectAFun(var_cons_PostDecr);
var_cons_Invoke = ATmakeAFun("Invoke", 2, ATfalse);
ATprotectAFun(var_cons_Invoke);
var_cons_Method1 = ATmakeAFun("Method", 1, ATfalse);
ATprotectAFun(var_cons_Method1);
var_cons_Method3 = ATmakeAFun("Method", 3, ATfalse);
ATprotectAFun(var_cons_Method3);
var_cons_SuperMethod = ATmakeAFun("SuperMethod", 2, ATfalse);
ATprotectAFun(var_cons_SuperMethod);
var_cons_QSuperMethod = ATmakeAFun("QSuperMethod", 3, ATfalse);
ATprotectAFun(var_cons_QSuperMethod);
var_cons_GenericMethod = ATmakeAFun("GenericMethod", 3, ATfalse);
ATprotectAFun(var_cons_GenericMethod);
var_cons_ArrayAccess = ATmakeAFun("ArrayAccess", 2, ATfalse);
ATprotectAFun(var_cons_ArrayAccess);
var_cons_Field = ATmakeAFun("Field", 2, ATfalse);
ATprotectAFun(var_cons_Field);
var_cons_SuperField = ATmakeAFun("SuperField", 1, ATfalse);
ATprotectAFun(var_cons_SuperField);
var_cons_QSuperField = ATmakeAFun("QSuperField", 2, ATfalse);
ATprotectAFun(var_cons_QSuperField);
var_cons_NewArray = ATmakeAFun("NewArray", 3, ATfalse);
ATprotectAFun(var_cons_NewArray);
var_cons_UnboundWld = ATmakeAFun("UnboundWld", 1, ATfalse);
ATprotectAFun(var_cons_UnboundWld);
var_cons_Dim1 = ATmakeAFun("Dim", 1, ATfalse);
ATprotectAFun(var_cons_Dim1);
var_cons_Dim0 = ATmakeAFun("Dim", 0, ATfalse);
ATprotectAFun(var_cons_Dim0);
var_cons_NewInstance = ATmakeAFun("NewInstance", 4, ATfalse);
ATprotectAFun(var_cons_NewInstance);
var_cons_QNewInstance = ATmakeAFun("QNewInstance", 6, ATfalse);
ATprotectAFun(var_cons_QNewInstance);
var_cons_Lit = ATmakeAFun("Lit", 1, ATfalse);
ATprotectAFun(var_cons_Lit);
var_cons_Class = ATmakeAFun("Class", 1, ATfalse);
ATprotectAFun(var_cons_Class);
var_cons_VoidClass = ATmakeAFun("VoidClass", 0, ATfalse);
ATprotectAFun(var_cons_VoidClass);
var_cons_This = ATmakeAFun("This", 0, ATfalse);
ATprotectAFun(var_cons_This);
var_cons_QThis = ATmakeAFun("QThis", 1, ATfalse);
ATprotectAFun(var_cons_QThis);
var_cons_PackageDec = ATmakeAFun("PackageDec", 2, ATfalse);
ATprotectAFun(var_cons_PackageDec);
var_cons_TypeImportDec = ATmakeAFun("TypeImportDec", 1, ATfalse);
ATprotectAFun(var_cons_TypeImportDec);
var_cons_TypeImportOnDemandDec = ATmakeAFun("TypeImportOnDemandDec", 1, ATfalse);
ATprotectAFun(var_cons_TypeImportOnDemandDec);
var_cons_StaticImportDec = ATmakeAFun("StaticImportDec", 2, ATfalse);
ATprotectAFun(var_cons_StaticImportDec);
var_cons_StaticImportOnDemandDec = ATmakeAFun("StaticImportOnDemandDec", 1, ATfalse);
ATprotectAFun(var_cons_StaticImportOnDemandDec);
var_cons_AnnoDec = ATmakeAFun("AnnoDec", 2, ATfalse);
ATprotectAFun(var_cons_AnnoDec);
var_cons_AnnoDecHead = ATmakeAFun("AnnoDecHead", 2, ATfalse);
ATprotectAFun(var_cons_AnnoDecHead);
var_cons_AnnoMethodDec = ATmakeAFun("AnnoMethodDec", 4, ATfalse);
ATprotectAFun(var_cons_AnnoMethodDec);
var_cons_Semicolon = ATmakeAFun("Semicolon", 0, ATfalse);
ATprotectAFun(var_cons_Semicolon);
var_cons_DefaultVal = ATmakeAFun("DefaultVal", 1, ATfalse);
ATprotectAFun(var_cons_DefaultVal);
var_cons_AbstractMethodDec = ATmakeAFun("AbstractMethodDec", 6, ATfalse);
ATprotectAFun(var_cons_AbstractMethodDec);
var_cons_DeprAbstractMethodDec = ATmakeAFun("DeprAbstractMethodDec", 7, ATfalse);
ATprotectAFun(var_cons_DeprAbstractMethodDec);
var_cons_ConstantDec = ATmakeAFun("ConstantDec", 3, ATfalse);
ATprotectAFun(var_cons_ConstantDec);
var_cons_InterfaceDec = ATmakeAFun("InterfaceDec", 2, ATfalse);
ATprotectAFun(var_cons_InterfaceDec);
var_cons_InterfaceDecHead = ATmakeAFun("InterfaceDecHead", 4, ATfalse);
ATprotectAFun(var_cons_InterfaceDecHead);
var_cons_ExtendsInterfaces = ATmakeAFun("ExtendsInterfaces", 1, ATfalse);
ATprotectAFun(var_cons_ExtendsInterfaces);
var_cons_EnumDec = ATmakeAFun("EnumDec", 2, ATfalse);
ATprotectAFun(var_cons_EnumDec);
var_cons_EnumDecHead = ATmakeAFun("EnumDecHead", 3, ATfalse);
ATprotectAFun(var_cons_EnumDecHead);
var_cons_EnumBody = ATmakeAFun("EnumBody", 2, ATfalse);
ATprotectAFun(var_cons_EnumBody);
var_cons_EnumConst = ATmakeAFun("EnumConst", 3, ATfalse);
ATprotectAFun(var_cons_EnumConst);
var_cons_EnumBodyDecs = ATmakeAFun("EnumBodyDecs", 1, ATfalse);
ATprotectAFun(var_cons_EnumBodyDecs);
var_cons_ConstrDec = ATmakeAFun("ConstrDec", 2, ATfalse);
ATprotectAFun(var_cons_ConstrDec);
var_cons_ConstrDecHead = ATmakeAFun("ConstrDecHead", 5, ATfalse);
ATprotectAFun(var_cons_ConstrDecHead);
var_cons_ConstrBody = ATmakeAFun("ConstrBody", 2, ATfalse);
ATprotectAFun(var_cons_ConstrBody);
var_cons_AltConstrInv = ATmakeAFun("AltConstrInv", 2, ATfalse);
ATprotectAFun(var_cons_AltConstrInv);
var_cons_SuperConstrInv = ATmakeAFun("SuperConstrInv", 2, ATfalse);
ATprotectAFun(var_cons_SuperConstrInv);
var_cons_QSuperConstrInv = ATmakeAFun("QSuperConstrInv", 3, ATfalse);
ATprotectAFun(var_cons_QSuperConstrInv);
var_cons_StaticInit = ATmakeAFun("StaticInit", 1, ATfalse);
ATprotectAFun(var_cons_StaticInit);
var_cons_InstanceInit = ATmakeAFun("InstanceInit", 1, ATfalse);
ATprotectAFun(var_cons_InstanceInit);
var_cons_Empty = ATmakeAFun("Empty", 0, ATfalse);
ATprotectAFun(var_cons_Empty);
var_cons_Labeled = ATmakeAFun("Labeled", 2, ATfalse);
ATprotectAFun(var_cons_Labeled);
var_cons_ExprStm = ATmakeAFun("ExprStm", 1, ATfalse);
ATprotectAFun(var_cons_ExprStm);
var_cons_If2 = ATmakeAFun("If", 2, ATfalse);
ATprotectAFun(var_cons_If2);
var_cons_If3 = ATmakeAFun("If", 3, ATfalse);
ATprotectAFun(var_cons_If3);
var_cons_AssertStm1 = ATmakeAFun("AssertStm", 1, ATfalse);
ATprotectAFun(var_cons_AssertStm1);
var_cons_AssertStm2 = ATmakeAFun("AssertStm", 2, ATfalse);
ATprotectAFun(var_cons_AssertStm2);
var_cons_Switch = ATmakeAFun("Switch", 2, ATfalse);
ATprotectAFun(var_cons_Switch);
var_cons_SwitchBlock = ATmakeAFun("SwitchBlock", 2, ATfalse);
ATprotectAFun(var_cons_SwitchBlock);
var_cons_SwitchGroup = ATmakeAFun("SwitchGroup", 2, ATfalse);
ATprotectAFun(var_cons_SwitchGroup);
var_cons_Case = ATmakeAFun("Case", 1, ATfalse);
ATprotectAFun(var_cons_Case);
var_cons_Default = ATmakeAFun("Default", 0, ATfalse);
ATprotectAFun(var_cons_Default);
var_cons_While = ATmakeAFun("While", 2, ATfalse);
ATprotectAFun(var_cons_While);
var_cons_DoWhile = ATmakeAFun("DoWhile", 2, ATfalse);
ATprotectAFun(var_cons_DoWhile);
var_cons_For = ATmakeAFun("For", 4, ATfalse);
ATprotectAFun(var_cons_For);
var_cons_ForEach = ATmakeAFun("ForEach", 3, ATfalse);
ATprotectAFun(var_cons_ForEach);
var_cons_Break = ATmakeAFun("Break", 1, ATfalse);
ATprotectAFun(var_cons_Break);
var_cons_Continue = ATmakeAFun("Continue", 1, ATfalse);
ATprotectAFun(var_cons_Continue);
var_cons_Return = ATmakeAFun("Return", 1, ATfalse);
ATprotectAFun(var_cons_Return);
var_cons_Throw = ATmakeAFun("Throw", 1, ATfalse);
ATprotectAFun(var_cons_Throw);
var_cons_Synchronized2 = ATmakeAFun("Synchronized", 2, ATfalse);
ATprotectAFun(var_cons_Synchronized2);
var_cons_Try2 = ATmakeAFun("Try", 2, ATfalse);
ATprotectAFun(var_cons_Try2);
var_cons_Try3 = ATmakeAFun("Try", 3, ATfalse);
ATprotectAFun(var_cons_Try3);
var_cons_Catch = ATmakeAFun("Catch", 2, ATfalse);
ATprotectAFun(var_cons_Catch);
var_cons_LocalVarDecStm = ATmakeAFun("LocalVarDecStm", 1, ATfalse);
ATprotectAFun(var_cons_LocalVarDecStm);
var_cons_LocalVarDec = ATmakeAFun("LocalVarDec", 3, ATfalse);
ATprotectAFun(var_cons_LocalVarDec);
var_cons_Block = ATmakeAFun("Block", 1, ATfalse);
ATprotectAFun(var_cons_Block);
var_cons_ClassDecStm = ATmakeAFun("ClassDecStm", 1, ATfalse);
ATprotectAFun(var_cons_ClassDecStm);
var_cons_MethodDec = ATmakeAFun("MethodDec", 2, ATfalse);
ATprotectAFun(var_cons_MethodDec);
var_cons_MethodDecHead = ATmakeAFun("MethodDecHead", 6, ATfalse);
ATprotectAFun(var_cons_MethodDecHead);
var_cons_DeprMethodDecHead = ATmakeAFun("DeprMethodDecHead", 7, ATfalse);
ATprotectAFun(var_cons_DeprMethodDecHead);
var_cons_Void = ATmakeAFun("Void", 0, ATfalse);
ATprotectAFun(var_cons_Void);
var_cons_Param = ATmakeAFun("Param", 3, ATfalse);
ATprotectAFun(var_cons_Param);
var_cons_VarArityParam = ATmakeAFun("VarArityParam", 3, ATfalse);
ATprotectAFun(var_cons_VarArityParam);
var_cons_ThrowsDec = ATmakeAFun("ThrowsDec", 1, ATfalse);
ATprotectAFun(var_cons_ThrowsDec);
var_cons_NoMethodBody = ATmakeAFun("NoMethodBody", 0, ATfalse);
ATprotectAFun(var_cons_NoMethodBody);
var_cons_ArrayInit = ATmakeAFun("ArrayInit", 1, ATfalse);
ATprotectAFun(var_cons_ArrayInit);
var_cons_Anno = ATmakeAFun("Anno", 2, ATfalse);
ATprotectAFun(var_cons_Anno);
var_cons_SingleElemAnno = ATmakeAFun("SingleElemAnno", 2, ATfalse);
ATprotectAFun(var_cons_SingleElemAnno);
var_cons_MarkerAnno = ATmakeAFun("MarkerAnno", 1, ATfalse);
ATprotectAFun(var_cons_MarkerAnno);
var_cons_ElemValPair = ATmakeAFun("ElemValPair", 2, ATfalse);
ATprotectAFun(var_cons_ElemValPair);
var_cons_ElemValArrayInit = ATmakeAFun("ElemValArrayInit", 1, ATfalse);
ATprotectAFun(var_cons_ElemValArrayInit);
var_cons_FieldDec = ATmakeAFun("FieldDec", 3, ATfalse);
ATprotectAFun(var_cons_FieldDec);
var_cons_VarDec1 = ATmakeAFun("VarDec", 1, ATfalse);
ATprotectAFun(var_cons_VarDec1);
var_cons_VarDec2 = ATmakeAFun("VarDec", 2, ATfalse);
ATprotectAFun(var_cons_VarDec2);
var_cons_ArrayVarDecId = ATmakeAFun("ArrayVarDecId", 2, ATfalse);
ATprotectAFun(var_cons_ArrayVarDecId);
var_cons_ClassDec = ATmakeAFun("ClassDec", 2, ATfalse);
ATprotectAFun(var_cons_ClassDec);
var_cons_ClassBody = ATmakeAFun("ClassBody", 1, ATfalse);
ATprotectAFun(var_cons_ClassBody);
var_cons_ClassDecHead = ATmakeAFun("ClassDecHead", 5, ATfalse);
ATprotectAFun(var_cons_ClassDecHead);
var_cons_SuperDec = ATmakeAFun("SuperDec", 1, ATfalse);
ATprotectAFun(var_cons_SuperDec);
var_cons_ImplementsDec = ATmakeAFun("ImplementsDec", 1, ATfalse);
ATprotectAFun(var_cons_ImplementsDec);
var_cons_CompilationUnit = ATmakeAFun("CompilationUnit", 3, ATfalse);
ATprotectAFun(var_cons_CompilationUnit);
var_cons_PackageName = ATmakeAFun("PackageName", 1, ATfalse);
ATprotectAFun(var_cons_PackageName);
var_cons_AmbName1 = ATmakeAFun("AmbName", 1, ATfalse);
ATprotectAFun(var_cons_AmbName1);
var_cons_AmbName2 = ATmakeAFun("AmbName", 2, ATfalse);
ATprotectAFun(var_cons_AmbName2);
var_cons_TypeName1 = ATmakeAFun("TypeName", 1, ATfalse);
ATprotectAFun(var_cons_TypeName1);
var_cons_TypeName2 = ATmakeAFun("TypeName", 2, ATfalse);
ATprotectAFun(var_cons_TypeName2);
var_cons_ExprName1 = ATmakeAFun("ExprName", 1, ATfalse);
ATprotectAFun(var_cons_ExprName1);
var_cons_ExprName2 = ATmakeAFun("ExprName", 2, ATfalse);
ATprotectAFun(var_cons_ExprName2);
var_cons_MethodName1 = ATmakeAFun("MethodName", 1, ATfalse);
ATprotectAFun(var_cons_MethodName1);
var_cons_MethodName2 = ATmakeAFun("MethodName", 2, ATfalse);
ATprotectAFun(var_cons_MethodName2);
var_cons_PackageOrTypeName1 = ATmakeAFun("PackageOrTypeName", 1, ATfalse);
ATprotectAFun(var_cons_PackageOrTypeName1);
var_cons_PackageOrTypeName2 = ATmakeAFun("PackageOrTypeName", 2, ATfalse);
ATprotectAFun(var_cons_PackageOrTypeName2);
var_cons_TypeArgs = ATmakeAFun("TypeArgs", 1, ATfalse);
ATprotectAFun(var_cons_TypeArgs);
var_cons_Wildcard = ATmakeAFun("Wildcard", 1, ATfalse);
ATprotectAFun(var_cons_Wildcard);
var_cons_WildcardUpperBound = ATmakeAFun("WildcardUpperBound", 1, ATfalse);
ATprotectAFun(var_cons_WildcardUpperBound);
var_cons_WildcardLowerBound = ATmakeAFun("WildcardLowerBound", 1, ATfalse);
ATprotectAFun(var_cons_WildcardLowerBound);
var_cons_TypeParam = ATmakeAFun("TypeParam", 2, ATfalse);
ATprotectAFun(var_cons_TypeParam);
var_cons_TypeBound = ATmakeAFun("TypeBound", 1, ATfalse);
ATprotectAFun(var_cons_TypeBound);
var_cons_TypeParams = ATmakeAFun("TypeParams", 1, ATfalse);
ATprotectAFun(var_cons_TypeParams);
var_cons_ClassOrInterfaceType = ATmakeAFun("ClassOrInterfaceType", 2, ATfalse);
ATprotectAFun(var_cons_ClassOrInterfaceType);
var_cons_ClassType = ATmakeAFun("ClassType", 2, ATfalse);
ATprotectAFun(var_cons_ClassType);
var_cons_InterfaceType = ATmakeAFun("InterfaceType", 2, ATfalse);
ATprotectAFun(var_cons_InterfaceType);
var_cons_Member = ATmakeAFun("Member", 3, ATfalse);
ATprotectAFun(var_cons_Member);
var_cons_TypeVar = ATmakeAFun("TypeVar", 1, ATfalse);
ATprotectAFun(var_cons_TypeVar);
var_cons_ArrayType = ATmakeAFun("ArrayType", 1, ATfalse);
ATprotectAFun(var_cons_ArrayType);
var_cons_Boolean = ATmakeAFun("Boolean", 0, ATfalse);
ATprotectAFun(var_cons_Boolean);
var_cons_Byte = ATmakeAFun("Byte", 0, ATfalse);
ATprotectAFun(var_cons_Byte);
var_cons_Short = ATmakeAFun("Short", 0, ATfalse);
ATprotectAFun(var_cons_Short);
var_cons_Int = ATmakeAFun("Int", 0, ATfalse);
ATprotectAFun(var_cons_Int);
var_cons_Long = ATmakeAFun("Long", 0, ATfalse);
ATprotectAFun(var_cons_Long);
var_cons_Char = ATmakeAFun("Char", 0, ATfalse);
ATprotectAFun(var_cons_Char);
var_cons_Float0 = ATmakeAFun("Float", 0, ATfalse);
ATprotectAFun(var_cons_Float0);
var_cons_Double = ATmakeAFun("Double", 0, ATfalse);
ATprotectAFun(var_cons_Double);
var_cons_Null = ATmakeAFun("Null", 0, ATfalse);
ATprotectAFun(var_cons_Null);
var_cons_Bool = ATmakeAFun("Bool", 1, ATfalse);
ATprotectAFun(var_cons_Bool);
var_cons_True = ATmakeAFun("True", 0, ATfalse);
ATprotectAFun(var_cons_True);
var_cons_False = ATmakeAFun("False", 0, ATfalse);
ATprotectAFun(var_cons_False);
var_cons_Float1 = ATmakeAFun("Float", 1, ATfalse);
ATprotectAFun(var_cons_Float1);
var_cons_Deci = ATmakeAFun("Deci", 1, ATfalse);
ATprotectAFun(var_cons_Deci);
var_cons_Hexa = ATmakeAFun("Hexa", 1, ATfalse);
ATprotectAFun(var_cons_Hexa);
var_cons_Octa = ATmakeAFun("Octa", 1, ATfalse);
ATprotectAFun(var_cons_Octa);
var_cons_Public = ATmakeAFun("Public", 0, ATfalse);
ATprotectAFun(var_cons_Public);
var_cons_Private = ATmakeAFun("Private", 0, ATfalse);
ATprotectAFun(var_cons_Private);
var_cons_Protected = ATmakeAFun("Protected", 0, ATfalse);
ATprotectAFun(var_cons_Protected);
var_cons_Abstract = ATmakeAFun("Abstract", 0, ATfalse);
ATprotectAFun(var_cons_Abstract);
var_cons_Final = ATmakeAFun("Final", 0, ATfalse);
ATprotectAFun(var_cons_Final);
var_cons_Static = ATmakeAFun("Static", 0, ATfalse);
ATprotectAFun(var_cons_Static);
var_cons_Native = ATmakeAFun("Native", 0, ATfalse);
ATprotectAFun(var_cons_Native);
var_cons_Transient = ATmakeAFun("Transient", 0, ATfalse);
ATprotectAFun(var_cons_Transient);
var_cons_Volatile = ATmakeAFun("Volatile", 0, ATfalse);
ATprotectAFun(var_cons_Volatile);
var_cons_Synchronized0 = ATmakeAFun("Synchronized", 0, ATfalse);
ATprotectAFun(var_cons_Synchronized0);
var_cons_StrictFP = ATmakeAFun("StrictFP", 0, ATfalse);
ATprotectAFun(var_cons_StrictFP);
var_cons_Id = ATmakeAFun("Id", 1, ATfalse);
ATprotectAFun(var_cons_Id);
}
static void print (ATerm);
static void print_cons_Parenthetical (ATerm);
static void print_cons_String (ATerm);
static void print_cons_Chars (ATerm);
static void print_cons_None (ATerm);
static void print_cons_Some (ATerm);
static void print_cons_NamedEscape (ATerm);
static void print_cons_OctaEscape1 (ATerm);
static void print_cons_OctaEscape2 (ATerm);
static void print_cons_OctaEscape3 (ATerm);
static void print_cons_Assign (ATerm);
static void print_cons_AssignMul (ATerm);
static void print_cons_AssignDiv (ATerm);
static void print_cons_AssignRemain (ATerm);
static void print_cons_AssignPlus (ATerm);
static void print_cons_AssignMinus (ATerm);
static void print_cons_AssignLeftShift (ATerm);
static void print_cons_AssignRightShift (ATerm);
static void print_cons_AssignURightShift (ATerm);
static void print_cons_AssignAnd (ATerm);
static void print_cons_AssignExcOr (ATerm);
static void print_cons_AssignOr (ATerm);
static void print_cons_InstanceOf (ATerm);
static void print_cons_Mul (ATerm);
static void print_cons_Div (ATerm);
static void print_cons_Remain (ATerm);
static void print_cons_Plus2 (ATerm);
static void print_cons_Minus2 (ATerm);
static void print_cons_LeftShift (ATerm);
static void print_cons_RightShift (ATerm);
static void print_cons_URightShift (ATerm);
static void print_cons_Lt (ATerm);
static void print_cons_Gt (ATerm);
static void print_cons_LtEq (ATerm);
static void print_cons_GtEq (ATerm);
static void print_cons_Eq (ATerm);
static void print_cons_NotEq (ATerm);
static void print_cons_LazyAnd (ATerm);
static void print_cons_LazyOr (ATerm);
static void print_cons_And (ATerm);
static void print_cons_ExcOr (ATerm);
static void print_cons_Or (ATerm);
static void print_cons_Cond (ATerm);
static void print_cons_Plus1 (ATerm);
static void print_cons_Minus1 (ATerm);
static void print_cons_PreIncr (ATerm);
static void print_cons_PreDecr (ATerm);
static void print_cons_Complement (ATerm);
static void print_cons_Not (ATerm);
static void print_cons_CastPrim (ATerm);
static void print_cons_CastRef (ATerm);
static void print_cons_PostIncr (ATerm);
static void print_cons_PostDecr (ATerm);
static void print_cons_Invoke (ATerm);
static void print_cons_Invoke_2 (ATerm);
static void print_cons_Method1 (ATerm);
static void print_cons_Method3 (ATerm);
static void print_cons_Method1_2 (ATerm);
static void print_cons_SuperMethod (ATerm);
static void print_cons_SuperMethod_1 (ATerm);
static void print_cons_QSuperMethod (ATerm);
static void print_cons_QSuperMethod_2 (ATerm);
static void print_cons_GenericMethod (ATerm);
static void print_cons_ArrayAccess (ATerm);
static void print_cons_Field (ATerm);
static void print_cons_SuperField (ATerm);
static void print_cons_QSuperField (ATerm);
static void print_cons_NewArray (ATerm);
static void print_cons_NewArray_2 (ATerm);
static void print_cons_NewArray_3 (ATerm);
static void print_cons_UnboundWld (ATerm);
static void print_cons_Dim1 (ATerm);
static void print_cons_Dim0 (ATerm);
static void print_cons_NewInstance (ATerm);
static void print_cons_NewInstance_1 (ATerm);
static void print_cons_NewInstance_3 (ATerm);
static void print_cons_NewInstance_4 (ATerm);
static void print_cons_QNewInstance (ATerm);
static void print_cons_QNewInstance_2 (ATerm);
static void print_cons_QNewInstance_4 (ATerm);
static void print_cons_QNewInstance_5 (ATerm);
static void print_cons_QNewInstance_6 (ATerm);
static void print_cons_Lit (ATerm);
static void print_cons_Class (ATerm);
static void print_cons_VoidClass (ATerm);
static void print_cons_This (ATerm);
static void print_cons_QThis (ATerm);
static void print_cons_PackageDec (ATerm);
static void print_cons_PackageDec_1 (ATerm);
static void print_cons_TypeImportDec (ATerm);
static void print_cons_TypeImportOnDemandDec (ATerm);
static void print_cons_StaticImportDec (ATerm);
static void print_cons_StaticImportOnDemandDec (ATerm);
static void print_cons_AnnoDec (ATerm);
static void print_cons_AnnoDec_2 (ATerm);
static void print_cons_AnnoDecHead (ATerm);
static void print_cons_AnnoDecHead_1 (ATerm);
static void print_cons_AnnoDecHead_1_1 (ATerm);
static void print_cons_AnnoMethodDec (ATerm);
static void print_cons_AnnoMethodDec_1 (ATerm);
static void print_cons_AnnoMethodDec_4 (ATerm);
static void print_cons_Semicolon (ATerm);
static void print_cons_DefaultVal (ATerm);
static void print_cons_AbstractMethodDec (ATerm);
static void print_cons_AbstractMethodDec_1 (ATerm);
static void print_cons_AbstractMethodDec_1_1 (ATerm);
static void print_cons_AbstractMethodDec_2 (ATerm);
static void print_cons_AbstractMethodDec_5 (ATerm);
static void print_cons_AbstractMethodDec_6 (ATerm);
static void print_cons_DeprAbstractMethodDec (ATerm);
static void print_cons_DeprAbstractMethodDec_1 (ATerm);
static void print_cons_DeprAbstractMethodDec_1_1 (ATerm);
static void print_cons_DeprAbstractMethodDec_2 (ATerm);
static void print_cons_DeprAbstractMethodDec_5 (ATerm);
static void print_cons_DeprAbstractMethodDec_6 (ATerm);
static void print_cons_DeprAbstractMethodDec_7 (ATerm);
static void print_cons_ConstantDec (ATerm);
static void print_cons_ConstantDec_1 (ATerm);
static void print_cons_ConstantDec_1_1 (ATerm);
static void print_cons_ConstantDec_3 (ATerm);
static void print_cons_InterfaceDec (ATerm);
static void print_cons_InterfaceDec_2 (ATerm);
static void print_cons_InterfaceDecHead (ATerm);
static void print_cons_InterfaceDecHead_1 (ATerm);
static void print_cons_InterfaceDecHead_1_1 (ATerm);
static void print_cons_InterfaceDecHead_3 (ATerm);
static void print_cons_InterfaceDecHead_4 (ATerm);
static void print_cons_ExtendsInterfaces (ATerm);
static void print_cons_ExtendsInterfaces_1 (ATerm);
static void print_cons_EnumDec (ATerm);
static void print_cons_EnumDecHead (ATerm);
static void print_cons_EnumDecHead_1 (ATerm);
static void print_cons_EnumDecHead_1_1 (ATerm);
static void print_cons_EnumDecHead_3 (ATerm);
static void print_cons_EnumBody (ATerm);
static void print_cons_EnumBody_1 (ATerm);
static void print_cons_EnumBody_2 (ATerm);
static void print_cons_EnumConst (ATerm);
static void print_cons_EnumConst_2 (ATerm);
static void print_cons_EnumConst_3 (ATerm);
static void print_cons_EnumBodyDecs (ATerm);
static void print_cons_EnumBodyDecs_1 (ATerm);
static void print_cons_ConstrDec (ATerm);
static void print_cons_ConstrDecHead (ATerm);
static void print_cons_ConstrDecHead_1 (ATerm);
static void print_cons_ConstrDecHead_1_1 (ATerm);
static void print_cons_ConstrDecHead_2 (ATerm);
static void print_cons_ConstrDecHead_4 (ATerm);
static void print_cons_ConstrDecHead_5 (ATerm);
static void print_cons_ConstrBody (ATerm);
static void print_cons_ConstrBody_1 (ATerm);
static void print_cons_ConstrBody_2 (ATerm);
static void print_cons_AltConstrInv (ATerm);
static void print_cons_AltConstrInv_1 (ATerm);
static void print_cons_AltConstrInv_2 (ATerm);
static void print_cons_SuperConstrInv (ATerm);
static void print_cons_SuperConstrInv_1 (ATerm);
static void print_cons_SuperConstrInv_2 (ATerm);
static void print_cons_QSuperConstrInv (ATerm);
static void print_cons_QSuperConstrInv_2 (ATerm);
static void print_cons_QSuperConstrInv_3 (ATerm);
static void print_cons_StaticInit (ATerm);
static void print_cons_InstanceInit (ATerm);
static void print_cons_Empty (ATerm);
static void print_cons_Labeled (ATerm);
static void print_cons_ExprStm (ATerm);
static void print_cons_If2 (ATerm);
static void print_cons_If3 (ATerm);
static void print_cons_AssertStm1 (ATerm);
static void print_cons_AssertStm2 (ATerm);
static void print_cons_Switch (ATerm);
static void print_cons_SwitchBlock (ATerm);
static void print_cons_SwitchBlock_1 (ATerm);
static void print_cons_SwitchBlock_2 (ATerm);
static void print_cons_SwitchGroup (ATerm);
static void print_cons_SwitchGroup_1 (ATerm);
static void print_cons_SwitchGroup_2 (ATerm);
static void print_cons_Case (ATerm);
static void print_cons_Default (ATerm);
static void print_cons_While (ATerm);
static void print_cons_DoWhile (ATerm);
static void print_cons_For (ATerm);
static void print_cons_For_2 (ATerm);
static void print_cons_For_3 (ATerm);
static void print_cons_ForEach (ATerm);
static void print_cons_Break (ATerm);
static void print_cons_Break_1 (ATerm);
static void print_cons_Continue (ATerm);
static void print_cons_Continue_1 (ATerm);
static void print_cons_Return (ATerm);
static void print_cons_Return_1 (ATerm);
static void print_cons_Throw (ATerm);
static void print_cons_Synchronized2 (ATerm);
static void print_cons_Try2 (ATerm);
static void print_cons_Try3 (ATerm);
static void print_cons_Catch (ATerm);
static void print_cons_LocalVarDecStm (ATerm);
static void print_cons_LocalVarDec (ATerm);
static void print_cons_LocalVarDec_1 (ATerm);
static void print_cons_LocalVarDec_1_1 (ATerm);
static void print_cons_LocalVarDec_3 (ATerm);
static void print_cons_Block (ATerm);
static void print_cons_Block_1 (ATerm);
static void print_cons_ClassDecStm (ATerm);
static void print_cons_MethodDec (ATerm);
static void print_cons_MethodDecHead (ATerm);
static void print_cons_MethodDecHead_1 (ATerm);
static void print_cons_MethodDecHead_1_1 (ATerm);
static void print_cons_MethodDecHead_2 (ATerm);
static void print_cons_MethodDecHead_5 (ATerm);
static void print_cons_MethodDecHead_6 (ATerm);
static void print_cons_DeprMethodDecHead (ATerm);
static void print_cons_DeprMethodDecHead_1 (ATerm);
static void print_cons_DeprMethodDecHead_1_1 (ATerm);
static void print_cons_DeprMethodDecHead_2 (ATerm);
static void print_cons_DeprMethodDecHead_5 (ATerm);
static void print_cons_DeprMethodDecHead_6 (ATerm);
static void print_cons_DeprMethodDecHead_7 (ATerm);
static void print_cons_Void (ATerm);
static void print_cons_Param (ATerm);
static void print_cons_Param_1 (ATerm);
static void print_cons_Param_1_1 (ATerm);
static void print_cons_VarArityParam (ATerm);
static void print_cons_VarArityParam_1 (ATerm);
static void print_cons_VarArityParam_1_1 (ATerm);
static void print_cons_ThrowsDec (ATerm);
static void print_cons_ThrowsDec_1 (ATerm);
static void print_cons_NoMethodBody (ATerm);
static void print_cons_ArrayInit (ATerm);
static void print_cons_ArrayInit_1 (ATerm);
static void print_cons_Anno (ATerm);
static void print_cons_Anno_2 (ATerm);
static void print_cons_SingleElemAnno (ATerm);
static void print_cons_MarkerAnno (ATerm);
static void print_cons_ElemValPair (ATerm);
static void print_cons_ElemValArrayInit (ATerm);
static void print_cons_ElemValArrayInit_1 (ATerm);
static void print_cons_FieldDec (ATerm);
static void print_cons_FieldDec_1 (ATerm);
static void print_cons_FieldDec_1_1 (ATerm);
static void print_cons_FieldDec_3 (ATerm);
static void print_cons_VarDec1 (ATerm);
static void print_cons_VarDec2 (ATerm);
static void print_cons_ArrayVarDecId (ATerm);
static void print_cons_ArrayVarDecId_2 (ATerm);
static void print_cons_ClassDec (ATerm);
static void print_cons_ClassBody (ATerm);
static void print_cons_ClassBody_1 (ATerm);
static void print_cons_ClassDecHead (ATerm);
static void print_cons_ClassDecHead_1 (ATerm);
static void print_cons_ClassDecHead_1_1 (ATerm);
static void print_cons_ClassDecHead_3 (ATerm);
static void print_cons_ClassDecHead_4 (ATerm);
static void print_cons_ClassDecHead_5 (ATerm);
static void print_cons_SuperDec (ATerm);
static void print_cons_ImplementsDec (ATerm);
static void print_cons_ImplementsDec_1 (ATerm);
static void print_cons_CompilationUnit (ATerm);
static void print_cons_CompilationUnit_1 (ATerm);
static void print_cons_CompilationUnit_2 (ATerm);
static void print_cons_CompilationUnit_3 (ATerm);
static void print_cons_PackageName (ATerm);
static void print_cons_PackageName_1 (ATerm);
static void print_cons_AmbName1 (ATerm);
static void print_cons_AmbName2 (ATerm);
static void print_cons_TypeName1 (ATerm);
static void print_cons_TypeName2 (ATerm);
static void print_cons_ExprName1 (ATerm);
static void print_cons_ExprName2 (ATerm);
static void print_cons_MethodName1 (ATerm);
static void print_cons_MethodName2 (ATerm);
static void print_cons_PackageOrTypeName1 (ATerm);
static void print_cons_PackageOrTypeName2 (ATerm);
static void print_cons_TypeArgs (ATerm);
static void print_cons_TypeArgs_1 (ATerm);
static void print_cons_Wildcard (ATerm);
static void print_cons_Wildcard_1 (ATerm);
static void print_cons_WildcardUpperBound (ATerm);
static void print_cons_WildcardLowerBound (ATerm);
static void print_cons_TypeParam (ATerm);
static void print_cons_TypeParam_2 (ATerm);
static void print_cons_TypeBound (ATerm);
static void print_cons_TypeBound_1 (ATerm);
static void print_cons_TypeParams (ATerm);
static void print_cons_TypeParams_1 (ATerm);
static void print_cons_ClassOrInterfaceType (ATerm);
static void print_cons_ClassOrInterfaceType_2 (ATerm);
static void print_cons_ClassType (ATerm);
static void print_cons_ClassType_2 (ATerm);
static void print_cons_InterfaceType (ATerm);
static void print_cons_InterfaceType_2 (ATerm);
static void print_cons_Member (ATerm);
static void print_cons_TypeVar (ATerm);
static void print_cons_ArrayType (ATerm);
static void print_cons_Boolean (ATerm);
static void print_cons_Byte (ATerm);
static void print_cons_Short (ATerm);
static void print_cons_Int (ATerm);
static void print_cons_Long (ATerm);
static void print_cons_Char (ATerm);
static void print_cons_Float0 (ATerm);
static void print_cons_Double (ATerm);
static void print_cons_Null (ATerm);
static void print_cons_Bool (ATerm);
static void print_cons_True (ATerm);
static void print_cons_False (ATerm);
static void print_cons_Float1 (ATerm);
static void print_cons_Deci (ATerm);
static void print_cons_Hexa (ATerm);
static void print_cons_Octa (ATerm);
static void print_cons_Public (ATerm);
static void print_cons_Private (ATerm);
static void print_cons_Protected (ATerm);
static void print_cons_Abstract (ATerm);
static void print_cons_Final (ATerm);
static void print_cons_Static (ATerm);
static void print_cons_Native (ATerm);
static void print_cons_Transient (ATerm);
static void print_cons_Volatile (ATerm);
static void print_cons_Synchronized0 (ATerm);
static void print_cons_StrictFP (ATerm);
static void print_cons_Id (ATerm);
static void print_cons_Parenthetical (ATerm tree)
{
push_box(H, 0, 0, 1);
{
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
}
pop_box();
}
static void print_cons_String (ATerm tree)
{
push_box(H, 0, 0, 0);
{
print_string("\"");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("\"");
}
pop_box();
}
static void print_cons_Chars (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_None (ATerm tree)
{
}
static void print_cons_Some (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_NamedEscape (ATerm tree)
{
print_string("\\");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_OctaEscape1 (ATerm tree)
{
print_string("\\");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_OctaEscape2 (ATerm tree)
{
print_string("\\");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_OctaEscape3 (ATerm tree)
{
print_string("\\");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Assign (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignMul (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("*=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignDiv (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("/=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignRemain (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("%=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignPlus (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("+=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignMinus (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("-=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignLeftShift (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("<<=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignRightShift (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(">>=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignURightShift (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(">>>=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignAnd (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("&=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignExcOr (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("^=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AssignOr (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("|=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_InstanceOf (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("instanceof");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Mul (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("*");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Div (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("/");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Remain (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("%");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Plus2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("+");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Minus2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("-");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_LeftShift (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("<<");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_RightShift (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(">>");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_URightShift (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(">>>");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Lt (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("<");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Gt (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(">");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_LtEq (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("<=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_GtEq (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(">=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Eq (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("==");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_NotEq (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("!=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_LazyAnd (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("&&");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_LazyOr (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("||");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_And (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("&");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_ExcOr (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("^");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Or (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("|");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Cond (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("?");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(":");
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_Plus1 (ATerm tree)
{
print_string("+");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Minus1 (ATerm tree)
{
print_string("-");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_PreIncr (ATerm tree)
{
print_string("++");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_PreDecr (ATerm tree)
{
print_string("--");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Complement (ATerm tree)
{
print_string("~");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Not (ATerm tree)
{
print_string("!");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_CastPrim (ATerm tree)
{
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_CastRef (ATerm tree)
{
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_PostIncr (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("++");
}
static void print_cons_PostDecr (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("--");
}
static void print_cons_Invoke (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_Invoke_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string(")");
}
static void print_cons_Invoke_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_Method1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Method3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_Method1_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_SuperMethod (ATerm tree)
{
print_string("super");
print_string(".");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_SuperMethod_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_SuperMethod_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_QSuperMethod (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
print_string("super");
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_QSuperMethod_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_QSuperMethod_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_GenericMethod (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_ArrayAccess (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("[");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string("]");
}
static void print_cons_Field (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_SuperField (ATerm tree)
{
print_string("super");
print_string(".");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_QSuperField (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
print_string("super");
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_NewArray (ATerm tree)
{
print_string("new");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_NewArray_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_NewArray_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
}
static void print_cons_NewArray_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_NewArray_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_UnboundWld (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("<");
print_string("?");
print_string(">");
}
static void print_cons_Dim1 (ATerm tree)
{
print_string("[");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("]");
}
static void print_cons_Dim0 (ATerm tree)
{
print_string("[");
print_string("]");
}
static void print_cons_NewInstance (ATerm tree)
{
print_string("new");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_NewInstance_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_NewInstance_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 3);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_NewInstance_4(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 4, "a Some(1) or a None(0)");
}
}
static void print_cons_NewInstance_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_NewInstance_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_NewInstance_4 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_QNewInstance (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
print_string("new");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_QNewInstance_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 3);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_QNewInstance_4(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 4, "a Some(1) or a None(0)");
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 4);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_QNewInstance_5((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 5, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 5);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_QNewInstance_6(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 6, "a Some(1) or a None(0)");
}
}
static void print_cons_QNewInstance_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_QNewInstance_4 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_QNewInstance_5 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_QNewInstance_6 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Lit (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Class (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
print_string("class");
}
static void print_cons_VoidClass (ATerm tree)
{
print_string("void");
print_string(".");
print_string("class");
}
static void print_cons_This (ATerm tree)
{
print_string("this");
}
static void print_cons_QThis (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
print_string("this");
}
static void print_cons_PackageDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_PackageDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string("package");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(";");
}
static void print_cons_PackageDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_TypeImportDec (ATerm tree)
{
print_string("import");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(";");
}
static void print_cons_TypeImportOnDemandDec (ATerm tree)
{
print_string("import");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
print_string("*");
print_string(";");
}
static void print_cons_StaticImportDec (ATerm tree)
{
print_string("import");
print_string("static");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(";");
}
static void print_cons_StaticImportOnDemandDec (ATerm tree)
{
print_string("import");
print_string("static");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
print_string("*");
print_string(";");
}
static void print_cons_AnnoDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("{");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_AnnoDec_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string("}");
}
static void print_cons_AnnoDec_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_AnnoDecHead (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_AnnoDecHead_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string("@");
print_string("interface");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_AnnoDecHead_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_AnnoDecHead_1_1(arg);
}
}
static void print_cons_AnnoDecHead_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_AnnoMethodDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_AnnoMethodDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
print_string("(");
print_string(")");
{
ATerm arg = ATgetArgument(tree, 3);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_AnnoMethodDec_4(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 4, "a Some(1) or a None(0)");
}
print_string(";");
}
static void print_cons_AnnoMethodDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_AnnoMethodDec_4 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Semicolon (ATerm tree)
{
print_string(";");
}
static void print_cons_DefaultVal (ATerm tree)
{
print_string("default");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_AbstractMethodDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_AbstractMethodDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_AbstractMethodDec_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 3);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 4);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_AbstractMethodDec_5((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 5, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 5);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_AbstractMethodDec_6(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 6, "a Some(1) or a None(0)");
}
print_string(";");
}
static void print_cons_AbstractMethodDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_AbstractMethodDec_1_1(arg);
}
}
static void print_cons_AbstractMethodDec_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_AbstractMethodDec_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_AbstractMethodDec_5 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_AbstractMethodDec_6 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_DeprAbstractMethodDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_DeprAbstractMethodDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_DeprAbstractMethodDec_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 3);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 4);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_DeprAbstractMethodDec_5((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 5, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 5);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_DeprAbstractMethodDec_6((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 6, "a list");
}
{
ATerm arg = ATgetArgument(tree, 6);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_DeprAbstractMethodDec_7(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 7, "a Some(1) or a None(0)");
}
print_string(";");
}
static void print_cons_DeprAbstractMethodDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_DeprAbstractMethodDec_1_1(arg);
}
}
static void print_cons_DeprAbstractMethodDec_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_DeprAbstractMethodDec_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_DeprAbstractMethodDec_5 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_DeprAbstractMethodDec_6 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_DeprAbstractMethodDec_7 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ConstantDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ConstantDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ConstantDec_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
print_string(";");
}
static void print_cons_ConstantDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_ConstantDec_1_1(arg);
}
}
static void print_cons_ConstantDec_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_ConstantDec_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_InterfaceDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("{");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_InterfaceDec_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string("}");
}
static void print_cons_InterfaceDec_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_InterfaceDecHead (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_InterfaceDecHead_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string("interface");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_InterfaceDecHead_3(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 3, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 3);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_InterfaceDecHead_4(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 4, "a Some(1) or a None(0)");
}
}
static void print_cons_InterfaceDecHead_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_InterfaceDecHead_1_1(arg);
}
}
static void print_cons_InterfaceDecHead_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_InterfaceDecHead_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_InterfaceDecHead_4 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ExtendsInterfaces (ATerm tree)
{
push_box(V, 0, 0, 1);
{
push_box(H, 0, 0, 1);
{
print_string("extends");
}
pop_box();
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ExtendsInterfaces_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
pop_box();
}
static void print_cons_ExtendsInterfaces_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_EnumDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_EnumDecHead (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_EnumDecHead_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string("enum");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_EnumDecHead_3(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 3, "a Some(1) or a None(0)");
}
}
static void print_cons_EnumDecHead_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_EnumDecHead_1_1(arg);
}
}
static void print_cons_EnumDecHead_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_EnumDecHead_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_EnumBody (ATerm tree)
{
print_string("{");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_EnumBody_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string(",");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_EnumBody_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
print_string("}");
}
static void print_cons_EnumBody_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_EnumBody_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_EnumConst (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_EnumConst_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_EnumConst_3(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 3, "a Some(1) or a None(0)");
}
}
static void print_cons_EnumConst_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_EnumConst_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_EnumBodyDecs (ATerm tree)
{
push_box(V, 0, 0, 1);
{
push_box(H, 0, 0, 1);
{
print_string(";");
}
pop_box();
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_EnumBodyDecs_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
pop_box();
}
static void print_cons_EnumBodyDecs_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ConstrDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_ConstrDecHead (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ConstrDecHead_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ConstrDecHead_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 3);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ConstrDecHead_4((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 4, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 4);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ConstrDecHead_5(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 5, "a Some(1) or a None(0)");
}
}
static void print_cons_ConstrDecHead_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_ConstrDecHead_1_1(arg);
}
}
static void print_cons_ConstrDecHead_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_ConstrDecHead_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ConstrDecHead_4 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_ConstrDecHead_5 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ConstrBody (ATerm tree)
{
print_string("{");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ConstrBody_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ConstrBody_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string("}");
}
static void print_cons_ConstrBody_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ConstrBody_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_AltConstrInv (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_AltConstrInv_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
print_string("this");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_AltConstrInv_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string(")");
print_string(";");
}
static void print_cons_AltConstrInv_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_AltConstrInv_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_SuperConstrInv (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_SuperConstrInv_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
print_string("super");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_SuperConstrInv_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string(")");
print_string(";");
}
static void print_cons_SuperConstrInv_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_SuperConstrInv_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_QSuperConstrInv (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_QSuperConstrInv_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
print_string("super");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_QSuperConstrInv_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
print_string(")");
print_string(";");
}
static void print_cons_QSuperConstrInv_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_QSuperConstrInv_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_StaticInit (ATerm tree)
{
print_string("static");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_InstanceInit (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Empty (ATerm tree)
{
print_string(";");
}
static void print_cons_Labeled (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(":");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_ExprStm (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(";");
}
static void print_cons_If2 (ATerm tree)
{
print_string("if");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_If3 (ATerm tree)
{
print_string("if");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string("else");
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_AssertStm1 (ATerm tree)
{
print_string("assert");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(";");
}
static void print_cons_AssertStm2 (ATerm tree)
{
print_string("assert");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(":");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(";");
}
static void print_cons_Switch (ATerm tree)
{
print_string("switch");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_SwitchBlock (ATerm tree)
{
print_string("{");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_SwitchBlock_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_SwitchBlock_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string("}");
}
static void print_cons_SwitchBlock_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_SwitchBlock_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_SwitchGroup (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_SwitchGroup_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_SwitchGroup_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
}
static void print_cons_SwitchGroup_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_SwitchGroup_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Case (ATerm tree)
{
print_string("case");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(":");
}
static void print_cons_Default (ATerm tree)
{
print_string("default");
print_string(":");
}
static void print_cons_While (ATerm tree)
{
print_string("while");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_DoWhile (ATerm tree)
{
print_string("do");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("while");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(")");
print_string(";");
}
static void print_cons_For (ATerm tree)
{
print_string("for");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(";");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_For_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
print_string(";");
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_For_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 3);
print(arg);
}
}
static void print_cons_For_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_For_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_ForEach (ATerm tree)
{
print_string("for");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(":");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_Break (ATerm tree)
{
print_string("break");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_Break_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
print_string(";");
}
static void print_cons_Break_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Continue (ATerm tree)
{
print_string("continue");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_Continue_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
print_string(";");
}
static void print_cons_Continue_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Return (ATerm tree)
{
print_string("return");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_Return_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
print_string(";");
}
static void print_cons_Return_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Throw (ATerm tree)
{
print_string("throw");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(";");
}
static void print_cons_Synchronized2 (ATerm tree)
{
print_string("synchronized");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Try2 (ATerm tree)
{
print_string("try");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_Try3 (ATerm tree)
{
print_string("try");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string("finally");
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_Catch (ATerm tree)
{
print_string("catch");
print_string("(");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_LocalVarDecStm (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(";");
}
static void print_cons_LocalVarDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_LocalVarDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_LocalVarDec_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
}
static void print_cons_LocalVarDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_LocalVarDec_1_1(arg);
}
}
static void print_cons_LocalVarDec_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_LocalVarDec_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_Block (ATerm tree)
{
push_box(V, 0, 0, 1);
{
print_string("{");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_Block_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
pop_box();
print_string("}");
}
static void print_cons_Block_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ClassDecStm (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_MethodDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_MethodDecHead (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_MethodDecHead_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_MethodDecHead_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 3);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 4);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_MethodDecHead_5((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 5, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 5);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_MethodDecHead_6(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 6, "a Some(1) or a None(0)");
}
}
static void print_cons_MethodDecHead_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_MethodDecHead_1_1(arg);
}
}
static void print_cons_MethodDecHead_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_MethodDecHead_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_MethodDecHead_5 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_MethodDecHead_6 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_DeprMethodDecHead (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_DeprMethodDecHead_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_DeprMethodDecHead_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 3);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 4);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_DeprMethodDecHead_5((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 5, "a list");
}
print_string(")");
{
ATerm arg = ATgetArgument(tree, 5);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_DeprMethodDecHead_6((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 6, "a list");
}
{
ATerm arg = ATgetArgument(tree, 6);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_DeprMethodDecHead_7(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 7, "a Some(1) or a None(0)");
}
}
static void print_cons_DeprMethodDecHead_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_DeprMethodDecHead_1_1(arg);
}
}
static void print_cons_DeprMethodDecHead_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_DeprMethodDecHead_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_DeprMethodDecHead_5 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_DeprMethodDecHead_6 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_DeprMethodDecHead_7 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Void (ATerm tree)
{
print_string("void");
}
static void print_cons_Param (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_Param_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_Param_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_Param_1_1(arg);
}
}
static void print_cons_Param_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_VarArityParam (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_VarArityParam_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string("...");
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_VarArityParam_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_VarArityParam_1_1(arg);
}
}
static void print_cons_VarArityParam_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_ThrowsDec (ATerm tree)
{
push_box(V, 0, 0, 1);
{
push_box(H, 0, 0, 1);
{
print_string("throws");
}
pop_box();
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ThrowsDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
pop_box();
}
static void print_cons_ThrowsDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_NoMethodBody (ATerm tree)
{
print_string(";");
}
static void print_cons_ArrayInit (ATerm tree)
{
print_string("{");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ArrayInit_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string("}");
}
static void print_cons_ArrayInit_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_Anno (ATerm tree)
{
print_string("@");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_Anno_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
print_string(")");
}
static void print_cons_Anno_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_SingleElemAnno (ATerm tree)
{
print_string("@");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("(");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(")");
}
static void print_cons_MarkerAnno (ATerm tree)
{
print_string("@");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ElemValPair (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_ElemValArrayInit (ATerm tree)
{
print_string("{");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ElemValArrayInit_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string("}");
}
static void print_cons_ElemValArrayInit_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_FieldDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_FieldDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_FieldDec_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
print_string(";");
}
static void print_cons_FieldDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_FieldDec_1_1(arg);
}
}
static void print_cons_FieldDec_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_FieldDec_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_VarDec1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_VarDec2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("=");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_ArrayVarDecId (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ArrayVarDecId_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
}
static void print_cons_ArrayVarDecId_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ClassDec (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_ClassBody (ATerm tree)
{
push_box(V, 0, 0, 1);
{
print_string("{");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ClassBody_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
pop_box();
print_string("}");
}
static void print_cons_ClassBody_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ClassDecHead (ATerm tree)
{
push_box(H, 0, 0, 1);
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ClassDecHead_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string("class");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ClassDecHead_3(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 3, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 3);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ClassDecHead_4(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 4, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 4);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ClassDecHead_5(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 5, "a Some(1) or a None(0)");
}
}
pop_box();
}
static void print_cons_ClassDecHead_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print_cons_ClassDecHead_1_1(arg);
}
}
static void print_cons_ClassDecHead_1_1 (ATerm tree)
{
if((ATgetAFun(tree) == AltFun))
{
ATerm arg = ATgetArgument(tree, 0);
int n;
if((ATgetType(arg) != AT_INT))
return(unexpected(tree, 1, "an integer"));
n = ATgetInt((ATermInt) arg);
arg = ATgetArgument(tree, 1);
if((ATgetType(arg) != AT_LIST))
unexpected(tree, 2, "a list");
if(ATisEmpty((ATermList) arg))
unexpected(tree, 2, "a non empty list");
{
ATerm tree = ATgetFirst((ATermList) arg);
if((n == 1))
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
else
if((n == 2))
{
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
else
{
ATfprintf(stderr, "Too big alt parameter in %a\n", tree);
exit(1);
}
}
}
else
print(tree);
}
static void print_cons_ClassDecHead_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ClassDecHead_4 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ClassDecHead_5 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_SuperDec (ATerm tree)
{
print_string("extends");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ImplementsDec (ATerm tree)
{
push_box(V, 0, 0, 1);
{
push_box(H, 0, 0, 1);
{
print_string("implements");
}
pop_box();
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_ImplementsDec_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
pop_box();
}
static void print_cons_ImplementsDec_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_CompilationUnit (ATerm tree)
{
push_box(V, 0, 0, 1);
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_CompilationUnit_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_CompilationUnit_2((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 2, "a list");
}
{
ATerm arg = ATgetArgument(tree, 2);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_CompilationUnit_3((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 3, "a list");
}
}
pop_box();
}
static void print_cons_CompilationUnit_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_CompilationUnit_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_CompilationUnit_3 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_PackageName (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_PackageName_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
static void print_cons_PackageName_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
}
static void print_cons_AmbName1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_AmbName2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_TypeName1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_TypeName2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_ExprName1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ExprName2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_MethodName1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_MethodName2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_PackageOrTypeName1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_PackageOrTypeName2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
}
static void print_cons_TypeArgs (ATerm tree)
{
print_string("<");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_TypeArgs_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string(">");
}
static void print_cons_TypeArgs_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_Wildcard (ATerm tree)
{
print_string("?");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_Wildcard_1(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 1, "a Some(1) or a None(0)");
}
}
static void print_cons_Wildcard_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_WildcardUpperBound (ATerm tree)
{
print_string("extends");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_WildcardLowerBound (ATerm tree)
{
print_string("super");
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_TypeParam (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_TypeParam_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
}
static void print_cons_TypeParam_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_TypeBound (ATerm tree)
{
push_box(V, 0, 0, 1);
{
push_box(H, 0, 0, 1);
{
print_string("extends");
}
pop_box();
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_TypeBound_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
}
pop_box();
}
static void print_cons_TypeBound_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("&");
}
static void print_cons_TypeParams (ATerm tree)
{
print_string("<");
{
ATerm arg = ATgetArgument(tree, 0);
if((ATgetType(arg) == AT_LIST))
{
ATermList l = (ATermList) arg;
while ( (ATgetLength(l) > 1) )
{
print_cons_TypeParams_1((ATerm) l);
l = ATgetNext(l);
}
if(!(ATisEmpty(l)))
print(ATgetFirst(l));
}
else
unexpected(tree, 1, "a list");
}
print_string(">");
}
static void print_cons_TypeParams_1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string(",");
}
static void print_cons_ClassOrInterfaceType (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ClassOrInterfaceType_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
}
static void print_cons_ClassOrInterfaceType_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ClassType (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_ClassType_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
}
static void print_cons_ClassType_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_InterfaceType (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
if((ATgetAFun(arg) == SomeFun))
{
print_cons_InterfaceType_2(arg);
}
else
if((ATgetAFun(arg) != NoneFun))
unexpected(tree, 2, "a Some(1) or a None(0)");
}
}
static void print_cons_InterfaceType_2 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Member (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
{
ATerm arg = ATgetArgument(tree, 1);
print(arg);
}
print_string(".");
{
ATerm arg = ATgetArgument(tree, 2);
print(arg);
}
}
static void print_cons_TypeVar (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_ArrayType (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
print_string("[");
print_string("]");
}
static void print_cons_Boolean (ATerm tree)
{
print_string("boolean");
}
static void print_cons_Byte (ATerm tree)
{
print_string("byte");
}
static void print_cons_Short (ATerm tree)
{
print_string("short");
}
static void print_cons_Int (ATerm tree)
{
print_string("int");
}
static void print_cons_Long (ATerm tree)
{
print_string("long");
}
static void print_cons_Char (ATerm tree)
{
print_string("char");
}
static void print_cons_Float0 (ATerm tree)
{
print_string("float");
}
static void print_cons_Double (ATerm tree)
{
print_string("double");
}
static void print_cons_Null (ATerm tree)
{
print_string("null");
}
static void print_cons_Bool (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_True (ATerm tree)
{
print_string("true");
}
static void print_cons_False (ATerm tree)
{
print_string("false");
}
static void print_cons_Float1 (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Deci (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Hexa (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Octa (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print_cons_Public (ATerm tree)
{
print_string("public");
}
static void print_cons_Private (ATerm tree)
{
print_string("private");
}
static void print_cons_Protected (ATerm tree)
{
print_string("protected");
}
static void print_cons_Abstract (ATerm tree)
{
print_string("abstract");
}
static void print_cons_Final (ATerm tree)
{
print_string("final");
}
static void print_cons_Static (ATerm tree)
{
print_string("static");
}
static void print_cons_Native (ATerm tree)
{
print_string("native");
}
static void print_cons_Transient (ATerm tree)
{
print_string("transient");
}
static void print_cons_Volatile (ATerm tree)
{
print_string("volatile");
}
static void print_cons_Synchronized0 (ATerm tree)
{
print_string("synchronized");
}
static void print_cons_StrictFP (ATerm tree)
{
print_string("strictfp");
}
static void print_cons_Id (ATerm tree)
{
{
ATerm arg = ATgetArgument(tree, 0);
print(arg);
}
}
static void print (ATerm tree)
{
if((ATgetType(tree) == AT_BLOB))
{
print_string((char*) ATgetBlobData((ATermBlob) tree));
}
else
if((ATgetType(tree) == AT_REAL))
print_real(ATgetReal((ATermReal) tree));
else
if((ATgetType(tree) == AT_LIST))
{
ATermList l = (ATermList) tree;
while ( !(ATisEmpty(l)) )
{
ATerm elt = ATgetFirst(l);
print(elt);
l = ATgetNext(l);
}
}
else
if((ATgetType(tree) == AT_INT))
print_int(ATgetInt((ATermInt) tree));
else
{
AFun cons = ATgetAFun(tree);
if((ATisQuoted(cons) && (ATgetArity(cons) == 0)))
print_string(ATgetName(cons));
else
if((cons == AmbFun))
{
ATerm a = ATgetArgument(tree, 0);
if((ATgetType(a) == AT_LIST))
{
ATermList l = (ATermList) a;
if(ATisEmpty(l))
unexpected(tree, 1, "a non empty list");
else
{
ATerm elt = ATgetFirst(l);
print(elt);
}
}
else
unexpected(tree, 1, "a list");
}
else
if((cons == var_cons_Parenthetical))
print_cons_Parenthetical(tree);
else
if((cons == var_cons_String))
print_cons_String(tree);
else
if((cons == var_cons_Chars))
print_cons_Chars(tree);
else
if((cons == var_cons_None))
print_cons_None(tree);
else
if((cons == var_cons_Some))
print_cons_Some(tree);
else
if((cons == var_cons_NamedEscape))
print_cons_NamedEscape(tree);
else
if((cons == var_cons_OctaEscape1))
print_cons_OctaEscape1(tree);
else
if((cons == var_cons_OctaEscape2))
print_cons_OctaEscape2(tree);
else
if((cons == var_cons_OctaEscape3))
print_cons_OctaEscape3(tree);
else
if((cons == var_cons_Assign))
print_cons_Assign(tree);
else
if((cons == var_cons_AssignMul))
print_cons_AssignMul(tree);
else
if((cons == var_cons_AssignDiv))
print_cons_AssignDiv(tree);
else
if((cons == var_cons_AssignRemain))
print_cons_AssignRemain(tree);
else
if((cons == var_cons_AssignPlus))
print_cons_AssignPlus(tree);
else
if((cons == var_cons_AssignMinus))
print_cons_AssignMinus(tree);
else
if((cons == var_cons_AssignLeftShift))
print_cons_AssignLeftShift(tree);
else
if((cons == var_cons_AssignRightShift))
print_cons_AssignRightShift(tree);
else
if((cons == var_cons_AssignURightShift))
print_cons_AssignURightShift(tree);
else
if((cons == var_cons_AssignAnd))
print_cons_AssignAnd(tree);
else
if((cons == var_cons_AssignExcOr))
print_cons_AssignExcOr(tree);
else
if((cons == var_cons_AssignOr))
print_cons_AssignOr(tree);
else
if((cons == var_cons_InstanceOf))
print_cons_InstanceOf(tree);
else
if((cons == var_cons_Mul))
print_cons_Mul(tree);
else
if((cons == var_cons_Div))
print_cons_Div(tree);
else
if((cons == var_cons_Remain))
print_cons_Remain(tree);
else
if((cons == var_cons_Plus2))
print_cons_Plus2(tree);
else
if((cons == var_cons_Minus2))
print_cons_Minus2(tree);
else
if((cons == var_cons_LeftShift))
print_cons_LeftShift(tree);
else
if((cons == var_cons_RightShift))
print_cons_RightShift(tree);
else
if((cons == var_cons_URightShift))
print_cons_URightShift(tree);
else
if((cons == var_cons_Lt))
print_cons_Lt(tree);
else
if((cons == var_cons_Gt))
print_cons_Gt(tree);
else
if((cons == var_cons_LtEq))
print_cons_LtEq(tree);
else
if((cons == var_cons_GtEq))
print_cons_GtEq(tree);
else
if((cons == var_cons_Eq))
print_cons_Eq(tree);
else
if((cons == var_cons_NotEq))
print_cons_NotEq(tree);
else
if((cons == var_cons_LazyAnd))
print_cons_LazyAnd(tree);
else
if((cons == var_cons_LazyOr))
print_cons_LazyOr(tree);
else
if((cons == var_cons_And))
print_cons_And(tree);
else
if((cons == var_cons_ExcOr))
print_cons_ExcOr(tree);
else
if((cons == var_cons_Or))
print_cons_Or(tree);
else
if((cons == var_cons_Cond))
print_cons_Cond(tree);
else
if((cons == var_cons_Plus1))
print_cons_Plus1(tree);
else
if((cons == var_cons_Minus1))
print_cons_Minus1(tree);
else
if((cons == var_cons_PreIncr))
print_cons_PreIncr(tree);
else
if((cons == var_cons_PreDecr))
print_cons_PreDecr(tree);
else
if((cons == var_cons_Complement))
print_cons_Complement(tree);
else
if((cons == var_cons_Not))
print_cons_Not(tree);
else
if((cons == var_cons_CastPrim))
print_cons_CastPrim(tree);
else
if((cons == var_cons_CastRef))
print_cons_CastRef(tree);
else
if((cons == var_cons_PostIncr))
print_cons_PostIncr(tree);
else
if((cons == var_cons_PostDecr))
print_cons_PostDecr(tree);
else
if((cons == var_cons_Invoke))
print_cons_Invoke(tree);
else
if((cons == var_cons_Method1))
print_cons_Method1(tree);
else
if((cons == var_cons_Method3))
print_cons_Method3(tree);
else
if((cons == var_cons_SuperMethod))
print_cons_SuperMethod(tree);
else
if((cons == var_cons_QSuperMethod))
print_cons_QSuperMethod(tree);
else
if((cons == var_cons_GenericMethod))
print_cons_GenericMethod(tree);
else
if((cons == var_cons_ArrayAccess))
print_cons_ArrayAccess(tree);
else
if((cons == var_cons_Field))
print_cons_Field(tree);
else
if((cons == var_cons_SuperField))
print_cons_SuperField(tree);
else
if((cons == var_cons_QSuperField))
print_cons_QSuperField(tree);
else
if((cons == var_cons_NewArray))
print_cons_NewArray(tree);
else
if((cons == var_cons_UnboundWld))
print_cons_UnboundWld(tree);
else
if((cons == var_cons_Dim1))
print_cons_Dim1(tree);
else
if((cons == var_cons_Dim0))
print_cons_Dim0(tree);
else
if((cons == var_cons_NewInstance))
print_cons_NewInstance(tree);
else
if((cons == var_cons_QNewInstance))
print_cons_QNewInstance(tree);
else
if((cons == var_cons_Lit))
print_cons_Lit(tree);
else
if((cons == var_cons_Class))
print_cons_Class(tree);
else
if((cons == var_cons_VoidClass))
print_cons_VoidClass(tree);
else
if((cons == var_cons_This))
print_cons_This(tree);
else
if((cons == var_cons_QThis))
print_cons_QThis(tree);
else
if((cons == var_cons_PackageDec))
print_cons_PackageDec(tree);
else
if((cons == var_cons_TypeImportDec))
print_cons_TypeImportDec(tree);
else
if((cons == var_cons_TypeImportOnDemandDec))
print_cons_TypeImportOnDemandDec(tree);
else
if((cons == var_cons_StaticImportDec))
print_cons_StaticImportDec(tree);
else
if((cons == var_cons_StaticImportOnDemandDec))
print_cons_StaticImportOnDemandDec(tree);
else
if((cons == var_cons_AnnoDec))
print_cons_AnnoDec(tree);
else
if((cons == var_cons_AnnoDecHead))
print_cons_AnnoDecHead(tree);
else
if((cons == var_cons_AnnoMethodDec))
print_cons_AnnoMethodDec(tree);
else
if((cons == var_cons_Semicolon))
print_cons_Semicolon(tree);
else
if((cons == var_cons_DefaultVal))
print_cons_DefaultVal(tree);
else
if((cons == var_cons_AbstractMethodDec))
print_cons_AbstractMethodDec(tree);
else
if((cons == var_cons_DeprAbstractMethodDec))
print_cons_DeprAbstractMethodDec(tree);
else
if((cons == var_cons_ConstantDec))
print_cons_ConstantDec(tree);
else
if((cons == var_cons_InterfaceDec))
print_cons_InterfaceDec(tree);
else
if((cons == var_cons_InterfaceDecHead))
print_cons_InterfaceDecHead(tree);
else
if((cons == var_cons_ExtendsInterfaces))
print_cons_ExtendsInterfaces(tree);
else
if((cons == var_cons_EnumDec))
print_cons_EnumDec(tree);
else
if((cons == var_cons_EnumDecHead))
print_cons_EnumDecHead(tree);
else
if((cons == var_cons_EnumBody))
print_cons_EnumBody(tree);
else
if((cons == var_cons_EnumConst))
print_cons_EnumConst(tree);
else
if((cons == var_cons_EnumBodyDecs))
print_cons_EnumBodyDecs(tree);
else
if((cons == var_cons_ConstrDec))
print_cons_ConstrDec(tree);
else
if((cons == var_cons_ConstrDecHead))
print_cons_ConstrDecHead(tree);
else
if((cons == var_cons_ConstrBody))
print_cons_ConstrBody(tree);
else
if((cons == var_cons_AltConstrInv))
print_cons_AltConstrInv(tree);
else
if((cons == var_cons_SuperConstrInv))
print_cons_SuperConstrInv(tree);
else
if((cons == var_cons_QSuperConstrInv))
print_cons_QSuperConstrInv(tree);
else
if((cons == var_cons_StaticInit))
print_cons_StaticInit(tree);
else
if((cons == var_cons_InstanceInit))
print_cons_InstanceInit(tree);
else
if((cons == var_cons_Empty))
print_cons_Empty(tree);
else
if((cons == var_cons_Labeled))
print_cons_Labeled(tree);
else
if((cons == var_cons_ExprStm))
print_cons_ExprStm(tree);
else
if((cons == var_cons_If2))
print_cons_If2(tree);
else
if((cons == var_cons_If3))
print_cons_If3(tree);
else
if((cons == var_cons_AssertStm1))
print_cons_AssertStm1(tree);
else
if((cons == var_cons_AssertStm2))
print_cons_AssertStm2(tree);
else
if((cons == var_cons_Switch))
print_cons_Switch(tree);
else
if((cons == var_cons_SwitchBlock))
print_cons_SwitchBlock(tree);
else
if((cons == var_cons_SwitchGroup))
print_cons_SwitchGroup(tree);
else
if((cons == var_cons_Case))
print_cons_Case(tree);
else
if((cons == var_cons_Default))
print_cons_Default(tree);
else
if((cons == var_cons_While))
print_cons_While(tree);
else
if((cons == var_cons_DoWhile))
print_cons_DoWhile(tree);
else
if((cons == var_cons_For))
print_cons_For(tree);
else
if((cons == var_cons_ForEach))
print_cons_ForEach(tree);
else
if((cons == var_cons_Break))
print_cons_Break(tree);
else
if((cons == var_cons_Continue))
print_cons_Continue(tree);
else
if((cons == var_cons_Return))
print_cons_Return(tree);
else
if((cons == var_cons_Throw))
print_cons_Throw(tree);
else
if((cons == var_cons_Synchronized2))
print_cons_Synchronized2(tree);
else
if((cons == var_cons_Try2))
print_cons_Try2(tree);
else
if((cons == var_cons_Try3))
print_cons_Try3(tree);
else
if((cons == var_cons_Catch))
print_cons_Catch(tree);
else
if((cons == var_cons_LocalVarDecStm))
print_cons_LocalVarDecStm(tree);
else
if((cons == var_cons_LocalVarDec))
print_cons_LocalVarDec(tree);
else
if((cons == var_cons_Block))
print_cons_Block(tree);
else
if((cons == var_cons_ClassDecStm))
print_cons_ClassDecStm(tree);
else
if((cons == var_cons_MethodDec))
print_cons_MethodDec(tree);
else
if((cons == var_cons_MethodDecHead))
print_cons_MethodDecHead(tree);
else
if((cons == var_cons_DeprMethodDecHead))
print_cons_DeprMethodDecHead(tree);
else
if((cons == var_cons_Void))
print_cons_Void(tree);
else
if((cons == var_cons_Param))
print_cons_Param(tree);
else
if((cons == var_cons_VarArityParam))
print_cons_VarArityParam(tree);
else
if((cons == var_cons_ThrowsDec))
print_cons_ThrowsDec(tree);
else
if((cons == var_cons_NoMethodBody))
print_cons_NoMethodBody(tree);
else
if((cons == var_cons_ArrayInit))
print_cons_ArrayInit(tree);
else
if((cons == var_cons_Anno))
print_cons_Anno(tree);
else
if((cons == var_cons_SingleElemAnno))
print_cons_SingleElemAnno(tree);
else
if((cons == var_cons_MarkerAnno))
print_cons_MarkerAnno(tree);
else
if((cons == var_cons_ElemValPair))
print_cons_ElemValPair(tree);
else
if((cons == var_cons_ElemValArrayInit))
print_cons_ElemValArrayInit(tree);
else
if((cons == var_cons_FieldDec))
print_cons_FieldDec(tree);
else
if((cons == var_cons_VarDec1))
print_cons_VarDec1(tree);
else
if((cons == var_cons_VarDec2))
print_cons_VarDec2(tree);
else
if((cons == var_cons_ArrayVarDecId))
print_cons_ArrayVarDecId(tree);
else
if((cons == var_cons_ClassDec))
print_cons_ClassDec(tree);
else
if((cons == var_cons_ClassBody))
print_cons_ClassBody(tree);
else
if((cons == var_cons_ClassDecHead))
print_cons_ClassDecHead(tree);
else
if((cons == var_cons_SuperDec))
print_cons_SuperDec(tree);
else
if((cons == var_cons_ImplementsDec))
print_cons_ImplementsDec(tree);
else
if((cons == var_cons_CompilationUnit))
print_cons_CompilationUnit(tree);
else
if((cons == var_cons_PackageName))
print_cons_PackageName(tree);
else
if((cons == var_cons_AmbName1))
print_cons_AmbName1(tree);
else
if((cons == var_cons_AmbName2))
print_cons_AmbName2(tree);
else
if((cons == var_cons_TypeName1))
print_cons_TypeName1(tree);
else
if((cons == var_cons_TypeName2))
print_cons_TypeName2(tree);
else
if((cons == var_cons_ExprName1))
print_cons_ExprName1(tree);
else
if((cons == var_cons_ExprName2))
print_cons_ExprName2(tree);
else
if((cons == var_cons_MethodName1))
print_cons_MethodName1(tree);
else
if((cons == var_cons_MethodName2))
print_cons_MethodName2(tree);
else
if((cons == var_cons_PackageOrTypeName1))
print_cons_PackageOrTypeName1(tree);
else
if((cons == var_cons_PackageOrTypeName2))
print_cons_PackageOrTypeName2(tree);
else
if((cons == var_cons_TypeArgs))
print_cons_TypeArgs(tree);
else
if((cons == var_cons_Wildcard))
print_cons_Wildcard(tree);
else
if((cons == var_cons_WildcardUpperBound))
print_cons_WildcardUpperBound(tree);
else
if((cons == var_cons_WildcardLowerBound))
print_cons_WildcardLowerBound(tree);
else
if((cons == var_cons_TypeParam))
print_cons_TypeParam(tree);
else
if((cons == var_cons_TypeBound))
print_cons_TypeBound(tree);
else
if((cons == var_cons_TypeParams))
print_cons_TypeParams(tree);
else
if((cons == var_cons_ClassOrInterfaceType))
print_cons_ClassOrInterfaceType(tree);
else
if((cons == var_cons_ClassType))
print_cons_ClassType(tree);
else
if((cons == var_cons_InterfaceType))
print_cons_InterfaceType(tree);
else
if((cons == var_cons_Member))
print_cons_Member(tree);
else
if((cons == var_cons_TypeVar))
print_cons_TypeVar(tree);
else
if((cons == var_cons_ArrayType))
print_cons_ArrayType(tree);
else
if((cons == var_cons_Boolean))
print_cons_Boolean(tree);
else
if((cons == var_cons_Byte))
print_cons_Byte(tree);
else
if((cons == var_cons_Short))
print_cons_Short(tree);
else
if((cons == var_cons_Int))
print_cons_Int(tree);
else
if((cons == var_cons_Long))
print_cons_Long(tree);
else
if((cons == var_cons_Char))
print_cons_Char(tree);
else
if((cons == var_cons_Float0))
print_cons_Float0(tree);
else
if((cons == var_cons_Double))
print_cons_Double(tree);
else
if((cons == var_cons_Null))
print_cons_Null(tree);
else
if((cons == var_cons_Bool))
print_cons_Bool(tree);
else
if((cons == var_cons_True))
print_cons_True(tree);
else
if((cons == var_cons_False))
print_cons_False(tree);
else
if((cons == var_cons_Float1))
print_cons_Float1(tree);
else
if((cons == var_cons_Deci))
print_cons_Deci(tree);
else
if((cons == var_cons_Hexa))
print_cons_Hexa(tree);
else
if((cons == var_cons_Octa))
print_cons_Octa(tree);
else
if((cons == var_cons_Public))
print_cons_Public(tree);
else
if((cons == var_cons_Private))
print_cons_Private(tree);
else
if((cons == var_cons_Protected))
print_cons_Protected(tree);
else
if((cons == var_cons_Abstract))
print_cons_Abstract(tree);
else
if((cons == var_cons_Final))
print_cons_Final(tree);
else
if((cons == var_cons_Static))
print_cons_Static(tree);
else
if((cons == var_cons_Native))
print_cons_Native(tree);
else
if((cons == var_cons_Transient))
print_cons_Transient(tree);
else
if((cons == var_cons_Volatile))
print_cons_Volatile(tree);
else
if((cons == var_cons_Synchronized0))
print_cons_Synchronized0(tree);
else
if((cons == var_cons_StrictFP))
print_cons_StrictFP(tree);
else
if((cons == var_cons_Id))
print_cons_Id(tree);
else
{
ATfprintf(stderr, "Unknown constructor: %a\n", cons);
exit(1);
}
}
}
ATerm pp_java_0_0 (StrSL sl, ATerm t)
{
ATerm out;
static int was_init = 0;
if(!(was_init))
{
init();
was_init = 1;
}
init_stack();
out = xtc_new_file_0_0(NULL, t);
if((out == NULL))
return(NULL);
stream = fopen(ATgetName(ATgetAFun(out)), "w");
if((stream == NULL))
return(NULL);
print(t);
print_string("\n");
fclose(stream);
return(ATmake("FILE(<term>)", out));
}
