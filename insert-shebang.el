;;; insert-shebang.el --- Inserts shebang line automatically

;; Copyright (C) 2013  Sachin Patil

;; Author: Sachin Patil <isachin@iitb.ac.in>
;; URL: http://github.com/psachin/insert-shebang
;; Keywords: tools, convenience
;; Version: 0.9.2

;; This file is NOT a part of GNU Emacs.

;; insert-shebang is free software distributed under the terms of the
;; GNU General Public License, version 3. For details, see the file
;; COPYING.

;;; Commentary:
;; Inserts shebang line automatically
;; URL: http://github.com/psachin/insert-shebang

;; Install
;;
;; Unless installed from a package, add the directory containing
;; this file to `load-path', and then:
;; (require 'insert-shebang)
;;
;; Then enable it globally using:
;;
;; (add-hook 'find-file-hook 'insert-shebang)

;; Customize
;; M-x customize-group RET insert-shebang RET

;;; Code:

(defgroup insert-shebang nil
  "Inserts shebang line automatically."
  :group 'extensions
  :link '(url-link :tag "Github" "https://github.com/psachin/insert-shebang"))

(defcustom insert-shebang-env-path "/usr/bin/env"
  "Full path to `env' binary.
You can find the path to `env' by typing `which env' in the
terminal."
  :type '(string)
  :group 'insert-shebang)

(defcustom insert-shebang-file-types
  '(("py" . "python")
    ("sh" . "bash")
    ("pl" . "perl"))
  "*If nil, add all your file extensions and file types here."
  :type '(alist :key-type (string :tag "Extension")
		:value-type (string :tag "Type"))
  :group 'insert-shebang)

(defcustom insert-shebang-ignore-extensions
  '("txt" "org")
  "*Add extensions you want to ignore.
List of file extensions to be ignored by default."
  :type '(repeat (string :tag "extn"))
  :group 'insert-shebang)

(defcustom insert-shebang-custom-headers nil
  "Put your custom headers for other file types here.
For example '#include <stdio.h>' for c file etc.

Example:

File type: c
Header: #include <stdio.h>

File type: f90
Header: program

File type: f95
Header: program"
  :type '(alist :key-type (string :tag "Extension")
		:value-type (string :tag "Header"))
  :group 'insert-shebang)

(defcustom insert-shebang-header-scan-limit 6
"Define how much initial characters to scan from starting for custom headers.
This is to avoid differentiating header `#include <stdio.h>` with
`#include <linux/modules.h>` or `#include <strings.h>`."
  :type '(integer :tag "Limit")
  :group 'insert-shebang)

(defun insert-shebang-get-extension-and-insert (filename)
  "Get extension from FILENAME and insert shebang.
FILENAME is a buffer name from which the extension in extracted."
  (if (file-name-extension filename)
  (let ((file-extn (file-name-extension filename)))
  ;; check if this extension is ignored
  (if (car (member file-extn insert-shebang-ignore-extensions))
      (progn (message "Extension ignored"))
    ;; if not, check in extension list
    (progn
      (if (car (assoc file-extn insert-shebang-custom-headers))
	  (progn ;; insert custom header
	    (let ((val (cdr (assoc file-extn insert-shebang-custom-headers))))
	    (if (= (point-min) (point-max))
		;; insert custom-header at (point-min)
		(insert-shebang-custom-header val)
	      (progn
		(insert-shebang-scan-first-line-custom-header val)))))
	(progn
	;; get value against the key
      (if (car (assoc file-extn insert-shebang-file-types))
	  ;; if key exists in list 'insert-shebang-file-types'
	  (progn
	    ;; set variable val to value of key
	    (let ((val (cdr (assoc file-extn insert-shebang-file-types))))
	    ;; if buffer is new
	    (if (= (point-min) (point-max))
		(insert-shebang-eval val)
	      ;; if buffer has something, then
	      (progn
		(insert-shebang-scan-first-line-eval val)))))
	;; if key don't exists
	(progn
	  (message "Can't guess file type. Type: 'M-x customize-group RET \
insert-shebang' to customize"))))))))))

(defun insert-shebang-eval (val)
  "Insert shebang with prefix 'eval' string in current buffer.
With VAL as an argument."
  (with-current-buffer (buffer-name)
    (goto-char (point-min))
    (insert (format "#!%s %s" insert-shebang-env-path val))
    (newline)
    (goto-char (point-min))
    (end-of-line)))

(defun insert-shebang-custom-header (val)
  "Insert custom header.
With VAL as an argument."
  (with-current-buffer (buffer-name)
    (goto-char (point-min))
    (insert val)
    (newline)
    (goto-char (point-min))
    (end-of-line)))

(defun insert-shebang-scan-first-line-eval (val)
  "Scan very first line of the file.
With VAL as an argument and look if it has matching shebang-line."
  (save-excursion
    (goto-char (point-min))
    ;; search for shebang pattern
    (if (integerp (re-search-forward "^#![ ]?\\([a-zA-Z_./]+\\)" 50 t))
	(message "This %s file already has shebang line" val)
      ;; prompt user
      (if (y-or-n-p "File do not have shebang line, \
do you want to insert it now? ")
	  (progn
	    (insert-shebang-eval val))
	(progn
	  (message "Leaving file as it is"))))))

(defun insert-shebang-scan-first-line-custom-header (val)
  "Scan very first line of the file and look if it has matching header.
With VAL as an argument."
    (save-excursion
      (goto-char (point-min))
      ;; search for shebang pattern
      (if (integerp (re-search-forward
		     (format "^%s"
			     (substring val 0 insert-shebang-header-scan-limit))
		     50 t))
	  (message "File already has header")
	;; prompt user
	(if (y-or-n-p "File do not have header, do you want to insert it now? ")
	  (progn
	    (goto-char (point-min))
	    (insert-shebang-custom-header val))
	  (progn
	    (message "Leaving file as it is"))))))

;;;###autoload
(defun insert-shebang ()
  "Call `insert-shebang-get-extension-and-insert`.
With argument as `buffer-name'."
  (interactive "*")
  (insert-shebang-get-extension-and-insert(buffer-name)))

(provide 'insert-shebang)
;;; insert-shebang.el ends here

