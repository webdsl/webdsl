#include <srts/stratego.h>
#include <stratego-lib/stratego-lib.h>
void init_constructors (void)
{
}
static Symbol sym_Id_1;
static Symbol sym_Public_0;
static Symbol sym_Private_0;
static Symbol sym_Protected_0;
static Symbol sym_Final_0;
static Symbol sym_Static_0;
static Symbol sym_String_1;
static Symbol sym_Chars_1;
static Symbol sym_Int_0;
static Symbol sym_PackageName_1;
static Symbol sym_AmbName_1;
static Symbol sym_AmbName_2;
static Symbol sym_TypeName_1;
static Symbol sym_ExprName_1;
static Symbol sym_ExprName_2;
static Symbol sym_MethodName_2;
static Symbol sym_TypeArgs_1;
static Symbol sym_ClassOrInterfaceType_2;
static Symbol sym_Lit_1;
static Symbol sym_This_0;
static Symbol sym_NewInstance_4;
static Symbol sym_Invoke_2;
static Symbol sym_Plus_2;
static Symbol sym_Assign_2;
static Symbol sym_FieldDec_3;
static Symbol sym_VarDec_1;
static Symbol sym_VarDec_2;
static Symbol sym_ExprStm_1;
static Symbol sym_Return_1;
static Symbol sym_Throw_1;
static Symbol sym_Try_2;
static Symbol sym_Block_1;
static Symbol sym_MethodDec_2;
static Symbol sym_MethodDecHead_6;
static Symbol sym_Void_0;
static Symbol sym_Param_3;
static Symbol sym_StaticInit_1;
static Symbol sym_ConstrDec_2;
static Symbol sym_ConstrDecHead_5;
static Symbol sym_ConstrBody_2;
static Symbol sym_ClassDec_2;
static Symbol sym_ClassBody_1;
static Symbol sym_ClassDecHead_5;
static Symbol sym_Field_2;
static Symbol sym_Method_1;
static Symbol sym_Method_3;
static Symbol sym_MarkerAnno_1;
static Symbol sym_ElemValPair_2;
static Symbol sym_ElemValArrayInit_1;
static Symbol sym_PackageDec_2;
static Symbol sym_TypeImportOnDemandDec_1;
static Symbol sym_CompilationUnit_3;
static Symbol sym_Domain_2;
static Symbol sym_ConceptDecl_2;
static Symbol sym_Concept_2;
static Symbol sym_SimpleConcept_1;
static Symbol sym_CollectionConcept_1;
static Symbol sym_SimpleAnnotation_1;
static Symbol sym_ParameterizedAnnotation_2;
static Symbol sym_GNU__LGPL_2;
static Symbol sym_CurrentXTCRepository_0;
static Symbol sym_DefaultXTCRepository_0;
static Symbol sym_Config_1;
static Symbol sym_AutoProgram_0;
static Symbol sym_AutoReportBugs_0;
static Symbol sym_WebHome_1;
static Symbol sym_Person_2;
static Symbol sym_Author_1;
static Symbol sym_OptionUsage_0;
static Symbol sym_Summary_1;
static Symbol sym_Usage_1;
static Symbol sym_FILE_1;
static Symbol sym__4;
static Symbol sym__3;
static Symbol sym__2;
static Symbol sym_DR__DUMMY_0;
static Symbol sym_Catch_2;
static Symbol sym_Anno_2;
static Symbol sym_Nil_0;
static Symbol sym_Cons_2;
static Symbol sym_None_0;
static Symbol sym_Some_1;
static Symbol sym_QName_2;
static Symbol sym_Prefix_1;
static Symbol sym_Prologue_3;
static Symbol sym_Epilogue_1;
static Symbol sym_XMLDecl_3;
static Symbol sym_VersionDecl_1;
static Symbol sym_Version_1;
static Symbol sym_Text_1;
static Symbol sym_Attribute_2;
static Symbol sym_DoubleQuoted_1;
static Symbol sym_Literal_1;
static Symbol sym_Document_3;
static Symbol sym_EmptyElement_2;
static Symbol sym_Element_4;
static Symbol sym_CollectionType_1;
static Symbol sym_ConceptType_1;
static Symbol sym_NativeType_1;
static void init_module_constructors (void)
{
sym_Id_1 = ATmakeSymbol("Id", 1, ATfalse);
ATprotectSymbol(sym_Id_1);
sym_Public_0 = ATmakeSymbol("Public", 0, ATfalse);
ATprotectSymbol(sym_Public_0);
sym_Private_0 = ATmakeSymbol("Private", 0, ATfalse);
ATprotectSymbol(sym_Private_0);
sym_Protected_0 = ATmakeSymbol("Protected", 0, ATfalse);
ATprotectSymbol(sym_Protected_0);
sym_Final_0 = ATmakeSymbol("Final", 0, ATfalse);
ATprotectSymbol(sym_Final_0);
sym_Static_0 = ATmakeSymbol("Static", 0, ATfalse);
ATprotectSymbol(sym_Static_0);
sym_String_1 = ATmakeSymbol("String", 1, ATfalse);
ATprotectSymbol(sym_String_1);
sym_Chars_1 = ATmakeSymbol("Chars", 1, ATfalse);
ATprotectSymbol(sym_Chars_1);
sym_Int_0 = ATmakeSymbol("Int", 0, ATfalse);
ATprotectSymbol(sym_Int_0);
sym_PackageName_1 = ATmakeSymbol("PackageName", 1, ATfalse);
ATprotectSymbol(sym_PackageName_1);
sym_AmbName_1 = ATmakeSymbol("AmbName", 1, ATfalse);
ATprotectSymbol(sym_AmbName_1);
sym_AmbName_2 = ATmakeSymbol("AmbName", 2, ATfalse);
ATprotectSymbol(sym_AmbName_2);
sym_TypeName_1 = ATmakeSymbol("TypeName", 1, ATfalse);
ATprotectSymbol(sym_TypeName_1);
sym_ExprName_1 = ATmakeSymbol("ExprName", 1, ATfalse);
ATprotectSymbol(sym_ExprName_1);
sym_ExprName_2 = ATmakeSymbol("ExprName", 2, ATfalse);
ATprotectSymbol(sym_ExprName_2);
sym_MethodName_2 = ATmakeSymbol("MethodName", 2, ATfalse);
ATprotectSymbol(sym_MethodName_2);
sym_TypeArgs_1 = ATmakeSymbol("TypeArgs", 1, ATfalse);
ATprotectSymbol(sym_TypeArgs_1);
sym_ClassOrInterfaceType_2 = ATmakeSymbol("ClassOrInterfaceType", 2, ATfalse);
ATprotectSymbol(sym_ClassOrInterfaceType_2);
sym_Lit_1 = ATmakeSymbol("Lit", 1, ATfalse);
ATprotectSymbol(sym_Lit_1);
sym_This_0 = ATmakeSymbol("This", 0, ATfalse);
ATprotectSymbol(sym_This_0);
sym_NewInstance_4 = ATmakeSymbol("NewInstance", 4, ATfalse);
ATprotectSymbol(sym_NewInstance_4);
sym_Invoke_2 = ATmakeSymbol("Invoke", 2, ATfalse);
ATprotectSymbol(sym_Invoke_2);
sym_Plus_2 = ATmakeSymbol("Plus", 2, ATfalse);
ATprotectSymbol(sym_Plus_2);
sym_Assign_2 = ATmakeSymbol("Assign", 2, ATfalse);
ATprotectSymbol(sym_Assign_2);
sym_FieldDec_3 = ATmakeSymbol("FieldDec", 3, ATfalse);
ATprotectSymbol(sym_FieldDec_3);
sym_VarDec_1 = ATmakeSymbol("VarDec", 1, ATfalse);
ATprotectSymbol(sym_VarDec_1);
sym_VarDec_2 = ATmakeSymbol("VarDec", 2, ATfalse);
ATprotectSymbol(sym_VarDec_2);
sym_ExprStm_1 = ATmakeSymbol("ExprStm", 1, ATfalse);
ATprotectSymbol(sym_ExprStm_1);
sym_Return_1 = ATmakeSymbol("Return", 1, ATfalse);
ATprotectSymbol(sym_Return_1);
sym_Throw_1 = ATmakeSymbol("Throw", 1, ATfalse);
ATprotectSymbol(sym_Throw_1);
sym_Try_2 = ATmakeSymbol("Try", 2, ATfalse);
ATprotectSymbol(sym_Try_2);
sym_Block_1 = ATmakeSymbol("Block", 1, ATfalse);
ATprotectSymbol(sym_Block_1);
sym_MethodDec_2 = ATmakeSymbol("MethodDec", 2, ATfalse);
ATprotectSymbol(sym_MethodDec_2);
sym_MethodDecHead_6 = ATmakeSymbol("MethodDecHead", 6, ATfalse);
ATprotectSymbol(sym_MethodDecHead_6);
sym_Void_0 = ATmakeSymbol("Void", 0, ATfalse);
ATprotectSymbol(sym_Void_0);
sym_Param_3 = ATmakeSymbol("Param", 3, ATfalse);
ATprotectSymbol(sym_Param_3);
sym_StaticInit_1 = ATmakeSymbol("StaticInit", 1, ATfalse);
ATprotectSymbol(sym_StaticInit_1);
sym_ConstrDec_2 = ATmakeSymbol("ConstrDec", 2, ATfalse);
ATprotectSymbol(sym_ConstrDec_2);
sym_ConstrDecHead_5 = ATmakeSymbol("ConstrDecHead", 5, ATfalse);
ATprotectSymbol(sym_ConstrDecHead_5);
sym_ConstrBody_2 = ATmakeSymbol("ConstrBody", 2, ATfalse);
ATprotectSymbol(sym_ConstrBody_2);
sym_ClassDec_2 = ATmakeSymbol("ClassDec", 2, ATfalse);
ATprotectSymbol(sym_ClassDec_2);
sym_ClassBody_1 = ATmakeSymbol("ClassBody", 1, ATfalse);
ATprotectSymbol(sym_ClassBody_1);
sym_ClassDecHead_5 = ATmakeSymbol("ClassDecHead", 5, ATfalse);
ATprotectSymbol(sym_ClassDecHead_5);
sym_Field_2 = ATmakeSymbol("Field", 2, ATfalse);
ATprotectSymbol(sym_Field_2);
sym_Method_1 = ATmakeSymbol("Method", 1, ATfalse);
ATprotectSymbol(sym_Method_1);
sym_Method_3 = ATmakeSymbol("Method", 3, ATfalse);
ATprotectSymbol(sym_Method_3);
sym_MarkerAnno_1 = ATmakeSymbol("MarkerAnno", 1, ATfalse);
ATprotectSymbol(sym_MarkerAnno_1);
sym_ElemValPair_2 = ATmakeSymbol("ElemValPair", 2, ATfalse);
ATprotectSymbol(sym_ElemValPair_2);
sym_ElemValArrayInit_1 = ATmakeSymbol("ElemValArrayInit", 1, ATfalse);
ATprotectSymbol(sym_ElemValArrayInit_1);
sym_PackageDec_2 = ATmakeSymbol("PackageDec", 2, ATfalse);
ATprotectSymbol(sym_PackageDec_2);
sym_TypeImportOnDemandDec_1 = ATmakeSymbol("TypeImportOnDemandDec", 1, ATfalse);
ATprotectSymbol(sym_TypeImportOnDemandDec_1);
sym_CompilationUnit_3 = ATmakeSymbol("CompilationUnit", 3, ATfalse);
ATprotectSymbol(sym_CompilationUnit_3);
sym_Domain_2 = ATmakeSymbol("Domain", 2, ATfalse);
ATprotectSymbol(sym_Domain_2);
sym_ConceptDecl_2 = ATmakeSymbol("ConceptDecl", 2, ATfalse);
ATprotectSymbol(sym_ConceptDecl_2);
sym_Concept_2 = ATmakeSymbol("Concept", 2, ATfalse);
ATprotectSymbol(sym_Concept_2);
sym_SimpleConcept_1 = ATmakeSymbol("SimpleConcept", 1, ATfalse);
ATprotectSymbol(sym_SimpleConcept_1);
sym_CollectionConcept_1 = ATmakeSymbol("CollectionConcept", 1, ATfalse);
ATprotectSymbol(sym_CollectionConcept_1);
sym_SimpleAnnotation_1 = ATmakeSymbol("SimpleAnnotation", 1, ATfalse);
ATprotectSymbol(sym_SimpleAnnotation_1);
sym_ParameterizedAnnotation_2 = ATmakeSymbol("ParameterizedAnnotation", 2, ATfalse);
ATprotectSymbol(sym_ParameterizedAnnotation_2);
sym_GNU__LGPL_2 = ATmakeSymbol("GNU_LGPL", 2, ATfalse);
ATprotectSymbol(sym_GNU__LGPL_2);
sym_CurrentXTCRepository_0 = ATmakeSymbol("CurrentXTCRepository", 0, ATfalse);
ATprotectSymbol(sym_CurrentXTCRepository_0);
sym_DefaultXTCRepository_0 = ATmakeSymbol("DefaultXTCRepository", 0, ATfalse);
ATprotectSymbol(sym_DefaultXTCRepository_0);
sym_Config_1 = ATmakeSymbol("Config", 1, ATfalse);
ATprotectSymbol(sym_Config_1);
sym_AutoProgram_0 = ATmakeSymbol("AutoProgram", 0, ATfalse);
ATprotectSymbol(sym_AutoProgram_0);
sym_AutoReportBugs_0 = ATmakeSymbol("AutoReportBugs", 0, ATfalse);
ATprotectSymbol(sym_AutoReportBugs_0);
sym_WebHome_1 = ATmakeSymbol("WebHome", 1, ATfalse);
ATprotectSymbol(sym_WebHome_1);
sym_Person_2 = ATmakeSymbol("Person", 2, ATfalse);
ATprotectSymbol(sym_Person_2);
sym_Author_1 = ATmakeSymbol("Author", 1, ATfalse);
ATprotectSymbol(sym_Author_1);
sym_OptionUsage_0 = ATmakeSymbol("OptionUsage", 0, ATfalse);
ATprotectSymbol(sym_OptionUsage_0);
sym_Summary_1 = ATmakeSymbol("Summary", 1, ATfalse);
ATprotectSymbol(sym_Summary_1);
sym_Usage_1 = ATmakeSymbol("Usage", 1, ATfalse);
ATprotectSymbol(sym_Usage_1);
sym_FILE_1 = ATmakeSymbol("FILE", 1, ATfalse);
ATprotectSymbol(sym_FILE_1);
sym__4 = ATmakeSymbol("", 4, ATfalse);
ATprotectSymbol(sym__4);
sym__3 = ATmakeSymbol("", 3, ATfalse);
ATprotectSymbol(sym__3);
sym__2 = ATmakeSymbol("", 2, ATfalse);
ATprotectSymbol(sym__2);
sym_DR__DUMMY_0 = ATmakeSymbol("DR_DUMMY", 0, ATfalse);
ATprotectSymbol(sym_DR__DUMMY_0);
sym_Catch_2 = ATmakeSymbol("Catch", 2, ATfalse);
ATprotectSymbol(sym_Catch_2);
sym_Anno_2 = ATmakeSymbol("Anno", 2, ATfalse);
ATprotectSymbol(sym_Anno_2);
sym_Nil_0 = ATmakeSymbol("Nil", 0, ATfalse);
ATprotectSymbol(sym_Nil_0);
sym_Cons_2 = ATmakeSymbol("Cons", 2, ATfalse);
ATprotectSymbol(sym_Cons_2);
sym_None_0 = ATmakeSymbol("None", 0, ATfalse);
ATprotectSymbol(sym_None_0);
sym_Some_1 = ATmakeSymbol("Some", 1, ATfalse);
ATprotectSymbol(sym_Some_1);
sym_QName_2 = ATmakeSymbol("QName", 2, ATfalse);
ATprotectSymbol(sym_QName_2);
sym_Prefix_1 = ATmakeSymbol("Prefix", 1, ATfalse);
ATprotectSymbol(sym_Prefix_1);
sym_Prologue_3 = ATmakeSymbol("Prologue", 3, ATfalse);
ATprotectSymbol(sym_Prologue_3);
sym_Epilogue_1 = ATmakeSymbol("Epilogue", 1, ATfalse);
ATprotectSymbol(sym_Epilogue_1);
sym_XMLDecl_3 = ATmakeSymbol("XMLDecl", 3, ATfalse);
ATprotectSymbol(sym_XMLDecl_3);
sym_VersionDecl_1 = ATmakeSymbol("VersionDecl", 1, ATfalse);
ATprotectSymbol(sym_VersionDecl_1);
sym_Version_1 = ATmakeSymbol("Version", 1, ATfalse);
ATprotectSymbol(sym_Version_1);
sym_Text_1 = ATmakeSymbol("Text", 1, ATfalse);
ATprotectSymbol(sym_Text_1);
sym_Attribute_2 = ATmakeSymbol("Attribute", 2, ATfalse);
ATprotectSymbol(sym_Attribute_2);
sym_DoubleQuoted_1 = ATmakeSymbol("DoubleQuoted", 1, ATfalse);
ATprotectSymbol(sym_DoubleQuoted_1);
sym_Literal_1 = ATmakeSymbol("Literal", 1, ATfalse);
ATprotectSymbol(sym_Literal_1);
sym_Document_3 = ATmakeSymbol("Document", 3, ATfalse);
ATprotectSymbol(sym_Document_3);
sym_EmptyElement_2 = ATmakeSymbol("EmptyElement", 2, ATfalse);
ATprotectSymbol(sym_EmptyElement_2);
sym_Element_4 = ATmakeSymbol("Element", 4, ATfalse);
ATprotectSymbol(sym_Element_4);
sym_CollectionType_1 = ATmakeSymbol("CollectionType", 1, ATfalse);
ATprotectSymbol(sym_CollectionType_1);
sym_ConceptType_1 = ATmakeSymbol("ConceptType", 1, ATfalse);
ATprotectSymbol(sym_ConceptType_1);
sym_NativeType_1 = ATmakeSymbol("NativeType", 1, ATfalse);
ATprotectSymbol(sym_NativeType_1);
}
static ATerm term667;
static ATerm term666;
static ATerm term665;
static ATerm term664;
static ATerm term663;
static ATerm term662;
static ATerm term661;
static ATerm term660;
static ATerm term659;
static ATerm term658;
static ATerm term657;
static ATerm term656;
static ATerm term655;
static ATerm term654;
static ATerm term653;
static ATerm term652;
static ATerm term651;
static ATerm term650;
static ATerm term649;
static ATerm term648;
static ATerm term647;
static ATerm term646;
static ATerm term645;
static ATerm term644;
static ATerm term643;
static ATerm term642;
static ATerm term641;
static ATerm term640;
static ATerm term639;
static ATerm term638;
static ATerm term637;
static ATerm term636;
static ATerm term635;
static ATerm term634;
static ATerm term633;
static ATerm term632;
static ATerm term631;
static ATerm term630;
static ATerm term629;
static ATerm term628;
static ATerm term627;
static ATerm term626;
static ATerm term625;
static ATerm term624;
static ATerm term623;
static ATerm term622;
static ATerm term621;
static ATerm term620;
static ATerm term619;
static ATerm term618;
static ATerm term617;
static ATerm term616;
static ATerm term615;
static ATerm term614;
static ATerm term613;
static ATerm term612;
static ATerm term611;
static ATerm term610;
static ATerm term609;
static ATerm term608;
static ATerm term607;
static ATerm term606;
static ATerm term605;
static ATerm term604;
static ATerm term603;
static ATerm term602;
static ATerm term601;
static ATerm term600;
static ATerm term599;
static ATerm term598;
static ATerm term597;
static ATerm term596;
static ATerm term595;
static ATerm term594;
static ATerm term593;
static ATerm term592;
static ATerm term591;
static ATerm term590;
static ATerm term589;
static ATerm term588;
static ATerm term587;
static ATerm term586;
static ATerm term585;
static ATerm term584;
static ATerm term583;
static ATerm term582;
static ATerm term581;
static ATerm term580;
static ATerm term579;
static ATerm term578;
static ATerm term577;
static ATerm term576;
static ATerm term575;
static ATerm term574;
static ATerm term573;
static ATerm term572;
static ATerm term571;
static ATerm term570;
static ATerm term569;
static ATerm term568;
static ATerm term567;
static ATerm term566;
static ATerm term565;
static ATerm term564;
static ATerm term563;
static ATerm term562;
static ATerm term561;
static ATerm term560;
static ATerm term559;
static ATerm term558;
static ATerm term557;
static ATerm term556;
static ATerm term555;
static ATerm term554;
static ATerm term553;
static ATerm term552;
static ATerm term551;
static ATerm term550;
static ATerm term549;
static ATerm term548;
static ATerm term547;
static ATerm term546;
static ATerm term545;
static ATerm term544;
static ATerm term543;
static ATerm term542;
static ATerm term541;
static ATerm term540;
static ATerm term539;
static ATerm term538;
static ATerm term537;
static ATerm term536;
static ATerm term535;
static ATerm term534;
static ATerm term533;
static ATerm term532;
static ATerm term531;
static ATerm term530;
static ATerm term529;
static ATerm term528;
static ATerm term527;
static ATerm term526;
static ATerm term525;
static ATerm term524;
static ATerm term523;
static ATerm term522;
static ATerm term521;
static ATerm term520;
static ATerm term519;
static ATerm term518;
static ATerm term517;
static ATerm term516;
static ATerm term515;
static ATerm term514;
static ATerm term513;
static ATerm term512;
static ATerm term511;
static ATerm term510;
static ATerm term509;
static ATerm term508;
static ATerm term507;
static ATerm term506;
static ATerm term505;
static ATerm term504;
static ATerm term503;
static ATerm term502;
static ATerm term501;
static ATerm term500;
static ATerm term499;
static ATerm term498;
static ATerm term497;
static ATerm term496;
static ATerm term495;
static ATerm term494;
static ATerm term493;
static ATerm term492;
static ATerm term491;
static ATerm term490;
static ATerm term489;
static ATerm term488;
static ATerm term487;
static ATerm term486;
static ATerm term485;
static ATerm term484;
static ATerm term483;
static ATerm term482;
static ATerm term481;
static ATerm term480;
static ATerm term479;
static ATerm term478;
static ATerm term477;
static ATerm term476;
static ATerm term475;
static ATerm term474;
static ATerm term473;
static ATerm term472;
static ATerm term471;
static ATerm term470;
static ATerm term469;
static ATerm term468;
static ATerm term467;
static ATerm term466;
static ATerm term465;
static ATerm term464;
static ATerm term463;
static ATerm term462;
static ATerm term461;
static ATerm term460;
static ATerm term459;
static ATerm term458;
static ATerm term457;
static ATerm term456;
static ATerm term455;
static ATerm term454;
static ATerm term453;
static ATerm term452;
static ATerm term451;
static ATerm term450;
static ATerm term449;
static ATerm term448;
static ATerm term447;
static ATerm term446;
static ATerm term445;
static ATerm term444;
static ATerm term443;
static ATerm term442;
static ATerm term441;
static ATerm term440;
static ATerm term439;
static ATerm term438;
static ATerm term437;
static ATerm term436;
static ATerm term435;
static ATerm term434;
static ATerm term433;
static ATerm term432;
static ATerm term431;
static ATerm term430;
static ATerm term429;
static ATerm term428;
static ATerm term427;
static ATerm term426;
static ATerm term425;
static ATerm term424;
static ATerm term423;
static ATerm term422;
static ATerm term421;
static ATerm term420;
static ATerm term419;
static ATerm term418;
static ATerm term417;
static ATerm term416;
static ATerm term415;
static ATerm term414;
static ATerm term413;
static ATerm term412;
static ATerm term411;
static ATerm term410;
static ATerm term409;
static ATerm term408;
static ATerm term407;
static ATerm term406;
static ATerm term405;
static ATerm term404;
static ATerm term403;
static ATerm term402;
static ATerm term401;
static ATerm term400;
static ATerm term399;
static ATerm term398;
static ATerm term397;
static ATerm term396;
static ATerm term395;
static ATerm term394;
static ATerm term393;
static ATerm term392;
static ATerm term391;
static ATerm term390;
static ATerm term389;
static ATerm term388;
static ATerm term387;
static ATerm term386;
static ATerm term385;
static ATerm term384;
static ATerm term383;
static ATerm term382;
static ATerm term381;
static ATerm term380;
static ATerm term379;
static ATerm term378;
static ATerm term377;
static ATerm term376;
static ATerm term375;
static ATerm term374;
static ATerm term373;
static ATerm term372;
static ATerm term371;
static ATerm term370;
static ATerm term369;
static ATerm term368;
static ATerm term367;
static ATerm term366;
static ATerm term365;
static ATerm term364;
static ATerm term363;
static ATerm term362;
static ATerm term361;
static ATerm term360;
static ATerm term359;
static ATerm term358;
static ATerm term357;
static ATerm term356;
static ATerm term355;
static ATerm term354;
static ATerm term353;
static ATerm term352;
static ATerm term351;
static ATerm term350;
static ATerm term349;
static ATerm term348;
static ATerm term347;
static ATerm term346;
static ATerm term345;
static ATerm term344;
static ATerm term343;
static ATerm term342;
static ATerm term341;
static ATerm term340;
static ATerm term339;
static ATerm term338;
static ATerm term337;
static ATerm term336;
static ATerm term335;
static ATerm term334;
static ATerm term333;
static ATerm term332;
static ATerm term331;
static ATerm term330;
static ATerm term329;
static ATerm term328;
static ATerm term327;
static ATerm term326;
static ATerm term325;
static ATerm term324;
static ATerm term323;
static ATerm term322;
static ATerm term321;
static ATerm term320;
static ATerm term319;
static ATerm term318;
static ATerm term317;
static ATerm term316;
static ATerm term315;
static ATerm term314;
static ATerm term313;
static ATerm term312;
static ATerm term311;
static ATerm term310;
static ATerm term309;
static ATerm term308;
static ATerm term307;
static ATerm term306;
static ATerm term305;
static ATerm term304;
static ATerm term303;
static ATerm term302;
static ATerm term301;
static ATerm term300;
static ATerm term299;
static ATerm term298;
static ATerm term297;
static ATerm term296;
static ATerm term295;
static ATerm term294;
static ATerm term293;
static ATerm term292;
static ATerm term291;
static ATerm term290;
static ATerm term289;
static ATerm term288;
static ATerm term287;
static ATerm term286;
static ATerm term285;
static ATerm term284;
static ATerm term283;
static ATerm term282;
static ATerm term281;
static ATerm term280;
static ATerm term279;
static ATerm term278;
static ATerm term277;
static ATerm term276;
static ATerm term275;
static ATerm term274;
static ATerm term273;
static ATerm term272;
static ATerm term271;
static ATerm term270;
static ATerm term269;
static ATerm term268;
static ATerm term267;
static ATerm term266;
static ATerm term265;
static ATerm term264;
static ATerm term263;
static ATerm term262;
static ATerm term261;
static ATerm term260;
static ATerm term259;
static ATerm term258;
static ATerm term257;
static ATerm term256;
static ATerm term255;
static ATerm term254;
static ATerm term253;
static ATerm term252;
static ATerm term251;
static ATerm term250;
static ATerm term249;
static ATerm term248;
static ATerm term247;
static ATerm term246;
static ATerm term245;
static ATerm term244;
static ATerm term243;
static ATerm term242;
static ATerm term241;
static ATerm term240;
static ATerm term239;
static ATerm term238;
static ATerm term237;
static ATerm term236;
static ATerm term235;
static ATerm term234;
static ATerm term233;
static ATerm term232;
static ATerm term231;
static ATerm term230;
static ATerm term229;
static ATerm term228;
static ATerm term227;
static ATerm term226;
static ATerm term225;
static ATerm term224;
static ATerm term223;
static ATerm term222;
static ATerm term221;
static ATerm term220;
static ATerm term219;
static ATerm term218;
static ATerm term217;
static ATerm term216;
static ATerm term215;
static ATerm term214;
static ATerm term213;
static ATerm term212;
static ATerm term211;
static ATerm term210;
static ATerm term209;
static ATerm term208;
static ATerm term207;
static ATerm term206;
static ATerm term205;
static ATerm term204;
static ATerm term203;
static ATerm term202;
static ATerm term201;
static ATerm term200;
static ATerm term199;
static ATerm term198;
static ATerm term197;
static ATerm term196;
static ATerm term195;
static ATerm term194;
static ATerm term193;
static ATerm term192;
static ATerm term191;
static ATerm term190;
static ATerm term189;
static ATerm term188;
static ATerm term187;
static ATerm term186;
static ATerm term185;
static ATerm term184;
static ATerm term183;
static ATerm term182;
static ATerm term181;
static ATerm term180;
static ATerm term179;
static ATerm term178;
static ATerm term177;
static ATerm term176;
static ATerm term175;
static ATerm term174;
static ATerm term173;
static ATerm term172;
static ATerm term171;
static ATerm term170;
static ATerm term169;
static ATerm term168;
static ATerm term167;
static ATerm term166;
static ATerm term165;
static ATerm term164;
static ATerm term163;
static ATerm term162;
static ATerm term161;
static ATerm term160;
static ATerm term159;
static ATerm term158;
static ATerm term157;
static ATerm term156;
static ATerm term155;
static ATerm term154;
static ATerm term153;
static ATerm term152;
static ATerm term151;
static ATerm term150;
static ATerm term149;
static ATerm term148;
static ATerm term147;
static ATerm term146;
static ATerm term145;
static ATerm term144;
static ATerm term143;
static ATerm term142;
static ATerm term141;
static ATerm term140;
static ATerm term139;
static ATerm term138;
static ATerm term137;
static ATerm term136;
static ATerm term135;
static ATerm term134;
static ATerm term133;
static ATerm term132;
static ATerm term131;
static ATerm term130;
static ATerm term129;
static ATerm term128;
static ATerm term127;
static ATerm term126;
static ATerm term125;
static ATerm term124;
static ATerm term123;
static ATerm term122;
static ATerm term121;
static ATerm term120;
static ATerm term119;
static ATerm term118;
static ATerm term117;
static ATerm term116;
static ATerm term115;
static ATerm term114;
static ATerm term113;
static ATerm term112;
static ATerm term111;
static ATerm term110;
static ATerm term109;
static ATerm term108;
static ATerm term107;
static ATerm term106;
static ATerm term105;
static ATerm term104;
static ATerm term103;
static ATerm term102;
static ATerm term101;
static ATerm term100;
static ATerm term99;
static ATerm term98;
static ATerm term97;
static ATerm term96;
static ATerm term95;
static ATerm term94;
static ATerm term93;
static ATerm term92;
static ATerm term91;
static ATerm term90;
static ATerm term89;
static ATerm term88;
static ATerm term87;
static ATerm term86;
static ATerm term85;
static ATerm term84;
static ATerm term83;
static ATerm term82;
static ATerm term81;
static ATerm term80;
static ATerm term79;
static ATerm term78;
static ATerm term77;
static ATerm term76;
static ATerm term75;
static ATerm term74;
static ATerm term73;
static ATerm term72;
static ATerm term71;
static ATerm term70;
static ATerm term69;
static ATerm term68;
static ATerm term67;
static ATerm term66;
static ATerm term65;
static ATerm term64;
static ATerm term63;
static ATerm term62;
static ATerm term61;
static ATerm term60;
static ATerm term59;
static ATerm term58;
static ATerm term57;
static ATerm term56;
static ATerm term55;
static ATerm term54;
static ATerm term53;
static ATerm term52;
static ATerm term51;
static ATerm term50;
static ATerm term49;
static ATerm term48;
static ATerm term47;
static ATerm term46;
static ATerm term45;
static ATerm term44;
static ATerm term43;
static ATerm term42;
static ATerm term41;
static ATerm term40;
static ATerm term39;
static ATerm term38;
static ATerm term37;
static ATerm term36;
static ATerm term35;
static ATerm term34;
static ATerm term33;
static ATerm term32;
static ATerm term31;
static ATerm term30;
static ATerm term29;
static ATerm term28;
static ATerm term27;
static ATerm term26;
static ATerm term25;
static ATerm term24;
static ATerm term23;
static ATerm term22;
static ATerm term21;
static ATerm term20;
static ATerm term19;
static ATerm term18;
static ATerm term17;
static ATerm term16;
static ATerm term15;
static ATerm term14;
static ATerm term13;
static ATerm term12;
static ATerm term11;
static ATerm term10;
static ATerm term9;
static ATerm term8;
static ATerm term7;
static ATerm term6;
static ATerm term5;
static ATerm term4;
static ATerm term3;
static ATerm term2;
static ATerm term1;
static ATerm term0;
static void init_module_constant_terms (void)
{
ATprotect(&(term0));
term0 = (ATerm) ATmakeAppl(ATmakeSymbol("Date", 0, ATtrue));
ATprotect(&(term1));
term1 = term0;
ATprotect(&(term2));
term2 = (ATerm) ATmakeAppl(ATmakeSymbol("Long", 0, ATtrue));
ATprotect(&(term3));
term3 = term2;
ATprotect(&(term4));
term4 = (ATerm) ATmakeAppl(ATmakeSymbol("Double", 0, ATtrue));
ATprotect(&(term5));
term5 = term4;
ATprotect(&(term6));
term6 = (ATerm) ATmakeAppl(ATmakeSymbol("Integer", 0, ATtrue));
ATprotect(&(term7));
term7 = term6;
ATprotect(&(term8));
term8 = (ATerm) ATmakeAppl(ATmakeSymbol("String", 0, ATtrue));
ATprotect(&(term9));
term9 = term8;
ATprotect(&(term10));
term10 = (ATerm) ATmakeAppl(sym_None_0);
ATprotect(&(term11));
term11 = term10;
ATprotect(&(term12));
term12 = (ATerm) ATmakeAppl(ATmakeSymbol("Set", 0, ATtrue));
ATprotect(&(term13));
term13 = term12;
ATprotect(&(term14));
term14 = (ATerm) ATmakeAppl(sym_Id_1, term13);
ATprotect(&(term15));
term15 = term14;
ATprotect(&(term16));
term16 = (ATerm) ATmakeAppl(sym_TypeName_1, term15);
ATprotect(&(term17));
term17 = term16;
ATprotect(&(term18));
term18 = (ATerm) ATmakeAppl(ATmakeSymbol("TypeError", 0, ATtrue));
ATprotect(&(term19));
term19 = term18;
ATprotect(&(term20));
term20 = (ATerm) ATmakeAppl(sym_DR__DUMMY_0);
ATprotect(&(term21));
term21 = term20;
ATprotect(&(term22));
term22 = (ATerm) ATmakeAppl(ATmakeSymbol("e95f9c33fb2770e7ee60aace2903edc4", 0, ATtrue));
ATprotect(&(term23));
term23 = term22;
ATprotect(&(term24));
term24 = (ATerm) ATmakeAppl(ATmakeSymbol("e1bbb8f5381f255a5424a06951e36ed7", 0, ATtrue));
ATprotect(&(term25));
term25 = term24;
ATprotect(&(term26));
term26 = (ATerm) ATmakeAppl(ATmakeSymbol(" undefined\n", 0, ATtrue));
ATprotect(&(term27));
term27 = term26;
ATprotect(&(term28));
term28 = (ATerm) ATmakeAppl(ATmakeSymbol("\n\n *** Error: type ", 0, ATtrue));
ATprotect(&(term29));
term29 = term28;
ATprotect(&(term30));
term30 = (ATerm) ATmakeAppl(ATmakeSymbol("\nType                : ", 0, ATtrue));
ATprotect(&(term31));
term31 = term30;
ATprotect(&(term32));
term32 = (ATerm) ATmakeAppl(ATmakeSymbol("\nConcept member      : ", 0, ATtrue));
ATprotect(&(term33));
term33 = term32;
ATprotect(&(term34));
term34 = (ATerm) ATmakeAppl(ATmakeSymbol("\nConcept declaration : ", 0, ATtrue));
ATprotect(&(term35));
term35 = term34;
ATprotect(&(term36));
term36 = (ATerm) ATmakeAppl(ATmakeSymbol("\n	", 0, ATtrue));
ATprotect(&(term37));
term37 = term36;
ATprotect(&(term38));
term38 = (ATerm) ATmakeAppl(sym_Literal_1, term37);
ATprotect(&(term39));
term39 = term38;
ATprotect(&(term40));
term40 = (ATerm) ATmakeAppl(ATmakeSymbol("properties", 0, ATtrue));
ATprotect(&(term41));
term41 = term40;
ATprotect(&(term42));
term42 = (ATerm) ATmakeAppl(sym_QName_2, term11, term41);
ATprotect(&(term43));
term43 = term42;
ATprotect(&(term44));
term44 = (ATerm) ATmakeAppl(ATmakeSymbol("\n		", 0, ATtrue));
ATprotect(&(term45));
term45 = term44;
ATprotect(&(term46));
term46 = (ATerm) ATmakeAppl(sym_Literal_1, term45);
ATprotect(&(term47));
term47 = term46;
ATprotect(&(term48));
term48 = (ATerm) ATmakeAppl(ATmakeSymbol("property", 0, ATtrue));
ATprotect(&(term49));
term49 = term48;
ATprotect(&(term50));
term50 = (ATerm) ATmakeAppl(sym_QName_2, term11, term49);
ATprotect(&(term51));
term51 = term50;
ATprotect(&(term52));
term52 = (ATerm) ATmakeAppl(ATmakeSymbol("value", 0, ATtrue));
ATprotect(&(term53));
term53 = term52;
ATprotect(&(term54));
term54 = (ATerm) ATmakeAppl(sym_QName_2, term11, term53);
ATprotect(&(term55));
term55 = term54;
ATprotect(&(term56));
term56 = (ATerm) ATmakeAppl(ATmakeSymbol("create", 0, ATtrue));
ATprotect(&(term57));
term57 = term56;
ATprotect(&(term58));
term58 = (ATerm) ATmakeAppl(sym_Literal_1, term57);
ATprotect(&(term59));
term59 = term58;
ATprotect(&(term60));
term60 = (ATerm) ATmakeAppl(ATmakeSymbol("name", 0, ATtrue));
ATprotect(&(term61));
term61 = term60;
ATprotect(&(term62));
term62 = (ATerm) ATmakeAppl(sym_QName_2, term11, term61);
ATprotect(&(term63));
term63 = term62;
ATprotect(&(term64));
term64 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.hbm2ddl.auto", 0, ATtrue));
ATprotect(&(term65));
term65 = term64;
ATprotect(&(term66));
term66 = (ATerm) ATmakeAppl(sym_Literal_1, term65);
ATprotect(&(term67));
term67 = term66;
ATprotect(&(term68));
term68 = (ATerm) ATmakeAppl(ATmakeSymbol("\n			", 0, ATtrue));
ATprotect(&(term69));
term69 = term68;
ATprotect(&(term70));
term70 = (ATerm) ATmakeAppl(sym_Literal_1, term69);
ATprotect(&(term71));
term71 = term70;
ATprotect(&(term72));
term72 = (ATerm) ATmakeAppl(ATmakeSymbol("org.hibernate.dialect.HSQLDialect", 0, ATtrue));
ATprotect(&(term73));
term73 = term72;
ATprotect(&(term74));
term74 = (ATerm) ATmakeAppl(sym_Literal_1, term73);
ATprotect(&(term75));
term75 = term74;
ATprotect(&(term76));
term76 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.dialect", 0, ATtrue));
ATprotect(&(term77));
term77 = term76;
ATprotect(&(term78));
term78 = (ATerm) ATmakeAppl(sym_Literal_1, term77);
ATprotect(&(term79));
term79 = term78;
ATprotect(&(term80));
term80 = (ATerm) ATmakeAppl(ATmakeSymbol("3000", 0, ATtrue));
ATprotect(&(term81));
term81 = term80;
ATprotect(&(term82));
term82 = (ATerm) ATmakeAppl(sym_Literal_1, term81);
ATprotect(&(term83));
term83 = term82;
ATprotect(&(term84));
term84 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.c3p0.idle_test_period", 0, ATtrue));
ATprotect(&(term85));
term85 = term84;
ATprotect(&(term86));
term86 = (ATerm) ATmakeAppl(sym_Literal_1, term85);
ATprotect(&(term87));
term87 = term86;
ATprotect(&(term88));
term88 = (ATerm) ATmakeAppl(ATmakeSymbol("50", 0, ATtrue));
ATprotect(&(term89));
term89 = term88;
ATprotect(&(term90));
term90 = (ATerm) ATmakeAppl(sym_Literal_1, term89);
ATprotect(&(term91));
term91 = term90;
ATprotect(&(term92));
term92 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.c3p0.max_statements", 0, ATtrue));
ATprotect(&(term93));
term93 = term92;
ATprotect(&(term94));
term94 = (ATerm) ATmakeAppl(sym_Literal_1, term93);
ATprotect(&(term95));
term95 = term94;
ATprotect(&(term96));
term96 = (ATerm) ATmakeAppl(ATmakeSymbol("300", 0, ATtrue));
ATprotect(&(term97));
term97 = term96;
ATprotect(&(term98));
term98 = (ATerm) ATmakeAppl(sym_Literal_1, term97);
ATprotect(&(term99));
term99 = term98;
ATprotect(&(term100));
term100 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.c3p0.timeout", 0, ATtrue));
ATprotect(&(term101));
term101 = term100;
ATprotect(&(term102));
term102 = (ATerm) ATmakeAppl(sym_Literal_1, term101);
ATprotect(&(term103));
term103 = term102;
ATprotect(&(term104));
term104 = (ATerm) ATmakeAppl(ATmakeSymbol("20", 0, ATtrue));
ATprotect(&(term105));
term105 = term104;
ATprotect(&(term106));
term106 = (ATerm) ATmakeAppl(sym_Literal_1, term105);
ATprotect(&(term107));
term107 = term106;
ATprotect(&(term108));
term108 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.c3p0.max_size", 0, ATtrue));
ATprotect(&(term109));
term109 = term108;
ATprotect(&(term110));
term110 = (ATerm) ATmakeAppl(sym_Literal_1, term109);
ATprotect(&(term111));
term111 = term110;
ATprotect(&(term112));
term112 = (ATerm) ATmakeAppl(ATmakeSymbol("5", 0, ATtrue));
ATprotect(&(term113));
term113 = term112;
ATprotect(&(term114));
term114 = (ATerm) ATmakeAppl(sym_Literal_1, term113);
ATprotect(&(term115));
term115 = term114;
ATprotect(&(term116));
term116 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.c3p0.min_size", 0, ATtrue));
ATprotect(&(term117));
term117 = term116;
ATprotect(&(term118));
term118 = (ATerm) ATmakeAppl(sym_Literal_1, term117);
ATprotect(&(term119));
term119 = term118;
ATprotect(&(term120));
term120 = (ATerm) ATmakeAppl(ATmakeSymbol("sa", 0, ATtrue));
ATprotect(&(term121));
term121 = term120;
ATprotect(&(term122));
term122 = (ATerm) ATmakeAppl(sym_Literal_1, term121);
ATprotect(&(term123));
term123 = term122;
ATprotect(&(term124));
term124 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.connection.username", 0, ATtrue));
ATprotect(&(term125));
term125 = term124;
ATprotect(&(term126));
term126 = (ATerm) ATmakeAppl(sym_Literal_1, term125);
ATprotect(&(term127));
term127 = term126;
ATprotect(&(term128));
term128 = (ATerm) ATmakeAppl(ATmakeSymbol("jdbc:hsqldb:hsql://localhost/", 0, ATtrue));
ATprotect(&(term129));
term129 = term128;
ATprotect(&(term130));
term130 = (ATerm) ATmakeAppl(sym_Literal_1, term129);
ATprotect(&(term131));
term131 = term130;
ATprotect(&(term132));
term132 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.connection.url", 0, ATtrue));
ATprotect(&(term133));
term133 = term132;
ATprotect(&(term134));
term134 = (ATerm) ATmakeAppl(sym_Literal_1, term133);
ATprotect(&(term135));
term135 = term134;
ATprotect(&(term136));
term136 = (ATerm) ATmakeAppl(ATmakeSymbol("org.hsqldb.jdbcDriver", 0, ATtrue));
ATprotect(&(term137));
term137 = term136;
ATprotect(&(term138));
term138 = (ATerm) ATmakeAppl(sym_Literal_1, term137);
ATprotect(&(term139));
term139 = term138;
ATprotect(&(term140));
term140 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.connection.driver_class", 0, ATtrue));
ATprotect(&(term141));
term141 = term140;
ATprotect(&(term142));
term142 = (ATerm) ATmakeAppl(sym_Literal_1, term141);
ATprotect(&(term143));
term143 = term142;
ATprotect(&(term144));
term144 = (ATerm) ATmakeAppl(ATmakeSymbol("true", 0, ATtrue));
ATprotect(&(term145));
term145 = term144;
ATprotect(&(term146));
term146 = (ATerm) ATmakeAppl(sym_Literal_1, term145);
ATprotect(&(term147));
term147 = term146;
ATprotect(&(term148));
term148 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.format_sql", 0, ATtrue));
ATprotect(&(term149));
term149 = term148;
ATprotect(&(term150));
term150 = (ATerm) ATmakeAppl(sym_Literal_1, term149);
ATprotect(&(term151));
term151 = term150;
ATprotect(&(term152));
term152 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.show_sql", 0, ATtrue));
ATprotect(&(term153));
term153 = term152;
ATprotect(&(term154));
term154 = (ATerm) ATmakeAppl(sym_Literal_1, term153);
ATprotect(&(term155));
term155 = term154;
ATprotect(&(term156));
term156 = (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATempty);
ATprotect(&(term157));
term157 = term156;
ATprotect(&(term158));
term158 = (ATerm) ATmakeAppl(sym_Attribute_2, term55, term157);
ATprotect(&(term159));
term159 = term158;
ATprotect(&(term160));
term160 = (ATerm) ATmakeAppl(ATmakeSymbol("hibernate.archive.autodetection", 0, ATtrue));
ATprotect(&(term161));
term161 = term160;
ATprotect(&(term162));
term162 = (ATerm) ATmakeAppl(sym_Literal_1, term161);
ATprotect(&(term163));
term163 = term162;
ATprotect(&(term164));
term164 = (ATerm) ATmakeAppl(ATmakeSymbol("\n		        ", 0, ATtrue));
ATprotect(&(term165));
term165 = term164;
ATprotect(&(term166));
term166 = (ATerm) ATmakeAppl(sym_Literal_1, term165);
ATprotect(&(term167));
term167 = term166;
ATprotect(&(term168));
term168 = (ATerm) ATmakeAppl(ATmakeSymbol("1.0", 0, ATtrue));
ATprotect(&(term169));
term169 = term168;
ATprotect(&(term170));
term170 = (ATerm) ATmakeAppl(sym_Version_1, term169);
ATprotect(&(term171));
term171 = term170;
ATprotect(&(term172));
term172 = (ATerm) ATmakeAppl(sym_VersionDecl_1, term171);
ATprotect(&(term173));
term173 = term172;
ATprotect(&(term174));
term174 = (ATerm) ATmakeAppl(sym_XMLDecl_3, term173, term11, term11);
ATprotect(&(term175));
term175 = term174;
ATprotect(&(term176));
term176 = (ATerm) ATmakeAppl(sym_Some_1, term175);
ATprotect(&(term177));
term177 = term176;
ATprotect(&(term178));
term178 = (ATerm) ATmakeAppl(sym_Prologue_3, term177, (ATerm)ATempty, term11);
ATprotect(&(term179));
term179 = term178;
ATprotect(&(term180));
term180 = (ATerm) ATmakeAppl(ATmakeSymbol("persistence", 0, ATtrue));
ATprotect(&(term181));
term181 = term180;
ATprotect(&(term182));
term182 = (ATerm) ATmakeAppl(sym_QName_2, term11, term181);
ATprotect(&(term183));
term183 = term182;
ATprotect(&(term184));
term184 = (ATerm) ATmakeAppl(ATmakeSymbol("version", 0, ATtrue));
ATprotect(&(term185));
term185 = term184;
ATprotect(&(term186));
term186 = (ATerm) ATmakeAppl(sym_QName_2, term11, term185);
ATprotect(&(term187));
term187 = term186;
ATprotect(&(term188));
term188 = (ATerm) ATmakeAppl(sym_Literal_1, term169);
ATprotect(&(term189));
term189 = term188;
ATprotect(&(term190));
term190 = (ATerm) ATmakeAppl(ATmakeSymbol("xsi", 0, ATtrue));
ATprotect(&(term191));
term191 = term190;
ATprotect(&(term192));
term192 = (ATerm) ATmakeAppl(sym_Prefix_1, term191);
ATprotect(&(term193));
term193 = term192;
ATprotect(&(term194));
term194 = (ATerm) ATmakeAppl(sym_Some_1, term193);
ATprotect(&(term195));
term195 = term194;
ATprotect(&(term196));
term196 = (ATerm) ATmakeAppl(ATmakeSymbol("schemaLocation", 0, ATtrue));
ATprotect(&(term197));
term197 = term196;
ATprotect(&(term198));
term198 = (ATerm) ATmakeAppl(sym_QName_2, term195, term197);
ATprotect(&(term199));
term199 = term198;
ATprotect(&(term200));
term200 = (ATerm) ATmakeAppl(ATmakeSymbol("http://java.sun.com/xml/ns/persistence http://java.sun.com/xml/ns/persistence/persistence_1_0.xsd", 0, ATtrue));
ATprotect(&(term201));
term201 = term200;
ATprotect(&(term202));
term202 = (ATerm) ATmakeAppl(sym_Literal_1, term201);
ATprotect(&(term203));
term203 = term202;
ATprotect(&(term204));
term204 = (ATerm) ATmakeAppl(ATmakeSymbol("xmlns", 0, ATtrue));
ATprotect(&(term205));
term205 = term204;
ATprotect(&(term206));
term206 = (ATerm) ATmakeAppl(sym_Prefix_1, term205);
ATprotect(&(term207));
term207 = term206;
ATprotect(&(term208));
term208 = (ATerm) ATmakeAppl(sym_Some_1, term207);
ATprotect(&(term209));
term209 = term208;
ATprotect(&(term210));
term210 = (ATerm) ATmakeAppl(sym_QName_2, term209, term191);
ATprotect(&(term211));
term211 = term210;
ATprotect(&(term212));
term212 = (ATerm) ATmakeAppl(ATmakeSymbol("http://www.w3.org/2001/XMLSchema-instance", 0, ATtrue));
ATprotect(&(term213));
term213 = term212;
ATprotect(&(term214));
term214 = (ATerm) ATmakeAppl(sym_Literal_1, term213);
ATprotect(&(term215));
term215 = term214;
ATprotect(&(term216));
term216 = (ATerm) ATmakeAppl(sym_QName_2, term11, term205);
ATprotect(&(term217));
term217 = term216;
ATprotect(&(term218));
term218 = (ATerm) ATmakeAppl(ATmakeSymbol("http://java.sun.com/xml/ns/persistence", 0, ATtrue));
ATprotect(&(term219));
term219 = term218;
ATprotect(&(term220));
term220 = (ATerm) ATmakeAppl(sym_Literal_1, term219);
ATprotect(&(term221));
term221 = term220;
ATprotect(&(term222));
term222 = (ATerm) ATmakeAppl(ATmakeSymbol("\n", 0, ATtrue));
ATprotect(&(term223));
term223 = term222;
ATprotect(&(term224));
term224 = (ATerm) ATmakeAppl(sym_Literal_1, term223);
ATprotect(&(term225));
term225 = term224;
ATprotect(&(term226));
term226 = (ATerm) ATmakeAppl(ATmakeSymbol("persistence-unit", 0, ATtrue));
ATprotect(&(term227));
term227 = term226;
ATprotect(&(term228));
term228 = (ATerm) ATmakeAppl(sym_QName_2, term11, term227);
ATprotect(&(term229));
term229 = term228;
ATprotect(&(term230));
term230 = (ATerm) ATmakeAppl(ATmakeSymbol("transaction-type", 0, ATtrue));
ATprotect(&(term231));
term231 = term230;
ATprotect(&(term232));
term232 = (ATerm) ATmakeAppl(sym_QName_2, term11, term231);
ATprotect(&(term233));
term233 = term232;
ATprotect(&(term234));
term234 = (ATerm) ATmakeAppl(ATmakeSymbol("RESOURCE_LOCAL", 0, ATtrue));
ATprotect(&(term235));
term235 = term234;
ATprotect(&(term236));
term236 = (ATerm) ATmakeAppl(sym_Literal_1, term235);
ATprotect(&(term237));
term237 = term236;
ATprotect(&(term238));
term238 = (ATerm) ATmakeAppl(ATmakeSymbol("provider", 0, ATtrue));
ATprotect(&(term239));
term239 = term238;
ATprotect(&(term240));
term240 = (ATerm) ATmakeAppl(sym_QName_2, term11, term239);
ATprotect(&(term241));
term241 = term240;
ATprotect(&(term242));
term242 = (ATerm) ATmakeAppl(ATmakeSymbol("org.hibernate.ejb.HibernatePersistence", 0, ATtrue));
ATprotect(&(term243));
term243 = term242;
ATprotect(&(term244));
term244 = (ATerm) ATmakeAppl(sym_Literal_1, term243);
ATprotect(&(term245));
term245 = term244;
ATprotect(&(term246));
term246 = (ATerm) ATmakeAppl(sym_Epilogue_1, (ATerm) ATempty);
ATprotect(&(term247));
term247 = term246;
ATprotect(&(term248));
term248 = (ATerm) ATmakeAppl(ATmakeSymbol("class", 0, ATtrue));
ATprotect(&(term249));
term249 = term248;
ATprotect(&(term250));
term250 = (ATerm) ATmakeAppl(sym_QName_2, term11, term249);
ATprotect(&(term251));
term251 = term250;
ATprotect(&(term252));
term252 = (ATerm) ATmakeAppl(ATmakeSymbol("--project-name", 0, ATtrue));
ATprotect(&(term253));
term253 = term252;
ATprotect(&(term254));
term254 = (ATerm) ATmakeAppl(ATmakeSymbol("-pn <name>| --project-name <name>    The name of the project this domain model will be part of.", 0, ATtrue));
ATprotect(&(term255));
term255 = term254;
ATprotect(&(term256));
term256 = (ATerm) ATmakeAppl(ATmakeSymbol("--prefix", 0, ATtrue));
ATprotect(&(term257));
term257 = term256;
ATprotect(&(term258));
term258 = (ATerm) ATmakeAppl(ATmakeSymbol("-p <package-prefix>| --prefix <package-prefix>    Prefix used for all generated classes. Example: org.mycompany", 0, ATtrue));
ATprotect(&(term259));
term259 = term258;
ATprotect(&(term260));
term260 = (ATerm) ATmakeAppl(sym_AutoReportBugs_0);
ATprotect(&(term261));
term261 = term260;
ATprotect(&(term262));
term262 = (ATerm) ATmakeAppl(sym_OptionUsage_0);
ATprotect(&(term263));
term263 = term262;
ATprotect(&(term264));
term264 = (ATerm) ATmakeAppl(ATmakeSymbol("Compiles a DomainModel DSL program into a JPA implementation.", 0, ATtrue));
ATprotect(&(term265));
term265 = term264;
ATprotect(&(term266));
term266 = (ATerm) ATmakeAppl(sym_Summary_1, term265);
ATprotect(&(term267));
term267 = term266;
ATprotect(&(term268));
term268 = (ATerm) ATmakeAppl(ATmakeSymbol("dmdsl [-i Foo.dm] [OPTIONS]", 0, ATtrue));
ATprotect(&(term269));
term269 = term268;
ATprotect(&(term270));
term270 = (ATerm) ATmakeAppl(sym_Usage_1, term269);
ATprotect(&(term271));
term271 = term270;
ATprotect(&(term272));
term272 = (ATerm) ATmakeAppl(sym_CurrentXTCRepository_0);
ATprotect(&(term273));
term273 = term272;
ATprotect(&(term274));
term274 = (ATerm) ATmakeAppl(sym_DefaultXTCRepository_0);
ATprotect(&(term275));
term275 = term274;
ATprotect(&(term276));
term276 = (ATerm) ATmakeAppl(ATmakeSymbol("no website available", 0, ATtrue));
ATprotect(&(term277));
term277 = term276;
ATprotect(&(term278));
term278 = (ATerm) ATmakeAppl(sym_WebHome_1, term277);
ATprotect(&(term279));
term279 = term278;
ATprotect(&(term280));
term280 = (ATerm) ATmakeAppl(ATmakeSymbol("2007", 0, ATtrue));
ATprotect(&(term281));
term281 = term280;
ATprotect(&(term282));
term282 = (ATerm) ATmakeAppl(ATmakeSymbol("Sander Mak <sbmak@cs.uu.nl>", 0, ATtrue));
ATprotect(&(term283));
term283 = term282;
ATprotect(&(term284));
term284 = (ATerm) ATmakeAppl(sym_GNU__LGPL_2, term281, term283);
ATprotect(&(term285));
term285 = term284;
ATprotect(&(term286));
term286 = (ATerm) ATmakeAppl(ATmakeSymbol("Sander Mak", 0, ATtrue));
ATprotect(&(term287));
term287 = term286;
ATprotect(&(term288));
term288 = (ATerm) ATmakeAppl(ATmakeSymbol("sbmak@cs.uu.nl", 0, ATtrue));
ATprotect(&(term289));
term289 = term288;
ATprotect(&(term290));
term290 = (ATerm) ATmakeAppl(sym_Person_2, term287, term289);
ATprotect(&(term291));
term291 = term290;
ATprotect(&(term292));
term292 = (ATerm) ATmakeAppl(sym_Author_1, term291);
ATprotect(&(term293));
term293 = term292;
ATprotect(&(term294));
term294 = (ATerm) ATmakeAppl(sym_AutoProgram_0);
ATprotect(&(term295));
term295 = term294;
ATprotect(&(term296));
term296 = (ATerm) ATmakeAppl(ATmakeSymbol("generated", 0, ATtrue));
ATprotect(&(term297));
term297 = term296;
ATprotect(&(term298));
term298 = (ATerm) ATmakeAppl(ATmakeSymbol(" on path ", 0, ATtrue));
ATprotect(&(term299));
term299 = term298;
ATprotect(&(term300));
term300 = (ATerm) ATmakeAppl(ATmakeSymbol("Writing file: ", 0, ATtrue));
ATprotect(&(term301));
term301 = term300;
ATprotect(&(term302));
term302 = (ATerm) ATmakeAppl(ATmakeSymbol("/", 0, ATtrue));
ATprotect(&(term303));
term303 = term302;
ATprotect(&(term304));
term304 = (ATerm) ATmakeAppl(ATmakeSymbol("w", 0, ATtrue));
ATprotect(&(term305));
term305 = term304;
ATprotect(&(term306));
term306 = (ATerm) ATmakeAppl(ATmakeSymbol("File written", 0, ATtrue));
ATprotect(&(term307));
term307 = term306;
ATprotect(&(term308));
term308 = (ATerm) ATmakeAppl(ATmakeSymbol("Projectname must be set. Try using -pn <name> or --projectname <name>. Use --help for more information.", 0, ATtrue));
ATprotect(&(term309));
term309 = term308;
ATprotect(&(term310));
term310 = (ATerm) ATmakeAppl(ATmakeSymbol("Package", 0, ATtrue));
ATprotect(&(term311));
term311 = term310;
ATprotect(&(term312));
term312 = (ATerm) ATmakeAppl(ATmakeSymbol("8dbf9365c4dc66f6f55631d9ae0554ea", 0, ATtrue));
ATprotect(&(term313));
term313 = term312;
ATprotect(&(term314));
term314 = (ATerm) ATmakeAppl(ATmakeSymbol("AST", 0, ATtrue));
ATprotect(&(term315));
term315 = term314;
ATprotect(&(term316));
term316 = (ATerm) ATmakeAppl(ATmakeSymbol("Compilation failed", 0, ATtrue));
ATprotect(&(term317));
term317 = term316;
ATprotect(&(term318));
term318 = (ATerm) ATmakeAppl(ATmakeSymbol("pp-java", 0, ATtrue));
ATprotect(&(term319));
term319 = term318;
ATprotect(&(term320));
term320 = (ATerm) ATmakeAppl(ATmakeSymbol("PersistenceUtil.java", 0, ATtrue));
ATprotect(&(term321));
term321 = term320;
ATprotect(&(term322));
term322 = (ATerm) ATmakeAppl(ATmakeSymbol("blog", 0, ATtrue));
ATprotect(&(term323));
term323 = term322;
ATprotect(&(term324));
term324 = (ATerm) ATmakeAppl(ATmakeSymbol(".java", 0, ATtrue));
ATprotect(&(term325));
term325 = term324;
ATprotect(&(term326));
term326 = (ATerm) ATmakeAppl(ATmakeSymbol(".", 0, ATtrue));
ATprotect(&(term327));
term327 = term326;
ATprotect(&(term328));
term328 = (ATerm) ATmakeAppl(ATmakeSymbol("classnames", 0, ATtrue));
ATprotect(&(term329));
term329 = term328;
ATprotect(&(term330));
term330 = (ATerm) ATmakeAppl(ATmakeSymbol("pp-xml-doc", 0, ATtrue));
ATprotect(&(term331));
term331 = term330;
ATprotect(&(term332));
term332 = (ATerm) ATmakeAppl(ATmakeSymbol("META-INF", 0, ATtrue));
ATprotect(&(term333));
term333 = term332;
ATprotect(&(term334));
term334 = (ATerm) ATmakeAppl(ATmakeSymbol("persistence.xml", 0, ATtrue));
ATprotect(&(term335));
term335 = term334;
ATprotect(&(term336));
term336 = (ATerm) ATmakeAppl(sym_Id_1, term181);
ATprotect(&(term337));
term337 = term336;
ATprotect(&(term338));
term338 = (ATerm) ATmakeAppl(ATmakeSymbol("javax", 0, ATtrue));
ATprotect(&(term339));
term339 = term338;
ATprotect(&(term340));
term340 = (ATerm) ATmakeAppl(sym_Id_1, term339);
ATprotect(&(term341));
term341 = term340;
ATprotect(&(term342));
term342 = (ATerm) ATmakeAppl(ATmakeSymbol("util", 0, ATtrue));
ATprotect(&(term343));
term343 = term342;
ATprotect(&(term344));
term344 = (ATerm) ATmakeAppl(sym_Id_1, term343);
ATprotect(&(term345));
term345 = term344;
ATprotect(&(term346));
term346 = (ATerm) ATmakeAppl(ATmakeSymbol("java", 0, ATtrue));
ATprotect(&(term347));
term347 = term346;
ATprotect(&(term348));
term348 = (ATerm) ATmakeAppl(sym_Id_1, term347);
ATprotect(&(term349));
term349 = term348;
ATprotect(&(term350));
term350 = (ATerm) ATmakeAppl(sym_Public_0);
ATprotect(&(term351));
term351 = term350;
ATprotect(&(term352));
term352 = (ATerm) ATmakeAppl(ATmakeSymbol("Entity", 0, ATtrue));
ATprotect(&(term353));
term353 = term352;
ATprotect(&(term354));
term354 = (ATerm) ATmakeAppl(sym_Id_1, term353);
ATprotect(&(term355));
term355 = term354;
ATprotect(&(term356));
term356 = (ATerm) ATmakeAppl(sym_TypeName_1, term355);
ATprotect(&(term357));
term357 = term356;
ATprotect(&(term358));
term358 = (ATerm) ATmakeAppl(sym_MarkerAnno_1, term357);
ATprotect(&(term359));
term359 = term358;
ATprotect(&(term360));
term360 = (ATerm) ATmakeAppl(sym_Protected_0);
ATprotect(&(term361));
term361 = term360;
ATprotect(&(term362));
term362 = (ATerm) ATmakeAppl(sym_Void_0);
ATprotect(&(term363));
term363 = term362;
ATprotect(&(term364));
term364 = (ATerm) ATmakeAppl(ATmakeSymbol("setVersionNum", 0, ATtrue));
ATprotect(&(term365));
term365 = term364;
ATprotect(&(term366));
term366 = (ATerm) ATmakeAppl(sym_Id_1, term365);
ATprotect(&(term367));
term367 = term366;
ATprotect(&(term368));
term368 = (ATerm) ATmakeAppl(sym_Int_0);
ATprotect(&(term369));
term369 = term368;
ATprotect(&(term370));
term370 = (ATerm) ATmakeAppl(ATmakeSymbol("versionNum", 0, ATtrue));
ATprotect(&(term371));
term371 = term370;
ATprotect(&(term372));
term372 = (ATerm) ATmakeAppl(sym_Id_1, term371);
ATprotect(&(term373));
term373 = term372;
ATprotect(&(term374));
term374 = (ATerm) ATmakeAppl(sym_Param_3, (ATerm)ATempty, term369, term373);
ATprotect(&(term375));
term375 = term374;
ATprotect(&(term376));
term376 = (ATerm) ATmakeAppl(sym_This_0);
ATprotect(&(term377));
term377 = term376;
ATprotect(&(term378));
term378 = (ATerm) ATmakeAppl(sym_Field_2, term377, term373);
ATprotect(&(term379));
term379 = term378;
ATprotect(&(term380));
term380 = (ATerm) ATmakeAppl(sym_ExprName_1, term373);
ATprotect(&(term381));
term381 = term380;
ATprotect(&(term382));
term382 = (ATerm) ATmakeAppl(sym_Assign_2, term379, term381);
ATprotect(&(term383));
term383 = term382;
ATprotect(&(term384));
term384 = (ATerm) ATmakeAppl(sym_ExprStm_1, term383);
ATprotect(&(term385));
term385 = term384;
ATprotect(&(term386));
term386 = (ATerm) ATmakeAppl(ATmakeSymbol("Column", 0, ATtrue));
ATprotect(&(term387));
term387 = term386;
ATprotect(&(term388));
term388 = (ATerm) ATmakeAppl(sym_Id_1, term387);
ATprotect(&(term389));
term389 = term388;
ATprotect(&(term390));
term390 = (ATerm) ATmakeAppl(sym_TypeName_1, term389);
ATprotect(&(term391));
term391 = term390;
ATprotect(&(term392));
term392 = (ATerm) ATmakeAppl(sym_Id_1, term61);
ATprotect(&(term393));
term393 = term392;
ATprotect(&(term394));
term394 = (ATerm) ATmakeAppl(ATmakeSymbol("OPTLOCK", 0, ATtrue));
ATprotect(&(term395));
term395 = term394;
ATprotect(&(term396));
term396 = (ATerm) ATmakeAppl(sym_Chars_1, term395);
ATprotect(&(term397));
term397 = term396;
ATprotect(&(term398));
term398 = (ATerm) ATmakeAppl(ATmakeSymbol("Version", 0, ATtrue));
ATprotect(&(term399));
term399 = term398;
ATprotect(&(term400));
term400 = (ATerm) ATmakeAppl(sym_Id_1, term399);
ATprotect(&(term401));
term401 = term400;
ATprotect(&(term402));
term402 = (ATerm) ATmakeAppl(sym_TypeName_1, term401);
ATprotect(&(term403));
term403 = term402;
ATprotect(&(term404));
term404 = (ATerm) ATmakeAppl(sym_MarkerAnno_1, term403);
ATprotect(&(term405));
term405 = term404;
ATprotect(&(term406));
term406 = (ATerm) ATmakeAppl(ATmakeSymbol("getVersionNum", 0, ATtrue));
ATprotect(&(term407));
term407 = term406;
ATprotect(&(term408));
term408 = (ATerm) ATmakeAppl(sym_Id_1, term407);
ATprotect(&(term409));
term409 = term408;
ATprotect(&(term410));
term410 = (ATerm) ATmakeAppl(sym_Some_1, term381);
ATprotect(&(term411));
term411 = term410;
ATprotect(&(term412));
term412 = (ATerm) ATmakeAppl(sym_Return_1, term411);
ATprotect(&(term413));
term413 = term412;
ATprotect(&(term414));
term414 = (ATerm) ATmakeAppl(sym_VarDec_1, term373);
ATprotect(&(term415));
term415 = term414;
ATprotect(&(term416));
term416 = (ATerm) ATmakeAppl(ATmakeSymbol("setId", 0, ATtrue));
ATprotect(&(term417));
term417 = term416;
ATprotect(&(term418));
term418 = (ATerm) ATmakeAppl(sym_Id_1, term417);
ATprotect(&(term419));
term419 = term418;
ATprotect(&(term420));
term420 = (ATerm) ATmakeAppl(sym_Id_1, term3);
ATprotect(&(term421));
term421 = term420;
ATprotect(&(term422));
term422 = (ATerm) ATmakeAppl(sym_TypeName_1, term421);
ATprotect(&(term423));
term423 = term422;
ATprotect(&(term424));
term424 = (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, term423, term11);
ATprotect(&(term425));
term425 = term424;
ATprotect(&(term426));
term426 = (ATerm) ATmakeAppl(ATmakeSymbol("id", 0, ATtrue));
ATprotect(&(term427));
term427 = term426;
ATprotect(&(term428));
term428 = (ATerm) ATmakeAppl(sym_Id_1, term427);
ATprotect(&(term429));
term429 = term428;
ATprotect(&(term430));
term430 = (ATerm) ATmakeAppl(sym_Param_3, (ATerm)ATempty, term425, term429);
ATprotect(&(term431));
term431 = term430;
ATprotect(&(term432));
term432 = (ATerm) ATmakeAppl(sym_Field_2, term377, term429);
ATprotect(&(term433));
term433 = term432;
ATprotect(&(term434));
term434 = (ATerm) ATmakeAppl(sym_ExprName_1, term429);
ATprotect(&(term435));
term435 = term434;
ATprotect(&(term436));
term436 = (ATerm) ATmakeAppl(sym_Assign_2, term433, term435);
ATprotect(&(term437));
term437 = term436;
ATprotect(&(term438));
term438 = (ATerm) ATmakeAppl(sym_ExprStm_1, term437);
ATprotect(&(term439));
term439 = term438;
ATprotect(&(term440));
term440 = (ATerm) ATmakeAppl(ATmakeSymbol("GeneratedValue", 0, ATtrue));
ATprotect(&(term441));
term441 = term440;
ATprotect(&(term442));
term442 = (ATerm) ATmakeAppl(sym_Id_1, term441);
ATprotect(&(term443));
term443 = term442;
ATprotect(&(term444));
term444 = (ATerm) ATmakeAppl(sym_TypeName_1, term443);
ATprotect(&(term445));
term445 = term444;
ATprotect(&(term446));
term446 = (ATerm) ATmakeAppl(sym_MarkerAnno_1, term445);
ATprotect(&(term447));
term447 = term446;
ATprotect(&(term448));
term448 = (ATerm) ATmakeAppl(ATmakeSymbol("Id", 0, ATtrue));
ATprotect(&(term449));
term449 = term448;
ATprotect(&(term450));
term450 = (ATerm) ATmakeAppl(sym_Id_1, term449);
ATprotect(&(term451));
term451 = term450;
ATprotect(&(term452));
term452 = (ATerm) ATmakeAppl(sym_TypeName_1, term451);
ATprotect(&(term453));
term453 = term452;
ATprotect(&(term454));
term454 = (ATerm) ATmakeAppl(sym_MarkerAnno_1, term453);
ATprotect(&(term455));
term455 = term454;
ATprotect(&(term456));
term456 = (ATerm) ATmakeAppl(ATmakeSymbol("getId", 0, ATtrue));
ATprotect(&(term457));
term457 = term456;
ATprotect(&(term458));
term458 = (ATerm) ATmakeAppl(sym_Id_1, term457);
ATprotect(&(term459));
term459 = term458;
ATprotect(&(term460));
term460 = (ATerm) ATmakeAppl(sym_Some_1, term435);
ATprotect(&(term461));
term461 = term460;
ATprotect(&(term462));
term462 = (ATerm) ATmakeAppl(sym_Return_1, term461);
ATprotect(&(term463));
term463 = term462;
ATprotect(&(term464));
term464 = (ATerm) ATmakeAppl(sym_Private_0);
ATprotect(&(term465));
term465 = term464;
ATprotect(&(term466));
term466 = (ATerm) ATmakeAppl(sym_VarDec_1, term429);
ATprotect(&(term467));
term467 = term466;
ATprotect(&(term468));
term468 = (ATerm) ATmakeAppl(sym_ConstrBody_2, term11, (ATerm) ATempty);
ATprotect(&(term469));
term469 = term468;
ATprotect(&(term470));
term470 = (ATerm) ATmakeAppl(ATmakeSymbol("Basic", 0, ATtrue));
ATprotect(&(term471));
term471 = term470;
ATprotect(&(term472));
term472 = (ATerm) ATmakeAppl(sym_Id_1, term471);
ATprotect(&(term473));
term473 = term472;
ATprotect(&(term474));
term474 = (ATerm) ATmakeAppl(sym_TypeName_1, term473);
ATprotect(&(term475));
term475 = term474;
ATprotect(&(term476));
term476 = (ATerm) ATmakeAppl(sym_MarkerAnno_1, term475);
ATprotect(&(term477));
term477 = term476;
ATprotect(&(term478));
term478 = (ATerm) ATmakeAppl(ATmakeSymbol("OneToOne", 0, ATtrue));
ATprotect(&(term479));
term479 = term478;
ATprotect(&(term480));
term480 = (ATerm) ATmakeAppl(sym_Id_1, term479);
ATprotect(&(term481));
term481 = term480;
ATprotect(&(term482));
term482 = (ATerm) ATmakeAppl(sym_TypeName_1, term481);
ATprotect(&(term483));
term483 = term482;
ATprotect(&(term484));
term484 = (ATerm) ATmakeAppl(ATmakeSymbol("cascade", 0, ATtrue));
ATprotect(&(term485));
term485 = term484;
ATprotect(&(term486));
term486 = (ATerm) ATmakeAppl(sym_Id_1, term485);
ATprotect(&(term487));
term487 = term486;
ATprotect(&(term488));
term488 = (ATerm) ATmakeAppl(ATmakeSymbol("CascadeType", 0, ATtrue));
ATprotect(&(term489));
term489 = term488;
ATprotect(&(term490));
term490 = (ATerm) ATmakeAppl(sym_Id_1, term489);
ATprotect(&(term491));
term491 = term490;
ATprotect(&(term492));
term492 = (ATerm) ATmakeAppl(sym_AmbName_1, term491);
ATprotect(&(term493));
term493 = term492;
ATprotect(&(term494));
term494 = (ATerm) ATmakeAppl(ATmakeSymbol("MERGE", 0, ATtrue));
ATprotect(&(term495));
term495 = term494;
ATprotect(&(term496));
term496 = (ATerm) ATmakeAppl(sym_Id_1, term495);
ATprotect(&(term497));
term497 = term496;
ATprotect(&(term498));
term498 = (ATerm) ATmakeAppl(sym_ExprName_2, term493, term497);
ATprotect(&(term499));
term499 = term498;
ATprotect(&(term500));
term500 = (ATerm) ATmakeAppl(ATmakeSymbol("PERSIST", 0, ATtrue));
ATprotect(&(term501));
term501 = term500;
ATprotect(&(term502));
term502 = (ATerm) ATmakeAppl(sym_Id_1, term501);
ATprotect(&(term503));
term503 = term502;
ATprotect(&(term504));
term504 = (ATerm) ATmakeAppl(sym_ExprName_2, term493, term503);
ATprotect(&(term505));
term505 = term504;
ATprotect(&(term506));
term506 = (ATerm) ATmakeAppl(ATmakeSymbol("add", 0, ATtrue));
ATprotect(&(term507));
term507 = term506;
ATprotect(&(term508));
term508 = (ATerm) ATmakeAppl(ATmakeSymbol("one", 0, ATtrue));
ATprotect(&(term509));
term509 = term508;
ATprotect(&(term510));
term510 = (ATerm) ATmakeAppl(sym_Id_1, term507);
ATprotect(&(term511));
term511 = term510;
ATprotect(&(term512));
term512 = (ATerm) ATmakeAppl(ATmakeSymbol("ManyToMany", 0, ATtrue));
ATprotect(&(term513));
term513 = term512;
ATprotect(&(term514));
term514 = (ATerm) ATmakeAppl(sym_Id_1, term513);
ATprotect(&(term515));
term515 = term514;
ATprotect(&(term516));
term516 = (ATerm) ATmakeAppl(sym_TypeName_1, term515);
ATprotect(&(term517));
term517 = term516;
ATprotect(&(term518));
term518 = (ATerm) ATmakeAppl(ATmakeSymbol("HashSet", 0, ATtrue));
ATprotect(&(term519));
term519 = term518;
ATprotect(&(term520));
term520 = (ATerm) ATmakeAppl(sym_Id_1, term519);
ATprotect(&(term521));
term521 = term520;
ATprotect(&(term522));
term522 = (ATerm) ATmakeAppl(sym_TypeName_1, term521);
ATprotect(&(term523));
term523 = term522;
ATprotect(&(term524));
term524 = (ATerm) ATmakeAppl(ATmakeSymbol("PersistenceUtil", 0, ATtrue));
ATprotect(&(term525));
term525 = term524;
ATprotect(&(term526));
term526 = (ATerm) ATmakeAppl(sym_Id_1, term525);
ATprotect(&(term527));
term527 = term526;
ATprotect(&(term528));
term528 = (ATerm) ATmakeAppl(sym_Static_0);
ATprotect(&(term529));
term529 = term528;
ATprotect(&(term530));
term530 = (ATerm) ATmakeAppl(ATmakeSymbol("EntityManager", 0, ATtrue));
ATprotect(&(term531));
term531 = term530;
ATprotect(&(term532));
term532 = (ATerm) ATmakeAppl(sym_Id_1, term531);
ATprotect(&(term533));
term533 = term532;
ATprotect(&(term534));
term534 = (ATerm) ATmakeAppl(sym_TypeName_1, term533);
ATprotect(&(term535));
term535 = term534;
ATprotect(&(term536));
term536 = (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, term535, term11);
ATprotect(&(term537));
term537 = term536;
ATprotect(&(term538));
term538 = (ATerm) ATmakeAppl(ATmakeSymbol("getEM", 0, ATtrue));
ATprotect(&(term539));
term539 = term538;
ATprotect(&(term540));
term540 = (ATerm) ATmakeAppl(sym_Id_1, term539);
ATprotect(&(term541));
term541 = term540;
ATprotect(&(term542));
term542 = (ATerm) ATmakeAppl(ATmakeSymbol("emf", 0, ATtrue));
ATprotect(&(term543));
term543 = term542;
ATprotect(&(term544));
term544 = (ATerm) ATmakeAppl(sym_Id_1, term543);
ATprotect(&(term545));
term545 = term544;
ATprotect(&(term546));
term546 = (ATerm) ATmakeAppl(sym_AmbName_1, term545);
ATprotect(&(term547));
term547 = term546;
ATprotect(&(term548));
term548 = (ATerm) ATmakeAppl(ATmakeSymbol("createEntityManager", 0, ATtrue));
ATprotect(&(term549));
term549 = term548;
ATprotect(&(term550));
term550 = (ATerm) ATmakeAppl(sym_Id_1, term549);
ATprotect(&(term551));
term551 = term550;
ATprotect(&(term552));
term552 = (ATerm) ATmakeAppl(sym_MethodName_2, term547, term551);
ATprotect(&(term553));
term553 = term552;
ATprotect(&(term554));
term554 = (ATerm) ATmakeAppl(sym_Method_1, term553);
ATprotect(&(term555));
term555 = term554;
ATprotect(&(term556));
term556 = (ATerm) ATmakeAppl(sym_Invoke_2, term555, (ATerm) ATempty);
ATprotect(&(term557));
term557 = term556;
ATprotect(&(term558));
term558 = (ATerm) ATmakeAppl(sym_Some_1, term557);
ATprotect(&(term559));
term559 = term558;
ATprotect(&(term560));
term560 = (ATerm) ATmakeAppl(sym_Return_1, term559);
ATprotect(&(term561));
term561 = term560;
ATprotect(&(term562));
term562 = (ATerm) ATmakeAppl(sym_ExprName_1, term545);
ATprotect(&(term563));
term563 = term562;
ATprotect(&(term564));
term564 = (ATerm) ATmakeAppl(ATmakeSymbol("Persistence", 0, ATtrue));
ATprotect(&(term565));
term565 = term564;
ATprotect(&(term566));
term566 = (ATerm) ATmakeAppl(sym_Id_1, term565);
ATprotect(&(term567));
term567 = term566;
ATprotect(&(term568));
term568 = (ATerm) ATmakeAppl(sym_AmbName_1, term567);
ATprotect(&(term569));
term569 = term568;
ATprotect(&(term570));
term570 = (ATerm) ATmakeAppl(ATmakeSymbol("createEntityManagerFactory", 0, ATtrue));
ATprotect(&(term571));
term571 = term570;
ATprotect(&(term572));
term572 = (ATerm) ATmakeAppl(sym_Id_1, term571);
ATprotect(&(term573));
term573 = term572;
ATprotect(&(term574));
term574 = (ATerm) ATmakeAppl(sym_MethodName_2, term569, term573);
ATprotect(&(term575));
term575 = term574;
ATprotect(&(term576));
term576 = (ATerm) ATmakeAppl(sym_Method_1, term575);
ATprotect(&(term577));
term577 = term576;
ATprotect(&(term578));
term578 = (ATerm) ATmakeAppl(ATmakeSymbol("Throwable", 0, ATtrue));
ATprotect(&(term579));
term579 = term578;
ATprotect(&(term580));
term580 = (ATerm) ATmakeAppl(sym_Id_1, term579);
ATprotect(&(term581));
term581 = term580;
ATprotect(&(term582));
term582 = (ATerm) ATmakeAppl(sym_TypeName_1, term581);
ATprotect(&(term583));
term583 = term582;
ATprotect(&(term584));
term584 = (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, term583, term11);
ATprotect(&(term585));
term585 = term584;
ATprotect(&(term586));
term586 = (ATerm) ATmakeAppl(ATmakeSymbol("ex", 0, ATtrue));
ATprotect(&(term587));
term587 = term586;
ATprotect(&(term588));
term588 = (ATerm) ATmakeAppl(sym_Id_1, term587);
ATprotect(&(term589));
term589 = term588;
ATprotect(&(term590));
term590 = (ATerm) ATmakeAppl(sym_Param_3, (ATerm)ATempty, term585, term589);
ATprotect(&(term591));
term591 = term590;
ATprotect(&(term592));
term592 = (ATerm) ATmakeAppl(ATmakeSymbol("RuntimeException", 0, ATtrue));
ATprotect(&(term593));
term593 = term592;
ATprotect(&(term594));
term594 = (ATerm) ATmakeAppl(sym_Id_1, term593);
ATprotect(&(term595));
term595 = term594;
ATprotect(&(term596));
term596 = (ATerm) ATmakeAppl(sym_TypeName_1, term595);
ATprotect(&(term597));
term597 = term596;
ATprotect(&(term598));
term598 = (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, term597, term11);
ATprotect(&(term599));
term599 = term598;
ATprotect(&(term600));
term600 = (ATerm) ATmakeAppl(sym_ExprName_1, term589);
ATprotect(&(term601));
term601 = term600;
ATprotect(&(term602));
term602 = (ATerm) ATmakeAppl(ATmakeSymbol("System", 0, ATtrue));
ATprotect(&(term603));
term603 = term602;
ATprotect(&(term604));
term604 = (ATerm) ATmakeAppl(sym_Id_1, term603);
ATprotect(&(term605));
term605 = term604;
ATprotect(&(term606));
term606 = (ATerm) ATmakeAppl(sym_AmbName_1, term605);
ATprotect(&(term607));
term607 = term606;
ATprotect(&(term608));
term608 = (ATerm) ATmakeAppl(ATmakeSymbol("err", 0, ATtrue));
ATprotect(&(term609));
term609 = term608;
ATprotect(&(term610));
term610 = (ATerm) ATmakeAppl(sym_Id_1, term609);
ATprotect(&(term611));
term611 = term610;
ATprotect(&(term612));
term612 = (ATerm) ATmakeAppl(sym_AmbName_2, term607, term611);
ATprotect(&(term613));
term613 = term612;
ATprotect(&(term614));
term614 = (ATerm) ATmakeAppl(ATmakeSymbol("println", 0, ATtrue));
ATprotect(&(term615));
term615 = term614;
ATprotect(&(term616));
term616 = (ATerm) ATmakeAppl(sym_Id_1, term615);
ATprotect(&(term617));
term617 = term616;
ATprotect(&(term618));
term618 = (ATerm) ATmakeAppl(sym_MethodName_2, term613, term617);
ATprotect(&(term619));
term619 = term618;
ATprotect(&(term620));
term620 = (ATerm) ATmakeAppl(sym_Method_1, term619);
ATprotect(&(term621));
term621 = term620;
ATprotect(&(term622));
term622 = (ATerm) ATmakeAppl(ATmakeSymbol(" ===== ", 0, ATtrue));
ATprotect(&(term623));
term623 = term622;
ATprotect(&(term624));
term624 = (ATerm) ATmakeAppl(sym_Chars_1, term623);
ATprotect(&(term625));
term625 = term624;
ATprotect(&(term626));
term626 = (ATerm) ATmakeAppl(sym_AmbName_1, term589);
ATprotect(&(term627));
term627 = term626;
ATprotect(&(term628));
term628 = (ATerm) ATmakeAppl(ATmakeSymbol("printStackTrace", 0, ATtrue));
ATprotect(&(term629));
term629 = term628;
ATprotect(&(term630));
term630 = (ATerm) ATmakeAppl(sym_Id_1, term629);
ATprotect(&(term631));
term631 = term630;
ATprotect(&(term632));
term632 = (ATerm) ATmakeAppl(sym_MethodName_2, term627, term631);
ATprotect(&(term633));
term633 = term632;
ATprotect(&(term634));
term634 = (ATerm) ATmakeAppl(sym_Method_1, term633);
ATprotect(&(term635));
term635 = term634;
ATprotect(&(term636));
term636 = (ATerm) ATmakeAppl(sym_Invoke_2, term635, (ATerm) ATempty);
ATprotect(&(term637));
term637 = term636;
ATprotect(&(term638));
term638 = (ATerm) ATmakeAppl(sym_ExprStm_1, term637);
ATprotect(&(term639));
term639 = term638;
ATprotect(&(term640));
term640 = (ATerm) ATmakeAppl(ATmakeSymbol("Initial EntityManagerFactory creation failed.", 0, ATtrue));
ATprotect(&(term641));
term641 = term640;
ATprotect(&(term642));
term642 = (ATerm) ATmakeAppl(sym_Chars_1, term641);
ATprotect(&(term643));
term643 = term642;
ATprotect(&(term644));
term644 = (ATerm) ATmakeAppl(sym_Final_0);
ATprotect(&(term645));
term645 = term644;
ATprotect(&(term646));
term646 = (ATerm) ATmakeAppl(ATmakeSymbol("EntityManagerFactory", 0, ATtrue));
ATprotect(&(term647));
term647 = term646;
ATprotect(&(term648));
term648 = (ATerm) ATmakeAppl(sym_Id_1, term647);
ATprotect(&(term649));
term649 = term648;
ATprotect(&(term650));
term650 = (ATerm) ATmakeAppl(sym_TypeName_1, term649);
ATprotect(&(term651));
term651 = term650;
ATprotect(&(term652));
term652 = (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, term651, term11);
ATprotect(&(term653));
term653 = term652;
ATprotect(&(term654));
term654 = (ATerm) ATmakeAppl(sym_VarDec_1, term545);
ATprotect(&(term655));
term655 = term654;
ATprotect(&(term656));
term656 = (ATerm) ATmakeAppl(ATmakeSymbol("get", 0, ATtrue));
ATprotect(&(term657));
term657 = term656;
ATprotect(&(term658));
term658 = (ATerm) ATmakeAppl(ATmakeSymbol("set", 0, ATtrue));
ATprotect(&(term659));
term659 = term658;
ATprotect(&(term660));
term660 = (ATerm) ATmakeInt(46);
ATprotect(&(term661));
term661 = term660;
ATprotect(&(term662));
term662 = (ATerm) ATmakeAppl(ATmakeSymbol("]", 0, ATtrue));
ATprotect(&(term663));
term663 = term662;
ATprotect(&(term664));
term664 = (ATerm) ATmakeAppl(ATmakeSymbol("[", 0, ATtrue));
ATprotect(&(term665));
term665 = term664;
ATprotect(&(term666));
term666 = (ATerm) ATmakeAppl(ATmakeSymbol(".domainclasses", 0, ATtrue));
ATprotect(&(term667));
term667 = term666;
}
#include <srts/init-stratego-application.h>
ATerm None_0_0 (StrSL sl, ATerm t);
ATerm mapconcat_1_0 (StrSL sl, StrCL e_168, ATerm t);
ATerm makeConc_0_0 (StrSL sl, ATerm t);
ATerm concat_0_0 (StrSL sl, ATerm t);
ATerm fetch_elem_1_0 (StrSL sl, StrCL n_166, ATerm t);
ATerm elem_0_0 (StrSL sl, ATerm t);
ATerm map_1_0 (StrSL sl, StrCL g_166, ATerm t);
ATerm list_loop_1_0 (StrSL sl, StrCL d_166, ATerm t);
ATerm filter_1_0 (StrSL sl, StrCL k_165, ATerm t);
ATerm unzip_0_0 (StrSL sl, ATerm t);
ATerm Fst_0_0 (StrSL sl, ATerm t);
ATerm dr_add_rule_0_3 (StrSL sl, ATerm j_150, ATerm k_150, ATerm l_150, ATerm t);
ATerm dr_set_rule_0_3 (StrSL sl, ATerm d_149, ATerm f_149, ATerm g_149, ATerm t);
ATerm dr_lookup_rule_0_2 (StrSL sl, ATerm w_148, ATerm x_148, ATerm t);
ATerm dr_scope_1_1 (StrSL sl, StrCL d_148, ATerm c_148, ATerm t);
ATerm collect_all_1_0 (StrSL sl, StrCL r_146, ATerm t);
ATerm try_1_0 (StrSL sl, StrCL w_145, ATerm t);
ATerm alltd_1_0 (StrSL sl, StrCL j_136, ATerm t);
ATerm topdown_1_0 (StrSL sl, StrCL q_133, ATerm t);
ATerm read_text_file_0_0 (StrSL sl, ATerm t);
ATerm fputs_0_0 (StrSL sl, ATerm t);
ATerm fclose_0_0 (StrSL sl, ATerm t);
ATerm fopen_0_0 (StrSL sl, ATerm t);
ATerm say_1_0 (StrSL sl, StrCL c_131, ATerm t);
ATerm debug_1_0 (StrSL sl, StrCL y_130, ATerm t);
ATerm to_upper_0_0 (StrSL sl, ATerm t);
ATerm string_tokenize_0_1 (StrSL sl, ATerm a_128, ATerm t);
ATerm concat_strings_0_0 (StrSL sl, ATerm t);
ATerm conc_strings_0_0 (StrSL sl, ATerm t);
ATerm explode_string_0_0 (StrSL sl, ATerm t);
ATerm implode_string_0_0 (StrSL sl, ATerm t);
ATerm new_0_0 (StrSL sl, ATerm t);
ATerm set_config_0_0 (StrSL sl, ATerm t);
ATerm get_config_0_0 (StrSL sl, ATerm t);
ATerm input_options_0_0 (StrSL sl, ATerm t);
ATerm option_wrap_5_0 (StrSL sl, StrCL x_124, StrCL y_124, StrCL z_124, StrCL a_125, StrCL b_125, ATerm t);
ATerm ArgOption_3_0 (StrSL sl, StrCL o_120, StrCL p_120, StrCL q_120, ATerm t);
ATerm err_msg_0_1 (StrSL sl, ATerm y_118, ATerm t);
ATerm fatal_err_msg_0_1 (StrSL sl, ATerm x_118, ATerm t);
ATerm fatal_err_0_1 (StrSL sl, ATerm r_118, ATerm t);
ATerm mkdir_0_1 (StrSL sl, ATerm z_112, ATerm t);
ATerm chdir_0_0 (StrSL sl, ATerm t);
ATerm getcwd_0_0 (StrSL sl, ATerm t);
ATerm file_exists_0_0 (StrSL sl, ATerm t);
ATerm xtc_check_dependencies_0_0 (StrSL sl, ATerm t);
ATerm xtc_input_1_0 (StrSL sl, StrCL s_109, ATerm t);
ATerm write_to_0_0 (StrSL sl, ATerm t);
ATerm xtc_transform_1_0 (StrSL sl, StrCL u_108, ATerm t);
ATerm read_from_0_0 (StrSL sl, ATerm t);
ATerm tool_doc_0_0 (StrSL sl, ATerm t);
ATerm aux_Package_0_1 (StrSL sl, ATerm x_38, ATerm t);
static ATerm lifted36 (StrSL sl, ATerm t);
ATerm Package_0_0 (StrSL sl, ATerm t);
ATerm aux_TypeError_0_1 (StrSL sl, ATerm d_39, ATerm t);
static ATerm lifted35 (StrSL sl, ATerm t);
ATerm bagof_TypeError_0_0 (StrSL sl, ATerm t);
ATerm pkg_to_dirlist_0_0 (StrSL sl, ATerm t);
ATerm setter_0_0 (StrSL sl, ATerm t);
ATerm getter_0_0 (StrSL sl, ATerm t);
ATerm first_to_upper_0_0 (StrSL sl, ATerm t);
ATerm persistence_helper_0_0 (StrSL sl, ATerm t);
ATerm member_to_classbodydecs_0_0 (StrSL sl, ATerm t);
ATerm member_to_formalparams_and_assign_0_0 (StrSL sl, ATerm t);
ATerm conceptdecl_to_class_0_0 (StrSL sl, ATerm t);
ATerm domainmodel_to_jpa_0_0 (StrSL sl, ATerm t);
ATerm DomainName_0_0 (StrSL sl, ATerm t);
ATerm Desugar_0_0 (StrSL sl, ATerm t);
static ATerm lifted29 (StrSL sl, ATerm t);
ATerm desugar_0_0 (StrSL sl, ATerm t);
static ATerm lifted28 (StrSL sl, ATerm t);
static ATerm lifted27 (StrSL sl, ATerm t);
ATerm domainmodel_to_jpa_xml_0_1 (StrSL sl, ATerm j_15, ATerm t);
ATerm output_class_0_0 (StrSL sl, ATerm t);
static ATerm lifted25 (StrSL sl, ATerm t);
static ATerm lifted24 (StrSL sl, ATerm t);
static ATerm lifted23 (StrSL sl, ATerm t);
static ATerm lifted21 (StrSL sl, ATerm t);
ATerm main_0_0 (StrSL sl, ATerm t);
static ATerm lifted20 (StrSL sl, ATerm t);
ATerm create_dirs_0_0 (StrSL sl, ATerm t);
static ATerm lifted19 (StrSL sl, ATerm t);
static ATerm lifted18 (StrSL sl, ATerm t);
static ATerm lifted17 (StrSL sl, ATerm t);
ATerm create_file_0_4 (StrSL sl, ATerm o_10, ATerm p_10, ATerm q_10, ATerm r_10, ATerm t);
ATerm dmdsl_about_0_0 (StrSL sl, ATerm t);
ATerm dmdsl_usage_0_0 (StrSL sl, ATerm t);
static ATerm lifted16 (StrSL sl, ATerm t);
static ATerm lifted15 (StrSL sl, ATerm t);
static ATerm lifted14 (StrSL sl, ATerm t);
static ATerm lifted13 (StrSL sl, ATerm t);
static ATerm lifted12 (StrSL sl, ATerm t);
static ATerm lifted11 (StrSL sl, ATerm t);
ATerm dmdsl_options_0_0 (StrSL sl, ATerm t);
static ATerm lifted10 (StrSL sl, ATerm t);
static ATerm lifted6 (StrSL sl, ATerm t);
ATerm xtc_input_wrap_custom_1_0 (StrSL sl, StrCL g_10, ATerm t);
ATerm Class_0_0 (StrSL sl, ATerm t);
ATerm create_jpa_config_0_1 (StrSL sl, ATerm n_9, ATerm t);
ATerm create_err_msg_0_4 (StrSL sl, ATerm i_9, ATerm j_9, ATerm l_9, ATerm m_9, ATerm t);
ATerm check_concept_0_2 (StrSL sl, ATerm b_39, ATerm c_39, ATerm t);
static ATerm lifted4 (StrSL sl, ATerm t);
static ATerm lifted3 (StrSL sl, ATerm t);
ATerm check_concept_decl_0_1 (StrSL sl, ATerm b_6, ATerm t);
static ATerm lifted0 (StrSL sl, ATerm t);
static ATerm lifted2 (StrSL sl, ATerm t);
ATerm def_use_check_0_0 (StrSL sl, ATerm t);
ATerm string2javaref_0_0 (StrSL sl, ATerm t);
ATerm native2java_0_0 (StrSL sl, ATerm t);
ATerm is_NativeType_0_0 (StrSL sl, ATerm t);
ATerm extract_type_0_0 (StrSL sl, ATerm t);
ATerm annotate_with_type_0_0 (StrSL sl, ATerm t);
ATerm aux_Package_0_1 (StrSL sl, ATerm x_38, ATerm t)
{
sl_decl(sl);
{
ATerm y_38 = NULL,z_38 = NULL,a_39 = NULL;
if(match_cons(t, sym__3))
{
ATerm trm46 = ATgetArgument(t, 0);
if(!((ATgetSymbol(trm46) == ATmakeSymbol("8dbf9365c4dc66f6f55631d9ae0554ea", 0, ATtrue))))
goto fail60 ;
y_38 = ATgetArgument(t, 1);
z_38 = ATgetArgument(t, 2);
}
else
goto fail60 ;
a_39 = t;
t = x_38;
t = a_39;
t = (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATempty, term667), z_38), term327), y_38);
t = concat_strings_0_0(sl, t);
if((t == NULL))
goto fail60 ;
}
return(t);
fail60 :
return(NULL);
}
ATerm Package_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
sl_vars(1);
{
ATerm o_38 = NULL,r_38 = NULL,s_38 = NULL,t_38 = NULL,u_38 = NULL,v_38 = NULL,w_38 = NULL;
sl_init_var(0, o_38);
{
struct str_closure d_200 = { &(lifted36) , &(frame) };
StrCL lifted36_cl = &(d_200);
if((o_38 == NULL))
{
o_38 = t;
}
else
if((o_38 != t))
goto fail58 ;
s_38 = t;
v_38 = t;
t = term311;
t_38 = t;
t = v_38;
w_38 = t;
t = (ATerm) ATinsert(ATempty, term21);
u_38 = t;
t = w_38;
t = dr_lookup_rule_0_2(sl, t_38, u_38, t);
if((t == NULL))
goto fail58 ;
r_38 = t;
t = s_38;
t = r_38;
t = fetch_elem_1_0(sl, lifted36_cl, t);
if((t == NULL))
goto fail58 ;
}
}
return(t);
fail58 :
return(NULL);
}
static ATerm lifted36 (StrSL sl, ATerm t)
{
sl_decl(sl);
if((sl_readvar(0, sl) == NULL))
goto fail59 ;
else
{
t = aux_Package_0_1(sl_up(sl), sl_readvar(0, sl), t);
if((t == NULL))
goto fail59 ;
}
return(t);
fail59 :
return(NULL);
}
ATerm aux_TypeError_0_1 (StrSL sl, ATerm d_39, ATerm t)
{
sl_decl(sl);
{
ATerm trm43 = t;
ATerm p_34 = NULL,q_34 = NULL,r_34 = NULL,s_34 = NULL,v_34 = NULL,w_34 = NULL;
if(match_cons(t, sym__4))
{
ATerm trm44 = ATgetArgument(t, 0);
if(!((ATgetSymbol(trm44) == ATmakeSymbol("e95f9c33fb2770e7ee60aace2903edc4", 0, ATtrue))))
goto label40 ;
p_34 = ATgetArgument(t, 1);
q_34 = ATgetArgument(t, 2);
r_34 = ATgetArgument(t, 3);
}
else
goto label40 ;
s_34 = t;
t = d_39;
t = s_34;
w_34 = t;
t = create_err_msg_0_4(sl, p_34, q_34, r_34, r_34, t);
if((t == NULL))
goto label40 ;
v_34 = t;
t = w_34;
t = v_34;
goto label39 ;
label40 :
t = trm43;
{
ATerm e_34 = NULL,f_34 = NULL,g_34 = NULL,h_34 = NULL,k_34 = NULL,l_34 = NULL,m_34 = NULL,n_34 = NULL;
if(match_cons(t, sym__4))
{
ATerm trm45 = ATgetArgument(t, 0);
if(!((ATgetSymbol(trm45) == ATmakeSymbol("e1bbb8f5381f255a5424a06951e36ed7", 0, ATtrue))))
goto fail57 ;
e_34 = ATgetArgument(t, 1);
f_34 = ATgetArgument(t, 2);
g_34 = ATgetArgument(t, 3);
}
else
goto fail57 ;
h_34 = t;
t = d_39;
t = h_34;
l_34 = t;
n_34 = t;
t = (ATerm) ATinsert(ATinsert(ATinsert(ATempty, term663), g_34), term665);
t = concat_strings_0_0(sl, t);
if((t == NULL))
goto fail57 ;
m_34 = t;
t = n_34;
t = create_err_msg_0_4(sl, e_34, f_34, m_34, g_34, t);
if((t == NULL))
goto fail57 ;
k_34 = t;
t = l_34;
t = k_34;
goto label39 ;
}
label39 :
;
}
return(t);
fail57 :
return(NULL);
}
ATerm bagof_TypeError_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
sl_vars(1);
{
ATerm g_30 = NULL,h_30 = NULL,i_30 = NULL;
sl_init_var(0, g_30);
{
struct str_closure c_200 = { &(lifted35) , &(frame) };
StrCL lifted35_cl = &(c_200);
if((g_30 == NULL))
{
g_30 = t;
}
else
if((g_30 != t))
goto fail55 ;
i_30 = t;
{
ATerm trm42 = t;
ATerm q_33 = NULL,r_33 = NULL,s_33 = NULL,t_33 = NULL;
s_33 = t;
t = term19;
q_33 = t;
t = s_33;
t_33 = t;
t = (ATerm) ATinsert(ATempty, term21);
r_33 = t;
t = t_33;
t = dr_lookup_rule_0_2(sl, q_33, r_33, t);
if((t == NULL))
goto label38 ;
goto label37 ;
label38 :
t = trm42;
t = (ATerm) ATempty;
goto label37 ;
label37 :
;
h_30 = t;
t = i_30;
t = h_30;
t = filter_1_0(sl, lifted35_cl, t);
if((t == NULL))
goto fail55 ;
}
}
}
return(t);
fail55 :
return(NULL);
}
static ATerm lifted35 (StrSL sl, ATerm t)
{
sl_decl(sl);
if((sl_readvar(0, sl) == NULL))
goto fail56 ;
else
{
t = aux_TypeError_0_1(sl_up(sl), sl_readvar(0, sl), t);
if((t == NULL))
goto fail56 ;
}
return(t);
fail56 :
return(NULL);
}
ATerm pkg_to_dirlist_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm h_23 = NULL,l_23 = NULL;
t = Package_0_0(sl, t);
if((t == NULL))
goto fail54 ;
l_23 = t;
t = (ATerm) ATinsert(ATempty, term661);
h_23 = t;
t = l_23;
t = string_tokenize_0_1(sl, h_23, t);
if((t == NULL))
goto fail54 ;
}
return(t);
fail54 :
return(NULL);
}
ATerm setter_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm a_23 = NULL,d_23 = NULL,g_23 = NULL;
a_23 = t;
g_23 = t;
t = a_23;
t = first_to_upper_0_0(sl, t);
if((t == NULL))
goto fail53 ;
d_23 = t;
t = g_23;
t = (ATerm) ATinsert(ATinsert(ATempty, d_23), term659);
t = concat_strings_0_0(sl, t);
if((t == NULL))
goto fail53 ;
}
return(t);
fail53 :
return(NULL);
}
ATerm getter_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm x_22 = NULL,y_22 = NULL,z_22 = NULL;
x_22 = t;
z_22 = t;
t = x_22;
t = first_to_upper_0_0(sl, t);
if((t == NULL))
goto fail52 ;
y_22 = t;
t = z_22;
t = (ATerm) ATinsert(ATinsert(ATempty, y_22), term657);
t = concat_strings_0_0(sl, t);
if((t == NULL))
goto fail52 ;
}
return(t);
fail52 :
return(NULL);
}
ATerm first_to_upper_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = explode_string_0_0(sl, t);
if((t == NULL))
goto fail51 ;
{
struct str_closure b_200 = { &(to_upper_0_0) , sl };
StrCL lifted34_cl = &(b_200);
t = SRTS_one(sl, lifted34_cl, t);
if((t == NULL))
goto fail51 ;
t = implode_string_0_0(sl, t);
if((t == NULL))
goto fail51 ;
}
return(t);
fail51 :
return(NULL);
}
ATerm persistence_helper_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm n_22 = NULL,o_22 = NULL,p_22 = NULL,u_22 = NULL;
n_22 = t;
o_22 = t;
u_22 = t;
t = Package_0_0(sl, t);
if((t == NULL))
goto fail50 ;
p_22 = t;
t = u_22;
t = (ATerm) ATmakeAppl(sym_CompilationUnit_3, (ATerm)ATmakeAppl(sym_Some_1, (ATerm) ATmakeAppl(sym_PackageDec_2, (ATerm)ATempty, (ATerm) ATmakeAppl(sym_PackageName_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Id_1, p_22))))), (ATerm)ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_TypeImportOnDemandDec_1, (ATerm) ATmakeAppl(sym_PackageName_1, (ATerm) ATinsert(ATinsert(ATempty, term337), term341)))), (ATerm) ATmakeAppl(sym_TypeImportOnDemandDec_1, (ATerm) ATmakeAppl(sym_PackageName_1, (ATerm) ATinsert(ATinsert(ATempty, term345), term349)))), (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ClassDec_2, (ATerm)ATmakeAppl(sym_ClassDecHead_5, (ATerm)ATinsert(ATempty, term351), term527, term11, term11, term11), (ATerm) ATmakeAppl(sym_ClassBody_1, (ATerm) ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATinsert(ATempty, term529), term351), term11, term537, term541, (ATerm)ATempty, term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, term561)))), (ATerm) ATmakeAppl(sym_StaticInit_1, (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Try_2, (ATerm)ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Assign_2, term563, (ATerm) ATmakeAppl(sym_Invoke_2, term577, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Lit_1, (ATerm) ATmakeAppl(sym_String_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Chars_1, n_22)))))))))), (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Catch_2, term591, (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Throw_1, (ATerm) ATmakeAppl(sym_NewInstance_4, term11, term599, (ATerm)ATinsert(ATempty, term601), term11))), (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Invoke_2, term621, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Lit_1, (ATerm) ATmakeAppl(sym_String_1, (ATerm) ATinsert(ATempty, term625))))))), term639), (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Invoke_2, term621, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Lit_1, (ATerm) ATmakeAppl(sym_String_1, (ATerm) ATinsert(ATempty, term625))))))), (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Invoke_2, term621, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Plus_2, (ATerm)ATmakeAppl(sym_Lit_1, (ATerm) ATmakeAppl(sym_String_1, (ATerm) ATinsert(ATempty, term643))), term601))))))))))))), (ATerm) ATmakeAppl(sym_FieldDec_3, (ATerm)ATinsert(ATinsert(ATinsert(ATempty, term645), term529), term465), term653, (ATerm) ATinsert(ATempty, term655)))))));
}
return(t);
fail50 :
return(NULL);
}
ATerm member_to_classbodydecs_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm33 = t;
ATerm q_21 = NULL,v_21 = NULL,y_21 = NULL,z_21 = NULL,g_22 = NULL,h_22 = NULL,k_22 = NULL;
if(match_cons(t, sym_Concept_2))
{
v_21 = ATgetArgument(t, 0);
{
ATerm trm34 = ATgetArgument(t, 1);
ATerm trm35;
trm35 = (ATerm) ATgetAnnotations(trm34);
if((trm35 == NULL))
trm35 = (ATerm) ATempty;
if(match_cons(trm34, sym_SimpleConcept_1))
{
ATerm trm36 = ATgetArgument(trm34, 0);
}
else
goto label34 ;
if(((ATgetType(trm35) == AT_LIST) && !(ATisEmpty(trm35))))
{
g_22 = ATgetFirst((ATermList) trm35);
{
ATerm trm37 = (ATerm) ATgetNext((ATermList) trm35);
if(!(((ATgetType(trm37) == AT_LIST) && ATisEmpty(trm37))))
goto label34 ;
}
}
else
goto label34 ;
}
}
else
goto label34 ;
k_22 = t;
t = v_21;
t = getter_0_0(sl, t);
if((t == NULL))
goto label34 ;
q_21 = t;
t = v_21;
t = setter_0_0(sl, t);
if((t == NULL))
goto label34 ;
y_21 = t;
t = g_22;
t = extract_type_0_0(sl, t);
if((t == NULL))
goto label34 ;
z_21 = t;
t = g_22;
{
ATerm trm38 = t;
ATerm i_22 = NULL;
i_22 = t;
t = is_NativeType_0_0(sl, t);
if((t == NULL))
goto label36 ;
t = i_22;
t = term477;
goto label35 ;
label36 :
t = trm38;
t = (ATerm) ATmakeAppl(sym_Anno_2, term483, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ElemValPair_2, term487, (ATerm) ATmakeAppl(sym_ElemValArrayInit_1, (ATerm) ATinsert(ATinsert(ATempty, term499), term505)))));
goto label35 ;
label35 :
;
h_22 = t;
t = k_22;
t = (ATerm) ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATempty, term351), term11, term363, (ATerm)ATmakeAppl(sym_Id_1, y_21), (ATerm)ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Param_3, (ATerm)ATempty, z_21, (ATerm) ATmakeAppl(sym_Id_1, v_21))), term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Assign_2, (ATerm)ATmakeAppl(sym_Field_2, term377, (ATerm) ATmakeAppl(sym_Id_1, v_21)), (ATerm) ATmakeAppl(sym_ExprName_1, (ATerm) ATmakeAppl(sym_Id_1, v_21)))))))), (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATinsert(ATempty, term351), h_22), term11, z_21, (ATerm)ATmakeAppl(sym_Id_1, q_21), (ATerm)ATempty, term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Return_1, (ATerm) ATmakeAppl(sym_Some_1, (ATerm) ATmakeAppl(sym_ExprName_1, (ATerm) ATmakeAppl(sym_Id_1, v_21)))))))), (ATerm) ATmakeAppl(sym_FieldDec_3, (ATerm)ATinsert(ATempty, term465), z_21, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_VarDec_1, (ATerm) ATmakeAppl(sym_Id_1, v_21)))));
}
goto label33 ;
label34 :
t = trm33;
{
ATerm z_18 = NULL,a_19 = NULL,g_19 = NULL,s_19 = NULL,t_19 = NULL,w_19 = NULL,l_20 = NULL,o_20 = NULL,y_20 = NULL,a_21 = NULL,m_21 = NULL;
if(match_cons(t, sym_Concept_2))
{
s_19 = ATgetArgument(t, 0);
{
ATerm trm39 = ATgetArgument(t, 1);
ATerm trm40;
trm40 = (ATerm) ATgetAnnotations(trm39);
if((trm40 == NULL))
trm40 = (ATerm) ATempty;
if(match_cons(trm39, sym_CollectionConcept_1))
{
z_18 = ATgetArgument(trm39, 0);
}
else
goto fail49 ;
if(((ATgetType(trm40) == AT_LIST) && !(ATisEmpty(trm40))))
{
w_19 = ATgetFirst((ATermList) trm40);
{
ATerm trm41 = (ATerm) ATgetNext((ATermList) trm40);
if(!(((ATgetType(trm41) == AT_LIST) && ATisEmpty(trm41))))
goto fail49 ;
}
}
else
goto fail49 ;
}
}
else
goto fail49 ;
y_20 = t;
t = s_19;
t = getter_0_0(sl, t);
if((t == NULL))
goto fail49 ;
a_19 = t;
t = s_19;
t = setter_0_0(sl, t);
if((t == NULL))
goto fail49 ;
g_19 = t;
m_21 = t;
t = s_19;
t = first_to_upper_0_0(sl, t);
if((t == NULL))
goto fail49 ;
a_21 = t;
t = m_21;
t = (ATerm) ATinsert(ATinsert(ATempty, a_21), term507);
t = concat_strings_0_0(sl, t);
if((t == NULL))
goto fail49 ;
t_19 = t;
t = w_19;
t = extract_type_0_0(sl, t);
if((t == NULL))
goto fail49 ;
l_20 = t;
t = term509;
t = new_0_0(sl, t);
if((t == NULL))
goto fail49 ;
o_20 = t;
t = y_20;
t = (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATempty, term351), term11, term363, (ATerm)ATmakeAppl(sym_Id_1, t_19), (ATerm)ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Param_3, (ATerm)ATempty, (ATerm)ATmakeAppl(sym_ClassOrInterfaceType_2, (ATerm)ATmakeAppl(sym_TypeName_1, (ATerm) ATmakeAppl(sym_Id_1, z_18)), term11), (ATerm) ATmakeAppl(sym_Id_1, o_20))), term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Invoke_2, (ATerm)ATmakeAppl(sym_Method_3, (ATerm)ATmakeAppl(sym_Field_2, term377, (ATerm) ATmakeAppl(sym_Id_1, s_19)), term11, term511), (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ExprName_1, (ATerm) ATmakeAppl(sym_Id_1, o_20))))))))), (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATempty, term351), term11, term363, (ATerm)ATmakeAppl(sym_Id_1, g_19), (ATerm)ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Param_3, (ATerm)ATempty, l_20, (ATerm) ATmakeAppl(sym_Id_1, s_19))), term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Assign_2, (ATerm)ATmakeAppl(sym_Field_2, term377, (ATerm) ATmakeAppl(sym_Id_1, s_19)), (ATerm) ATmakeAppl(sym_ExprName_1, (ATerm) ATmakeAppl(sym_Id_1, s_19)))))))), (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATinsert(ATempty, term351), (ATerm) ATmakeAppl(sym_Anno_2, term517, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ElemValPair_2, term487, (ATerm) ATmakeAppl(sym_ElemValArrayInit_1, (ATerm) ATinsert(ATinsert(ATempty, term499), term505)))))), term11, l_20, (ATerm)ATmakeAppl(sym_Id_1, a_19), (ATerm)ATempty, term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Return_1, (ATerm) ATmakeAppl(sym_Some_1, (ATerm) ATmakeAppl(sym_ExprName_1, (ATerm) ATmakeAppl(sym_Id_1, s_19)))))))), (ATerm) ATmakeAppl(sym_FieldDec_3, (ATerm)ATinsert(ATempty, term465), l_20, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_VarDec_2, (ATerm)ATmakeAppl(sym_Id_1, s_19), (ATerm) ATmakeAppl(sym_NewInstance_4, term11, (ATerm)ATmakeAppl(sym_ClassOrInterfaceType_2, term523, (ATerm) ATmakeAppl(sym_Some_1, (ATerm) ATmakeAppl(sym_TypeArgs_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, (ATerm)ATmakeAppl(sym_TypeName_1, (ATerm) ATmakeAppl(sym_Id_1, z_18)), term11))))), (ATerm)ATempty, term11)))));
goto label33 ;
}
label33 :
;
}
return(t);
fail49 :
return(NULL);
}
ATerm member_to_formalparams_and_assign_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm s_18 = NULL,t_18 = NULL,u_18 = NULL,v_18 = NULL;
if(match_cons(t, sym_Concept_2))
{
s_18 = ATgetArgument(t, 0);
{
ATerm trm30 = ATgetArgument(t, 1);
ATerm trm31;
trm31 = (ATerm) ATgetAnnotations(trm30);
if((trm31 == NULL))
trm31 = (ATerm) ATempty;
if(((ATgetType(trm31) == AT_LIST) && !(ATisEmpty(trm31))))
{
t_18 = ATgetFirst((ATermList) trm31);
{
ATerm trm32 = (ATerm) ATgetNext((ATermList) trm31);
if(!(((ATgetType(trm32) == AT_LIST) && ATisEmpty(trm32))))
goto fail48 ;
}
}
else
goto fail48 ;
}
}
else
goto fail48 ;
v_18 = t;
t = t_18;
t = extract_type_0_0(sl, t);
if((t == NULL))
goto fail48 ;
u_18 = t;
t = v_18;
t = (ATerm) ATmakeAppl(sym__2, (ATerm)ATmakeAppl(sym_Param_3, (ATerm)ATempty, u_18, (ATerm) ATmakeAppl(sym_Id_1, s_18)), (ATerm) ATmakeAppl(sym_ExprStm_1, (ATerm) ATmakeAppl(sym_Assign_2, (ATerm)ATmakeAppl(sym_Field_2, term377, (ATerm) ATmakeAppl(sym_Id_1, s_18)), (ATerm) ATmakeAppl(sym_ExprName_1, (ATerm) ATmakeAppl(sym_Id_1, s_18)))));
}
return(t);
fail48 :
return(NULL);
}
ATerm conceptdecl_to_class_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm m_17 = NULL,n_17 = NULL,x_17 = NULL,y_17 = NULL,z_17 = NULL,a_18 = NULL,e_18 = NULL,f_18 = NULL;
if(match_cons(t, sym_ConceptDecl_2))
{
m_17 = ATgetArgument(t, 0);
x_17 = ATgetArgument(t, 1);
}
else
goto fail47 ;
a_18 = t;
t = x_17;
{
ATerm trm28 = t;
struct str_closure y_199 = { &(member_to_classbodydecs_0_0) , sl };
StrCL lifted32_cl = &(y_199);
t = mapconcat_1_0(sl, lifted32_cl, t);
if((t == NULL))
goto label32 ;
goto label31 ;
label32 :
t = trm28;
t = (ATerm) ATempty;
goto label31 ;
label31 :
;
n_17 = t;
t = x_17;
{
struct str_closure z_199 = { &(member_to_formalparams_and_assign_0_0) , sl };
StrCL lifted33_cl = &(z_199);
t = map_1_0(sl, lifted33_cl, t);
if((t == NULL))
goto fail47 ;
t = unzip_0_0(sl, t);
if((t == NULL))
goto fail47 ;
if(match_cons(t, sym__2))
{
y_17 = ATgetArgument(t, 0);
z_17 = ATgetArgument(t, 1);
}
else
goto fail47 ;
t = a_18;
f_18 = t;
t = Package_0_0(sl, t);
if((t == NULL))
goto fail47 ;
e_18 = t;
t = f_18;
{
ATerm trm29;
trm29 = CheckATermList(n_17);
if((trm29 == NULL))
goto fail47 ;
t = (ATerm) ATmakeAppl(sym__2, m_17, (ATerm) ATmakeAppl(sym_CompilationUnit_3, (ATerm)ATmakeAppl(sym_Some_1, (ATerm) ATmakeAppl(sym_PackageDec_2, (ATerm)ATempty, (ATerm) ATmakeAppl(sym_PackageName_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Id_1, e_18))))), (ATerm)ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_TypeImportOnDemandDec_1, (ATerm) ATmakeAppl(sym_PackageName_1, (ATerm) ATinsert(ATinsert(ATempty, term337), term341)))), (ATerm) ATmakeAppl(sym_TypeImportOnDemandDec_1, (ATerm) ATmakeAppl(sym_PackageName_1, (ATerm) ATinsert(ATinsert(ATempty, term345), term349)))), (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ClassDec_2, (ATerm)ATmakeAppl(sym_ClassDecHead_5, (ATerm)ATinsert(ATinsert(ATempty, term351), term359), (ATerm)ATmakeAppl(sym_Id_1, m_17), term11, term11, term11), (ATerm) ATmakeAppl(sym_ClassBody_1, (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert((ATermList)trm29, (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATempty, term361), term11, term363, term367, (ATerm)ATinsert(ATempty, term375), term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, term385)))), (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATinsert(ATinsert(ATempty, term361), (ATerm) ATmakeAppl(sym_Anno_2, term391, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ElemValPair_2, term393, (ATerm) ATmakeAppl(sym_Lit_1, (ATerm) ATmakeAppl(sym_String_1, (ATerm) ATinsert(ATempty, term397))))))), term405), term11, term369, term409, (ATerm)ATempty, term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, term413)))), (ATerm) ATmakeAppl(sym_FieldDec_3, (ATerm)ATempty, term369, (ATerm) ATinsert(ATempty, term415))), (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATempty, term351), term11, term363, term419, (ATerm)ATinsert(ATempty, term431), term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, term439)))), (ATerm) ATmakeAppl(sym_MethodDec_2, (ATerm)ATmakeAppl(sym_MethodDecHead_6, (ATerm)ATinsert(ATinsert(ATinsert(ATempty, term351), term447), term455), term11, term425, term459, (ATerm)ATempty, term11), (ATerm) ATmakeAppl(sym_Block_1, (ATerm) ATinsert(ATempty, term463)))), (ATerm) ATmakeAppl(sym_FieldDec_3, (ATerm)ATinsert(ATempty, term465), term425, (ATerm) ATinsert(ATempty, term467))), (ATerm) ATmakeAppl(sym_ConstrDec_2, (ATerm)ATmakeAppl(sym_ConstrDecHead_5, (ATerm)ATinsert(ATempty, term351), term11, (ATerm)ATmakeAppl(sym_Id_1, m_17), y_17, term11), (ATerm) ATmakeAppl(sym_ConstrBody_2, term11, z_17))), (ATerm) ATmakeAppl(sym_ConstrDec_2, (ATerm)ATmakeAppl(sym_ConstrDecHead_5, (ATerm)ATinsert(ATempty, term351), term11, (ATerm)ATmakeAppl(sym_Id_1, m_17), (ATerm)ATempty, term11), term469)))))));
}
}
}
}
return(t);
fail47 :
return(NULL);
}
ATerm domainmodel_to_jpa_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm g_17 = NULL,h_17 = NULL,l_17 = NULL;
struct str_closure x_199 = { &(conceptdecl_to_class_0_0) , sl };
StrCL lifted31_cl = &(x_199);
if(match_cons(t, sym_Domain_2))
{
g_17 = ATgetArgument(t, 0);
h_17 = ATgetArgument(t, 1);
}
else
goto fail46 ;
l_17 = t;
t = h_17;
t = map_1_0(sl, lifted31_cl, t);
if((t == NULL))
goto fail46 ;
}
return(t);
fail46 :
return(NULL);
}
ATerm DomainName_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm b_17 = NULL,c_17 = NULL;
if(match_cons(t, sym_Domain_2))
{
b_17 = ATgetArgument(t, 0);
{
ATerm trm27 = ATgetArgument(t, 1);
}
}
else
goto fail45 ;
c_17 = t;
t = b_17;
}
return(t);
fail45 :
return(NULL);
}
ATerm Desugar_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm z_16 = NULL,a_17 = NULL;
if(match_cons(t, sym_SimpleAnnotation_1))
{
z_16 = ATgetArgument(t, 0);
}
else
goto fail44 ;
a_17 = t;
t = (ATerm) ATmakeAppl(sym_ParameterizedAnnotation_2, z_16, (ATerm) ATempty);
}
return(t);
fail44 :
return(NULL);
}
ATerm desugar_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
struct str_closure w_199 = { &(lifted29) , &(frame) };
StrCL lifted29_cl = &(w_199);
t = topdown_1_0(sl, lifted29_cl, t);
if((t == NULL))
goto fail42 ;
}
return(t);
fail42 :
return(NULL);
}
static ATerm lifted29 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
struct str_closure v_199 = { &(Desugar_0_0) , sl_up(sl) };
StrCL lifted30_cl = &(v_199);
t = try_1_0(sl_up(sl), lifted30_cl, t);
if((t == NULL))
goto fail43 ;
}
return(t);
fail43 :
return(NULL);
}
ATerm domainmodel_to_jpa_xml_0_1 (StrSL sl, ATerm j_15, ATerm t)
{
sl_decl(sl);
{
ATerm q_15 = NULL,r_15 = NULL,s_15 = NULL,t_15 = NULL,u_15 = NULL,v_15 = NULL,e_16 = NULL,f_16 = NULL,l_16 = NULL,m_16 = NULL;
struct str_closure t_199 = { &(lifted27) , &(frame) };
StrCL lifted27_cl = &(t_199);
t = filter_1_0(sl, lifted27_cl, t);
if((t == NULL))
goto fail39 ;
{
struct str_closure u_199 = { &(lifted28) , &(frame) };
StrCL lifted28_cl = &(u_199);
t = debug_1_0(sl, lifted28_cl, t);
if((t == NULL))
goto fail39 ;
t = create_jpa_config_0_1(sl, j_15, t);
if((t == NULL))
goto fail39 ;
u_15 = t;
t = term331;
q_15 = t;
t = u_15;
v_15 = t;
t = (ATerm) ATinsert(ATempty, term333);
r_15 = t;
t = v_15;
e_16 = t;
t = term335;
s_15 = t;
t = e_16;
f_16 = t;
m_16 = t;
l_16 = t;
t = m_16;
t = l_16;
t_15 = t;
t = f_16;
t = create_file_0_4(sl, q_15, r_15, s_15, t_15, t);
if((t == NULL))
goto fail39 ;
}
}
return(t);
fail39 :
return(NULL);
}
static ATerm lifted28 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = term329;
return(t);
fail41 :
return(NULL);
}
static ATerm lifted27 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm l_15 = NULL,o_15 = NULL,m_15 = NULL,p_15 = NULL;
t = Fst_0_0(sl_up(sl), t);
if((t == NULL))
goto fail40 ;
o_15 = t;
t = Package_0_0(sl_up(sl), t);
if((t == NULL))
goto fail40 ;
l_15 = t;
t = o_15;
p_15 = t;
m_15 = t;
t = p_15;
t = (ATerm) ATinsert(ATinsert(ATinsert(ATempty, m_15), term327), l_15);
t = concat_strings_0_0(sl_up(sl), t);
if((t == NULL))
goto fail40 ;
}
return(t);
fail40 :
return(NULL);
}
ATerm output_class_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm y_14 = NULL,z_14 = NULL,a_15 = NULL,b_15 = NULL,d_15 = NULL,e_15 = NULL,f_15 = NULL,g_15 = NULL,h_15 = NULL;
if(match_cons(t, sym__2))
{
z_14 = ATgetArgument(t, 0);
a_15 = ATgetArgument(t, 1);
}
else
goto fail38 ;
d_15 = t;
t = pkg_to_dirlist_0_0(sl, t);
if((t == NULL))
goto fail38 ;
b_15 = t;
t = d_15;
t = b_15;
y_14 = t;
g_15 = t;
t = term319;
e_15 = t;
t = g_15;
h_15 = t;
t = (ATerm) ATmakeAppl(sym__2, z_14, term325);
t = conc_strings_0_0(sl, t);
if((t == NULL))
goto fail38 ;
f_15 = t;
t = h_15;
t = create_file_0_4(sl, e_15, y_14, f_15, a_15, t);
if((t == NULL))
goto fail38 ;
}
return(t);
fail38 :
return(NULL);
}
ATerm main_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
sl_vars(3);
{
ATerm n_12 = NULL,o_12 = NULL,p_12 = NULL;
sl_init_var(0, n_12);
sl_init_var(1, o_12);
sl_init_var(2, p_12);
{
struct str_closure s_199 = { &(lifted21) , &(frame) };
StrCL lifted21_cl = &(s_199);
t = xtc_input_wrap_custom_1_0(sl, lifted21_cl, t);
if((t == NULL))
goto fail33 ;
}
}
return(t);
fail33 :
return(NULL);
}
static ATerm lifted21 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm t_12 = NULL,u_12 = NULL,d_13 = NULL,f_13 = NULL,v_12 = NULL,g_13 = NULL,h_13 = NULL,i_13 = NULL,k_13 = NULL,l_13 = NULL,m_13 = NULL,w_12 = NULL,n_13 = NULL,p_13 = NULL,a_13 = NULL,i_14 = NULL,k_14 = NULL,m_14 = NULL,p_14 = NULL,q_14 = NULL,r_14 = NULL,u_14 = NULL,v_14 = NULL,w_14 = NULL,x_14 = NULL;
t_12 = t;
{
ATerm trm24 = t;
t = term253;
t = get_config_0_0(sl_up(sl), t);
if((t == NULL))
goto label26 ;
if((sl_readvar(2, sl) == NULL))
{
sl_readvar(2, sl) = t;
}
else
if((sl_readvar(2, sl) != t))
goto label26 ;
goto label25 ;
label26 :
t = trm24;
{
ATerm b_13 = NULL,c_13 = NULL;
c_13 = t;
t = term309;
b_13 = t;
t = c_13;
t = fatal_err_0_1(sl_up(sl), b_13, t);
if((t == NULL))
goto fail34 ;
else
goto label25 ;
}
label25 :
;
{
ATerm trm25 = t;
t = term257;
t = get_config_0_0(sl_up(sl), t);
if((t == NULL))
goto label28 ;
if((sl_readvar(0, sl) == NULL))
{
sl_readvar(0, sl) = t;
}
else
if((sl_readvar(0, sl) != t))
goto label28 ;
goto label27 ;
label28 :
t = trm25;
t = None_0_0(sl_up(sl), t);
if((t == NULL))
goto fail34 ;
else
goto label27 ;
label27 :
;
t = t_12;
t = read_from_0_0(sl_up(sl), t);
if((t == NULL))
goto fail34 ;
t = desugar_0_0(sl_up(sl), t);
if((t == NULL))
goto fail34 ;
u_12 = t;
f_13 = t;
t = DomainName_0_0(sl_up(sl), t);
if((t == NULL))
goto fail34 ;
d_13 = t;
t = f_13;
t = d_13;
if((sl_readvar(1, sl) == NULL))
{
sl_readvar(1, sl) = t;
}
else
if((sl_readvar(1, sl) != t))
goto fail34 ;
v_12 = t;
k_13 = t;
t = term311;
g_13 = t;
t = k_13;
l_13 = t;
t = (ATerm) ATinsert(ATempty, term21);
h_13 = t;
t = l_13;
m_13 = t;
if(((sl_readvar(0, sl) == NULL) || (sl_readvar(1, sl) == NULL)))
goto fail34 ;
else
{
t = (ATerm) ATmakeAppl(sym__3, term313, sl_readvar(0, sl), sl_readvar(1, sl));
}
i_13 = t;
t = m_13;
t = dr_set_rule_0_3(sl_up(sl), g_13, h_13, i_13, t);
if((t == NULL))
goto fail34 ;
t = v_12;
t = u_12;
{
struct str_closure l_199 = { &(annotate_with_type_0_0) , sl_up(sl) };
StrCL lifted22_cl = &(l_199);
t = alltd_1_0(sl_up(sl), lifted22_cl, t);
if((t == NULL))
goto fail34 ;
{
struct str_closure m_199 = { &(lifted23) , &(frame) };
StrCL lifted23_cl = &(m_199);
t = debug_1_0(sl_up(sl), lifted23_cl, t);
if((t == NULL))
goto fail34 ;
w_12 = t;
p_13 = t;
t = term19;
n_13 = t;
t = p_13;
{
struct str_closure o_199 = { &(lifted24) , &(frame) };
StrCL lifted24_cl = &(o_199);
t = dr_scope_1_1(sl_up(sl), lifted24_cl, n_13, t);
if((t == NULL))
goto fail34 ;
t = w_12;
t = domainmodel_to_jpa_0_0(sl_up(sl), t);
if((t == NULL))
goto fail34 ;
a_13 = t;
if((sl_readvar(2, sl) == NULL))
goto fail34 ;
else
{
t = domainmodel_to_jpa_xml_0_1(sl_up(sl), sl_readvar(2, sl), t);
if((t == NULL))
goto fail34 ;
}
t = a_13;
{
struct str_closure p_199 = { &(output_class_0_0) , sl_up(sl) };
StrCL lifted26_cl = &(p_199);
t = map_1_0(sl_up(sl), lifted26_cl, t);
if((t == NULL))
goto fail34 ;
q_14 = t;
t = term319;
i_14 = t;
t = q_14;
r_14 = t;
v_14 = t;
t = pkg_to_dirlist_0_0(sl_up(sl), t);
if((t == NULL))
goto fail34 ;
u_14 = t;
t = v_14;
t = u_14;
k_14 = t;
t = r_14;
w_14 = t;
t = term321;
m_14 = t;
t = w_14;
x_14 = t;
t = term323;
t = persistence_helper_0_0(sl_up(sl), t);
if((t == NULL))
goto fail34 ;
p_14 = t;
t = x_14;
t = create_file_0_4(sl_up(sl), i_14, k_14, m_14, p_14, t);
if((t == NULL))
goto fail34 ;
}
}
}
}
}
}
}
return(t);
fail34 :
return(NULL);
}
static ATerm lifted24 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = def_use_check_0_0(sl_up(sl_up(sl)), t);
if((t == NULL))
goto fail36 ;
t = bagof_TypeError_0_0(sl_up(sl_up(sl)), t);
if((t == NULL))
goto fail36 ;
{
ATerm trm26 = t;
ATerm y_12 = NULL;
y_12 = t;
if(!(((ATgetType(t) == AT_LIST) && ATisEmpty(t))))
goto label30 ;
t = y_12;
goto label29 ;
label30 :
t = trm26;
{
ATerm v_13 = NULL,w_13 = NULL;
struct str_closure n_199 = { &(lifted25) , &(frame) };
StrCL lifted25_cl = &(n_199);
t = list_loop_1_0(sl_up(sl_up(sl)), lifted25_cl, t);
if((t == NULL))
goto fail36 ;
w_13 = t;
t = term317;
v_13 = t;
t = w_13;
t = fatal_err_msg_0_1(sl_up(sl_up(sl)), v_13, t);
if((t == NULL))
goto fail36 ;
else
goto label29 ;
}
label29 :
;
}
return(t);
fail36 :
return(NULL);
}
static ATerm lifted25 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm z_12 = NULL,q_13 = NULL,r_13 = NULL,s_13 = NULL,u_13 = NULL;
z_12 = t;
r_13 = t;
u_13 = t;
s_13 = t;
t = u_13;
t = s_13;
q_13 = t;
t = r_13;
t = err_msg_0_1(sl_up(sl_up(sl_up(sl))), q_13, t);
if((t == NULL))
goto fail37 ;
}
return(t);
fail37 :
return(NULL);
}
static ATerm lifted23 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = term315;
return(t);
fail35 :
return(NULL);
}
ATerm create_dirs_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm b_11 = NULL,c_11 = NULL,f_11 = NULL,h_11 = NULL,d_11 = NULL;
c_11 = t;
h_11 = t;
t = getcwd_0_0(sl, t);
if((t == NULL))
goto fail31 ;
f_11 = t;
t = h_11;
t = f_11;
b_11 = t;
t = c_11;
{
struct str_closure k_199 = { &(lifted20) , &(frame) };
StrCL lifted20_cl = &(k_199);
t = map_1_0(sl, lifted20_cl, t);
if((t == NULL))
goto fail31 ;
t = getcwd_0_0(sl, t);
if((t == NULL))
goto fail31 ;
d_11 = t;
t = b_11;
t = chdir_0_0(sl, t);
if((t == NULL))
goto fail31 ;
t = d_11;
}
}
return(t);
fail31 :
return(NULL);
}
static ATerm lifted20 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm23 = t;
t = file_exists_0_0(sl_up(sl), t);
if((t == NULL))
goto label24 ;
goto label23 ;
label24 :
t = trm23;
{
ATerm i_11 = NULL,n_11 = NULL;
n_11 = t;
t = term305;
i_11 = t;
t = n_11;
t = mkdir_0_1(sl_up(sl), i_11, t);
if((t == NULL))
goto fail32 ;
else
goto label23 ;
}
label23 :
;
t = chdir_0_0(sl_up(sl), t);
if((t == NULL))
goto fail32 ;
}
return(t);
fail32 :
return(NULL);
}
ATerm create_file_0_4 (StrSL sl, ATerm o_10, ATerm p_10, ATerm q_10, ATerm r_10, ATerm t)
{
sl_decl(sl);
sl_vars(3);
sl_init_var(0, o_10);
sl_init_var(1, q_10);
{
ATerm s_10 = NULL,t_10 = NULL,u_10 = NULL,w_10 = NULL,x_10 = NULL,v_10 = NULL,y_10 = NULL;
sl_init_var(2, s_10);
{
ATerm trm22;
trm22 = CheckATermList(p_10);
if((trm22 == NULL))
goto fail27 ;
t = (ATerm) ATinsert((ATermList)trm22, term297);
t = create_dirs_0_0(sl, t);
if((t == NULL))
goto fail27 ;
if((s_10 == NULL))
{
s_10 = t;
}
else
if((s_10 != t))
goto fail27 ;
{
struct str_closure f_199 = { &(lifted17) , &(frame) };
StrCL lifted17_cl = &(f_199);
t = say_1_0(sl, lifted17_cl, t);
if((t == NULL))
goto fail27 ;
x_10 = t;
if(((s_10 == NULL) || (q_10 == NULL)))
goto fail27 ;
else
{
t = (ATerm) ATinsert(ATinsert(ATinsert(ATempty, q_10), term303), s_10);
}
t = concat_strings_0_0(sl, t);
if((t == NULL))
goto fail27 ;
w_10 = t;
t = x_10;
t = (ATerm) ATmakeAppl(sym__2, w_10, term305);
t = fopen_0_0(sl, t);
if((t == NULL))
goto fail27 ;
u_10 = t;
v_10 = t;
t = r_10;
t = write_to_0_0(sl, t);
if((t == NULL))
goto fail27 ;
{
struct str_closure i_199 = { &(lifted18) , &(frame) };
StrCL lifted18_cl = &(i_199);
t = xtc_transform_1_0(sl, lifted18_cl, t);
if((t == NULL))
goto fail27 ;
if(match_cons(t, sym_FILE_1))
{
y_10 = ATgetArgument(t, 0);
}
else
goto fail27 ;
t = y_10;
t = read_text_file_0_0(sl, t);
if((t == NULL))
goto fail27 ;
t_10 = t;
t = v_10;
t = (ATerm) ATmakeAppl(sym__2, t_10, u_10);
t = fputs_0_0(sl, t);
if((t == NULL))
goto fail27 ;
{
struct str_closure j_199 = { &(lifted19) , &(frame) };
StrCL lifted19_cl = &(j_199);
t = say_1_0(sl, lifted19_cl, t);
if((t == NULL))
goto fail27 ;
t = u_10;
t = fclose_0_0(sl, t);
if((t == NULL))
goto fail27 ;
}
}
}
}
}
return(t);
fail27 :
return(NULL);
}
static ATerm lifted19 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = term307;
return(t);
fail30 :
return(NULL);
}
static ATerm lifted18 (StrSL sl, ATerm t)
{
sl_decl(sl);
if((sl_readvar(0, sl) == NULL))
goto fail29 ;
else
{
t = sl_readvar(0, sl);
}
return(t);
fail29 :
return(NULL);
}
static ATerm lifted17 (StrSL sl, ATerm t)
{
sl_decl(sl);
if(((sl_readvar(1, sl) == NULL) || (sl_readvar(2, sl) == NULL)))
goto fail28 ;
else
{
t = (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATempty, sl_readvar(2, sl)), term299), sl_readvar(1, sl)), term301);
}
t = concat_strings_0_0(sl_up(sl), t);
if((t == NULL))
goto fail28 ;
return(t);
fail28 :
return(NULL);
}
ATerm dmdsl_about_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Config_1, (ATerm) ATinsert(ATinsert(ATempty, term273), term275))), term279), term285), term293), term295);
t = tool_doc_0_0(sl, t);
if((t == NULL))
goto fail26 ;
return(t);
fail26 :
return(NULL);
}
ATerm dmdsl_usage_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATempty, term261), term263), term267), term271);
t = tool_doc_0_0(sl, t);
if((t == NULL))
goto fail25 ;
return(t);
fail25 :
return(NULL);
}
ATerm dmdsl_options_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm19 = t;
struct str_closure x_198 = { &(lifted11) , &(frame) };
StrCL lifted11_cl = &(x_198);
struct str_closure y_198 = { &(lifted12) , &(frame) };
StrCL lifted12_cl = &(y_198);
struct str_closure z_198 = { &(lifted13) , &(frame) };
StrCL lifted13_cl = &(z_198);
t = ArgOption_3_0(sl, lifted11_cl, lifted12_cl, lifted13_cl, t);
if((t == NULL))
goto label18 ;
goto label17 ;
label18 :
t = trm19;
{
struct str_closure a_199 = { &(lifted14) , &(frame) };
StrCL lifted14_cl = &(a_199);
struct str_closure d_199 = { &(lifted15) , &(frame) };
StrCL lifted15_cl = &(d_199);
struct str_closure e_199 = { &(lifted16) , &(frame) };
StrCL lifted16_cl = &(e_199);
t = ArgOption_3_0(sl, lifted14_cl, lifted15_cl, lifted16_cl, t);
if((t == NULL))
goto fail18 ;
else
goto label17 ;
}
label17 :
;
}
return(t);
fail18 :
return(NULL);
}
static ATerm lifted16 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = term259;
return(t);
fail24 :
return(NULL);
}
static ATerm lifted15 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm j_10 = NULL,m_10 = NULL,n_10 = NULL;
j_10 = t;
n_10 = t;
m_10 = t;
t = n_10;
t = (ATerm) ATmakeAppl(sym__2, term257, m_10);
t = set_config_0_0(sl_up(sl), t);
if((t == NULL))
goto fail23 ;
t = j_10;
}
return(t);
fail23 :
return(NULL);
}
static ATerm lifted14 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm21 = t;
if(!((ATgetSymbol(t) == ATmakeSymbol("-p", 0, ATtrue))))
goto label22 ;
goto label21 ;
label22 :
t = trm21;
if((ATgetSymbol(t) == ATmakeSymbol("--prefix", 0, ATtrue)))
goto label21 ;
else
goto fail22 ;
label21 :
;
}
return(t);
fail22 :
return(NULL);
}
static ATerm lifted13 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = term255;
return(t);
fail21 :
return(NULL);
}
static ATerm lifted12 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm i_10 = NULL,k_10 = NULL,l_10 = NULL;
i_10 = t;
l_10 = t;
k_10 = t;
t = l_10;
t = (ATerm) ATmakeAppl(sym__2, term253, k_10);
t = set_config_0_0(sl_up(sl), t);
if((t == NULL))
goto fail20 ;
t = i_10;
}
return(t);
fail20 :
return(NULL);
}
static ATerm lifted11 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm20 = t;
if(!((ATgetSymbol(t) == ATmakeSymbol("-pn", 0, ATtrue))))
goto label20 ;
goto label19 ;
label20 :
t = trm20;
if((ATgetSymbol(t) == ATmakeSymbol("--project-name", 0, ATtrue)))
goto label19 ;
else
goto fail19 ;
label19 :
;
}
return(t);
fail19 :
return(NULL);
}
ATerm xtc_input_wrap_custom_1_0 (StrSL sl, StrCL g_10, ATerm t)
{
sl_decl(sl);
sl_funs(1);
sl_init_fun(0, g_10);
{
struct str_closure s_198 = { &(lifted6) , &(frame) };
StrCL lifted6_cl = &(s_198);
struct str_closure t_198 = { &(dmdsl_usage_0_0) , sl };
StrCL lifted7_cl = &(t_198);
struct str_closure u_198 = { &(dmdsl_about_0_0) , sl };
StrCL lifted8_cl = &(u_198);
struct str_closure v_198 = { &(_Id) , sl };
StrCL lifted9_cl = &(v_198);
struct str_closure w_198 = { &(lifted10) , &(frame) };
StrCL lifted10_cl = &(w_198);
t = option_wrap_5_0(sl, lifted6_cl, lifted7_cl, lifted8_cl, lifted9_cl, lifted10_cl, t);
if((t == NULL))
goto fail15 ;
}
return(t);
fail15 :
return(NULL);
}
static ATerm lifted10 (StrSL sl, ATerm t)
{
sl_decl(sl);
t = xtc_check_dependencies_0_0(sl_up(sl), t);
if((t == NULL))
goto fail17 ;
t = xtc_input_1_0(sl_up(sl), sl_fun_cl(0, sl), t);
if((t == NULL))
goto fail17 ;
return(t);
fail17 :
return(NULL);
}
static ATerm lifted6 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm18 = t;
t = dmdsl_options_0_0(sl_up(sl), t);
if((t == NULL))
goto label16 ;
goto label15 ;
label16 :
t = trm18;
t = input_options_0_0(sl_up(sl), t);
if((t == NULL))
goto fail16 ;
else
goto label15 ;
label15 :
;
}
return(t);
fail16 :
return(NULL);
}
ATerm Class_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm c_10 = NULL,d_10 = NULL,e_10 = NULL,f_10 = NULL;
c_10 = t;
d_10 = t;
f_10 = t;
t = c_10;
e_10 = t;
t = f_10;
t = (ATerm) ATmakeAppl(sym_Element_4, term251, (ATerm)ATempty, (ATerm)ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Literal_1, e_10)))), term251);
}
return(t);
fail14 :
return(NULL);
}
ATerm create_jpa_config_0_1 (StrSL sl, ATerm n_9, ATerm t)
{
sl_decl(sl);
{
ATerm r_9 = NULL,t_9 = NULL,s_9 = NULL,u_9 = NULL,w_9 = NULL,y_9 = NULL,x_9 = NULL,b_10 = NULL;
t_9 = t;
t = n_9;
r_9 = t;
t = t_9;
u_9 = t;
y_9 = t;
{
struct str_closure r_198 = { &(Class_0_0) , sl };
StrCL lifted5_cl = &(r_198);
t = map_1_0(sl, lifted5_cl, t);
if((t == NULL))
goto fail13 ;
w_9 = t;
t = y_9;
b_10 = t;
t = n_9;
x_9 = t;
t = b_10;
t = (ATerm) ATmakeAppl(sym__2, w_9, (ATerm) ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term39))), (ATerm) ATmakeAppl(sym_Element_4, term43, (ATerm)ATempty, (ATerm)ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term47))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term59)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term67)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term75)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term79)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term83)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term87)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term91)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term95)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term99)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term103)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term107)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term111)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term115)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term119)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term123)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term127)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Literal_1, x_9)), term131)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term135)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term139)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term143)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term147)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term151)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term55, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term147)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term155)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term71))), (ATerm) ATmakeAppl(sym_EmptyElement_2, term51, (ATerm) ATinsert(ATinsert(ATempty, term159), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term163)))))), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term167))), term43)), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term47))));
t = makeConc_0_0(sl, t);
if((t == NULL))
goto fail13 ;
s_9 = t;
t = u_9;
{
ATerm trm17;
trm17 = CheckATermList(s_9);
if((trm17 == NULL))
goto fail13 ;
t = (ATerm) ATmakeAppl(sym_Document_3, term179, (ATerm)ATmakeAppl(sym_Element_4, term183, (ATerm)ATinsert(ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term187, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term189)))), (ATerm) ATmakeAppl(sym_Attribute_2, term199, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term203)))), (ATerm) ATmakeAppl(sym_Attribute_2, term211, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term215)))), (ATerm) ATmakeAppl(sym_Attribute_2, term217, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term221)))), (ATerm)ATinsert(ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term225))), (ATerm) ATmakeAppl(sym_Element_4, term229, (ATerm)ATinsert(ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Attribute_2, term233, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, term237)))), (ATerm) ATmakeAppl(sym_Attribute_2, term63, (ATerm) ATmakeAppl(sym_DoubleQuoted_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Literal_1, r_9))))), (ATerm)ATinsert(ATinsert(ATinsert((ATermList)trm17, (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term47))), (ATerm) ATmakeAppl(sym_Element_4, term241, (ATerm)ATempty, (ATerm)ATinsert(ATempty, (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term245))), term241)), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term47))), term229)), (ATerm) ATmakeAppl(sym_Text_1, (ATerm) ATinsert(ATempty, term39))), term183), term247);
}
}
}
return(t);
fail13 :
return(NULL);
}
ATerm create_err_msg_0_4 (StrSL sl, ATerm i_9, ATerm j_9, ATerm l_9, ATerm m_9, ATerm t)
{
sl_decl(sl);
t = (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATempty, term27), m_9), term29), l_9), term31), j_9), term33), i_9), term35);
t = concat_strings_0_0(sl, t);
if((t == NULL))
goto fail12 ;
return(t);
fail12 :
return(NULL);
}
ATerm check_concept_0_2 (StrSL sl, ATerm b_39, ATerm c_39, ATerm t)
{
sl_decl(sl);
{
ATerm trm10 = t;
ATerm b_7 = NULL,u_8 = NULL,v_8 = NULL;
if(match_cons(t, sym_Concept_2))
{
u_8 = ATgetArgument(t, 0);
{
ATerm trm11 = ATgetArgument(t, 1);
ATerm trm12;
trm12 = (ATerm) ATgetAnnotations(trm11);
if((trm12 == NULL))
trm12 = (ATerm) ATempty;
if(match_cons(trm11, sym_SimpleConcept_1))
{
v_8 = ATgetArgument(trm11, 0);
}
else
goto label11 ;
if(((ATgetType(trm12) == AT_LIST) && !(ATisEmpty(trm12))))
{
b_7 = ATgetFirst((ATermList) trm12);
{
ATerm trm13 = (ATerm) ATgetNext((ATermList) trm12);
if(!(((ATgetType(trm13) == AT_LIST) && ATisEmpty(trm13))))
goto label11 ;
}
}
else
goto label11 ;
}
}
else
goto label11 ;
{
ATerm trm14 = t;
ATerm y_8 = NULL,z_8 = NULL;
z_8 = t;
t = b_7;
t = extract_type_0_0(sl, t);
if((t == NULL))
goto label13 ;
y_8 = t;
t = z_8;
t = (ATerm) ATmakeAppl(sym__2, y_8, b_39);
t = elem_0_0(sl, t);
if((t == NULL))
goto label13 ;
goto label12 ;
label13 :
t = trm14;
{
ATerm w_8 = NULL,a_9 = NULL,b_9 = NULL,e_9 = NULL,f_9 = NULL,g_9 = NULL,h_9 = NULL;
w_8 = t;
f_9 = t;
t = term19;
a_9 = t;
t = f_9;
g_9 = t;
t = (ATerm) ATinsert(ATempty, term21);
b_9 = t;
t = g_9;
h_9 = t;
t = (ATerm) ATmakeAppl(sym__4, term23, c_39, u_8, v_8);
e_9 = t;
t = h_9;
t = dr_add_rule_0_3(sl, a_9, b_9, e_9, t);
if((t == NULL))
goto label11 ;
t = w_8;
goto label12 ;
}
label12 :
;
}
goto label10 ;
label11 :
t = trm10;
{
ATerm k_6 = NULL,l_6 = NULL;
if(match_cons(t, sym_Concept_2))
{
k_6 = ATgetArgument(t, 0);
{
ATerm trm15 = ATgetArgument(t, 1);
if(match_cons(trm15, sym_CollectionConcept_1))
{
l_6 = ATgetArgument(trm15, 0);
}
else
goto fail11 ;
}
}
else
goto fail11 ;
{
ATerm trm16 = t;
ATerm n_6 = NULL,o_6 = NULL;
o_6 = t;
t = l_6;
t = string2javaref_0_0(sl, t);
if((t == NULL))
goto label14 ;
n_6 = t;
t = o_6;
t = (ATerm) ATmakeAppl(sym__2, n_6, b_39);
t = elem_0_0(sl, t);
if((t == NULL))
goto label14 ;
goto label10 ;
label14 :
t = trm16;
{
ATerm m_6 = NULL,s_6 = NULL,t_6 = NULL,u_6 = NULL,v_6 = NULL,w_6 = NULL,x_6 = NULL;
m_6 = t;
v_6 = t;
t = term19;
s_6 = t;
t = v_6;
w_6 = t;
t = (ATerm) ATinsert(ATempty, term21);
t_6 = t;
t = w_6;
x_6 = t;
t = (ATerm) ATmakeAppl(sym__4, term25, c_39, k_6, l_6);
u_6 = t;
t = x_6;
t = dr_add_rule_0_3(sl, s_6, t_6, u_6, t);
if((t == NULL))
goto fail11 ;
t = m_6;
goto label10 ;
}
}
}
label10 :
;
}
return(t);
fail11 :
return(NULL);
}
ATerm check_concept_decl_0_1 (StrSL sl, ATerm b_6, ATerm t)
{
sl_decl(sl);
sl_vars(2);
sl_init_var(0, b_6);
{
ATerm c_6 = NULL,d_6 = NULL;
sl_init_var(1, c_6);
{
struct str_closure n_198 = { &(lifted3) , &(frame) };
StrCL lifted3_cl = &(n_198);
if(match_cons(t, sym_ConceptDecl_2))
{
if((c_6 == NULL))
{
c_6 = ATgetArgument(t, 0);
}
else
if((c_6 != ATgetArgument(t, 0)))
goto fail8 ;
d_6 = ATgetArgument(t, 1);
}
else
goto fail8 ;
t = d_6;
t = map_1_0(sl, lifted3_cl, t);
if((t == NULL))
goto fail8 ;
}
}
return(t);
fail8 :
return(NULL);
}
static ATerm lifted3 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
struct str_closure m_198 = { &(lifted4) , &(frame) };
StrCL lifted4_cl = &(m_198);
t = try_1_0(sl_up(sl), lifted4_cl, t);
if((t == NULL))
goto fail9 ;
}
return(t);
fail9 :
return(NULL);
}
static ATerm lifted4 (StrSL sl, ATerm t)
{
sl_decl(sl);
if(((sl_readvar(0, sl_up(sl)) == NULL) || (sl_readvar(1, sl_up(sl)) == NULL)))
goto fail10 ;
else
{
t = check_concept_0_2(sl_up(sl_up(sl)), sl_readvar(0, sl_up(sl)), sl_readvar(1, sl_up(sl)), t);
if((t == NULL))
goto fail10 ;
}
return(t);
fail10 :
return(NULL);
}
ATerm def_use_check_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
sl_vars(1);
{
ATerm v_5 = NULL,w_5 = NULL,x_5 = NULL,y_5 = NULL,z_5 = NULL;
sl_init_var(0, x_5);
{
struct str_closure j_198 = { &(lifted2) , &(frame) };
StrCL lifted2_cl = &(j_198);
if(match_cons(t, sym_Domain_2))
{
ATerm trm8 = ATgetArgument(t, 0);
w_5 = ATgetArgument(t, 1);
}
else
goto fail5 ;
z_5 = t;
{
struct str_closure k_198 = { &(lifted0) , &(frame) };
StrCL lifted0_cl = &(k_198);
t = collect_all_1_0(sl, lifted0_cl, t);
if((t == NULL))
goto fail5 ;
y_5 = t;
t = z_5;
t = y_5;
v_5 = t;
t = (ATerm) ATinsert(ATinsert(ATempty, v_5), (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATempty, term1), term3), term5), term7), term9));
t = concat_0_0(sl, t);
if((t == NULL))
goto fail5 ;
{
struct str_closure l_198 = { &(string2javaref_0_0) , sl };
StrCL lifted1_cl = &(l_198);
t = map_1_0(sl, lifted1_cl, t);
if((t == NULL))
goto fail5 ;
if((x_5 == NULL))
{
x_5 = t;
}
else
if((x_5 != t))
goto fail5 ;
t = w_5;
t = map_1_0(sl, lifted2_cl, t);
if((t == NULL))
goto fail5 ;
}
}
}
}
return(t);
fail5 :
return(NULL);
}
static ATerm lifted0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm a_6 = NULL;
if(match_cons(t, sym_ConceptDecl_2))
{
a_6 = ATgetArgument(t, 0);
{
ATerm trm9 = ATgetArgument(t, 1);
}
}
else
goto fail7 ;
t = a_6;
}
return(t);
fail7 :
return(NULL);
}
static ATerm lifted2 (StrSL sl, ATerm t)
{
sl_decl(sl);
if((sl_readvar(0, sl) == NULL))
goto fail6 ;
else
{
t = check_concept_decl_0_1(sl_up(sl), sl_readvar(0, sl), t);
if((t == NULL))
goto fail6 ;
}
return(t);
fail6 :
return(NULL);
}
ATerm string2javaref_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm t_5 = NULL,u_5 = NULL;
t_5 = t;
u_5 = t;
t = (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, (ATerm)ATmakeAppl(sym_TypeName_1, (ATerm) ATmakeAppl(sym_Id_1, t_5)), term11);
}
return(t);
fail4 :
return(NULL);
}
ATerm native2java_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm6 = t;
ATerm o_5 = NULL,p_5 = NULL,q_5 = NULL;
if(match_cons(t, sym_SimpleConcept_1))
{
p_5 = ATgetArgument(t, 0);
}
else
goto label8 ;
q_5 = t;
t = p_5;
t = string2javaref_0_0(sl, t);
if((t == NULL))
goto label8 ;
o_5 = t;
t = (ATerm) ATmakeAppl(sym__2, p_5, (ATerm) ATinsert(ATinsert(ATinsert(ATinsert(ATinsert(ATempty, term1), term3), term5), term7), term9));
t = elem_0_0(sl, t);
if((t == NULL))
goto label8 ;
t = q_5;
t = (ATerm) ATmakeAppl(sym_NativeType_1, o_5);
goto label7 ;
label8 :
t = trm6;
{
ATerm trm7 = t;
ATerm m_5 = NULL,n_5 = NULL;
if(match_cons(t, sym_SimpleConcept_1))
{
m_5 = ATgetArgument(t, 0);
}
else
goto label9 ;
n_5 = t;
t = (ATerm) ATmakeAppl(sym_ConceptType_1, (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, (ATerm)ATmakeAppl(sym_TypeName_1, (ATerm) ATmakeAppl(sym_Id_1, m_5)), term11));
goto label7 ;
label9 :
t = trm7;
{
ATerm k_5 = NULL,l_5 = NULL;
if(match_cons(t, sym_CollectionConcept_1))
{
k_5 = ATgetArgument(t, 0);
}
else
goto fail3 ;
l_5 = t;
t = (ATerm) ATmakeAppl(sym_NativeType_1, (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, term17, (ATerm) ATmakeAppl(sym_Some_1, (ATerm) ATmakeAppl(sym_TypeArgs_1, (ATerm) ATinsert(ATempty, (ATerm) ATmakeAppl(sym_ClassOrInterfaceType_2, (ATerm)ATmakeAppl(sym_TypeName_1, (ATerm) ATmakeAppl(sym_Id_1, k_5)), term11))))));
goto label7 ;
}
}
label7 :
;
}
return(t);
fail3 :
return(NULL);
}
ATerm is_NativeType_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm j_5 = NULL;
if(match_cons(t, sym_NativeType_1))
{
j_5 = ATgetArgument(t, 0);
}
else
goto fail2 ;
t = j_5;
{
ATerm trm4 = t;
if(match_cons(t, sym_CollectionType_1))
{
ATerm trm5 = ATgetArgument(t, 0);
}
else
goto label6 ;
goto fail2 ;
label6 :
t = trm4;
goto label5 ;
label5 :
;
}
}
return(t);
fail2 :
return(NULL);
}
ATerm extract_type_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm1 = t;
ATerm h_5 = NULL,i_5 = NULL;
if(match_cons(t, sym_NativeType_1))
{
ATerm trm2 = ATgetArgument(t, 0);
if(match_cons(trm2, sym_CollectionType_1))
{
h_5 = ATgetArgument(trm2, 0);
}
else
goto label3 ;
}
else
goto label3 ;
i_5 = t;
t = h_5;
goto label2 ;
label3 :
t = trm1;
{
ATerm trm3 = t;
ATerm f_5 = NULL,g_5 = NULL;
if(match_cons(t, sym_NativeType_1))
{
f_5 = ATgetArgument(t, 0);
}
else
goto label4 ;
g_5 = t;
t = f_5;
goto label2 ;
label4 :
t = trm3;
{
ATerm d_5 = NULL,e_5 = NULL;
if(match_cons(t, sym_ConceptType_1))
{
d_5 = ATgetArgument(t, 0);
}
else
goto fail1 ;
e_5 = t;
t = d_5;
goto label2 ;
}
}
label2 :
;
}
return(t);
fail1 :
return(NULL);
}
ATerm annotate_with_type_0_0 (StrSL sl, ATerm t)
{
sl_decl(sl);
{
ATerm trm0 = t;
ATerm s_4 = NULL,t_4 = NULL,v_4 = NULL,a_5 = NULL,b_5 = NULL,c_5 = NULL;
s_4 = t;
if(match_cons(t, sym_SimpleConcept_1))
{
t_4 = ATgetArgument(t, 0);
}
else
goto label1 ;
a_5 = t;
c_5 = t;
t = native2java_0_0(sl, t);
if((t == NULL))
goto label1 ;
b_5 = t;
t = c_5;
t = b_5;
v_4 = t;
t = a_5;
t = (ATerm) SRTS_setAnnotations((ATerm)ATmakeAppl(sym_SimpleConcept_1, t_4), (ATerm) ATinsert(ATempty, v_4));
goto label0 ;
label1 :
t = trm0;
{
ATerm e_4 = NULL,p_4 = NULL,q_4 = NULL,r_4 = NULL;
p_4 = t;
if(match_cons(t, sym_CollectionConcept_1))
{
e_4 = ATgetArgument(t, 0);
}
else
goto fail0 ;
r_4 = t;
t = p_4;
t = native2java_0_0(sl, t);
if((t == NULL))
goto fail0 ;
q_4 = t;
t = r_4;
t = (ATerm) SRTS_setAnnotations((ATerm)ATmakeAppl(sym_CollectionConcept_1, e_4), (ATerm) ATinsert(ATempty, q_4));
goto label0 ;
}
label0 :
;
}
return(t);
fail0 :
return(NULL);
}
static void register_strategies (void)
{
int initial_size = 117;
int max_load = 75;
struct str_closure * closures;
int closures_index = 0;
if((strategy_table == NULL))
strategy_table = ATtableCreate(initial_size, max_load);
closures = (struct str_closure*) malloc((sizeof(struct str_closure) * 111));
if((closures == NULL))
{
perror("malloc error for registration of dynamic strategies");
exit(1);
}
closures[closures_index].fun = &(None_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("None_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(mapconcat_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("mapconcat_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(makeConc_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("makeConc_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(concat_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("concat_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(fetch_elem_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("fetch_elem_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(elem_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("elem_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(map_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("map_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(list_loop_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("list_loop_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(filter_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("filter_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(unzip_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("unzip_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(Fst_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("Fst_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(dr_add_rule_0_3);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("dr_add_rule_0_3", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(dr_set_rule_0_3);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("dr_set_rule_0_3", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(dr_lookup_rule_0_2);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("dr_lookup_rule_0_2", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(dr_scope_1_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("dr_scope_1_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(collect_all_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("collect_all_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(try_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("try_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(alltd_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("alltd_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(topdown_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("topdown_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(read_text_file_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("read_text_file_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(fputs_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("fputs_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(fclose_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("fclose_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(fopen_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("fopen_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(say_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("say_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(debug_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("debug_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(to_upper_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("to_upper_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(string_tokenize_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("string_tokenize_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(concat_strings_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("concat_strings_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(conc_strings_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("conc_strings_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(explode_string_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("explode_string_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(implode_string_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("implode_string_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(new_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("new_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(set_config_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("set_config_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(get_config_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("get_config_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(input_options_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("input_options_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(option_wrap_5_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("option_wrap_5_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(ArgOption_3_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("ArgOption_3_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(err_msg_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("err_msg_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(fatal_err_msg_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("fatal_err_msg_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(fatal_err_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("fatal_err_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(mkdir_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("mkdir_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(chdir_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("chdir_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(getcwd_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("getcwd_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(file_exists_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("file_exists_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(xtc_check_dependencies_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("xtc_check_dependencies_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(xtc_input_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("xtc_input_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(write_to_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("write_to_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(xtc_transform_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("xtc_transform_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(read_from_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("read_from_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(tool_doc_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("tool_doc_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(aux_Package_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("aux_Package_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted36);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted36", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(Package_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("Package_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(aux_TypeError_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("aux_TypeError_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted35);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted35", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(bagof_TypeError_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("bagof_TypeError_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(pkg_to_dirlist_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("pkg_to_dirlist_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(setter_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("setter_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(getter_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("getter_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(first_to_upper_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("first_to_upper_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(persistence_helper_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("persistence_helper_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(member_to_classbodydecs_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("member_to_classbodydecs_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(member_to_formalparams_and_assign_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("member_to_formalparams_and_assign_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(conceptdecl_to_class_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("conceptdecl_to_class_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(domainmodel_to_jpa_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("domainmodel_to_jpa_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(DomainName_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("DomainName_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(Desugar_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("Desugar_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted29);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted29", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(desugar_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("desugar_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted28);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted28", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted27);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted27", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(domainmodel_to_jpa_xml_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("domainmodel_to_jpa_xml_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(output_class_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("output_class_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted25);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted25", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted24);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted24", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted23);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted23", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted21);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted21", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(main_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("main_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted20);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted20", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(create_dirs_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("create_dirs_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted19);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted19", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted18);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted18", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted17);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted17", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(create_file_0_4);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("create_file_0_4", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(dmdsl_about_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("dmdsl_about_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(dmdsl_usage_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("dmdsl_usage_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted16);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted16", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted15);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted15", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted14);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted14", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted13);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted13", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted12);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted12", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted11);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted11", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(dmdsl_options_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("dmdsl_options_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted10);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted10", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted6);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted6", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(xtc_input_wrap_custom_1_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("xtc_input_wrap_custom_1_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(Class_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("Class_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(create_jpa_config_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("create_jpa_config_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(create_err_msg_0_4);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("create_err_msg_0_4", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(check_concept_0_2);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("check_concept_0_2", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted4);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted4", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted3);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted3", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(check_concept_decl_0_1);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("check_concept_decl_0_1", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(lifted2);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("lifted2", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(def_use_check_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("def_use_check_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(string2javaref_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("string2javaref_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(native2java_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("native2java_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(is_NativeType_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("is_NativeType_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(extract_type_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("extract_type_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
closures[closures_index].fun = &(annotate_with_type_0_0);
closures[closures_index].sl = NULL;
SRTS_register_function((ATerm)ATmakeAppl0(ATmakeSymbol("annotate_with_type_0_0", 0, ATtrue)), &(closures[closures_index]));
closures_index++;
}
int main (int argc, char * argv [])
{
ATerm out_term;
ATermList in_term;
int i;
ATinit(argc, argv, &(out_term));
init_constructors();
in_term = ATempty;
for ( i = (argc - 1) ; (i >= 0) ; i-- )
{
in_term = ATinsert(in_term, (ATerm) ATmakeAppl0(ATmakeSymbol(argv[i], 0, ATtrue)));
}
SRTS_stratego_initialize();
register_strategies();
out_term = main_0_0(NULL, (ATerm) in_term);
if((out_term != NULL))
{
ATfprintf(stdout, "%t\n", out_term);
exit(0);
}
else
{
ATfprintf(stderr, "%s: rewriting failed\n", argv[0]);
exit(1);
}
}
