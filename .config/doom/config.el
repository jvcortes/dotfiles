;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Source Code Pro" :size 13)
      doom-variable-pitch-font (font-spec :family "Source Sans 3" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-rose-pine)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/Notes.org")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; -- global settings
;;
;; -> packages


;; -- org mode
;; -> settings

(setq org-adapt-indentation t)
(setq org-hide-leading-stars t)
(setq org-hide-emphasis-markers t)
(setq org-pretty-entities t)
(setq org-ellipsis "  ·")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-edit-src-content-indentation 0)
(setq org-startup-with-latex-preview t)
(setq org-hidden-keywords '(title author email))
(setq org-startup-with-inline-images t)
(setq org-hide-drawer-startup nil)
(setq org-cycle-hide-drawer-startup t)
(setq line-spacing 0.2)
(setq org-id-link-to-org-use-id t)


;; -> packages

(use-package! org-modern
  :commands (org-modern-mode)
  :hook     (org-mode . org-modern-mode)
  :config
  (setq
   org-auto-align-tags t
   org-tags-column 0
   org-fold-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; Don't style the following
   org-modern-list nil
   org-modern-tag nil
   org-modern-priority nil
   org-modern-todo nil
   org-modern-table nil))

(use-package! org-appear
  :commands (org-appear-mode)
  :hook     (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t)  ;; Must be activated for org-appear to work
  (setq org-appear-autoemphasis   t)   ;; Show bold, italics, verbatim, etc.
  (setq org-appear-autolinks      t)   ;; Show links
  (setq org-appear-autosubmarkers t)) ;; Show sub- and superscripts

(use-package! org-padding
  :commands (org-padding-mode)
  :hook     (org-mode . org-padding-mode)
  :config
  (setq org-padding-heading-padding-alist
        '((3.0 . 1.5) (2.8 . 1.2) (3.0 . 0.5) (3.0 . 0.5) (2.5 . 0.5) (2.0 . 0.5) (1.5 . 0.5) (0.5 . 0.5))))

(use-package! org-tidy
  :commands (org-tidy-mode)
  :hook (org-mode . org-tidy-mode))

(use-package! org-superstar
  :commands (org-superstar-mode)
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-prettify-item-bullets t)
  (setq org-superstar-item-bullet-alist
        '((?* . ?◈)
          (?+ . ?⚬)
          (?- . ?•))))

(use-package! org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Dropbox/Notes.org/"))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (org-roam-db-autosync-mode)
  (setq org-roam-node-display-template #("${doom-hierarchy:120} ${doom-type}" 20 30
                                         (face font-lock-keyword-face)))

        ;; If using org-roam-protocol
        (require 'org-roam-protocol))

  ;; -> hooks

  (defun set-org-faces ()
    (dolist (face '((org-level-1 . 1.35)
                    (org-level-2 . 1.3)
                    (org-level-3 . 1.2)
                    (org-level-4 . 1.1)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)
                    (org-document-title . 1.8)
                    ))
      (set-face-attribute (car face) nil :weight 'bold :height (cdr face))))

  (defun org-hide-line-numbers ()
    (setq display-line-numbers nil))

  (defun my/org-fold-custom-blocks ()
    "Fold specified custom blocks (e.g., `warning`, `note`, `info`)
   in the current Org buffer."
    (save-excursion
      (goto-char (point-min))
      (let ((block-types '("warning" "note" "info"))) ; List of block types to fold
        (dolist (block block-types)
          (while (re-search-forward (format "#\\+begin_%s" block) nil t)
            (org-fold-hide-block-toggle t))))))

  (add-hook! 'org-mode-hook #'org-hide-line-numbers)
  (add-hook! 'org-mode-hook #'set-org-faces)
  (add-hook! 'org-mode-hook #'writeroom-mode)
  (add-hook! 'org-mode-hook 'my/org-fold-custom-blocks)

  ;; -> Capture templates
  (setq org-capture-templates
        '(("n" "Note")))

  ;; -- global key mappings
  (map! :leader :desc "Open Doom Emacs configuration folder" "ce" (cmd! (dired "~/.config/doom")))
