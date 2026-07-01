;;; ~/.doom.d/custom-config.el -*- lexical-binding: t; -*-
;;; Sourced from config.el via (load! "custom-config.el") -- do not rename
;;; without also updating that load! line.

;; Skip GPG signature checks -- remove after gnu-elpa-keyring-update installs successfully
;; (setq package-check-signature nil)  ; re-enable if GPG errors return

;; ============================================================
;;  General editor tweaks (from org-mode-better-defaults .emacs)
;; ============================================================

(setq org-directory "~/org")
(setq default-directory org-directory)

(setq confirm-kill-processes nil       ; don't ask before killing processes
      use-short-answers t              ; y/n instead of yes/no for y-or-n-p
      read-process-output-max (* 1024 1024)
      inhibit-startup-screen t
      visible-bell t
      initial-scratch-message nil)

(add-to-list 'image-types 'svg)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

(column-number-mode t)

;; show the menu bar (Doom hides it by default)
(menu-bar-mode t)

;; line numbers (Doom usually already does this, harmless if duplicated)
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;; Navigate split windows using SHIFT + ARROW KEY
(windmove-default-keybindings)

;; Cleanup whitespace on save
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Win/Super key passthrough (Windows only, harmless elsewhere)
(setq w32-pass-lwindow-to-system nil
      w32-lwindow-modifier 'super)

;; Start maximized
(add-hook 'doom-init-ui-hook #'toggle-frame-maximized)

;; Treemacs disabled in init.el -- uncomment to re-enable
;; (setq treemacs-persist-file (expand-file-name "treemacs-persist" doom-user-dir))
;; (after! treemacs
;;   (map! "M-0"       #'treemacs-select-window
;;         "C-x t t"   #'treemacs
;;         "C-x t C-t" #'treemacs-find-file
;;         "C-x t M-t" #'treemacs-find-tag)
;;   (map! :leader
;;         :desc "Switch treemacs workspace" "o W" #'treemacs-switch-workspace))


;; ============================================================
;;  New minor packages from packages.el
;; ============================================================

(use-package! auto-highlight-symbol
  :hook (prog-mode . auto-highlight-symbol-mode))

(use-package! format-all
  :hook (prog-mode . format-all-mode))

(use-package! paredit
  :hook (emacs-lisp-mode . paredit-mode))

;; Comment tags become colorized when followed by a colon, e.g. // BUG: ...
(use-package! comment-tags
  :hook (prog-mode . comment-tags-mode)
  :config
  (setq comment-tags-keymap-prefix (kbd "C-c t")
        comment-tags-comment-start-only t
        comment-tags-require-colon t
        comment-tags-case-sensitive t
        comment-tags-show-faces t
        comment-tags-lighter nil
        comment-tags-keyword-faces
        `(("TODO"  . ,(list :weight 'bold :foreground "Cyan"))
          ("FIXME" . ,(list :weight 'bold :foreground "Red"))
          ("BUG"   . ,(list :weight 'bold :foreground "Red"))
          ("HACK"  . ,(list :weight 'bold :foreground "Yellow"))
          ("INFO"  . ,(list :weight 'bold :foreground "LimeGreen")))))


;; ============================================================
;;  ORG MODE -- merged from both configs
;; ============================================================

;; Make sure ~/org exists and is the agenda root
(unless (file-directory-p org-directory)
  (make-directory org-directory t))
(setq org-agenda-files (list org-directory))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(after! org
  (setq org-confirm-babel-evaluate nil   ; don't prompt before running src blocks
        org-src-fontify-natively t       ; syntax highlight in src blocks
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-return-follows-link t
        org-log-done 'time
        org-hide-emphasis-markers nil)   ; flip to t if you'd rather hide */~ etc.

  (add-hook 'org-mode-hook 'visual-line-mode)
  (add-hook 'org-mode-hook 'org-indent-mode)
  (setq org-indent-indentation-per-level 4))

(use-package! org-autolist
  :hook (org-mode . org-autolist-mode))

(use-package! org-bullets
  :hook (org-mode . org-bullets-mode))



;; --- Color palette toggle (light vs dark terminal/theme) ---
(setq light-mode nil)

(if light-mode
    (setq todo-color        "DarkOrange"
          planning-color    "DeepPink4"
          in-progress-color "DeepSkyBlue3"
          verifying-color   "DarkOrange3"
          blocked-color     "Firebrick1"
          done-color        "Green3"
          obe-color         "Green3"
          wont-do-color     "Green3"
          critical-color    "red1"
          easy-color        "turquoise4"
          medium-color      "turquoise4"
          hard-color        "turquoise4"
          work-color        "royalblue1"
          home-color        "mediumPurple2")
  (setq todo-color        "GoldenRod"
        planning-color    "DeepPink"
        in-progress-color "Cyan"
        verifying-color   "DarkOrange"
        blocked-color     "Red"
        done-color        "LimeGreen"
        obe-color         "LimeGreen"
        wont-do-color     "LimeGreen"
        critical-color    "red1"
        easy-color        "cyan3"
        medium-color      "cyan3"
        hard-color        "cyan3"
        work-color        "royalblue1"
        home-color        "mediumPurple1"))


;; --- TODO states: the richer workflow from the tutorial config ---
(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)"
                     "BLOCKED(b@)" "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)")))

  (setq org-todo-keyword-faces
        `(("TODO"        . (:weight bold :foreground ,todo-color))
          ("PLANNING"    . (:weight bold :foreground ,planning-color))
          ("IN-PROGRESS" . (:weight bold :foreground ,in-progress-color))
          ("VERIFYING"   . (:weight bold :foreground ,verifying-color))
          ("BLOCKED"     . (:weight bold :foreground ,blocked-color))
          ("DONE"        . (:weight bold :foreground ,done-color))
          ("OBE"         . (:weight bold :foreground ,obe-color))
          ("WONT-DO"     . (:weight bold :foreground ,wont-do-color)))))


;; --- Tags: merged generic + work-ticket tags. Trim to taste. ---
(after! org
  (setq org-tag-alist
        '((:startgroup . nil)
          ("easy" . ?e) ("medium" . ?m) ("difficult" . ?d)
          (:endgroup . nil)

          (:startgroup . nil)
          ("@work" . ?w) ("@home" . ?h) ("@anywhere" . ?a)
          (:endgroup . nil)

          (:startgroup . nil)
          ("@bug" . ?b) ("@feature" . ?u) ("@spike" . ?j)
          (:endgroup . nil)

          ("@write_future_ticket" . ?W)
          ("@emergency" . ?E)
          ("@research" . ?r)

          (:startgroup . nil)
          ("sprint_review" . ?i) ("sprint_retro" . ?n)
          ("dsu" . ?D) ("grooming" . ?g)
          (:endgroup . nil)

          ("QA" . ?q)
          ("backend" . ?k)
          ("frontend" . ?f)
          ("broken_code" . ?c)

          ("CRITICAL" . ?C)
          ("obstacle" . ?o)
          ("meeting" . ?M)
          ("planning" . ?P)
          ("misc" . ?z)
          ("accomplishment" . ?A)
          ("HR" . ?H)
          ("general" . ?G)))

  (setq org-tag-faces
        `(("CRITICAL" . (:weight bold :foreground ,critical-color))
          ("easy"     . (:weight bold :foreground ,easy-color))
          ("medium"   . (:weight bold :foreground ,medium-color))
          ("hard"     . (:weight bold :foreground ,hard-color))
          ("@work"    . (:weight bold :foreground ,work-color))
          ("@home"    . (:weight bold :foreground ,home-color))
          ("backend"  . (:weight bold :foreground "royalblue1"))
          ("frontend" . (:weight bold :foreground "forest green"))
          ("QA"       . (:weight bold :foreground "sienna"))
          ("meeting"  . (:weight bold :foreground "yellow1"))
          ("planning" . (:weight bold :foreground "mediumPurple1")))))


;; --- Project note helpers (Option B: one file per topic) ---
(defvar my/capture-project-name nil)
(defvar my/capture-project-file nil)

(defun my/org-new-project-file ()
  "Prompt for project name, visit a slug-named .org file in org-directory.
Org-capture (function ...) targets require the function to open the buffer
and leave point where insertion should happen."
  (let* ((name (read-string "Project name: "))
         (slug (replace-regexp-in-string "[^a-zA-Z0-9]+" "-" (downcase name)))
         (file (expand-file-name (concat slug ".org") org-directory)))
    (setq my/capture-project-name name
          my/capture-project-file file)
    (find-file file)
    (goto-char (point-min))))

(defun my/org-insert-project-link-in-notes ()
  "After capture, insert a link to the new project file in notes.org."
  (when (and my/capture-project-file (not org-note-abort))
    (let ((notes-file (expand-file-name "notes.org" org-directory))
          (proj-file  my/capture-project-file)
          (proj-name  my/capture-project-name))
      (with-current-buffer (find-file-noselect notes-file)
        (goto-char (point-max))
        (unless (bolp) (insert "\n"))
        (insert (format "* [[file:%s][%s]]\n" proj-file proj-name))
        (save-buffer)))
    (setq my/capture-project-file nil
          my/capture-project-name nil)))

(add-hook 'org-capture-after-finalize-hook #'my/org-insert-project-link-in-notes)

;; --- Capture templates: merged set from both configs ---
(after! org
  (setq org-capture-templates
        `(("t" "TODO Item"
           entry (file ,(expand-file-name "todos.org" org-directory))
           "* TODO [#B] %? %^g\n"
           :empty-lines 0)

          ("g" "General To-Do"
           entry (file+headline ,(expand-file-name "todos.org" org-directory) "General Tasks")
           "* TODO [#B] %?\n:Created: %T\n"
           :empty-lines 0)

          ("c" "Code To-Do"
           entry (file+headline ,(expand-file-name "todos.org" org-directory) "Code Related Tasks")
           "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: "
           :empty-lines 0)

          ("j" "Journal Entry"
           entry (file+datetree ,(expand-file-name "journal.org" org-directory))
           "* %?"
           :empty-lines 1)

          ("l" "Work Log Entry"
           entry (file+datetree ,(expand-file-name "work-log.org" org-directory))
           "* %?"
           :empty-lines 0)

          ("m" "Meeting"
           entry (file+datetree ,(expand-file-name "meetings.org" org-directory))
           "* %? :meeting:%^g \n:Created: %T\n** Attendees\n*** \n** Notes\n** Action Items\n*** TODO [#A] "
           :tree-type week
           :clock-in t
           :clock-resume t
           :empty-lines 0)

          ("n" "Note"
           entry (file+headline ,(expand-file-name "notes.org" org-directory) "Random Notes")
           "** %?"
           :empty-lines 0)

          ("d" "Door Codes"
           entry (file+headline ,(expand-file-name "notes.org" org-directory) "Door Codes")
           "** %?"
           :empty-lines 0)

          ("p" "Project Note"
           plain
           (function my/org-new-project-file)
           "#+TITLE: %(identity my/capture-project-name)
#+DATE: %<%Y-%m-%d>
#+DEADLINE:
#+PEOPLE:
#+PROJECT:

* Scope
%?

* Notes

"
           :jump-to-captured t
           :unnarrowed t))))


;; --- Agenda: skip-functions, daily view, and org-super-agenda view ---
(defun air-org-skip-subtree-if-priority (priority)
  "Skip an agenda subtree if it has a priority of PRIORITY (?A, ?B, or ?C)."
  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
        (pri-value (* 1000 (- org-lowest-priority priority)))
        (pri-current (org-get-priority (thing-at-point 'line t))))
    (if (= pri-value pri-current) subtree-end nil)))

(defun air-org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit") subtree-end nil)))

(after! org
  (setq org-agenda-skip-deadline-if-done t))

(use-package! org-super-agenda
  :after org
  :config
  (org-super-agenda-mode))

(after! org-agenda
  (setq org-agenda-custom-commands
        '(("d" "Daily agenda and all TODOs"
           ((tags "PRIORITY=\"A\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-overriding-header "High-priority unfinished tasks:")))
            (agenda "" ((org-agenda-span 7)))
            (alltodo ""
                     ((org-agenda-skip-function '(or (air-org-skip-subtree-if-priority ?A)
                                                     (air-org-skip-subtree-if-priority ?C)
                                                     (org-agenda-skip-if nil '(scheduled deadline))))
                      (org-agenda-overriding-header "ALL normal priority tasks:")))
            (tags "PRIORITY=\"C\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-overriding-header "Low-priority Unfinished tasks:"))))
           ((org-agenda-compact-blocks nil)))

          ("j" "Super View"
           ((agenda "" ((org-agenda-remove-tags t)
                        (org-agenda-span 7)))
            (alltodo ""
                     ((org-agenda-remove-tags t)
                      (org-agenda-prefix-format "  %t  %s")
                      (org-agenda-overriding-header "CURRENT STATUS")
                      (org-super-agenda-groups
                       '((:name "Critical Tasks" :tag "CRITICAL" :order 0)
                         (:name "Currently Working" :todo "IN-PROGRESS" :order 1)
                         (:name "Planning Next Steps" :todo "PLANNING" :order 2)
                         (:name "Problems & Blockers" :todo "BLOCKED" :tag "obstacle" :order 3)
                         (:name "Tickets to Create" :tag "@write_future_ticket" :order 4)
                         (:name "Research Required" :tag "@research" :order 7)
                         (:name "Meeting Action Items" :and (:tag "meeting" :priority "A") :order 8)
                         (:name "Other Important Items" :and (:todo "TODO" :priority "A" :not (:tag "meeting")) :order 9)
                         (:name "General Backlog" :and (:todo "TODO" :priority "B") :order 10)
                         (:name "Non Critical" :priority<= "C" :order 11)
                         (:name "Currently Being Verified" :todo "VERIFYING" :order 20))))))))))


;; --- Heading sizes / done-headline strikethrough ---
(after! org
  (let* ((variable-tuple
          (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
                ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
                ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
                ((x-list-fonts "Verdana")         '(:font "Verdana"))
                ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                (t (warn "Cannot find a Sans Serif Font. Install Source Sans Pro."))))
         (base-font-color (face-foreground 'default nil 'default))
         (headline `(:inherit default :weight bold :foreground ,base-font-color)))
    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-6 ((t (,@headline ,@variable-tuple))))
     `(org-level-5 ((t (,@headline ,@variable-tuple))))
     `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
     `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
     `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

  (setq org-fontify-done-headline t)
  (set-face-attribute 'org-done nil :strike-through t)
  (set-face-attribute 'org-headline-done nil :strike-through t))

(use-package! fountain-mode
  :mode ("\\.fountain$" . fountain-mode)
  :config
  ;; Automatically enable olivetti-mode when opening a script
  (add-hook 'fountain-mode-hook 'olivetti-mode)
  ;; Visual tweaks for clean screenplay formatting
  (setq fountain-align-elements t))
