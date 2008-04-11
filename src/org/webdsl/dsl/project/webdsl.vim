" Vim syntax file
" Language:	    WebDSL Syntax
" Maintainer:	Zef Hemel <zef@zefhemel.com>
" Last Change:  2008 March 26
" Filenames:	*.app
" URL:		
"
" To use, include the following in your ~/.vim/filetype.vim:
"    augroup filetypedetect
"       au! BufRead,BufNewFile *.app setfiletype webdsl
"    augroup END


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
	if b:current_syntax != "webdsl"
	    syntax clear
		unlet b:current_syntax
	else 
		finish
	endif
endif

setlocal iskeyword=a-z,A-Z,48-57,_,-,=,>,128-167,224-235

syntax keyword webdslVisibility imports
syntax keyword webdslBlocks module application section description note
syntax keyword webdslConditional for if else
syntax keyword webdslKeywords in return define var page email enum session entity extend predicate policy pointcut access control rules globals action function template where order by init goto
syntax keyword webdslBuiltins true false this Bool String Int Float Bool Secret Email Text WikiText Date Time DateTime Patch Image File URL Set List inverse
syntax keyword webdslTemplateCalls title section header form table row list listitem captcha output input select navigate url menu menuheader menuitem menubar block par to from subject

syntax region webdslCmtLine start="//" skip="\\$" end="$" 
syntax region webdslCmtBlock start="/\*" skip="\\$" end="\*/" keepend
syntax region webdslString start="\"" skip="\\\"" end="\"" keepend

syn sync fromstart

if !exists("did_r_syn_inits")
   let did_r_syn_inits = 1

   hi link webdslVisibility     Type
   hi link webdslBlocks 		UnderLined
   hi link webdslKeywords		Identifier
   hi link webdslConditional	Conditional
   hi link webdslCmtLine		Comment
   hi link webdslCmtBlock		Comment
   hi link webdslString         String
   hi link webdslBuiltins       Constant
   hi link webdslTemplateCalls  Special
endif

let b:current_syntax = "webdsl"

" vim: ts=4 sw=2
