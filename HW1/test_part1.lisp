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
(defun list-leveller(lst)
	(if (null lst)		; Lst'nin null olup olmadığını kontrol ediyor.
		NIL		; Eğer lst null ise NIL return ediliyor. Böylece recursion'da append'e NIL gidiyor ve listede herhangi bir değişime sebep vermiyor.
		(if (null (listp(car lst)))		; Lst'nin ilk elemanının bir alt liste (sublist) olup olmadığını kontrol ediyor.
			(append (list(car lst)) (list-leveller(cdr lst)))	; Eğer ilk eleman liste değilse o elemanı return edeceğim listeye ekliyor ve recursive olarak fonksiyonu tekrar çağırıyorum.Böylece eklenecek diğer elemanlar return edilerek recursion sayesinde en üstteki listeye ulaşıyor.
			(append (list-leveller(car lst)) (list-leveller(cdr lst)))  ; Eğer ilk eleman bir listeyse nested liste olacağından parantezlerden kurtulmak için recursive olarak fonksiyonu tekrar çağırıyorum.
		)
	)
)


;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part1.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
	  (list-leveller (read-from-string (nth 0 line)))


      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
