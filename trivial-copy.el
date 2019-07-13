;;; trivial-copy.el --- Trivial copy files in Dired     -*- lexical-binding: t; -*-

;; Author: Yuan Fu <casouri@gmail.com>

;;; This file is NOT part of GNU Emacs

;;; Commentary:
;;
;; Right now trivial-copy only supports mac.

(require 'subr-x)
(require 'pcase)

(defvar trivial-copy-mac-copy-exe "pbcopyf"
  "Path to the copy tool on mac.")

(defvar trivial-copy-mac-paste-exe "pbpastef"
  "Path to the paste tool on mac.")

(defvar trivial-copy-mac-move-exe "pbmovef"
  "Path to the move tool on mac.")

(defun trivial-copy-os ()
  "Return symbolized system name or nil."
  (intern-soft system-type))

(defvar trivial-copy-copy-fn-alist '((darwin . (lambda (file-list)
                                                 (shell-command-to-string
                                                  (string-join
                                                   (append (list trivial-copy-mac-copy-exe) file-list)
                                                   " ")))))
  "An alist of copy functions. (system-symbol . function)
System-symbol is symbolized from `system-type’.
The function takes a list of absolute file paths.")

(defvar trivial-copy-paste-fn-alist '((darwin . (lambda (dir)
                                                  (shell-command-to-string
                                                   (format "%s %s" trivial-copy-mac-paste-exe dir)))))
  "An alist of paste functions. (system-symbol . function)
System-symbol is symbolized from `system-type’.
The function takes an absolute directory path.")

(defvar trivial-copy-move-fn-alist '((darwin . (lambda (dir)
                                                 (shell-command-to-string
                                                  (format "%s %s" trivial-copy-mac-move-exe dir)))))
  "An alist of move functions. (system-symbol . function)
System-symbol is symbolized from `system-type’.
The function takes an absolute directory path.")

(defun trivial-copy-copy ()
  "Copy marked files to system’s clipboard."
  (interactive)
  (when (derived-mode-p 'dired-mode)
    (funcall (alist-get (trivial-copy-os) trivial-copy-copy-fn-alist)
             (dired-get-marked-files))))

(defun trivial-copy-paste ()
  "Paste files in system’s clipboard to current directory."
  (interactive)
  (when (derived-mode-p 'dired-mode)
    (funcall (alist-get (trivial-copy-os) trivial-copy-paste-fn-alist)
             default-directory)))

(defun trivial-copy-move ()
  "Move files in system’s clipboard to current directory."
  (interactive)
  (when (derived-mode-p 'dired-mode)
    (funcall (alist-get (trivial-copy-os) trivial-copy-move-fn-alist)
             default-directory)))

;;; Code:
;;

(provide 'trivial-copy)

;;; trivial-copy.el ends here
