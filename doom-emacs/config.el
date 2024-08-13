;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Raphaele Salvatore Licciardo, M.Sc."
      user-mail-address "raphaele.salvatore@outlook.de")

;; Deutsche MacOS Tastatur
 (setq mac-command-modifier 'meta
      mac-option-modifier 'none
      default-input-method "MacOSX")

(setq display-line-numbers-type 'relative
      global-display-line-numbers-mode t)

(setq doom-font 'Iosevka-12)

;; Keymaps Inc and Dec Font Size
(defun increase-font-size ()
  (interactive)
  (text-scale-increase 1))
(defun decrease-font-size ()
  (interactive)
  (text-scale-decrease 1))
(global-set-key (kbd "M-+") 'increase-font-size)
(global-set-key (kbd "M--") 'decrease-font-size)

;; No Titlebar with round corners
(add-to-list 'default-frame-alist '(undecorated-round . t))

;; No Modeline
(setq-default mode-line-format nil)
(add-hook 'after-change-major-mode-hook (lambda () (setq mode-line-format nil)))
(setq-default header-line-format nil)

;; Auto Theme
(defun my/apply-theme (appearance)
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-one-light t))
    ('dark (load-theme 'doom-dark+ t))))

(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
