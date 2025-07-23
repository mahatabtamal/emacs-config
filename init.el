;;#########################################
;;#              Basic settings           #
;;#########################################

;; -*- lexical binding: t -*-
(setopt electric-pair-mode t
	      electric-pair-delete-adjacent-pairs t
	      electric-indent-mode t
	      electric-pair-delete-adjacent-pairs t);; this is literally the first settings to be enabled oh my God

(setopt recentf-mode t    ;;remembers of recent files
	savehist-mode t    ;;minibuffer history is saved
	save-place-mode t;;remembers previous cursor position in a file
	;;(setopt visible-bell t)
	;;(delete-selection-mode t)
	global-page-break-lines-mode t
	;; Basic ui tweaks that come builtin.
	menu-bar-mode nil    ;; stops menubar, toolbar and scrollbar
	tool-bar-mode nil
	scroll-bar-mode nil)

;;(add-to-list 'default-frame-alist '(fullscreen . maximized))    ;; starts in fullscreen

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(use-package gcmh    ;; Using garbage magic hack
  :custom
  (gc-cons-threshold 402653184)    ;;  Setting garbage collection threshold
  (gc-cons-percentage 0.5)
  :hook
  (after-init . gcmh-mode))

(setopt native-comp-async-query-on-exit t
      confirm-kill-processes t
      package-native-compile t
      native-comp-async-report-warnings-errors nil
      load-prefer-newer t
      native-comp-warning-on-missing-source t)

(setopt custom-file "~/.emacs.d/custom.el")    ;; trashes custom settings to this path
(load custom-file)

;;#########################################
;;#              Fonts                    #
;;#########################################

(setopt line-spacing 1)  ;;  line spacing

(custom-set-faces
 '(font-lock-comment-face ((t (:slant italic))))
 '(font-lock-keyword-face ((t (:slant italic)))))
;; '(font-lock-variable-name-face ((t (:slant italic))))
;; '(font-lock-function-name-face ((t (:slant italic)))))

(custom-set-faces
 '(italic ((t (:slant italic)))))    ;; workaround for underlined italics for some themes

;; font settings
(custom-set-faces
 '(default ((t (:family "LigaSauceCodePro Nerd Font" :height 110 :weight regular))))
 '(variable-pitch ((t (:family "Source Sans Pro " :height 130 :weight regular))))
 '(fixed-pitch ((t (:family "Source Code Pro" :height 110 :weight regular))))
 '(shr-text ((t (:family "Source Sans Pro" :height 120 :weight regular)))))


(set-fontset-font "fontset-default" 'bengali "Noto Serif Bengali-13")
(set-fontset-font "fontset-default" 'arabic "Noto Naskh Arabic-18")


;;#########################################
;;#              Completion               #
;;#########################################

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-scroll-margin 0) ;; scroll margin
  (vertico-count 12) ;; vertico candidates number
  (vertico-resize t) ;; resize the vertico minibuffer
  (vertico-cycle t))   ;; minibuffer options are cyclical

(use-package vertico-directory    ;; Configure directory extension
  :after vertico   ;; after launching vertico
  :ensure nil
  :bind (:map vertico-map   ;; More convenient directory navigation commands
	      ("RET" . vertico-directory-enter)
	      ("DEL" . vertico-directory-delete-char)
	      ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(setf ;; completion-styles '(basic flex)
      completion-auto-select t
      completion-auto-help 'visible
      completions-format 'one-column
      completions-sort 'historical
      completions-max-height 20
      completion-ignore-case t)

(use-package marginalia;; M-x details information
  :after vertico
  :custom
  (marginalia-align 'center)    ;; info aligns to left/right/center
  :init    ;; startvvs
  (marginalia-mode))

(use-package orderless    ;;completion algorithm that  matches by any order
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :defer t
  :bind
  ("C-x r b" . consult-bookmark)
  ("C-x b" . consult-buffer)    ;; preview buffer while switching
  ("M-y" . consult-yank-pop)    ;; open kill ring
  ("M-g e" . consult-compile-error)   ;; find compile error in minibuffer
  ("M-g f" . consult-flymake)    ;; flymake view like on IDEs
  ("M-g g" . consult-goto-line)    ;; goto line number
  ("M-s f" . consult-find)    ;; fuzzy find file
  ("M-s r" . consult-grep)    ;; grep/ripgrep
  ("M-g i" . consult-imenu)    ;; browse org-headers with imenu
  ("M-s l" . consult-line))    ;; better C-s search

(use-package consult-dir
  :after consult
  :bind
  ("M-s d" . consult-dir))

;; (global-set-key (kbd "C-s") 'consult-line)
(use-package affe
  :defer t
  :bind
  ("C-x a f" . affe-find))

(use-package corfu    ;; completion ui
  :ensure t
  :custom
  (corfu-cycle t)    ;; cycles the completion options
  (corfu-auto t)    ;; autocompletion
  (corfu-min-width 20)    ;; ui minimum width for 20 chars
  (corfu-scroll-margin 5)    ;; scroll margin
  (corfu-history-mode t)    ;; saves comp. option history
  :hook
  (prog-mode . corfu-mode)
  (org-mode . corfu-mode))

(use-package corfu-popupinfo
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode))

(setopt completion-preview-minimum-symbol-length 2)
(dolist (mode '(org-mode text-mode comint-mode eshell-mode web-mode))
  (add-hook (intern (format "%s-hook" mode)) 'completion-preview-mode))

(use-package which-key
  :hook  
  (after-init . which-key-mode)
  :custom
  (which-key-side-window-location 'bottom)
  ;;  ( which-key-unicode-correction 3)
  (which-key-max-display-columns 5)
  (which-key-idle-delay 1.0)
  (which-key-max-description-length 35)
  (which-key-add-column-padding 5)
  (which-key-popup-type 'minibuffer)
  
  (define-key which-key-mode-map (kbd "C-x <f5>") 'which-key-C-h-dispatch)
  (which-key-side-window-max-height 0.2))

(use-package dired
  :custom
  (dired-listing-switches "-alh")   ;; file size in human readable format
  (dired-dwim-target t)
  :hook
  (dired-mode . dired-hide-details-mode) ;; hide details on left, ( to toggle
  (dired-mode . auto-revert-mode))


(use-package dired-open
  :ensure t
  :custom
  (dired-open-extensions '(("pdf" . "papers")
				("mp4" . "mpv")
				("webm" . "celluloid")
				("mkv" . "mpv"))))

(setopt TeX-command-default "latexmk")


;;#########################################
;;#              programming              #
;;#########################################

(global-set-key (kbd "M-!") 'async-shell-command)
(global-set-key (kbd "M-&") 'shell-command)

(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-fallback-alist
	'((ocaml-ts-mode . tuareg-mode)))
  (treesit-auto-add-to-auto-mode-alist))

(setopt treesit-font-lock-level 4)

(setq treesit-language-source-alist
      '((ocaml "https://github.com/tree-sitter/tree-sitter-ocaml" "0.21.0" "ocaml")))

(use-package devdocs
  :custom
  ;; (devdocs-current-docs
  ;;             '((go-ts-mode . "go")
  ;; 		(python-ts-mode . "python~3.13")))
  (devdocs-browser-function 'eww-browse-url)
  :bind
  ("C-h D" . 'devdocs-lookup))

(getenv "TERM")

(use-package envrc
  :hook (after-init . envrc-global-mode))

(setopt python-indent-offset 4)

(use-package flymake
  :hook
  (prog-mode . flymake-mode))

(setopt global-treesit-auto-mode t)

(use-package eglot
  :bind (:map eglot-mode-map
	      ("C-c e r" . eglot-rename)
	      ("C-c e a" . eglot-code-actions))
  :config
  (add-to-list 'eglot-server-programs
	       '(python-ts-mode. "pylsp"))
  :hook
  (python-ts-mode . eglot-ensure)
  (css-ts-mode. eglot-ensure))

(use-package eglot-booster
  :custom
  (eglot-booster-io-only t)
  (eglot-booster-mode))

;; guile configuration
(use-package geiser
  :config
  (setq geiser-active-implementations '(guile)))

;; Python configuration;;

;; (use-package elpy
;;   :hook
;;   (python-ts-mode . elpy-enable))

;; (setopt python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i --simple-prompt")

;; go customuration
;; (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))


;;ocaml config
(use-package ocp-indent)
(add-to-list 'load-path "/home/tamal/.opam/cs3110-2025sp/share/emacs/site-lisp")


(use-package tuareg
  :ensure t
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))

(use-package ocaml-eglot
  :after tuareg
  :hook
  (tuareg-mode . ocaml-eglot))
;; (use-package kotlin-ts-mode)
;; (add-to-list 'auto-mode-alist '("\\.kts\\'" . kotlin-ts-mode))

(use-package web-mode
  :defer t
  ;; :ensure t
  :mode "\\.html?\\'" 
  ;; :mode "\\.css\\'"
  :mode "\\.phtml\\'"
  :mode "\\.tpl\\.php\\'"
  :mode "\\.[agj]sp\\'"
  :mode "\\.as[cp]x\\'"
  :mode "\\.erb\\'"
  :mode "\\.mustache\\'"
  :mode "\\.djhtml\\'"
  :mode "\\.vue\\'"
  ;; :mode "\\.jsx\\'"
  :custom
  (web-mode-markup-indent-offser 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

;; ;; (use-package jtsx-mode
;; ;;   :defer t
;; ;;   :mode (("\\.jsx\\'" . jtsx-mode)))

;; (use-package emmet-mode
;;   :defer t
;;   :hook ((web-mode
;; 	 js-jsx-mode)
;; 	 . emmet-mode)
;;   :custom
;;   (setopt emmet-indent-after-insert nil
;;         emmet-indentation 2))

;; (use-package simple-httpd
;;   :defer t
;;   :custom
;;   (setopt httpd-port 5176))

;; (use-package js-comint
;;   :ensure t
;;   :custom
;;   (setopt inferior-js-program-command "node"
;; 	js-comint-program-command "node"))
;; 					; Remap Elisp's eval-last-sexp (C-x C-e) to eval JavaScript
;; (define-key js-mode-map [remap eval-last-sexp] #'js-comint-send-last-sexp)
;; (define-key js-mode-map (kbd "C-c b") 'js-send-buffer)

(defun open-in-live-server ()
  "Start live-server exactly like VS Code Live Server"
  (interactive)
  (when (buffer-file-name)
    (let* ((file-dir (file-name-directory (buffer-file-name)))
           (file-name (file-name-nondirectory (buffer-file-name)))
           (default-directory file-dir))
      
      ;; Kill existing live-server processes
      (shell-command "pkill -f live-server" nil nil)
      (sit-for 1)
      
      ;; Start live-server on port 5500 WITHOUT auto-open
      (start-process "live-server" "*live-server*" 
                     "live-server" 
                     "--port=5500"
                     "--host=127.0.0.1"
                     "--no-browser")
      (sit-for 2)
      
      ;; Manually open browser
      (browse-url (format "http://127.0.0.1:5500/%s" file-name))
      (message "Live Server started on http://127.0.0.1:5500/%s" file-name))))
(global-set-key (kbd "C-c C-v") 'open-in-live-server)


(use-package yasnippet
  :hook
  (yas-global-mode))

(use-package indent-bars
  :custom
  (indent-bars-color '(highlight :face-bg t :blend 0.15))
  (indent-bars-pattern ".")
  (indent-bars-width-frac 0.1)
  (indent-bars-pad-frac 0.1)
  (indent-bars-zigzag nil)
  (indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1)) ; blend=1: blend with BG only
  (indent-bars-highlight-current-depth '(:blend 0.5)) ; pump up the BG blend on current
  (indent-bars-display-on-blank-lines t)
  (indent-bars-no-descend-lists t)
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  :hook
  (prog-mode . indent-bars-mode))

(global-set-key (kbd "C-c c c") 'compile)
(global-set-key (kbd "C-c c r") 'recompile)
(setopt compilation-auto-jump-to-first-error t
      compilation-scroll-output t)

(global-set-key (kbd "M-$") 'replace-string)

(use-package eat
  :bind
  ("C-x t t" . eat))
(setopt process-adaptive-read-buffering nil)


;;#########################################
;;#              Theming                  #
;;#########################################


;;Transparency effects
(set-frame-parameter nil 'alpha-background 95) ; For current frame
(add-to-list 'default-frame-alist '(alpha-background . 100)) ;;new frames henceforth

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(use-package kaolin-themes
  :config
  (setq kaolin-themes-distinct-fringe t)
  (load-theme 'kaolin-ocean t))
  
(use-package solaire-mode
  :hook
  (after-init . solaire-global-mode))

(defun special-visual-mode ()
  "Enable olivetti-mode and disable fringes for special modes."
  (olivetti-mode 1)
  (add-hook 'window-configuration-change-hook
            (lambda ()
              (when (and (get-buffer-window (current-buffer))
                         (or (derived-mode-p 'help-mode)
                             (derived-mode-p 'Info-mode)
                             (derived-mode-p 'Man-mode)
			     (derived-mode-p 'eldoc-mode)))
                (set-window-fringes (get-buffer-window (current-buffer)) 0 0)))
            nil t))

(use-package olivetti    ;; centers the buffer
 :defer t
 :custom
 (olivetti-body-width 78)
 (olivetti-style 'nil)
 :bind ("C-c o v" . olivetti-mode)
 :hook
 ((help-mode
   Info-mode
   Man-mode) . special-visual-mode)
 (markdown-mode . olivetti-mode))

(defun increase-org-left-fringe ()
  "Increase left fringe width in org-mode."
  (setq-local left-fringe-width 12)
  (setq-local right-fringe-width 8)
  (when (get-buffer-window (current-buffer))
    (set-window-fringes (get-buffer-window (current-buffer)) 12 8)))

(add-hook 'org-mode-hook 'increase-org-left-fringe)

(setopt eldoc-echo-area-use-multiline-p nil
	eldoc-echo-area-display-truncation-message nil
	eldoc-echo-area-prefer-doc-buffer t)

(use-package doom-modeline    ;;  fancy modeline
  :custom
  (doom-modeline-height 35)    ;; modeline details
  (doom-modeline-bar-width 5)
  (doom-modeline-icon t)
  (doom-modeline-hud t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  :hook
  (after-init . doom-modeline-mode))

(use-package nerd-icons-completion
  :demand t
  :init
  (nerd-icons-completion-mode))

(add-hook 'prog-mode-hook
          (lambda ()
            (hl-line-mode 1)
            (hs-minor-mode 1)))

(setopt pixel-scroll-precision-mode t  ;; smqooth scrolling :0
	pixel-dead-time 0)

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters 'nerd-icons-corfu-formatter))

(use-package nerd-icons-ibuffer
  :custom
  (setopt nerd-icons-ibuffer-icon t
	nerd-icons-ibuffer-color-icon t
	nerd-icons-ibuffer-icon-size 1.0
	nerd-icons-ibuffer-human-readable-size t)
  :hook
  (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package nerd-icons-dired    ;; icons for dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(setopt inhibit-compacting-font-caches t)

(use-package dashboard
  :ensure t
  :custom
  (dashboard-setup-startup-hook)
  ;;  (dashboard-refresh-buffer)
  :diminish
  (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-center-content t)   ;; center dashboard, default left
  (dashboard-startup-banner "~/.emacs.d/xemacs_color.svg")    ;; dashboard image
  (dashboard-banner-logo-title "You have to a die few times to really live.")    ;; welcome message
  (dashboard-image-banner-max-height 200)
  (dashboard-items '((recents . 5)
		     (bookmarks . 3)
		     (agenda . 5)
		     (projects . 3)))
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-footer t)
  (dashboard-navigation-cycle t)
  :hook
  (after-init . dashboard-setup-startup-hook))

(setopt initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
(add-hook 'server-after-make-frame-hook 'dashboard-refresh-buffer)

;;#########################################
;;#              OrgMode                  #
;;#########################################

(defun my/org-set-margins ()
  "Set visual margins using fringes."
  (when (derived-mode-p 'org-mode)
    (set-window-margins nil 4 4)
    (set-window-fringes (selected-window) 12 0)))
(add-hook 'org-mode-hook #'my/org-set-margins)

(defun disable-fringes-in-help-mode ()
  (set-window-fringes (get-buffer-window) 0 0))

(add-hook 'help-mode-hook #'disable-fringes-in-help-mode)

(use-package auctex
  :custom
  (TeX-PDF-mode t
	TeX-command-default t)
  :hook
  (TeX-source-correlate-mode . LaTeX-mode)
  (TeX-PDF-mode . LaTeX-mode))
(setopt TeX-auto-save t
      TeX-parse-self t)

(global-set-key (kbd "C-c |") 'org-table-create)
(setopt org-image-actual-width nil)

;; (add-hook 'org-mode-hook (lambda ()(
;; 				    (setopt-local sentence-end-double-space nil))))
(add-hook 'org-mode-hook 'org-indent-mode)
(setopt sentence-end-double-space nil)


(setopt make-backup-files nil)    ;; stops making temporary backup files
(setq-default org-startup-folded t)    ;; folded documents in startup
(setopt org-startup-with-inline-images nil)    ;; show inline images
(setopt org-startup-indented nil)    ;; indented orgmode
(setopt org-indent-indentation-per-level 2)   ;indentation level
(add-hook 'markdown-mode-hook 'turn-on-auto-fill)    ;;  in markdown mode also
(setopt fill-column 80)    ;;  paragraph column size 80 chars

(setopt display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook
                ;; org-mode-hook
                ;; markdown-mode-hook
                LaTeX-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode t))))

(setopt org-agenda-span 'month)    ;; views org agenda for the whole month
;; (setopt dictionary-server "localhost")

(setopt org-todo-keywords    ;; todo list keywords
      '((sequence "TODO" "NEXT" "|" "DONE" "CANCEL")))    ;; done is the separated state
(global-set-key (kbd "C-c o a") 'org-agenda-list)
(global-set-key (kbd "C-c o t") 'org-todo-list)
;; Move "DONE" items to the bottom of the agenda
(global-set-key (kbd "C-c i t") 'org-insert-todo-heading)    ;; insert todo heading, easier than switching

;; (setopt org-agenda-files '("~/Library/org/uni.org"    ;;  org agenda files list
;; 			 "~/Library/org/coding.org" 
;; 			 "~/Library/org/books.org"))
(setopt org-agenda-include-diary nil)    ;; exclude the holiday shit

(setopt ispell-program-name "aspell")   ;; spell checking with aspell
;; (setopt ispell-dictionary "english")    ;;  english dictionary for aspell

(use-package jinx    ;; new grammar checker ui
  :defer t
  ;; :hook (org-mode . jinx-mode)
  :bind (("M-*" . jinx-correct)
	 ("M-p" . jinx-previous)
	 ("M-n" . jinx-next)
         ("C-M-$" . jinx-languages)))

(use-package shrface
  :custom
  (shrface-basic)
  (shrface-trial)
  (shrface-default-keybindings) ; setup default keybindings
  (setopt shrface-href-versatile t))

(use-package shr-tag-pre-highlight
  :after shr
  :custom
  (add-to-list 'shr-external-rendering-functions
	       '(pre . shr-tag-pre-highlight))
  (when (version< emacs-version "26")
    (with-eval-after-load 'eww
      (advice-add 'eww-display-html :around
		  'eww-display-html--override-shr-external-rendering-functions))))

(use-package eww
  :defer t
  :hook
  (eww-after-render . shrface-mode))

(add-hook 'org-mode-hook 'turn-on-auto-fill)    ;;  auto setting of paragraphs

(use-package markdown-mode)

(setopt org-src-fontify-natively t)    ;; native src highlighting for org code blocks
'(setopt org-emphasis-alist   ;; emphasize bold, Italic, underline
      '(("*" bold)
	("/" italic)
	("_" underline)))
(setopt org-hide-emphasis-markers t)    ;; hide emphasis markers
(setopt org-ellipsis "﹀")    ;; replace triple dots with symbol
(setopt org-fontify-quote-and-verse-blocks t)

(with-eval-after-load 'org
  (setcar (nthcdr 4 org-emphasis-regexp-components) 20)
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
  (custom-set-faces
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit fixed-pitch))))
   '(org-verbatim ((t (:inherit fixed-pitch))))
   '(org-table ((t (:inherit fixed-pitch))))
   '(org-formula ((t (:inherit fixed-pitch))))))

(add-hook 'org-mode-hook 'variable-pitch-mode)

(use-package org-modern 
  :custom
  (org-modern-fold-stars '(("⦿" . "○") ("✿" . "❀") ("♣" . "♧") ("♠" . "♤") ("✦" . "✧")))
  :hook (org-mode . org-modern-mode))

(use-package ligature
  :ensure t
  :config
  ;; Enable all ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
				       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
				       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
				       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
				       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
				       "..." "+++" "/==" "///" "_|_" "www" "^=" "~~" "~@" "~="
				       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
				       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
				       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
				       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
				       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
				       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
				       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers.  You can also do it
  ;; per mode with `ligature-mode'.
  :config
  (global-ligature-mode t))

;; Add extensions
(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
	 ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p a" . cape-abbrev)
         ("C-c p w" . cape-dict))
  ("C-c p \\" . cape-tex)
  ("C-c p _" . cape-tex)
  ("C-c p ^" . cape-tex)
  ("C-c p &" . cape-sgml)
  ("C-c p r" . cape-rfc1345)
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  ;; NOTE: The order matters!
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  ;;  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-sgml)
  (add-to-list 'completion-at-point-functions #'cape-rfc1345)
  (add-to-list 'completion-at-point-functions #'cape-abbrev))

;; To disable collection of benchmark data after init is done.
;; (require 'benchmark-init)
;; (add-hook 'after-init-hook 'benchmark-init/deactivate)

(put 'upcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(put 'downcase-region 'disabled nil)
