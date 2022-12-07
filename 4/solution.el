#!/usr/bin/env -S emacs -Q --script
;;; package --- Summary

;;; Commentary:

;;; Code:

(require 'cl-lib)

(let ((fallback-file "sample_input.txt"))
  (cl-flet* ((read-file (file-path)
               (with-temp-buffer
                 (insert-file-contents file-path)
                 (buffer-string)))

             (parse-input (input)
               (mapcar
                (lambda (row)
                  (mapcar
                   (lambda (section)
                     (mapcar #'string-to-number (split-string section "-" t)))
                   (split-string row "," t)))
                (split-string input "\n" t)))

             (contains (a b)
               (and (<= (car a) (car b)) (>= (cadr a) (cadr b) )))

             (one-contains-the-other (el)
               (or
                (contains (car el) (cadr el))
                (contains (cadr el) (car el))))

             (overlaps (a b)
               (and
                (>= (cadr a) (car b))
                (>= (cadr b) (car a))))

             (process-file (file-path)
               (let* ((input (read-file file-path))
                      (pairs (parse-input input))
                      (contains-count (seq-count #'one-contains-the-other pairs))
                      (overlaps-count (seq-count (lambda (el) (overlaps (car el) (cadr el))) pairs)))
                 (princ (format "part1: %d\n" contains-count))
                 (princ (format "part2: %d\n" overlaps-count))
                 )))

    (process-file (or  (car command-line-args-left) fallback-file))
    ))

(provide 'solution)
;;; solution.el ends here
