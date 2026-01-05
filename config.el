;;; config.el --- AdiOS Doom Emacs PKM Configuration -*- lexical-binding: t; -*-
;;
;; Author: TridentBiz Team
;; Description: Dual-brain PKM setup with org-roam and AdiOS integration

;;; Commentary:
;; Enterprise-grade org-roam configuration for:
;; - Personal knowledge base (local only)
;; - EWA enterprise brain (synced to org repo)
;; - AdiOS ecosystem integration

;;; Code:

;; ============================================================================
;; ADIOS INTEGRATION
;; ============================================================================

(defvar adios-doom-pkm-integration nil
  "Enable AdiOS ecosystem integration.")

(defvar adios-luna-ai-enabled nil
  "Enable Luna AI integration for context-aware suggestions.")

(defvar adios-sync-protocol-enabled nil
  "Enable adios-sync-protocol for enterprise brain sync.")

(defvar adios-gamification-enabled nil
  "Enable gamification for knowledge management activities.")

;; ============================================================================
;; BASIC SETTINGS
;; ============================================================================

(setq user-full-name "AdiOS User"
      user-mail-address "user@tridentbiz.com")

;; Doom theme optimized for knowledge work
(setq doom-theme 'doom-one
      doom-font (font-spec :family "Fira Code" :size 14)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 14))

;; Line numbers for code editing
(setq display-line-numbers-type 'relative)

;; ============================================================================
;; PERFORMANCE TUNING
;; ============================================================================

;; Increase garbage collection threshold for smoother performance
(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024))

;; ============================================================================
;; ORG-MODE BASIC SETUP
;; ============================================================================

(setq org-directory "~/org/"
      org-default-notes-file (concat org-directory "inbox.org")
      org-agenda-files (list (concat org-directory "personal/")
                             (concat org-directory "ewa/")))

;; Better org-mode defaults for knowledge management
(after! org
  (setq org-startup-folded 'content
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-ellipsis " ▾"
        org-log-done 'time
        org-log-into-drawer t
        org-use-fast-todo-selection t
        org-treat-S-cursor-todo-selection-as-state-change nil))

;; ============================================================================
;; DUAL-BRAIN ORG-ROAM SETUP
;; ============================================================================

(setq adios-personal-brain-dir "~/org/personal/"
      adios-ewa-brain-dir "~/org/ewa/"
      adios-personal-db (concat adios-personal-brain-dir "org-roam-personal.db")
      adios-ewa-db (concat adios-ewa-brain-dir "org-roam-ewa.db"))

(use-package! org-roam
  :init
  ;; Default to personal brain
  (setq org-roam-directory adios-personal-brain-dir
        org-roam-db-location adios-personal-db)
  
  :config
  (org-roam-db-autosync-mode)
  
  ;; org-roam-ui for graph visualization
  (use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start nil))
  
  ;; Enhanced org-roam templates for AdiOS integration
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n#+filetags: :knowledge:\n\n")
           :unnarrowed t)
          
          ("l" "learning" plain "%?"
           :target (file+head "learning/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :learning:\n#+date: %U\n\n* Overview\n\n* Key Insights\n\n* Applications\n\n* Related Concepts\n\n")
           :unnarrowed t)
          
          ("p" "project" plain "%?"
           :target (file+head "projects/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :project:\n#+date: %U\n\n* Overview\n\n* Objectives\n\n* Tasks\n\n** TODO Define project scope\n\n* Resources\n\n* Notes\n\n")
           :unnarrowed t)
          
          ("a" "architecture" plain "%?"
           :target (file+head "architecture/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+filetags: :architecture:\n#+date: %U\n\n* Context\n\n* Decision\n\n* Consequences\n\n* Alternatives Considered\n\n")
           :unnarrowed t)))
  
  ;; Daily notes with enhanced templates
  (setq org-roam-dailies-directory "daily/"
        org-roam-dailies-capture-templates
        '(("d" "default" entry "* %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d %A>\n#+filetags: :daily:\n\n* Morning Review\n\n* Key Activities\n\n* Learnings\n\n* Tomorrow's Focus\n\n")))))

;; ============================================================================
;; BRAIN SWITCHING FUNCTIONS
;; ============================================================================

(defun adios/switch-to-personal-brain ()
  "Switch org-roam to personal brain."
  (interactive)
  (setq org-roam-directory adios-personal-brain-dir
        org-roam-db-location adios-personal-db)
  (org-roam-db-sync)
  (when adios-gamification-enabled
    (adios/award-xp 'brain-switch 10))
  (message "🧠 Switched to Personal Brain"))

(defun adios/switch-to-ewa-brain ()
  "Switch org-roam to EWA enterprise brain."
  (interactive)
  (setq org-roam-directory adios-ewa-brain-dir
        org-roam-db-location adios-ewa-db)
  (org-roam-db-sync)
  (when adios-gamification-enabled
    (adios/award-xp 'brain-switch 10))
  (message "🏢 Switched to EWA Brain"))

(defun adios/current-brain-status ()
  "Display current brain status in modeline."
  (cond
   ((string= org-roam-directory adios-personal-brain-dir) "🧠 Personal")
   ((string= org-roam-directory adios-ewa-brain-dir) "🏢 EWA")
   (t "❓ Unknown")))

;; ============================================================================
;; ENHANCED KEYBINDINGS
;; ============================================================================

(map! :leader
      ;; Brain management
      (:prefix ("m b" . "brain")
       :desc "Personal brain" "p" #'adios/switch-to-personal-brain
       :desc "EWA brain" "e" #'adios/switch-to-ewa-brain
       :desc "Brain status" "s" (lambda () (interactive) (message (adios/current-brain-status))))
      
      ;; org-roam enhanced
      (:prefix ("n r" . "roam")
       :desc "Find node" "f" #'org-roam-node-find
       :desc "Insert node" "i" #'org-roam-node-insert
       :desc "Toggle roam buffer" "r" #'org-roam-buffer-toggle
       :desc "Graph UI" "g" #'org-roam-ui-open
       :desc "Sync database" "s" #'org-roam-db-sync
       :desc "Random note" "R" #'org-roam-node-random)
       
      ;; Capture enhanced
      :desc "Org capture" "X" #'org-capture)

;; ============================================================================
;; LOAD MACHINE-SPECIFIC CUSTOMIZATIONS
;; ============================================================================

(let ((custom-file-path "~/.config/doom/custom.el"))
  (when (file-exists-p custom-file-path)
    (load custom-file-path)))

;; ============================================================================
;; ADIOS INTEGRATION INITIALIZATION
;; ============================================================================

(when adios-doom-pkm-integration
  (message "🚀 AdiOS Doom Emacs PKM Plugin loaded")
  (when adios-luna-ai-enabled
    (message "🤖 Luna AI integration enabled"))
  (when adios-sync-protocol-enabled
    (message "🔄 Sync protocol integration enabled"))
  (when adios-gamification-enabled
    (message "🎮 Gamification enabled")))

;;; config.el ends here