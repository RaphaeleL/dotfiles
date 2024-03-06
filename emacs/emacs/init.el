;; ---------------------------------------------------------------------------------
;; -------- Appearance -------------------------------------------------------------
;; ---------------------------------------------------------------------------------

;; No Startup Message
(setq inhibit-startup-message t)
(setq initial-scratch-message "\n\n\n")

;; Cleanup the UI
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 0)
(menu-bar-mode -1)
(spacious-padding-mode 1)

;; Theme
(load-theme 'modus-operandi-tinted t)

;; Font
(defun get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Iosevka-14")
   ((eq system-type 'darwin) "Iosevka-14")
   ((eq system-type 'gnu/linux) "Iosevka-14")))

(add-to-list 'default-frame-alist `(font . ,(get-default-font)))

;; Ido Mode for Files
(ido-mode 1)
(ido-everywhere 1)

;; Package Manager
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ido Mode for M-x
(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Relative Line Numbering
(global-display-line-numbers-mode t)

;; Bigger Font
(set-face-attribute 'default nil :height 130)

;; Window Size
(when window-system (set-frame-size (selected-frame) 120 39))

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
;; -------- Shortcuts --------------------------------------------------------------
;; ---------------------------------------------------------------------------------

;; Dired
(dired-preview-global-mode 1)
(global-set-key (kbd "C-x d") 'dired)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Buffer Navigation
(global-set-key (kbd "C-<tab>") 'next-buffer)
(global-set-key (kbd "C-S-<tab>") 'previous-buffer)
(global-set-key (kbd "C-c l") 'buffer-menu)
(global-set-key (kbd "C-c s") 'switch-to-buffer)

;; Window Navigation
(global-set-key (kbd "C-x h") 'windmove-left)
(global-set-key (kbd "C-x l") 'windmove-right)
(global-set-key (kbd "C-x k") 'windmove-up)
(global-set-key (kbd "C-x j") 'windmove-down)

;; Close window
(global-set-key (kbd "C-x 0") 'delete-window)
(global-set-key (kbd "C-x 1") 'delete-other-windows)

;; Compile
(global-set-key (kbd "C-x m") 'compile)

;; Copy and Paste
(require 'simpleclip)
(simpleclip-mode 1)
(global-set-key (kbd "C-x b") 'simpleclib-cut)
(global-set-key (kbd "C-x v") 'simpleclip-copy)
(global-set-key (kbd "C-x p") 'simpleclip-paste)

;; Multi Cursor
(require 'multiple-cursors)
(global-set-key (kbd "C-<") 'mc/mark-next-like-this)
(global-set-key (kbd "C->") 'mc/mark-previous-like-this)

;; Font Size
(global-set-key (kbd "M-+") (lambda () (interactive) (text-scale-increase 1)))
(global-set-key (kbd "M--") (lambda () (interactive) (text-scale-decrease 1)))

;; Kill Current Buffer
(global-set-key (kbd "C-c k") (lambda () (interactive) (kill-current-buffer)))

;; Which Key
(require 'which-key)
(which-key-mode)
(which-key-setup-side-window-right)

;; Move Text
(require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;; ---------------------------------------------------------------------------------
;; -------- LSP --------------------------------------------------------------------
;; ---------------------------------------------------------------------------------

(set-fringe-mode 0)

(setq package-selected-packages '(lsp-mode yasnippet helm-lsp
    projectile hydra flycheck company avy helm-xref))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'python-mode-hook 'lsp)
(add-hook 'lisp-mode-hook 'lsp)

;; TODO: Add more LSPs
;; - https://emacs-lsp.github.io/lsp-mode/page/lsp-cmake/
;; - CMake
;; - Make
;; - Java
;; - JS/TS
;; - Markdown
;; - ...

(setq lsp-headerline-breadcrumb-enable nil)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (yas-global-mode))

;; ---------------------------------------------------------------------------------
;; -------- Modeline ---------------------------------------------------------------
;; ---------------------------------------------------------------------------------

(column-number-mode t)

(defun simple-mode-line-render (left right)
  "Return a string of `window-width' length.
Containing LEFT, and RIGHT aligned respectively."
  (let ((available-width
	 (- (window-total-width)
	    (+ (length (format-mode-line left))
	       (length (format-mode-line right))))))
    (append left
	    (list (format (format "%%%ds" available-width) ""))
	    right)))

(setq-default
 mode-line-format
 '((:eval
    (simple-mode-line-render
     ;; Left.
     (quote ("%e "
	     mode-line-buffer-identification
	     " %l : %c"
	     evil-mode-line-tag
	     "[%*]"))
     ;; Right.
     (quote ("%p "
	     mode-line-frame-identification
	     mode-line-modes
	     mode-line-misc-info))))))


;; ---------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3cbfdfce26469ddf69164b28d07852cc0f09a7b4b14d25ca40b34369db7e1664"
     "aed3a896c4ea7cd7603f7a242fe2ab21f1539ab4934347e32b0070a83c9ece01"
     "e13beeb34b932f309fb2c360a04a460821ca99fe58f69e65557d6c1b10ba18c7"
     "18cf5d20a45ea1dff2e2ffd6fbcd15082f9aa9705011a3929e77129a971d1cb3"
     default))
 '(package-selected-packages
   '(dired-preview linum-relative magit modus-themes move-text
		   python-mode simpleclip smex spacious-padding
		   which-key zenburn-theme)))
(custom-set-faces

'(org-level-1 ((t (:inherit outline-1 :height 2.0))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0))))

 )
