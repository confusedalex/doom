;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

(setq doom-font (font-spec :family "JetBrains Mono Nerd Font" :size 16))
(setq doom-theme 'doom-gruvbox)
(setq display-line-numbers-type 'relative)

(map! :leader
      "oo" (cmd! (find-file (expand-file-name "~/persist/org/" doom-user-dir)))
      "o n" (cmd! (find-file "~/persist/org/notes.org"))
      "o i" (cmd! (find-file "~/persist/org/inbox.org"))
      "o j" (cmd! (find-file "~/persist/org/journal.org"))
      "o w" (cmd! (find-file "~/persist/org/work.org"))
      "o b" (cmd! (find-file "~/persist/org/books.org"))
      )

(setq org-directory "~/persist/org/")

(after! org
  (setq org-ellipsis "⤵")
  (setq org-agenda-span 'day)
  (setq org-log-done t)
  (setq org-log-into-drawer t)
  (setq org-agenda-start-day nil)
  (setq org-capture-templates
        '(
          ("t" "Personal todo" entry
           (file+headline "inbox.org" "todos")
           "* TODO %?\n%i" :prepend t)
          ("n" "Personal notes" entry
           (file+headline "inbox.org" "notes")
           "* %u %?\n%i" :prepend t)
          ("b" "Book" entry (file "books.org")
           "** TODO %^{Title}
                :PROPERTIES:
                :name:     %\\1
                :author:   %^{Author}
                :pages:    %^{Pages}
                :rating:   %^{Rating}
                :END:\n%?"
           )
          ("l" "Log Entry" entry (file+olp+datetree "daybook.org") "* %? %T")
          ("j" "Journal entry" entry (file+datetree "journal.org") "* %(format-time-string \"%H:%M\") \n%?")))
  )

(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))


(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-header-map nil)
  (org-super-agenda-mode t)
  (setq org-agenda-custom-commands
        '(("p" "private"
           ((agenda "" ((org-agenda-span 'day)
                        (org-super-agenda-groups
                         '((:name "Today"
                            :time-grid t
                            :date today
                            :todo "TODAY"
                            :scheduled today
                            :order 1)))))
            (tags-todo "-work" ((org-agenda-overriding-header "")
                                (org-super-agenda-groups
                                 '((:name "Important"
                                    :tag "Important"
                                    :priority "A"
                                    :order 6)
                                   (:name "Due Today"
                                    :deadline today
                                    :order 2)
                                   (:name "Due Soon"
                                    :deadline future
                                    :order 8)
                                   (:name "Overdue"
                                    :deadline past
                                    :face error
                                    :order 7)
                                   (:name "To read"
                                    :tag "read"
                                    :order 30)
                                   (:name "People"
                                    :and (:tag "people" :not (:tag "gifts"))
                                    :order 19)
                                   (:name "Waiting"
                                    :todo "WAIT"
                                    :order 20)
                                   (:name "Personal"
                                    :tag "home"
                                    :order 29)
                                   (:name "Geschenke"
                                    :tag "gifts"
                                    :order 33)
                                   ))))))
          ("w" "work"
           ((agenda "" ((org-agenda-files '("~/persist/org/work.org"))
                        (org-agenda-span 'day)
                        (org-super-agenda-groups
                         '((:name "Today"
                            :time-grid t
                            :date today
                            :todo "TODAY"
                            :scheduled today
                            :order 1)))))
            (todo "" ((org-agenda-files '("~/persist/org/work.org"))
                      (org-agenda-overriding-header "")
                      (org-super-agenda-groups
                       '((:name "Important"
                          :tag "Important"
                          :priority "A"
                          :order 6)
                         (:name "Due Today"
                          :deadline today
                          :order 2)
                         (:name "Due Soon"
                          :deadline future
                          :order 8)
                         (:name "Overdue"
                          :deadline past
                          :face error
                          :order 7)
                         (:name "To read"
                          :tag "read"
                          :order 30)
                         (:name "Waiting"
                          :todo "WAIT"
                          :order 20)
                         ))))))))
  )
