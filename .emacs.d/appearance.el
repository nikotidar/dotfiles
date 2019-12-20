;;; emacs appearance

;; colors
(setq cursor "#484848"
      modebg "#e2d3d0"
      modefg "#484848"
      modebg2 "#e4d7d4"
      modefg2 "#828282"
      paren-fg "#f0f0f0"
      paren-bg "#6f6f6f"
      ido-subdir "#e38a77")

;; hidden
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 0)
(setq inhibit-startup-screen t
      initial-scratch-message "")

;; font
(add-to-list 'default-frame-alist
             '(font . "Iosevka-10.5"))

;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'xresources t)

;; neotree
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;; padding
(set-frame-parameter nil 'internal-border-width 25)

;; cursor color
(set-cursor-color cursor)

;; ido subdir color
(set-face-attribute 'ido-subdir nil
                    :foreground ido-subdir)

;; show paren color
(set-face-attribute 'show-paren-match nil
                    :background paren-bg
                    :foreground paren-fg)

;; modeline
(setq-default mode-line-format
              (list " %m: %b, line %l. "))

(set-face-attribute 'mode-line nil
                    :weight 'normal
                    :background modebg
                    :foreground modefg
                    :box `(:line-width 3 :color ,modebg))

(set-face-attribute 'mode-line-inactive nil
                    :background modebg2
                    :foreground modefg2
                    :box `(:line-width 3 :color ,modebg2))
