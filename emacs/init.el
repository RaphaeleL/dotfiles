;; ---------------------------------------------------------------------------------
;; -------- Package Manager --------------------------------------------------------
;; ---------------------------------------------------------------------------------

; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;
; (defun ensure-package-installed (&rest packages)
;   "Assure every package is installed, ask for installation if it’s not.
;
; Return a list of installed packages or nil for every skipped package."
;   (mapcar
;    (lambda (package)
;      ;; (package-installed-p 'evil)
;      (if (package-installed-p package)
;          nil
;        (if (y-or-n-p (format "Package %s is missing. Install it? " package))
;            (package-install package)
;          package)))
;    packages))
;
; (or (file-exists-p package-user-dir)
;     (package-refresh-contents))
;
; (package-refresh-contents)
;
; (ensure-package-installed
;  'spacious-padding
;  'gruber-darker-theme
;  'modus-themes
;  'smex
;  'simpleclip
;  'multiple-cursors
;  'move-text
;  'mood-line
;  'magit
;  'doom-themes
; )

;; activate installed packages
; (package-initialize)

;; ---------------------------------------------------------------------------------
;; -------- Appearance -------------------------------------------------------------
;; ---------------------------------------------------------------------------------

;; No Startup Message
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; Cleanup the UI
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

;; Theme
;; (load-theme 'modus-operandi-tinted 1)
(load-theme 'gruber-darker 1)
;; (load-theme 'doom-one 1)
;; (load-theme 'zenburn 1)

(use-package mood-line
  :config
  (mood-line-mode 1)
)

;; Font
(defun get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Iosevka-12") ;; IosevkaTermSlab NF-12
   ((eq system-type 'darwin) "Iosevka-14")
   ((eq system-type 'gnu/linux) "Iosevka-12")))

(add-to-list 'default-frame-alist `(font . ,(get-default-font)))

;; Ido Mode for Files
(ido-mode 1)
(ido-everywhere 1)

;; Package Manager
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Ido Mode for M-x
(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
 (global-set-key (kbd "M-X") 'smex-major-mode-commands)
 (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Line Numbering
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Bigger Font
(set-face-attribute 'default nil :height 130)

;; Window Size
(when window-system (set-frame-size (selected-frame) 120 30))

;; Disable Backup and Autosave Settings
(setq make-backup-files nil)
(setq auto-save-default nil)

;; ---------------------------------------------------------------------------------
;; -------- Tastatur ---------------------------------------------------------------
;; ---------------------------------------------------------------------------------

;; Deutsche Mac Tastatur
(if (eq system-type 'darwin)
    (setq mac-command-modifier 'meta
	  mac-option-modifier 'none
	  default-input-method "MacOSX"))

;; ---------------------------------------------------------------------------------
;; -------- Some Basic (Plugin-) Settings ------------------------------------------
;; ---------------------------------------------------------------------------------

;; Smooth Scroll - Vertical
(setq scroll-step 1)
(setq scroll-margin 1)
(setq scroll-conservatively 101)
(setq scroll-up-aggressively 0.01)
(setq scroll-down-aggressively 0.01)
(setq auto-window-vscroll nil)
(setq fast-but-imprecise-scrolling nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
;; Smooth Scroll - Horizontal
(setq hscroll-step 1)
(setq hscroll-margin 1)

;; Dired
(use-package dired
  :ensure nil
  :bind
  (("C-x C-j" . dired-jump))
  :custom
  (dired-listing-switches "-lah")
  (dired-recursive-deletes 'always)
  (dired-recursive-copies 'always)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil)
  (dired-dwim-target t)
  (delete-by-moving-to-trash t)
  (load-prefer-newer t)
  (auto-revert-use-notify nil)
  (auto-revert-interval 3)
  :config
  (global-auto-revert-mode t)
  (put 'dired-find-alternate-file 'disabled nil)
  :hook
  (dired-mode . (lambda ()
                  (local-set-key (kbd "<mouse-2>") #'dired-find-alternate-file)
                  (local-set-key (kbd "RET") #'dired-find-alternate-file)
                  (local-set-key (kbd "^")
                                 (lambda () (interactive) (find-alternate-file ".."))))))

;; Disable package-enable-at-startup
(setq package-enable-at-startup nil)

;; Unset file-name-handler-alist
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Defer Garbage Collection
(setq gc-cons-threshold 100000000)

;; Garbage Collection
(defvar better-gc-cons-threshold 134217728 ; 128mb
  "The default value to use for `gc-cons-threshold'. If you experience freezing, decrease this.  If you experience stuttering, increase this.")

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold better-gc-cons-threshold)
            (setq file-name-handler-alist file-name-handler-alist-original)
            (makunbound 'file-name-handler-alist-original)))

(add-hook 'emacs-startup-hook
          (lambda ()
            (if (boundp 'after-focus-change-function)
                (add-function :after after-focus-change-function
                              (lambda ()
                                (unless (frame-focus-state)
                                  (garbage-collect))))
              (add-hook 'after-focus-change-function 'garbage-collect))
            (defun gc-minibuffer-setup-hook ()
              (setq gc-cons-threshold (* better-gc-cons-threshold 2)))

            (defun gc-minibuffer-exit-hook ()
              (garbage-collect)
              (setq gc-cons-threshold better-gc-cons-threshold))

            (add-hook 'minibuffer-setup-hook #'gc-minibuffer-setup-hook)
            (add-hook 'minibuffer-exit-hook #'gc-minibuffer-exit-hook)))

;; IBuffer
(use-package ibuffer
  :ensure nil
  :init
  (use-package ibuffer-vc
    :commands (ibuffer-vc-set-filter-groups-by-vc-root)
    :custom
    (ibuffer-vc-skip-if-remote 'nil))
  :custom
  (ibuffer-formats
   '((mark modified read-only locked " "
           (name 35 35 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename))))

;; ---------------------------------------------------------------------------------
;; -------- Shortcuts --------------------------------------------------------------
;; ---------------------------------------------------------------------------------

(defun delete-current-line ()
  "Delete (not kill) the current line."
  (interactive)
  (save-excursion
    (delete-region
     (progn (forward-visible-line 0) (point))
     (progn (forward-visible-line 1) (point)))))

;; Simplify yes/no Prompts
(fset 'yes-or-no-p 'y-or-n-p)
(setq use-dialog-box nil)

;; Dired
;; (dired-preview-global-mode 1)
(global-set-key (kbd "C-x d") 'dired) 
(global-set-key (kbd "C-x C-d") 'dired)
(global-set-key (kbd "C-x .") 'dired)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x C-g") 'magit-log-all)

;; Buffer Navigation
(global-set-key (kbd "C-<tab>") 'next-buffer)
(global-set-key (kbd "C-<iso-lefttab>") 'previous-buffer)
(global-set-key (kbd "C-c i") 'ibuffer)
(global-set-key (kbd "C-c l") 'switch-to-buffer)

;; Close window
(global-set-key (kbd "C-c 0") 'delete-window)
(global-set-key (kbd "C-c 1") 'delete-other-windows)

;; Usefull Commands
(global-set-key (kbd "C-c m") 'compile)
(global-set-key (kbd "C-c s") 'shell-command)
(global-set-key (kbd "C-c n") 'duplicate-line)
(global-set-key (kbd "C-c d") 'delete-current-line)
(global-set-key (kbd "C-c j") 'join-line)

;; Copy and Paste
(require 'simpleclip)
(simpleclip-mode 1)
(global-set-key (kbd "C-c c") 'simpleclip-copy)
(global-set-key (kbd "C-c v") 'simpleclip-paste)

;; Multi Cursor
(require 'multiple-cursors)
(global-set-key (kbd "C-<") 'mc/mark-next-like-this)
(global-set-key (kbd "C->") 'mc/mark-previous-like-this)

;; Font Size
(global-set-key (kbd "M-+") (lambda () (interactive) (text-scale-increase 1)))
(global-set-key (kbd "M--") (lambda () (interactive) (text-scale-decrease 1)))

;; Kill Current Buffer
(global-set-key (kbd "C-c k") (lambda () (interactive) (kill-current-buffer)))

;; Move Text
(require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;; Undo
(global-set-key (kbd "M-z") 'undo)

;; Mark Whole Buffer
(global-set-key (kbd "C-c a") 'mark-whole-buffer)

;; Magit
(global-set-key (kbd "C-c g") 'magit)

;; Selection
(global-set-key (kbd "M-w") 'mark-word)
(global-set-key (kbd "M-a") 'mark-page)
(global-set-key (kbd "M-F") 'mark-defun)
(global-set-key (kbd "M-s") 'mark-paragraph)

;; Line Numbers
(global-set-key (kbd "C-c C-l") 'global-display-line-numbers-mode)

;; ---------------------------------------------------------------------------------
;; -------- LSP --------------------------------------------------------------------
;; ---------------------------------------------------------------------------------

; (set-fringe-mode 0)
;
; (setq package-selected-packages '(lsp-mode yasnippet helm-lsp
;     projectile hydra flycheck company avy helm-xref))
;
; (when (cl-find-if-not #'package-installed-p package-selected-packages)
;   (package-refresh-contents)
;   (mapc #'package-install package-selected-packages))
;
; ; (add-hook 'c-mode-hook 'lsp)
; ; (add-hook 'c++-mode-hook 'lsp)
; ; (add-hook 'python-mode-hook 'lsp)
; ; (add-hook 'go-mode-hook 'lsp)
;
; (setq lsp-headerline-breadcrumb-enable nil)
;
; (setq gc-cons-threshold (* 100 1024 1024)
;       read-process-output-max (* 1024 1024)
;       treemacs-space-between-root-nodes nil
;       company-idle-delay 0.0
;       company-minimum-prefix-length 1
;       lsp-idle-delay 0.1)
;
; (with-eval-after-load 'lsp-mode
;   (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;   (yas-global-mode))
;
; (use-package lsp-pyright
;   :ensure t
;   :hook (python-mode . (lambda ()
;                           (require 'lsp-pyright)
;                           (lsp))))  ; or lsp-deferred


;; ---------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f079ef5189f9738cf5a2b4507bcaf83138ad22d9c9e32a537d61c9aae25502ef" "c7a926ad0e1ca4272c90fce2e1ffa7760494083356f6bb6d72481b879afce1f2" "0f76f9e0af168197f4798aba5c5ef18e07c926f4e7676b95f2a13771355ce850" "e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "7613ef56a3aebbec29618a689e47876a72023bbd1b8393efc51c38f5ed3f33d1" "d77d6ba33442dd3121b44e20af28f1fae8eeda413b2c3d3b9f1315fbda021992" "e13beeb34b932f309fb2c360a04a460821ca99fe58f69e65557d6c1b10ba18c7" "9f297216c88ca3f47e5f10f8bd884ab24ac5bc9d884f0f23589b0a46a608fe14" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "4b026ac68a1vaa4d1a91879b64f54c2490b4ecad8b64de5b1865bca0addd053d9" "21e3d55141186651571241c2ba3c665979d1e886f53b2e52411e9e96659132d4" default))
 '(package-selected-packages
   '(zenburn-theme yasnippet super-save smex simpleclip projectile multiple-cursors move-text mood-line modus-themes magit lsp-pyright hydra hide-mode-line helm-xref helm-lsp gruber-darker-theme format-all flycheck doom-themes company avy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

