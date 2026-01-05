;;; packages.el --- AdiOS Doom Emacs PKM Packages -*- no-bytecompile: t; -*-

;; Core org-roam and dependencies
(package! org-roam)
(package! org-roam-ui)
(package! websocket)  ;; Required for org-roam-ui

;; Enhanced org experience
(package! org-super-agenda)
(package! org-fancy-priorities)
(package! org-appear)

;; Knowledge management enhancements
(package! org-transclusion)
(package! org-ql)
(package! org-sidebar)

;; Export and publishing
(package! ox-hugo)
(package! ox-pandoc)

;; AdiOS integration packages (conditional loading)
(when (featurep 'adios-doom-pkm-integration)
  ;; These would be loaded from AdiOS core if available
  (package! adios-sync-protocol :recipe (:local-repo "../../libs/adios-sync-protocol"))
  (package! adios-context-capture :recipe (:local-repo "../../libs/adios-context-capture"))
  (package! adios-gamification :recipe (:local-repo "../../libs/adios-gamification")))