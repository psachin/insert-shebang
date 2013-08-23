;;; insert-shebang.el --- Inserts shebang line automatically

;; Copyright (C) 2013  Sachin Patil

;; Author: Sachin Patil <isachin@iitb.ac.in>
;; URL: http://github.com/psachin/insert-shebang
;; Keywords: tools, convenience
;; Version: 0.9.1

;; This file is NOT a part of GNU Emacs.

;; insert-shebang is free software distributed under the terms of the
;; GNU General Public License, version 3. For details, see the file
;; COPYING. 

;;; Commentary:
;; Inserts shebang line automatically

;; Install
;;
;; Unless installed from a package, add the directory containing
;; this file to `load-path', and then:
;; (require 'insert-shebang)
;;
;; Then enable it globally using:
;;
;; (add-hook 'find-file-hook 'insert-shebang)

;;; Code:

(defgroup insert-shebang nil
  "Inserts shebang line automatically"
  :group 'extensions
  :link '(url-link :tag "Github" "https://github.com/psachin/insert-shebang"))

(defcustom file-types
  '(("py" . "python")
    ("sh" . "bash")
    ("pl" . "perl"))
  "*If nil, add all your file extensions and file types here."
  :type '(alist :key-type (string :tag "Extension") :value-type (string :tag "Type"))
  :group 'insert-shebang)

(defun get-extension-and-insert (filename)
  "Get extension from FILENAME and insert shebang.
FILENAME is a buffer name from which the extension in extracted."
  (interactive "*")
    ;; strip filename extension
    (setq file-extn (file-name-extension filename))
    
    ;; get value against the key
    (if (car (assoc file-extn file-types))
	;; if key exists in hashtable
	(progn
	  ;; set variable val to value of key
	  (setq val (cdr (assoc file-extn file-types)))
	  ;; if buffer is new
	  (if (= (point-min) (point-max))
	      (with-current-buffer (buffer-name)
		(goto-char (point-min))
		(insert (format "#!%s %s" (executable-find "env") val))
		(newline))
	    ;; if buffer has something, then
	    (save-excursion
	      (goto-char (point-min))
	      ;; search for shebang pattern
	      (if (integerp (re-search-forward "^#![ ]?\\([a-zA-Z_./]+\\)" 50 t))
		  (message "File already have %s shebang line" val)
		;; prompt user
		(if (y-or-n-p "File do not have shebang line, do you want to insert it now? ")
		    (progn
		      (with-current-buffer (buffer-name)
			(goto-char (point-min))
			(insert (format "#!%s %s" (executable-find "env") val))
			(newline))
		      (message "Shebang inserted"))
		  (progn
		    (message "Leaving file as it is"))
		  )))))
      ;; if key don't exists
      (progn
	(message "Can't guess file type. Type: M-x customize-group RET insert-shebang"))))

;;;###autoload
(defun insert-shebang ()
  "Calls get-get-extension-and-insert with argument as
buffer-name"
  (interactive "*")
  (get-extension-and-insert(buffer-name)))


(provide 'insert-shebang)
;;; insert-shebang.el ends here

