;; A simple Emacs mode for WebDSL, written by Zef Hemel
;; Usage:
;;   Put the following line in your ~/.emacs file:
;;     (load "~/webdsl/webdsls/src/org/webdsl/dsl/project/webdsl")
;;   change path depending on your configuration, do not append the .el extension!
;;
;; Features:
;; - Basic highlighting for keywords (for all .app files)
;; - Basic indentation
;; - Basic building and deploying features: C-c c to compile your current webdsl application
;;                                          C-c d to deploy your current webdsl application
;;                                          C-c k to hide the build/deploy window

(setq auto-mode-alist (cons '("\\.app\\'" . webdsl-mode) auto-mode-alist))

(defun indent-like-previous-return ()
  (interactive)
  (newline)
  (indent-like-previous-line))

(defun indent-like-previous-line ()
  "Indents this line as the previous one"
  (interactive)
  (if (eq (line-beginning-position) (point))
      (let ((s (point)))
	(forward-line -1)
	(let ((pls (point)))
	  (skip-chars-forward " \t")
	  (if (eq (point) (line-end-position))
	      (progn
		(goto-char s)
		(insert "  "))
	      (let ((ple (point)))
		(goto-char s)
		(insert (buffer-substring pls ple))))))
    (insert "  ")))

(defvar webdsl-mode-hook nil
  "Normal hook run when entering WebDSL mode.")

(defvar webdsl-mode-map nil
  "Keymap for WebDSL mode.")

(setq webdsl-mode-map (make-sparse-keymap))

(defun webdsl-mode ()
  "Major mode for editing WebDSL programs."
  (interactive)
  (kill-all-local-variables)
  (use-local-map webdsl-mode-map)
  (setq major-mode 'webdsl-mode)
  (setq mode-name "WebDSL")
  
  ; Setting up font-locking
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(webdsl-keywords nil t nil nil))

  (make-local-variable 'comment-start)
  (make-local-variable 'comment-end)
  (make-local-variable 'comment-start-skip)

  (setq comment-start "// "
	comment-end ""
	comment-start-skip "/\\*[ \n\t]+")
  (define-key webdsl-mode-map (kbd "TAB") 'indent-like-previous-line)
  (define-key webdsl-mode-map (kbd "RET") 'indent-like-previous-return)
  (define-key webdsl-mode-map "\C-cc" 'compile-webdsl)
  (define-key webdsl-mode-map "\C-cd" 'deploy-webdsl)
  (define-key webdsl-mode-map "\C-ck" 'hide-compile-webdsl-window)

  (run-hooks 'webdsl-mode-hook))

(defvar webdsl-keywords
   ; for i in $( cat WebDSL.sdf | cut -d "-" -f 1 | grep -o -e '"[A-Za-z]*"' | cut -d '"' -f 2 | sort | uniq); do  echo -n "  \"\\\\<$i\\\\>\"";  done
  '("\\<a\\>"  "\\<action\\>"  "\\<application\\>"  "\\<as\\>"  "\\<define\\>"  "\\<description\\>"  "\\<else\\>"  "\\<end\\>"  "\\<entity\\>"  "\\<extend\\>"  "\\<false\\>"  "\\<for\\>"  "\\<function\\>"  "\\<globals\\>"  "\\<goto\\>"  "\\<if\\>"  "\\<imports\\>"  "\\<in\\>"  "\\<init\\>"  "\\<inverse\\>"  "\\<inverseSlave\\>"  "\\<is\\>"  "\\<List\\>"  "\\<module\\>"  "\\<note\\>"  "\\<null\\>"  "\\<page\\>"  "\\<return\\>"  "\\<rules\\>"  "\\<section\\>"  "\\<select\\>"  "\\<session\\>"  "\\<Set\\>"  "\\<task\\>"  "\\<true\\>"  "\\<var\\>"  "\\<where\\>" "\\<access\\>" "\\<control\\>" "\\<with\\>" "\\<template\\>" "\\<order\\>" "\\<by\\>" "\\<asc\\>" "\\<desc\\>" "\\<enum\\>" "\\<credentials\\>"
    ("//.*$" 0 'font-lock-comment-face t)))

(defun compile-webdsl ()
  (interactive)
  (setq webdsl-filename (file-name-directory (buffer-file-name)))
  (if (not (eq webdsl-compile-window nil)) (hide-compile-webdsl-window))
  (setq shw (selected-window))
  (setq webdsl-compile-window (split-window-vertically))
  (select-window shw)
  (shell "*WebDSL output*")
  (insert (concat "cd " webdsl-filename "; webdsl"))
  (comint-send-input)
  (select-window shw))

(defun deploy-webdsl ()
  (interactive)
  (setq webdsl-filename (file-name-directory (buffer-file-name)))
  (if (not (eq webdsl-compile-window nil)) (hide-compile-webdsl-window))
  (setq shw (selected-window))
  (setq webdsl-compile-window (split-window-vertically))
  (select-window shw)
  (shell "*WebDSL output*")
  (insert (concat "cd " webdsl-filename "; webdsl deploy"))
  (comint-send-input)
  (select-window shw))

(defun hide-compile-webdsl-window ()
  (interactive)
  (delete-window webdsl-compile-window)
  (setq webdsl-compile-window nil))

(setq webdsl-compile-window nil)

