(define custom-activate-default-im-name? #t)
(define custom-preserved-default-im-name 'anthy)
(define default-im-name 'anthy)
(define enabled-im-list '(anthy))
(define enable-im-switch? #f)
(define switch-im-key '("<Control>Shift_key" "<Shift>Control_key"))
(define switch-im-key? (make-key-predicate '("<Control>Shift_key" "<Shift>Control_key")))
(define switch-im-skip-direct-im? #f)
(define enable-im-toggle? #t)
(define toggle-im-key '("<Meta> "))
(define toggle-im-key? (make-key-predicate '("<Meta> ")))
(define toggle-im-alt-im 'direct)
(define uim-color 'uim-color-uim)
(define candidate-window-style 'vertical)
(define candidate-window-position 'caret)
(define enable-lazy-loading? #t)
(define bridge-show-input-state? #f)
(define bridge-show-with? 'time)
(define bridge-show-input-state-time-length 3)
