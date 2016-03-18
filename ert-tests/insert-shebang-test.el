;;; insert-shebang-test.el --- Tests for insert-shebang.el
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

(ert-deftest insert-shebang-file-types-test ()
  "Function to test default file types."
  (should (equal (cdr (assoc "py" insert-shebang-file-types)) "python"))
  (should (equal (cdr (assoc "sh" insert-shebang-file-types)) "bash"))
  (should (equal (cdr (assoc "pl" insert-shebang-file-types)) "perl")))
