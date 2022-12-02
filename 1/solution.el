#!/usr/bin/env -S emacs -Q --script
;;; package --- Summary

;;; Commentary:

;;; Code:

(require 'cl-lib)

(cl-flet* ((read-file (file-path)
             (with-temp-buffer
               (insert-file-contents file-path)
               (buffer-string)))

           (parse-input (input)
             (mapcar
              (lambda (reindeer)
                (mapcar #'string-to-number (split-string reindeer "\n" t)))
              (split-string input "\n\n" t)))

           (sum-list (list)
             (apply '+ list))

           (process-file (file-path)
             (let* ((reindeers (parse-input (read-file file-path)))
                    (sums  (mapcar #'sum-list reindeers))
                    (top-reindeer (seq-reduce (lambda (a b) (if (> a b) a b)) sums 0))
                    (sorted-sums (sort sums #'>))
                    (top-3-reindeer (seq-take sorted-sums 3))
                    (top-3-sum (sum-list top-3-reindeer)))
               (princ (format "part1: %d\n" top-reindeer))
               (princ (format "part2: %d\n" top-3-sum)))))

  (process-file (car command-line-args-left)))


(provide 'solution)
;;; solution.el ends here
