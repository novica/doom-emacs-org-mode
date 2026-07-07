;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/custom-packages.el
;;; Sourced from packages.el via (load! "custom-packages.el") -- do not rename
;;; without also updating that load! line.

;; --- New packages pulled in from the two source configs ---
;; (Doom already ships: doom-modeline, treemacs, which-key, rainbow-delimiters,
;;  all-the-icons, vertico/ivy completion, so those are intentionally skipped.
;;  helm is also skipped since it duplicates Doom's completion stack -- add it
;;  back with (package! helm) if you actually want it instead of vertico.)

(package! spinner)               ; dependency of auto-highlight-symbol
(package! gnu-elpa-keyring-update) ; fix "no public key" GPG errors
(package! comment-tags)          ; colorize TODO:/FIXME:/BUG: etc in comments
(package! auto-highlight-symbol) ; highlight other occurrences of symbol at point
(package! format-all)            ; auto-format on save
(package! org-autolist)          ; smarter RET behavior in org lists
(package! paredit)                ; structured editing for lisp
(package! org-super-agenda)      ; grouped/sectioned agenda views (from the 2nd config)
(package! fountain-mode)
(package! olivetti)

(package! org-bullets)           ; prettier org heading bullets
(package! org-roam-ui)           ; visual graph UI for org-roam

;; Optional, only if you want them:
;; (package! mode-icons)
;; (package! paradox)
;; (package! highlight-parentheses)
