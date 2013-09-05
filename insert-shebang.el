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

(defcustom file-types
  '(("py" . "python")
    ("sh" . "bash")
    ("pl" . "perl"))
  "*If nil, add all your file extensions and file types here."
  :type '(alist :key-type (string :tag "Extension") :value-type (string :tag "Type"))
  :group 'insert-shebang)

(defcustom ignore-extensions
  '("txt" "org")
  "*Add extensions you want to ignore.
List of file extensions to be ignored by default."
  :type '(repeat (string :tag "extn"))
  :group 'insert-shebang)

(defcustom custom-headers nil
  "Put your custom headers for other file types here.
For example '#include <stdio.h>' for c file etc.

Example:

File type: c
Header: #include <stdio.h>

File type: f90
Header: program

File type: f95
Header: program"
  :type '(alist :key-type (string :tag "Extension") :value-type (string :tag "Header"))
  :group 'insert-shebang)

(defcustom header-scan-limit 6
"Define how much initial characters to scan from starting for custom headers.
This is to avoid differentiating header `#include <stdio.h>` with
`#include <linux/modules.h>` or `#include <strings.h>`."
  :type '(integer :tag "Limit")
  :group 'insert-shebang)

(defun get-extension-and-insert (filename)
  "Get extension from FILENAME and insert shebang.
FILENAME is a buffer name from which the extension in extracted."
  (interactive "*")
  (let (file-extn
	val)
  ;; strip filename extension
  (setq file-extn (file-name-extension filename))
  ;; check if this extension is ignored
  (if (car (member file-extn ignore-extensions))
      (progn (message "Extension ignored"))
    ;; if not, check in extension list
    (progn
      (if (car (assoc file-extn custom-headers))
	  (progn ;; insert custom header
	    (setq val (cdr (assoc file-extn custom-headers)))
	    (if (= (point-min) (point-max))
		;; insert custom-header at (point-min)
		(insert-custom-header val)
	      (progn
		(scan-first-line val))))
	(progn
	;; get value against the key
      (if (car (assoc file-extn file-types))
	  ;; if key exists in list 'file-types'
	  (progn
	    ;; set variable val to value of key
	    (setq val (cdr (assoc file-extn file-types)))
	    ;; if buffer is new
	    (if (= (point-min) (point-max))
		(insert-shebang-eval val)
	      ;; if buffer has something, then
	      (progn
		(scan-first-line-eval val))))
	;; if key don't exists
	(progn
	  (message "Can't guess file type. Type: 'M-x customize-group RET insert-shebang' to customize")))))))))

(defun insert-shebang-eval (val)
  "Insert shebang with prefix 'eval' string in current buffer.
With VAL as an argument."
  (with-current-buffer (buffer-name)
    (goto-char (point-min))
    (insert (format "#!%s %s" (executable-find "env") val))
    (newline)
    (goto-char (point-min))
    (end-of-line)))

(defun scan-first-line-eval (val)
  "Scan very first line of the file.
With VAL as an argument and look if it has matching shebang-line."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    ;; search for shebang pattern
    (if (integerp (re-search-forward "^#![ ]?\\([a-zA-Z_./]+\\)" 50 t))
	(message "This %s file already has shebang line" val)
      ;; prompt user
      (if (y-or-n-p "File do not have shebang line, do you want to insert it now? ")
	  (progn
	    (insert-shebang-eval val))
	(progn
	  (message "Leaving file as it is"))))))

(defun insert-custom-header (val)
  "Insert custom header.
With VAL as an argument."
  (interactive)
  (with-current-buffer (buffer-name)
    (goto-char (point-min))
    (insert val)
    (newline)
    (goto-char (point-min))
    (end-of-line)))

(defun scan-first-line (val)
  "Scan very first line of the file and look if it has matching header.
With VAL as an argument."
  (interactive)
    (save-excursion
      (goto-char (point-min))
      ;; search for shebang pattern
      (if (integerp (re-search-forward (format "^%s" (substring val 0 header-scan-limit)) 50 t))
	  (message "File already has header")
	;; prompt user
	(if (y-or-n-p "File do not have header, do you want to insert it now? ")
	  (progn
	    (goto-char (point-min))
	    (insert-custom-header val))
	  (progn
	    (message "Leaving file as it is"))))))

;;;###autoload
(defun insert-shebang ()
  "Call `get-extension-and-insert`.
With argument as `buffer-name'."
  (interactive "*")
  (get-extension-and-insert(buffer-name)))

(provide 'insert-shebang)
;;; insert-shebang.el ends here

