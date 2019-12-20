;;; emacs behavior

;; no tabs
(setq-default tab-width 4
              indent-tabs-mode nil)

;; easier confirmation
(defalias 'yes-or-no-p 'y-or-n-p)

;; scroll by one line
(setq scroll-conservatively most-positive-fixnum)

;; use ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; always kill current buffer
(global-set-key (kbd "C-x k") 'kill-current-buffer)

;; auto close & highlight matching pairs
(electric-pair-mode t)
(show-paren-mode 1)
(setq show-paren-delay 0)

;; indent whole buffer
(defun iwb ()
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

;; company mode
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; cleanup
(setq make-backup-files nil
      auto-save-default nil
      custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
(add-hook 'before-save-hook 'whitespace-cleanup)
