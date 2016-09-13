(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

;;;;;;;;;;;;;
;; General ;;
;;;;;;;;;;;;;

;; Default encoding
(set-language-environment "UTF-8")

;; Initalize package.el
(require 'package)

(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("elpy" . "https://jorgenschaefer.github.io/packages/")))

;; use-package.el
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Electric pair on startup
(electric-pair-mode 1)

;; Maximize on startup
(defun w32-maximize-frame ()
  "Maximize the current frame (windows only)"
  (interactive)
  (w32-send-sys-command 61488))
(if (eq system-type 'windows-nt)
    (progn
      (add-hook 'window-setup-hook 'w32-maximize-frame t))
  (set-frame-parameter nil 'fullscreen 'maximized))

;; Remove GUI guff
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen
(setq inhibit-splash-screen t)

;; Set font
;; (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-11" ))
;; (set-face-attribute 'default t :font "DejaVu Sans Mono-11")

;; Set theme
;; (use-package monokai-theme
;;   :init
;;   (setq monokai-use-variable-pitch nil
;;         monokai-height-minus-1 1.0
;;         monokai-height-plus-1 1.0
;;         monokai-height-plus-2 1.0
;;         monokai-height-plus-3 1.0
;;         monokai-height-plus-4 1.0)
;;   :config
;;   (load-theme 'monokai t))

;; Add doom theme to loadpath

;; Doom requires Dash
(use-package dash)

(add-to-list 'load-path "~/.emacs.d/themes/doom-theme")
(require 'doom-theme)
(load-theme 'doom-one t)

;; Rainbow delimiters
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; Highlight matching parenthesis
(custom-set-variables '(show-paren-delay 0.0))
(show-paren-mode t)

;; Highlight trailing whitespace
(custom-set-variables '(show-trailing-whitespace t))
(custom-set-faces '(trailing-whitespace ((t (:background "dim gray")))))

;; Prettify symbols
(global-prettify-symbols-mode)

;; Indicate lines after EOF
(define-fringe-bitmap 'tilde [0 0 0 113 219 142 0 0] nil nil 'center)
(setcdr (assq 'empty-line fringe-indicator-alist) 'tilde)
(set-fringe-bitmap-face 'tilde 'font-lock-comment-face)
(setq-default indicate-empty-lines t)

;; Auto-Complete
;; (use-package auto-complete
;;   :config
;;   (ac-config-default))

;; Show column lines in mode-lin
(column-number-mode t)

;; Cleanup mode-line
(use-package diminish
  :config
  (eval-after-load "hideshow" '(diminish 'hs-minor-mode))
  (eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
  (eval-after-load "simple" '(diminish 'overwrite-mode))
  (eval-after-load "autorevert" '(diminish 'auto-revert-mode)))


;; Backup & auto-save in one directory
(setq backup-directory-alist `((".*" . "~/.emacs.d/tmp"))
      auto-save-file-name-transforms `((".*" , "~/.emacs.d/tmp" t)))

;; Smooth scroll
(setq scroll-margin 0)
(setq scroll-conservatively 10000)
(setq scroll-preserve-screen-position t)

;; y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Wrap text at 80 chars
(setq-default fill-column 80)

;; Auto-update changed files
(global-auto-revert-mode t)

;; Better same-name buffers
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Remember last position for reopened files
(if (version< emacs-version "25.0")
    (progn (require 'saveplace)
           (setq-default save-place t))
  (save-place-mode 1))

;; Disable garbage collection in mini-buffer
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))
(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))
(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

;;;;;;;;;;;;;;;;;;;;;;;;
;; Install extensions ;;
;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit)
(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))
(use-package ace-jump-mode)
(autoload 'ace-jump-mode-pop-mark
  "ace-jump-mode")
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; ido-imenu
(use-package imenu-anywhere)
(global-set-key (kbd "C-.") #'imenu-anywhere)

;; ace-window
(use-package ace-window
  :init
  (global-set-key (kbd "M-p") 'ace-window))

;; smart-parens
(use-package smartparens)
(require 'smartparens-config)

;; indent guide
(use-package indent-guide
  :config
  (indent-guide-global-mode))

;;;;;;;;;;;;;;;;;;;
;; Sane defaults ;;
;;;;;;;;;;;;;;;;;;;
;; (use-package sane-defaults)

;; Expand-region
(use-package expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Don't use expand-region fast keys
(setq expand-region-fast-keys-enabled nil)

;; Show expand-region command used
(setq er--show-expansion-message t)

;; Smart M-x is smart
(use-package smex)
(smex-initialize)

;; Run at full power please
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)


;;;;;;;;;;
;; Helm ;;
;;;;;;;;;;
(use-package helm
  :diminish helm-mode
  :init
  (require 'helm-config)
  (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
        helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
        helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
        helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
        helm-ff-file-name-history-use-recentf t)
  :config
  (helm-mode 1)
  (custom-set-variables
   '(helm-recentf-fuzzy-match t)
   '(helm-buffers-fuzzy-matching t)
   '(helm-M-x-fuzzy-match t)
   '(helm-apropos-fuzzy-match t)
   '(helm-completion-in-region-fuzzy-match t)))

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

;; Helm keybindings
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-,") 'helm-imenu-anywhere)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)


;; File associatons
;; setup files ending in “.js” to open in js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


;; Company
(use-package company
  :init
  (global-company-mode))

(use-package company-c-headers
  :init
  (add-to-list 'company-backends 'company-c-headers))

;; (add-hook 'after-init-hook 'global-company-mode)

;; jedi-company
;; (use-package company-jedi)

;; php
;; (use-package php-mode)
;; (use-package ac-php)
;; (use-package company-quickhelp
;;   :init
;;   (company-quickhelp-mode 1))

(use-package company-php
  :init
  (add-hook 'php-mode-hook
	    '(lambda ()
	       (require 'company-php)
	       (company-mode t)
	       (add-to-list 'company-backends 'company-ac-php-backend ))))

;; Python
(use-package elpy
  :init
  (elpy-enable))

;; Replace selected text
(delete-selection-mode 1)

(setq tramp-default-method "ssh")

;; Default to global linum mode
(global-linum-mode 1)
;; (setq org-alphabetical-lists t)

(use-package restclient)

;; Org mode
(use-package org-bullets
  :ensure t
  :init
  (setq org-bullets-bullet-list
	'("◉" "◎" "⚫" "○" "►" "◇"))
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-todo-keywords '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")
			  (sequence "⚑ WAITING(w)" "|")
			  (sequence "|" "✘ CANCELED(c)")))


;; C++
(use-package ggtags)
(use-package helm-gtags)
(use-package helm-projectile)
(use-package irony)
(use-package company-irony)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(use-package flycheck-irony)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; Swoop
(use-package helm-swoop)

(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)
;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

;; Move up and down like isearch
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))


(use-package projectile)

(projectile-global-mode)
(setq projectile-enable-caching t)

(helm-projectile-on)
(setq projectile-completion-system 'helm)

(use-package helm-company
  :init
  (eval-after-load 'company
    '(progn
       (define-key company-mode-map (kbd "C-:") 'helm-company)
       (define-key company-active-map (kbd "C-:") 'helm-company)))
  )

(use-package flycheck)
(global-flycheck-mode)


;; Twitter bootstrap org export
(use-package ox-twbs)


;; Eval and replace by magnars
(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(global-set-key (kbd "C-x C-e") 'eval-and-replace)

;; Aggresive Indent
(use-package aggressive-indent)
(global-aggressive-indent-mode 1)


;; Emojis because why not
(use-package emojify)
;; Enable emojify gloablly
(add-hook 'after-init-hook #'global-emojify-mode)


;; Which key
(use-package which-key)
(which-key-mode)



;; systemd file highlight
(add-to-list 'auto-mode-alist '("\\.service\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.timer\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.target\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.mount\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.automount\\'" . conf-unix-mode))
p(add-to-list 'auto-mode-alist '("\\.slice\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.socket\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.path\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.netdev\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.network\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.link\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.automount\\'" . conf-unix-mode))
