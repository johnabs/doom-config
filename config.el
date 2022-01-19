;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(tool-bar-mode -1)
(menu-bar-mode -1)
;;(setq fancy-startup-text )
(setq fancy-splash-image "~/.doom.d/assets/emacs-gnu-logo.png")

(setq doom-font (font-spec :family "Iosevka Term" :size 15)
      doom-variable-pitch-font (font-spec :family "Iosevka Term" :size 15))

;;(setq doom-theme 'doom-solarized-dark-high-contrast)
(setq doom-theme 'doom-nord)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Biechele-Speziale"
      user-mail-address "johnbs1234@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

;; Dired Config
(use-package dired
;;#:ensure nil
  :commands(dired dired-jump)
  ;; :bind(("SPC-.-." . dired-jump))
  :custom ((dired-listing-switches "-agho -group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file)
  )

;; Org Prettification
(setq org-ellipsis " ▾")
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom(
          (org-bullets-bullet-list '("◉" "✸" "✿"))
          )
  )
(after! 'org-faces (dolist (face '((org-level-1 . 2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Iosevka Term" :weight 'regular :height (cdr face))))

;; EViL-Org Config
(map! :leader
      (:prefix ("r" . "roam")
      :desc "Org Roam Capture"
      "c" #'org-roam-capture
      "t" #'org-roam-tag-add
      "l" #'org-roam-node-at-point
      "f" #'org-roam-node-find))

;; Org-Roam Config
(setq org-roam-directory (file-truename "~/Documents/org/roam"))
(org-roam-db-autosync-mode)

;; Org-Roam-Ui Config
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t
          org-roam-ui-open-on-start nil))

;;Helm-Config
(defhydra helm-like-unite ()
  "vim movement"
  ("?" helm-help "help")
  ("<escape>" keyboard-escape-quit "exit")
  ("<SPC>" helm-toggle-visible-mark "mark")
  ("a" helm-toggle-all-marks "(un)mark all")
  ;; not sure if there's a better way to do this
  ("/" (lambda ()
          (interactive)
          (execute-kbd-macro [?\C-s]))
       "search")
  ("v" helm-execute-persistent-action)
  ("g" helm-beginning-of-buffer "top")
  ("G" helm-end-of-buffer "bottom")
  ("j" helm-next-line "down")
  ("k" helm-previous-line "up")
  ("i" nil "cancel")
  ("h" helm-previous-source)
  ("l" helm-next-source)
  ("r" helm-select-action :color blue))
(define-key helm-map (kbd "<escape>") 'helm-like-unite/body)

;; Helm-Bibtex Config
(setq bibtex-completion-bibliography '("~/Documents/all.bib")
      reftex-default-bibliography '("~/Documents/all.bib")
      bibtex-completion-pdf-field "file")

;; Org-Ref Config
(setq org-ref-default-bibliography "~/Documents/all.bib")

;;Org-Noter Config
(setq org-noter-separate-notes-from-heading t
      org-noter-notes-search-path '("~/Documents/org/notes"))

;;PDF-Tools Config
(pdf-tools-install)
(pdf-loader-install)
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)


;;Org-Timer Config+Default Pomodoro Function
(setq org-clock-sound "~/.doom.d/assets/ding.wav") ; set `org-clock-sound'
(defun pomodoro ()
 (interactive)
            (let ((current-prefix-arg 25))
              (call-interactively 'org-timer-set-timer)))

;; MU4E Config
(setq doom-modeline-mu4e nil)
(auth-source-pass-enable)
(setq auth-source-do-cache nil)
(setq auth-source-debug t)
(setq auth-sources '(password-store))
(setq mu4e-update-interval (* 10 60))
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-root-maildir "~/Mail")
(setq message-kill-buffer-on-exit t)
(setq mu4e-compose-dont-reply-to-self t)
(setq mu4e-maildir-shortcuts
        '(("/Gmail/Inbox"             . ?g)
        ("/Mailbox/INBOX"           . ?m)
        ("/Purdue/Inbox"            . ?p)
        )
        )
(require 'mu4e-context)
(add-to-list 'mu4e-bookmarks '("m:/Mailbox/INBOX or m:/Gmail/Inbox or m:/Purdue/Inbox" "All Inboxes" ?i))
  (setq mu4e-contexts
        (list
         ;; Gmail account (on the way out)
         (make-mu4e-context
          :name "Gmail"
          :match-func
            (lambda (msg)
              (when msg
                (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "johnbs1234@gmail.com")
                  (smtpmail-smtp-user . "johnbs1234@gmail.com")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (user-full-name    . "John Biechele-Speziale")
                  (mu4e-drafts-folder  . "/Gmail/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/Gmail/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/Gmail/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/Gmail/[Gmail]/Trash")))
         ;; Personal account
         (make-mu4e-context
          :name "Mailbox"
          :match-func
            (lambda (msg)
              (when msg
                (string-prefix-p "/Mailbox" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "johnabs@mailbox.org")
                  (smtpmail-smtp-user . "johnabs@mailbox.org")
                  (smtpmail-smtp-server . "smtp.mailbox.org")
                  (user-full-name    . "John Biechele-Speziale")
                  (mu4e-drafts-folder  . "/Mailbox/Drafts")
                  (mu4e-sent-folder  . "/Mailbox/Sent")
                  (mu4e-refile-folder  . "/Mailbox/Archive")
                  (mu4e-trash-folder  . "/Mailbox/Trash")))
         ;; Work account
         (make-mu4e-context
          :name "Purdue"
          :match-func
            (lambda (msg)
              (when msg
                (string-prefix-p "/Purdue" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "jbiechel@purdue.edu")
                  (smtpmail-smtp-user . "jbiechel@purdue.edu")
                  (smtpmail-smtp-server . "smtp.office365.com")
                  (user-full-name    . "John Biechele-Speziale")
                  (mu4e-drafts-folder  . "/Purdue/Drafts")
                  (mu4e-sent-folder  . "/Purdue/Sent Items")
                  (mu4e-refile-folder  . "/Purdue/Archive")
                  (mu4e-trash-folder  . "/Purdue/Deleted Items")))

         ))
 (setq mu4e-alert-interesting-mail-query
    (concat
     "flag:unread maildir:/Exchange/INBOX "
     "OR "
     "flag:unread maildir:/Gmail/INBOX"
     ))
(setq mu4e-org-contacts-file  "~/Documents/org/contacts.org")
(require 'org-msg)
(setq org-msg-signature "
Best,

#+begin_signature
--
John Biechele-Speziale
#+end_signature
Ph.D. Student\\\\
Mario Ventresca Group\\\\
School of Industrial Engineering, Purdue University\\\\
")

;; Org-Contacts Config
(use-package org-contacts
  :ensure nil
  :after org
  :custom (org-contacts-files '("~/Documents/org/contacts.org")))
(add-to-list 'org-capture-templates
      '("c" "Contact" entry (file+headline "~/Documents/org/contacts.org" "Contacts")
        "* %^{Name}
        :PROPERTIES:
        :ADDRESS: %^{289 Cleveland St. Brooklyn, 11206 NY, USA}
        :BIRTHDAY: %^{yyyy-mm-dd}
        :EMAIL: %^{EMAIL}
        :END:"
        :empty-lines 1))


(after! 'mu4e
(add-to-list 'mu4e-headers-actions
  '("org-contact-add" . mu4e-action-add-org-contact) t)
(add-to-list 'mu4e-view-actions
  '("org-contact-add" . mu4e-action-add-org-contact) t)
)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
