(setq user-full-name "Raphaele Salvatore Licciardo, B.Sc."
      user-mail-address "raphaele.salvatore@outlook.de")

(setq doom-theme 'doom-one-light)

(setq display-line-numbers-type 'relative)

;; Slows the k / j movements down ..
;;(require 'key-chord)
;;(key-chord-mode t)
;;(key-chord-define-global "jk" 'evil-normal-state)
;;(key-chord-define-global "kj" 'evil-normal-state)

(setq default-input-method "MacOSX")

(setq mac-command-modifier 'meta
      mac-option-modifier nil
      mac-allow-anti-aliasing t
      mac-command-key-is-meta t)

(setq auto-save-default t
      make-backup-files t)

(setq confirm-kill-emacs nil)

(add-hook 'buffer-list-update-hook (lambda ()
                                     (unless (active-minibuffer-window)
                                       (hide-mode-line-mode))))

(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.6))))
 '(org-level-2 ((t (:inherit outline-1 :height 1.5))))
 '(org-level-3 ((t (:inherit outline-1 :height 1.4))))
 '(org-level-4 ((t (:inherit outline-1 :height 1.3))))
 '(org-level-5 ((t (:inherit outline-1 :height 1.2))))
 '(org-level-6 ((t (:inherit outline-1 :height 1.1))))
)

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight b ld :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(global-set-key [C-wheel-up] 'text-scale-increase)
(global-set-key [C-wheel-down] 'text-scale-decrease)

(setq initial-frame-alist '((top . 1) (left . 1) (width . 120) (height . 60)))

