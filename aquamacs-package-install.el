;;; aquamacs-package-install.el --- auto-installer for package.el under aquamacs

;; Copyright (C) 2011 Hilary J Holz <hilary@hholz.com>

;; Author: Hilary J Holz <hilary@hholz.com>
;; Maintainer: Hilary J Holz <hilary@hholz.com>
;; Keywords: elpa, aquamacs, tramp, org
;; Code Repo: http://github.com/hilary/aquamacs-package-install
;; Homepage: http://design.hholz.com/tools/aquamacs-package-install
;; Version: 0.02

;; This script is based on Tom Tromey's package-install.el, modified
;; for use with Aquamacs 2.3a. It is intended to serve as a bridge until
;; Aquamacs is running emacs 24

;; It is distributed under the same license as Tom's script and GNU Emacs itself.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;; Code:

;;; We don't want to define anything global here, so no defuns or
;;; defvars.

;; Some values we need, copied from package.el, but with different
;; names.

;; HJH: grab package.el version 1.0
;;   set configuration vars correctly for Aquamacs

(let (
      (my-archive-base "http://tromey.com/elpa/")
      (pkg-loc "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el")
      (my-user-dir (expand-file-name "~/Library/Preferences/Aquamacs Emacs/elpa"))
      )

  (setq my-pkg-loc (concat (file-name-as-directory my-user-dir) "package.el"))

  (require 'pp)
  (let ((download
	  (lambda (url)
	       (if (fboundp 'url-retrieve-synchronously)
		          ;; Use URL to download.
		          (let ((buffer (url-retrieve-synchronously url)))
			     (save-excursion
			          (set-buffer buffer)
				     (goto-char (point-min))
				        (re-search-forward "^$" nil 'move)
					   (forward-char)
					      (delete-region (point-min) (point))
					         buffer))
		      ;; Use wget to download.
		      (save-excursion
			       (with-current-buffer
				      (get-buffer-create
				           (generate-new-buffer-name " *Download*"))
				  (shell-command (concat "wget -q -O- " url)
						 (current-buffer))
				   (goto-char (point-min))
				    (current-buffer)))))))

    ;; Make the ELPA directory.
    (make-directory my-user-dir t)

    ;; HJH: revised for aquamacs
    ;; Download package.el version 1.0 (where is development going on?) and put it in the user dir.
    (let ((pkg-buffer (funcall download pkg-loc)))
      (save-excursion
	(set-buffer pkg-buffer)
	;; HJH: revised for aquamacs
	(setq buffer-file-name my-pkg-loc)
	(save-buffer)
	(kill-buffer pkg-buffer)))

    ;; Load package.el.
    ;; (load (expand-file-name "~/.emacs.d/elpa/package.el"))
    ;; HJH: revised for aquamacs
    (load my-pkg-loc)

    ;; Download URL package if we need it.
    (unless (fboundp 'url-retrieve-synchronously)
      ;; Note that we don't name the symbol "url-version", as that
      ;; will cause us not to define the real url-version when
      ;; url-vars is loaded, which in turn will cause errors later.
      ;; Thanks to Tom Breton for this subtlety.
      (let* ((the-version "1.15")
	          (pkg-buffer (funcall download (concat my-archive-base
							   "url-" the-version ".tar"))))
	(save-excursion
	    (set-buffer pkg-buffer)
	      (package-unpack 'url the-version)
	        (kill-buffer pkg-buffer)))
      )

    ;; Arrange to load package.el at startup.
    ;; Partly copied from custom-save-all.

    ;; HJH, user-init-file is .emacs, use hjh-aq-init-file
    (let ((hjh-aq-init-file (expand-file-name "~/Library/Preferences/Aquamacs Emacs/Preferences.el"))
	  (magic 
	   (pp-to-string 
	    '(when 
		 (load (expand-file-name "~/Library/Preferences/Aquamacs Emacs/elpa/package.el"))
	       (package-initialize)))))
      (if (not filename)
          (warn (concat "Could not find "
			"%s" 
			" Add the following code to the beginning (if configuring packages in Preferences.el) or the end (otherwise) of Preferences.el: \n" 
			"%s") hjh-aq-init-file magic)
        (let ((old-buffer (find-buffer-visiting filename)))
          (with-current-buffer (let ((find-file-visit-truename t))
                                 (or old-buffer (find-file-noselect filename)))
            (unless (eq major-mode 'emacs-lisp-mode)
              (emacs-lisp-mode))
            (let ((inhibit-read-only t))
              (save-excursion
                (goto-char (point-max))
                (newline (if (bolp) 2 1))
                (insert ";;; This was installed by aquamacs-package-install.el.\n")
                (insert ";;; This provides support for the package system and\n")
                (insert ";;; interfacing with ELPA, the package archive under Aquamacs Emacs.\n")
                (insert ";;; Move to the beginning of Preferences.el if you configure packages\n")
                (insert ";;; in this file.\n")
                (insert magic)))
            (let ((file-precious-flag t))
              (save-buffer))
            (unless old-buffer
              (kill-buffer (current-buffer)))))))

    ;; Start the package manager.
    (package-initialize)
    
    )
  )

;;; aquamacs-package-install.el ends here