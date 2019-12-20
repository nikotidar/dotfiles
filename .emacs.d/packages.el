;;; emacs packages

(use-package ido-vertical-mode
  :ensure t
  :config
  (ido-mode 1)
  (ido-vertical-mode 1)
  (setq ido-everywhere t
        ido-use-faces 't
        ido-enable-flex-matching nil
        ido-create-new-buffer 'always
        ido-vertical-define-keys 'C-n-and-C-p-only))

(use-package smex
  :ensure t
  :init
  (smex-initialize)
  :bind ("M-x" . smex))

(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0
        company-minimum-prefix-length 2))

(use-package company-anaconda
  :ensure t
  :config
  (require 'rx)
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-to-list 'company-backends 'company-anaconda))

(use-package blacken
  :ensure t
  :config
  (add-hook 'python-mode-hook 'blacken-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . 'er/expand-region))

(use-package avy
  :ensure t
  :bind ("C-'" . avy-goto-char-timer))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package golden-ratio
  :ensure t
  :config
  (golden-ratio-mode 1))

(use-package all-the-icons
  :ensure t
  :config
  (all-the-icons-install-fonts 'install-without-asking))
