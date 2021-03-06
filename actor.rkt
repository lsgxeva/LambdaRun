(define actors (make-list))

(define (make-actor owner)
  (let* ((base (make-component "actor" owner))
         (rest-time 0)
         (self 
          (lambda (message)
            (case message
              ((destroy);remove self from list of actors
               (lambda (self)
                 (ask actors 'remove self)))
              
              ((cool-down)
               (lambda (self)
                 (set! rest-time (- rest-time 1))))
              
              ((rest-time)
               (lambda (self)
                 rest-time))
              
              ((add-rest-time)
               (lambda (self rtime)
                 (set! rest-time (+ rest-time rtime))))
              
              ((destroy)
               (lambda (self)
                 (ask actors' remove self)))
              
              (else (get-method base message))))))
    ;register actor
    (ask actors 'prepend self)
    self))

(define actor make-actor)

(define (update-actors)
  (ask actors 'for-each
       (lambda (actr)
         (if (<= (ask actr 'rest-time) 0);can act now
             (ask (ask actr 'owner) 'act)
             (ask actr 'cool-down)))))