;;; insert-shebang.el --- Inserts shebang line automatically -*- lexical-binding: t; -*-

;; Copyright (C) 2013  Sachin Patil

;; Author: Sachin Patil <isachin@iitb.ac.in>
;; URL: http://github.com/psachin/insert-shebang
;; Keywords: tools, convenience
;; Version: 0.9
;; Package-Requires: None

;; This file is NOT a part of GNU Emacs.

;; insert-shebang is free software distributed under the terms of the
;; GNU General Public License, version 3. For details, see the file
;; COPYING. 

;;; Commentary:
;; Inserts shebang line automatically

;;; Install
;; (load "~/.emacs.d/insert-shebang.el")

;;; Code:

(defgroup insert-shebang nil
  "Inserts shebang line automatically"
  :group 'extensions
  :link '(url-link :tag "Github" "https://github.com/psachin/insert-shebang")
  )

(defcustom insert-shebang-flag nil
  "*If non-nil, add the root directory to the load path."
  :type 'boolean
  :group 'example)

(defun get-extension-and-insert(filename)
  "Get extension from FILENAME and insert shebang.
FILENAME is a buffer name from which the extension in extracted."

  (interactive "*")
  (let (myInterpreter val)
     
    ;; Create a hash table
    ;; Our 'key' as well as 'values' are of type 'string'
    ;; so we used :test 'equal to let elisp know that the function equal
    ;; should be used when testing whether a key exists.
    (setq myInterpreter (make-hash-table :test 'equal))
    
    ;; add new entry here (dictionary)
    (puthash "py" "python" myInterpreter)
    (puthash "sh" "bash" myInterpreter)
    (puthash "el" "emacs" myInterpreter)
    (puthash "pl" "perl" myInterpreter)
    (puthash "rb" "ruby" myInterpreter)
    
    ;; strip filename extension
    (setq file-extn (file-name-extension filename))
    
    ;; get value against the key
    (if (gethash file-extn myInterpreter)
	;; if key exists in hashtable
	(progn
	  ;; set variable val to value of key
	  (setq val (gethash file-extn myInterpreter))
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
	(message "Can't guess file type"))
      )))

(defun insert-shebang()
  "Calls get-get-extension-and-insert with argument as
buffer-name"
  (interactive "*")
  (get-extension-and-insert(buffer-name)))

;; create hook
(add-hook 'find-file-hook 'insert-shebang)
;; (remove-hook 'find-file-hook 'insert-shebang)

(provide 'insert-shebang)
;;; insert-shebang.el ends here

