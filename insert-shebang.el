(defun insert-shebang()
  "whenever the new file is created, it will scan its extention
and insert a shabang line"
  (interactive "*")			;ASTERISK means - abort the
					;function if the buffer is
					;read-only
  (let ((bufname (buffer-name)))
    ;;    (message "present buffer name: %s" bufname)
    ;;    (message "present buffer extension: %s" (file-name-extension bufname)) 
    (let ((extname (file-name-extension bufname)))
      (if (equal extname "sh")
	(progn
	  (message "file is BASH")
	  (goto-char (point-min))
	  (let ((sh-str (shell-command-to-string "which bash")))
	    (insert-string "#!"sh-str))
	  ;;(insert-string "#!/bin/bash")
	  )
;;	(message "extension does not match")
	(if (equal extname "py")
	    (progn
	      (message "file is PYTHON")
	      (goto-char (point-min))
	      (let ((sh-str (shell-command-to-string "which python")))
		(insert-string "#!"sh-str))
	      ;;(insert-string "#!/usr/bin/python")
	      )
	  (error "I cant identify the file extension")
	  )
	)
      )
    )
  )

(insert-shebang)

(add-hook 'find-file-hook 'insert-shebang)

;; TODO
;; works only for new files
;; what is shebang line already exist ??

;; if the first line is not shebang, put it to the next line, and shebang will be the first line

;; (let ((sh-str (shell-command-to-string "which python")))
;;   (message "#!%s"sh-str))

(buffer-substring (point-min) (end-of-line))


;; --------------------
(defun testpoint()
"check the very first line of the visiting file"
  ;;  (point-min)
  (let ((pnt1 (point-min)))
    ;; (message "%d"pnt)
    (goto-char (point-min))
    (end-of-line)
    (goto-char (point))
    (let ((pnt2 (point)))
      ;;(message "%d,%d" pnt1 pnt2)
      (buffer-substring-no-properties pnt1 pnt2)
       )
    )
  ;;(point)
  )

(testpoint)

;; --------------------
(defun nxt-replace()
  "if the first line is not shebang, put it to the next line, and
shebang will be the first line" 
  (goto-char (point-min))
  (kill-line)
  (next-line)
  (beginning-of-line)
  (yank)
  )

(nxt-replace)



