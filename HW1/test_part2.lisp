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
(defun merge-list(lst1 lst2)
	(if (null (cdr lst1))	; 1. Listemde 1 elemandan fazla olup olmadığını kontrol ediyorum
			(if (null (car lst1))	; Liste 1 elemandan fazla olmadığı için listede eleman olup olmadıgını kontrol ediyorum.
				lst2		; Listem boşsa 2. listemi return ediyorum.
				(cons (car lst1) lst2)) 	; 1. Listedeki tek elemanı 2. listenin başına ekliyorum.
			(merge-list (reverse(cdr (reverse lst1))) (cons (car (reverse lst1)) lst2))	; 1. Listemi ters çevirip ilk elemanını 2. listenin başına ekliyorum. 1. Listemin son elemanını 2. listeye eklediğim için 1. listemi ters çevirip kalan elemanları alıp tekrar ters çeviriyorum. Böylece 1. listenin son elemanını kaldırmış oluyorum.
	)
)


;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part2.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
       (merge-list (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))
      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
