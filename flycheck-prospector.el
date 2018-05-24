;;; flycheck-prospector.el --- Support prospector in flycheck

;; Copyright (C) 2018 Carlos Coelho <carlospecter@gmail.com>
;;
;; Author: Carlos Coelho <carlospecter@gmail.com>
;; Created: 23 May 2018
;; Version: 0.1
;; Package-Requires: ((flycheck "0.22"))

;;; Commentary:

;; This package adds support for prospector to flycheck. To use it, add
;; to your init.el:

;; (require 'flycheck-prospector)
;; (add-hook 'python-mode-hook 'flycheck-mode)

;; If you want to use prospector you probably don't want pylint or
;; flake8. To disable those checkers, add the following to your
;; init.el:

;; (add-to-list 'flycheck-disabled-checkers 'python-flake8)
;; (add-to-list 'flycheck-disabled-checkers 'python-pylint)

;;; License:

;; This file is not part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(require 'flycheck)


(flycheck-define-checker python-prospector
  "A Python syntax and style checker using the prospector utility.

To override the path to the prospector executable, set
`flycheck-python-prospector-executable'.

See URL `http://pypi.python.org/pypi/prospector'."
  :command ("prospector"
            "-0" "-M" "-o" "emacs"
            source-inplace)
  :error-patterns
  ((error line-start
    (file-name) ":" (one-or-more digit) ":" (one-or-more digit) ":" (optional "\r") "\n"
    (one-or-more " ") "L" line ":" column
    (message (minimal-match (one-or-more not-newline)) (or "frosted" "pep8") "E" (one-or-more digit) (optional "\r") "\n"
      (one-or-more not-newline)) (optional "\r") "\n" line-end)
   (error line-start
          (file-name) ":" (one-or-more digit) ":" (one-or-more digit) ":" (optional "\r") "\n"
          (one-or-more " ") "L" line ":" column
          (message (minimal-match (one-or-more not-newline)) "pylint" (one-or-more not-newline) (optional "\r") "\n"
                   (one-or-more " ") (one-or-more not-newline)) (optional "\r") "\n" line-end)
   (warning line-start
            (file-name) ":" (one-or-more digit) ":" (one-or-more digit) ":" (optional "\r") ":\n"
    (one-or-more " ") "L" line ":" column
    (message (minimal-match (one-or-more not-newline)) (or "frosted" "pep8") "W" (one-or-more digit) (optional "\r") "\n"
      (one-or-more not-newline)) (optional "\r") "\n" line-end)
   (warning line-start
          (file-name) ":" (one-or-more digit) ":" (one-or-more digit) ":" (optional "\r") "\n"
          (one-or-more " ") "L" line ":" column
          (message (minimal-match (one-or-more not-newline)) (or "dodgy" "pyroma" "vulture") (one-or-more not-newline) (optional "\r") "\n"
                   (one-or-more " ") (one-or-more not-newline)) (optional "\r") "\n" line-end))
  :modes python-mode)

;;;###autoload
(defun flycheck-prospector-setup ()
  "Setup Flycheck Prospector.

Add `prospector' to `flycheck-checkers'"
  (interactive)
  (add-to-list 'flycheck-checkers 'python-prospector))

(provide 'flycheck-prospector)
;;; flycheck-prospector.el ends here
