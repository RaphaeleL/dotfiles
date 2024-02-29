;; No Startup Message
(setq inhibit-startup-message t)

;; Cleanup the UI
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

;; Theme
(load-theme 'gruber-darker t)

;; Ido Mode for Files
(ido-mode 1)

;; Package Manager
(add-to-list 'package-archives
           '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ido Mode for M-x
(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Relative Line Numbering
(global-display-line-numbers-mode t)
(setq display-line-numbers 'relative) 

;; Bigger Font
(set-face-attribute 'default nil :height 130)

;; Window Size
(when window-system (set-frame-size (selected-frame) 120 45))

;; Disable Backup and Autosave Settings
(setq make-backup-files nil) ; Stop creating backup~ files
(setq auto-save-default nil) ; Stop creating #autosave# files

;; Tastatur

;; Deutsche Mac Tastatur
(setq mac-command-modifier 'meta
      mac-option-modifier 'none
      default-input-method "MacOSX")

;; Custom Keybindings

;; Dired
(global-set-key (kbd "C-x d") 'dired) ; Open Dired with C-x d

;; Magit
(global-set-key (kbd "C-x g") 'magit-status) ; Open Magit Status with C-x g

;; Buffer Navigation
(global-set-key (kbd "C-<tab>") 'next-buffer) ; Next buffer with Ctrl-Tab
(global-set-key (kbd "C-S-<tab>") 'previous-buffer) ; Previous buffer with Ctrl-Shift-Tab
(global-set-key (kbd "C-c l") 'buffer-menu) ; Buffer Menu

;; Window Navigation
(global-set-key (kbd "C-x h") 'windmove-left) ; Move to left window with C-x left arrow
(global-set-key (kbd "C-x l") 'windmove-right) ; Move to right window with C-x right arrow
(global-set-key (kbd "C-x k") 'windmove-up) ; Move to upper window with C-x up arrow
(global-set-key (kbd "C-x j") 'windmove-down) ; Move to lower window with C-x down arrow

;; Split Windows more intuitively
(global-set-key (kbd "C-x .") 'split-window-right) ; Split window vertically with C-x |
(global-set-key (kbd "C-x -") 'split-window-below) ; Split window horizontally with C-x _

;; Close window
(global-set-key (kbd "C-x 0") 'delete-window) ; Close current window with C-x 0
(global-set-key (kbd "C-x 1") 'delete-other-windows) ; Close other windows with C-x 1

;; Compile
(global-set-key (kbd "C-x m") 'compile) ; Run Compile Command

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

;; C / C++ LSP
(setq package-selected-packages '(lsp-mode yasnippet helm-lsp
    projectile hydra flycheck company avy helm-xref))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(simpleclip smex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
