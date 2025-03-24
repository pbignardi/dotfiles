" Vim syntax file
" Language:        gams
" Filenames:       *.gms
" Quit when a syntax file was already loaded

if exists("b:current_syntax")
  finish
endif

" gams is not case sensitive
syn case ignore

" KEYWORDS

" for model definition and solve
" gams statements defined as regions below: set, parameter, model, equation, variable, Table
syn keyword gamsStatement       solve using
syn keyword gamsStatement       display
syn keyword gamsStatement       option
syn keyword gamsStatement       alias
syn keyword gamsStatement       sameas abort
syn keyword gamsStatement       free semicont semiint sos1 sos2 binary integer
syn keyword gamsStatement       positive negative
syn keyword gamsStatement       xxpto

" model types
syn keyword gamsStatement       lp mip nlp mcp mpec cns dnlp minlp qcp
syn keyword gamsStatement       miqcp rmip rminlp rmiqcp

" external utilities
syn keyword gamsStatement       put file putclose putpage puttl puthd

syn keyword gamsYesNo           yes no

" control structures and logical operators
syn keyword gamsConditional if else elseif ifi exist ife
syn match   gamsConditional "\$"

syn keyword gamsControl     and or xor not

syn keyword gamsRepeat loop while repeat until for to downto by

" logical and math operators
syn match   gamsMathsOperators "[-+^/]\|\*\*"

syn match   gamsComparison "<=>\|=\|->\|<>\|>\|<"
syn keyword gamsComparison eq ne gt ge lt le eqv imp

" math and statistical functions
syn keyword gamsFunction      abs asc sigmoid sum
syn keyword gamsFunction      acos acosh asin asinh atan atan2
syn keyword gamsFunction      atanh ceil ctime cos cosh exp floor log log10
syn keyword gamsFunction      max min precision round sin sinh sqrt tan tanh sqrt
syn keyword gamsFunction      smax smin
syn keyword gamsFunction      time trunc div
syn keyword gamsFunction      beta betareg binomial edist entropy errorf fact
syn keyword gamsFunction      gamma gammareg logbeta loggamma normal
syn keyword gamsFunction      mapval mod ncpcm ncpf pi poly power
syn keyword gamsFunction      sign signpower trunc uniform uniformint

" execution time gdx commands
syn keyword gamsSpecial execute_load execute_unload

syn region gamsDollarCommand matchgroup=gamsDollarCommandName start="^\$[[:alpha:]]\+" end="$" transparent


" usually dollar commands are put to the first position within the line
" but if there is an $if[ie] command before...
syn match gamsSpecial "\$option"
syn match gamsSpecial "\$call"
syn match gamsSpecial "\$eval"
syn match gamsSpecial "\$evalglobal"
syn match gamsSpecial "\$evallocal"

syn match gamsSpecial "\$if"
syn match gamsSpecial "\$ifi"
syn match gamsSpecial "\$endif"
syn match gamsSpecial "\$endifi"
syn match gamsSpecial "\$iftheni"
syn match gamsSpecial "\$ifthene"

syn match gamsSpecial "\$gdxin"
syn match gamsSpecial "\$gdxout"
syn match gamsSpecial "\$load"
syn match gamsSpecial "\$unload"
syn match gamsSpecial "\$include"
syn match gamsSpecial "\$batinclude"
syn match gamsSpecial "\$libinclude"
syn match gamsSpecial "\$sysinclude"
syn match gamsSpecial "\$goto"
syn match gamsSpecial "\$label"
syn match gamsSpecial "\$exit"
syn match gamsSpecial "\$kill"

syn match gamsSpecial "\$offlisting"
syn match gamsSpecial "\$onlisting"
syn match gamsSpecial "\$oneolcom"
syn match gamsSpecial "\$offeolcom"

syn match gamsSpecial "\$stars"
syn match gamsSpecial "\$setglobal"
syn match gamsSpecial "\$dropglobal"
syn match gamsSpecial "\$setlocal"
syn match gamsSpecial "\$droplocal"
syn match gamsSpecial "\$setenv"
syn match gamsSpecial "\$setnames"

syn match gamsSpecial "\$onglobal"
syn match gamsSpecial "\$offglobal"

syn match gamsSpecial "\$setargs"
syn match gamsSpecial "\$onmulti"
syn match gamsSpecial "\$offmulti"
syn match gamsSpecial "\$onempty"
syn match gamsSpecial "\$offempty"

syn match gamsSpecial "\$comment"
syn match gamsSpecial "\$dollar"
syn match gamsSpecial "\$double"
syn match gamsSpecial "\$single"
syn match gamsSpecial "\$echo"
syn match gamsSpecial "\$echon"
syn match gamsSpecial "\$eject"
syn match gamsSpecial "\$error"
syn match gamsSpecial "\$escape"
syn match gamsSpecial "\$expose"
syn match gamsSpecial "\$hidden"
syn match gamsSpecial "\$hide"

syn match gamsSpecial "\$inlinecom"
syn match gamsSpecial "\$lines"
syn match gamsSpecial "\$log"

syn match gamsSpecial "\$maxcol"
syn match gamsSpecial "\$mincol"
syn match gamsSpecial "\$offdigit"
syn match gamsSpecial "\$ondigit"
syn match gamsSpecial "\$offend"
syn match gamsSpecial "\$onend"
syn match gamsSpecial "\$offeps"
syn match gamsSpecial "\$oneps"
syn match gamsSpecial "\$offinline"
syn match gamsSpecial "\$oninline"
syn match gamsSpecial "\$offmargin"
syn match gamsSpecial "\$onmargin"
syn match gamsSpecial "\$offnestcom"
syn match gamsSpecial "\$onnestcom"

syn match gamsSpecial "\$onput"
syn match gamsSpecial "\$onputs"
syn match gamsSpecial "\$onputv"
syn match gamsSpecial "\$offput"

syn match gamsSpecial "\$onsymlist"
syn match gamsSpecial "\$offsymlist"
syn match gamsSpecial "\$onsymxref"
syn match gamsSpecial "\$offsymxref"
syn match gamsSpecial "\$onuellist"
syn match gamsSpecial "\$offuellist"
syn match gamsSpecial "\$onuelxref"
syn match gamsSpecial "\$offuelxref"

syn match gamsSpecial "\$onundf"
syn match gamsSpecial "\$offundf"
syn match gamsSpecial "\$onupper"
syn match gamsSpecial "\$offupper"
syn match gamsSpecial "\$onwarning"
syn match gamsSpecial "\$offwarning"

syn match gamsSpecial "\$phantom"
syn match gamsSpecial "\$prefixpath"
syn match gamsSpecial "\$protect"
syn match gamsSpecial "\$purge"
syn match gamsSpecial "\$remark"

syn match gamsSpecial "\$setcomps"
syn match gamsSpecial "\$setddlist"
syn match gamsSpecial "\$shift"
syn match gamsSpecial "\$show"

syn match gamsSpecial "\$use205"
syn match gamsSpecial "\$use225"
syn match gamsSpecial "\$use999"

syn match gamsSpecial "\$title"
syn match gamsSpecial "\$stitle"

syn match gamsSpecial "\$abort"
syn match gamsSpecial "\$terminate"
syn match gamsSpecial "\$stop"

" uncomment to hihglight every word starting with a dollar sign in the beggining of the line
syn match gamsSpecial           "^\$\<[^ ]\+\>"

" integer number, or floating point number without a dot.
" use the special boundary symbols \< and \>
syn match  gamsNumber           "\<\d\+\>"
syn match  gamsNumber           "\<[-+]\d\+\>"
" floating point number, with dot
syn match  gamsNumber           "\<\d\+\.\d*\>"
syn match  gamsNumber           "\<[-+]\d\+\.\d*\>"
" floating point number, starting with a dot
syn match  gamsNumber           "\<\.\d\+\>"
syn match  gamsNumber           "\<[-+]\.\d\+\>"
" scientific notation (with exponent)?
" Floating point like number with E and decimal point (+,-)
syn match gamsNumber '\<[-+]\=\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+\>'
syn match gamsNumber '\<\d[[:digit:]]*\.\d*[eE][\-+]\=\d\+\>'

" special numbers
syn keyword gamsNumber eps na undf
syn match   gamsNumber "[-+]inf"

" GAMS suffixes
" TODO: Rename to `gamsAttribute` ?
syn keyword gamsSuffix bm case cc cr data errors fx hdcc hdcr hdll ifile infeas
syn keyword gamsSuffix l lj ll lo lp lw m nd nj nr nw nz ofile page pc prior ps pw
syn keyword gamsSuffix range rdate rfile rtime scale sfile sj slack slackup slacklo sw
syn keyword gamsSuffix te tf time title tj tl tlcc tlcr tlll tm ts tw
syn keyword gamsSuffix up val ws

" String and Character contstants
syn region gamsString matchgroup=Delimiter start=+"+  skip=+\\\\\|\\"+  end=+"+
syn region gamsString matchgroup=Delimiter start=+'+  skip=+\\\\\|\\"+  end=+'+

" equation types (e.g. =e= or =G=)
syn match gamsEquationType "=[cegln]=" contained

" to include .csv files
syn region gamsInclude matchgroup=gamsDollarCommandName start="^\$ondelim" end="^\$offdelim"

" GAMS global variables e.g. %myglobal%
syn region gamsGlobalVar start="%" end="%\|\$"

" when a command line parameter is passed to the gams code the %1 notation can be used
syn match  gamsInclude           "%\d\+"

" TODO and FIXME are special keywords in comments
syn keyword gamsTodo contained       TODO FIXME

" GAMS comments
syn match  gamsComment "\(^\*.*\|#.*\)" contains=gamsTodo,@Spell
syn region gamsComment matchgroup=gamsDollarCommandName start="^\$ontext" end="^\$offtext" keepend contains=gamsTodo,@Spell


syn region gamsItem matchgroup=gamsItemName start="\<[[:alpha:]][_[:alnum:]]*" skip="/[^/]*/" matchgroup=None end="\s*\(,\|;\|$\)" contained transparent contains=gamsItemComment,gamsItemDimension,gamsItemValues
syn region gamsItemDimension start="(" end=")" contained transparent keepend
syn region gamsItemComment start="\s[^/]" end=".\($\|/\|,\)\@=" contained contains=@Spell
syn region gamsItemValues matchgroup=Delimiter start=+/+ skip=+".*"+ end=+/+ transparent keepend contained contains=gamsComment,gamsString,gamsNumber

syn region gamsScalar matchgroup=gamsDeclaration start=/^\s*scalars\{0,1\}\_s/ end=/;/ transparent keepend fold contains=gamsItemName,gamsNumber

" equation declaration and definition regions
syn region gamsEqn    matchgroup=Delimiter start=/\.\.\(\s\|\n\)/ end=/;/ fold transparent contains=gamsComment,gamsNumber,gamsConditional,gamsRepeat,gamsSuffix,gamsEquationType,gamsString,gamsFunction
syn region gamsEqDecl matchgroup=gamsDeclaration start=/^\s*equations\{0,1\}/ end=/;/ fold transparent keepend contains=gamsItem

" variable declaration region
syn region gamsVar matchgroup=gamsDeclaration start=/^\s*variables\{0,1\}/ end=/;/ fold transparent keepend contains=gamsItem

" set region
syn region gamsSet matchgroup=gamsDeclaration start=/^\s*sets\{0,1\}/ end=/;/ fold transparent keepend contains=gamsItem

" parameter region
syn region gamsParam matchgroup=gamsDeclaration start=/^\s*parameters\{0,1\}/ end=/;/ fold transparent keepend contains=gamsItem

" table region
syn region gamsTable matchgroup=gamsDeclaration start=/^\s*tables\{0,1\}/ end=/;/ fold transparent contains=gamsNumber,gamsComment,gamsString

" model definition region
syn region gamsModel matchgroup=gamsDeclaration start=/^\s*models\{0,1\}/ end=/;/ fold transparent keepend contains=gamsItem

hi def link gamsItemComment        gamsComment
hi def link gamsLabel              Label
hi def link gamsConditional        Conditional
hi def link gamsControl            Statement
hi def link gamsRepeat             Repeat
hi def link gamsLineNumber         Comment
hi def link gamsNumber             Number
hi def link gamsError              Error
hi def link gamsStatement          Statement
hi def link gamsString             String
hi def link gamsComment            Comment
hi def link gamsSpecial            Special
hi def link gamsTodo               Todo
hi def link gamsFunction           Keyword
hi def link gamsDeclaration        Type
hi def link gamsInclude            Special
hi def link gamsSuffix             Operator
hi def link gamsEquationType       Operator
hi def link gamsItemName           Function
hi def link gamsDollarCommandName  Include
hi def link gamsGlobalVar          Special
hi def link gamsYesNo              Constant
hi def link gamsItemValues         String

let b:current_syntax = "gams"

" vim: ts=4 expandtab
