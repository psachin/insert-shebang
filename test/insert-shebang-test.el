;;; insert-shebang-test.el --- Tests for insert-shebang.el
(require 'ert)
(require 'insert-shebang)

(ert-deftest insert-shebang-env-path-test ()
  "Test insert-shebang `env' path."
  (should (equal insert-shebang-env-path "/usr/bin/env")))

(ert-deftest insert-shebang-header-scan-limit-test ()
  "Test header scan limit."
  (should (equal insert-shebang-header-scan-limit 6)))

(ert-deftest insert-shebang-eval-test ()
  "Test function insert-shebang-eval."
  (should (equal (insert-shebang-eval "bash") nil)))

(ert-deftest insert-shebang-eval-scan-first-line ()
  "TODO insert-shebang-scan-first-line-eval (val)"
  (should (equal nil nil)))

(ert-deftest insert-shebang-eval-scan-first-line-custom-header ()
  "TODO insert-shebang-scan-first-line-custom-header (val)"
  (should (equal nil nil)))

(ert-deftest insert-shebang-eval-write-log-file ()
  "TODO insert-shebang-write-log-file (log-file-path log-file-list)"
  (should (equal nil nil)))

(ert-deftest insert-shebang-eval-create-log-file ()
  "TODO insert-shebang-create-log-file (logfile)"
  (should (equal nil nil)))

(ert-deftest insert-shebang-eval-log-ignored-files ()
  "TODO insert-shebang-log-ignored-files (filename)"
  (should (equal nil nil)))

(ert-deftest insert-shebang-eval-log-ignored-files ()
  "TODO insert-shebang-open-log-buffer"
  (should (equal nil nil)))

(ert-deftest insert-shebang-file-types-test ()
  "Function to test default file types."
  (should (equal (cdr (assoc "py" insert-shebang-file-types)) "python"))
  (should (equal (cdr (assoc "sh" insert-shebang-file-types)) "bash"))
  (should (equal (cdr (assoc "pl" insert-shebang-file-types)) "perl"))
  (should (equal (cdr (assoc "groovy" insert-shebang-file-types)) "groovy"))
  (should (equal (cdr (assoc "rb" insert-shebang-file-types)) "ruby"))
  (should (equal (cdr (assoc "lua" insert-shebang-file-types)) "lua"))
  (should (equal (cdr (assoc "fish" insert-shebang-file-types)) "fish"))
  (should (equal (cdr (assoc "php" insert-shebang-file-types)) "php"))
  (should (equal (cdr (assoc "robot" insert-shebang-file-types)) "robot")))
