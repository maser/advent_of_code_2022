#!/usr/bin/env -S emacs -Q --script
;;; package --- Summary

;;; Commentary:

;;; Code:

(require 'cl-lib)

(let ((p1-parse-mapping  '(("A" . rock)
                           ("B" . paper)
                           ("C" . scissors)
                           ("X" . rock)
                           ("Y" . paper)
                           ("Z" . scissors)))
      (p2-parse-mapping  '(("A" . rock)
                           ("B" . paper)
                           ("C" . scissors)
                           ("X" . lose)
                           ("Y" . draw)
                           ("Z" . win)))
      (outcome-mapping '(((rock paper) . win)
                         ((rock scissors) . lose)
                         ((paper rock) . lose)
                         ((paper scissors) . win)
                         ((scissors rock) . win)
                         ((scissors paper) . lose)))
      (outcome-scores '((win . 6)
                        (lose . 0)
                        (draw . 3)))
      (shape-value '((rock . 1)
                     (paper . 2)
                     (scissors . 3))))

  (cl-flet* ((read-file (file-path)
               (with-temp-buffer
                 (insert-file-contents file-path)
                 (buffer-string)))

             (parse-input (input mapping)
               (mapcar
                (lambda (row)
                  (mapcar (lambda (i) (cdr (assoc i mapping))) (split-string row " " t)))
                (split-string input "\n" t)))

             (score-shape (shape)
               (cdr (assoc shape shape-value)))

             (score-outcome (round)
               (if (eq (car round) (cadr round))
                   3
                 (cdr (assoc (cdr (assoc round outcome-mapping)) outcome-scores))))

             (score-round (round)
               (+
                (score-shape (cadr round))
                (score-outcome round)))

             (match-strategyp (strategy play)
               (let ((other-play (car strategy))
                     (outcome (cadr strategy))
                     (play-other (caar play))
                     (play-own (cadar play))
                     (play-outcome (cdr play)))
                 (cond ((and
                         (eq other-play play-other)
                         (eq outcome play-outcome))
                        play-own))))

             (strategy-to-round (strategy)
               (if (eq (cadr strategy) 'draw)
                   `(,(car strategy) ,(car strategy))
                 (let ((determined-play (seq-find
                                         #'identity
                                         (seq-map
                                          (lambda (play) (match-strategyp strategy play))
                                          outcome-mapping))))
                   `(,(car strategy) ,determined-play)))
               )

             (process-file (file-path)
               (let* ((input (read-file file-path))
                      (p1-rounds (parse-input input p1-parse-mapping))
                      (p1-round-scores (mapcar #'score-round p1-rounds))
                      (p1-total-score (apply #'+ p1-round-scores))
                      (p2-input (parse-input input p2-parse-mapping))
                      (p2-rounds (mapcar #'strategy-to-round p2-input))
                      (p2-round-scores (mapcar #'score-round p2-rounds))
                      (p2-total-score (apply #'+ p2-round-scores))
                      )
                 (princ (format "part1: %d\n" p1-total-score))
                 (princ (format "part2: %d\n" p2-total-score)))))

    (process-file (car command-line-args-left))))

(provide 'solution)
;;; solution.el ends here
