xquery version "3.1" encoding "utf-8";

(: This library has been written and run with BaseX 8.6.2 by Giuseppe G. Celano.
 : It is published under a CC BY-NC 4.0 license.     
 :)

declare namespace lp="http://l-processor.org";
declare namespace functx = "http://www.functx.com";
declare variable $d := doc("/yourdirectory/MorpheusBeta.xml");

declare function lp:grc-change-diacritics-order($x as xs:string*) 

as xs:string*
{
	replace($x, "(\*)([)(/\\=+|_^?]*)(\p{L})", "$1$3$2")
};

declare function functx:capitalize-first($arg as xs:string?) 

as xs:string?
{
	concat(upper-case(substring($arg,1,1)), substring($arg,2))
};

declare function lp:grc-capitalize-after-asterisk($x as xs:string*) 

as xs:string*
{
	let $p :=
    		if (matches($x, "\*")) then
    			for $z in tokenize($x, " ")
      			return
      			<c>{$z}</c>
		else $x
	for $t in $p
	return
		if (matches($t, "\*")) then 
			functx:capitalize-first(replace($t, "\*", ""))
		else $t
};

declare function lp:grc-sigma-conversion($x as xs:string*) 

as xs:string*
{
	replace($x, "(s)([\p{L}])", "σ$2")
};

declare function lp:grc-convert-betacode($x as xs:string*) 

as xs:string*
{
	normalize-unicode(translate($x,
"abgdezhqiklmncoprstufxywvjABGDEZHQIKLMNCOPRSTUFXYWV&#39;)(\/=+|_^&#x002E;&#x002C;&#x003A;",
"αβγδεζηθικλμνξοπρςτυφχψω&#x03DD;&#x03F3;ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ&#x03DC;&#8217;&#x0313;&#x0314;&#x0300;&#x0301;&#x0342;&#x0308;&#x0345;&#x0304;&#x0306;&#x002E;&#x002C;&#x00B7;"
				    ), 
	"NFC")
};


for $u in $d
return
copy $e := $u
modify (
for $o in $e//t
let $f := $o/f[1]
let $f2 := $o/f[2]
let $b := $o/b
let $l := $o/l
let $ee := $o/e
return
(
rename node $f2 as "s",  
  
replace value of node $f with 
lp:grc-convert-betacode(
lp:grc-sigma-conversion(
lp:grc-sigma-conversion(
lp:grc-capitalize-after-asterisk(lp:grc-change-diacritics-order(
  $f
))
)))
,

replace value of node $l with 
lp:grc-convert-betacode(
lp:grc-sigma-conversion(
lp:grc-sigma-conversion(
lp:grc-capitalize-after-asterisk(lp:grc-change-diacritics-order(
  $l
))
)))
,

replace value of node $b with 

lp:grc-convert-betacode(
lp:grc-sigma-conversion(
lp:grc-sigma-conversion(
lp:grc-capitalize-after-asterisk(lp:grc-change-diacritics-order(
  $b
))
)))
,
replace value of node $ee with 

lp:grc-convert-betacode(
lp:grc-sigma-conversion(
lp:grc-sigma-conversion(
lp:grc-capitalize-after-asterisk(lp:grc-change-diacritics-order(
  $ee
))
)))

)
)
return $e
