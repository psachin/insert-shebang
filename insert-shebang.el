(defun insert-shebang()
  "whenever the new file is created, it will scan its extention
and insert a shabang line"
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

