;;; emacs init

(add-to-list 'load-path "~/.emacs.d/lib/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(add-to-list 'load-path "~/.emacs.d/lib/evil")
(require 'evil)
(evil-mode 1)

(require 'package)
(package-initialize)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(load "~/.emacs.d/packages" nil t)
(load "~/.emacs.d/appearance" nil t)
(load "~/.emacs.d/behavior" nil t)
