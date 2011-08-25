WHAT IS THIS?

aquamacs-package-install.el is a variation of Tom Tromey's
package-install.el, modified for use with Aquamacs 2.3a.

The script installs package.el version 1.0 and configures an Aquamacs
2.3a installation to use ELPA, the Emacs Lisp Package Archive.

WHY DO I CARE?

I wrote this because of the struggles I had getting Org mode, Tramp,
and other parts of Aquamacs to behave. I finally decided that I had to
get elpa configured Aquamacs native to make everything happy. So far
so good.

Note that the version of package.el installed is actually intended for
use with emacs v 24, whereas Aquamacs is running emacs v 23. Seems
happy, though.

HOW DO I USE IT?

NB: I am completely willing to believe that easier ways than
the following exist! I am just pleased to have gotten an installation
of Aquamacs going that has all the bits and pieces in the appropriate
places...

1) Update your Aquamacs installation to the most recent version.
2) Launch Aquamacs
3) Start a shell:

    M-x shell

4) navigate to the Aquamacs Emacs preferences directory:

    cd ~/Library/Preferences/Aquamacs Emacs/

5) install aquamacs-package-install.el in the prefs directory. My
   recommended method would be to use git, as in

   git clone git://github.com/hilary/aquamacs-package-install-el.git

   but if that seems like too much to learn atm, you can just 
   cut-n-paste aquamacs-package-install.el using Aquamacs. Learning
   to use git and github is well worth the time and effort wading 
   through first generation semi-permeable documentation.

6) eval aquamacs-package-install.el (Open aquamacs-package-install.el
   and you'll see an 'Evaluate Buffer' option under the Emacs-Lisp
   menu. Lovely!)

I HAVE THE REMAINS OF PREVIOUS ATTEMPTS LYING ABOUT. DO I NEED TO 
CLEAN THEM UP?

The new version of package.el looks pretty robust, and I've gone
through the variables quite thoroughly, so you are probably ok. That
said, I don't have the resources or setup at present to do the type of
rigorous testing for those sorts of scenarios that makes my DevOps
soul glow, so YMMV. Besides, OS cruft is never a good idea. If you 
have ~/.emacs.d/elpa/ sitting around, take a few moments and delete
the thing. Your blood pressure will thank you for it.


