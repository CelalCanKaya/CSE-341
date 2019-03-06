(setq spaces '(#\Newline #\Space #\Tab))
(setq operators '(#\+ #\- #\/ #\* #\( #\)))
(setq operators2 '("+" "-" "/" "*" "(" ")" "**"))
(setq keywords '("and" "or" "not" "equal" "append" "concat" "set" "deffun" "for" "while" "if" "exit"))
(setq binary '("true" "false"))
(setq result '())
(setq lst '())
(setq modifiedlst '())
(setq printlst '())

(defun filetolist (filename)			; Verilen dosyayi açip karakter karakter okuyor ve lst'ye pushluyor. Dosyayi okumayi bitirdikten sonra lst ters olacagindan tersini alip sirali hale getiriyorum.
	(with-open-file (stream filename)
	    (do ((char (read-char stream nil)
	               (read-char stream nil)))
	        ((null char))
	      (push (list char) lst)))
		(setq lst(reverse lst))
)

(defun modifylist ()		; lst'de tutulan karakterleri boşluk, tab, yada newline görene kadar okuyup birleştirip string olarak başka bir listeye atıyor
	(if (null lst)		; lst null olana kadar
		NIL 		; Return NIL
		(progn
		(if (find (car(car lst)) spaces)	; lst'nin ilk elemani boşluk, tab ya da newline ise
			(setq lst (cdr lst))	; lst'den ilk elemani siliyorum
			(if (find (car(car(cdr lst))) spaces)	; lst'nin 2. elemanini bosluk, tab ya da newline ise
				(progn
					(push (car lst) modifiedlst)	; lst'nin ilk elemanini modifiedlst ye at
					(setq lst (cdr(cdr lst)))		; lst'nin ilk 2 elemanini kaldir
				)
				(if (null (cdr lst))		; lst'de 2'den az eleman varsa
					(progn
						(push (car lst) modifiedlst)	;lst'nin ilk elemanini modifiedlst ye at
						(setq lst '())		; lst'nin ilk 2 elemanini kaldir
					)
					(if (stringp (car(car lst)))		;lst'nin ilk elemani string ise
						(setq lst (push (list (concatenate 'string (car(car lst)) (car (cdr lst)))) (cdr (cdr lst))))	;ilk eleman ile 2. elemani birlestir. Ilk eleman ve 2. elemani silip yerine birlesimini koy
						(setq lst (push (list (concatenate 'string (car lst) (car (cdr lst)))) (cdr (cdr lst))))		;ilk eleman ile 2. elemani birlestir. Ilk eleman ve 2. elemani silip yerine birlesimini koy
					)
				)
			)
		)
		(modifylist)	;Recursive olarak fonku cagir
		)
	)
)

(defun allString(ls)	;modifiedlst'deki bazi elemanlar char olarak kaldigindan onlari stringe ceviriyorum ve butun elemanlari tekrardan lst ye aktariyorum
	(if (null ls)
		lst
		(progn
			(if (stringp (car(car ls)))		;ls'nin ilk elemani string ise
				(push (list(concatenate 'string (car(car ls)) "")) lst)		;lst'ye pushla
				(push (list(concatenate 'string (car ls) "")) lst)		;char'ı string yapip lst'ye pushla
			)
			(allString (cdr ls))	;recursive olarak fonku cagir
		)
	)
)



(defun tokenization(lst1)		;Elde ettigim stringleri tokenlere ayiriyorum
	(if (null lst1)		; Eger liste null'sa
		result
		(progn
			(setq temp(coerce (car(car lst1)) 'list))	;Stringi karakterlere bölüp temp degiskenine atiyorum
			(loop while temp
				do (if (find (car temp) operators)	; Eger temp'in ilk elemani bir operator ise
						(if (equal #\* (car temp))	; temp'in ilk elemani * ise
							(if (equal #\* (car (cdr temp)))	; temp'in ikinci elemanida yildiz ise ** oldugunu anliyorum
								(progn
									(push(list(concatenate 'string (list(car temp)) (list (car (cdr temp)))))result)	; ** operatorunu result listeme atip tempten siliyorum
									(setq temp (cdr (cdr temp)))
								)
								(progn
									(push (list(concatenate 'string (list(car temp)) "")) result)	;ikinci eleman * olmadigi icin * operatoru oldugunu anliyorum ve result listeme atip tempten siliyorum
									(setq temp (cdr temp))
								)
							)
							(if (equal #\- (car temp))	; temp'in ilk elemani - ise (Integer'in -'simi operator olan - mi oldugunu anlamak icin)
								(if (null (cdr temp))	; Listede baska eleman kalmadiysa
									(progn
										(push (list(concatenate 'string (list(car temp)) "")) result)	; Operator olan - oldugunu anliyorum resulta atiyorum
										(setq temp (cdr temp))
									)
									(if (digit-char-p (car (cdr temp)))		; Bir sonraki karakter sayi ise integer'in - si oldugunu anliyorum
										(setq temp(push(concatenate 'string (list(car temp)) (list (car (cdr temp)))) (cdr(cdr temp))))	; Integer ile birlestiriyorum
										(progn
											(push (list(concatenate 'string (list(car temp)) "")) result)	;Operator olan - oldugunu anliyorum ve resulta atiyorum
											(setq temp (cdr temp))
										)
									)
								)
								(progn
									(push (list(concatenate 'string (list(car temp)) "")) result)		;Operator olan - oldugunu anliyorum ve resulta atiyorum
									(setq temp (cdr temp))
								)
							)
						)
					(if(stringp (car temp))		; Eger ilk eleman string ise
						(if (find (car(cdr temp)) operators)	; ikinci eleman operator ise
							(progn
								(push (list(concatenate 'string (car temp) "")) result)	;Identifier'in sonuna geldigimi anliyorum ve identifier'i result listesine atiyorum
								(setq temp (cdr temp))
							)
							(if (null (cdr temp))	;Listenin geri kalani bos ise
								(progn
									(push (list(concatenate 'string (car temp) "")) result)	;Liste bos oldugu icin string'i result'a atiyorum
									(setq temp (cdr temp))
								)
								(setq temp(push(concatenate 'string (car temp) (list (car (cdr temp)))) (cdr(cdr temp))))	;Bir sonraki elemani ilk elemandaki string'e ekliyorum
							)
						)
						(if (null (cdr temp))	;Listenin geri kalani bos ise
							(progn
								(push (list(concatenate 'string (list(car temp)) "")) result)	;Liste bos oldugu icin karakteri string yapip string'i result'a atiyorum
								(setq temp (cdr temp))
							)
							(if (find (car(cdr temp)) operators)	;Listenin 2. elemani operator ise
								(progn
									(push (list(concatenate 'string (list(car temp)) "")) result)	;Liste bos oldugu icin karakteri string yapip string'i result'a atiyorum
									(setq temp (cdr temp))
								)
									(setq temp(push(concatenate 'string (list(car temp)) (list (car (cdr temp)))) (cdr(cdr temp))))	;Ilk ve ikinci eleman karakterleri birlestiriyorum ve bu elemanlari kaldirip listeye birlesimi pushluyorum
							)
						)
					)
				)
			)
			(tokenization (cdr lst1))	;Recursive call
		)
	)
)

(defun printresults()	;Lexical Analysis sonucunu Istenen output ornegindeki gibi printlst listesine attigim fonksiyon
	(if (null result)
		printlst
		(progn
			(cond
				((find (car(car result)) operators2 :test #'equal)	; Operator ise
						(push (car result) printlst )
						(push "operator" (car printlst))
						(setq result (cdr result))
						(printresults)
				)
				((find (car(car result)) keywords :test #'equal)	;Keyword ise
						(push (car result) printlst )
						(push "keyword" (car printlst))
						(setq result (cdr result))
						(printresults)
				)
				((find (car(car result)) binary :test #'equal)	;Binary Value ise
						(push (car result) printlst )
						(push "binary" (car printlst))
						(setq result (cdr result))
						(printresults)
				)
				((numberp (read-from-string (car(car result))))	;Integer ise
						(push (car result) printlst )
						(push "integer" (car printlst))
						(setq result (cdr result))
						(printresults)
				)
				((every #'alpha-char-p (car(car result)))	;Identifier ise
						(push (car result) printlst )
						(push "identifier" (car printlst))
						(setq result (cdr result))
						(printresults)
				)
				(t 											;Unidentified ise
						(push (car result) printlst )
						(push "Unidentified" (car printlst))
						(setq result (cdr result))
						(printresults)	
				)
			)
		)	
	)
)

(defun lexer (filename)	;Lexer func
	(setq lst '())
	(setq modifiedlst '())
	(setq result '())
	(setq printlst '())
	(filetolist filename)
	(modifylist)
	(allString modifiedlst)
	(tokenization lst)
	(printresults)
)