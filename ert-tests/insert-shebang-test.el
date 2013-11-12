;;; insert-shebang-test.el --- tests for insert-shebang.el
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
