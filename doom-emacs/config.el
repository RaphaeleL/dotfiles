(setq user-full-name "Raphaele Salvatore Licciardo"
      user-mail-address "raphaele.salvatore@outlook.de")

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

(map! :leader
      (:prefix ("b". "buffer")
       :desc "Descripe iBuffers" "a" #'ibuffer))

(map! :leader
      (:prefix ("d". "dired")
       :desc "Open Dired" "d" #'dired))

