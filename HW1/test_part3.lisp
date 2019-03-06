(load "csv-parser.lisp")
(in-package :csv-parser)

;; (read-from-string STRING)
;; This function converts the input STRING to a lisp object.
;; In this code, I use this function to convert lists (in string format) from csv file to real lists.

;; (nth INDEX LIST)
;; This function allows us to access value at INDEX of LIST.
;; Example: (nth 0 '(a b c)) => a

;; !!! VERY VERY VERY IMPORTANT NOTE !!!
;; FOR EACH ARGUMENT IN CSV FILE
;; USE THE CODE (read-from-string (nth ARGUMENT-INDEX line))
;; Example: (mypart1-funct (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))

;; DEFINE YOUR FUNCTION(S) HERE
(defun insert-n (lst number index)
	(cond 	
		((= 0 index) 	; Eğer index 0'a eşitse
			(cons number lst))	; Ekleyeceğim sayıyı listenin başına ekliyorum.
		((null lst)		; Eğer liste null'sa geçersiz bir index girildiği anlaşılıyor ve kullanıcıya mesajı bastırıp NIL return ediyorum.
			(write "Gecersiz Index Girdiniz.")
			(terpri)	
			NIL
		)
		(t(cons (car lst) (insert-n (cdr lst) number (- index 1))))	; Yukarıdaki 2 conditionda yanlış ise listemin ilk elemanını return edeceğim listeye ekledikten sonra kalan elemanları recursive olarak çağırıyorum. Aynı zamanda indexi 1 azaltıyorum.
	)
)



;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part3.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
      (insert-n (read-from-string (nth 0 line)) (read-from-string (nth 1 line)) (read-from-string (nth 2 line)))
      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
