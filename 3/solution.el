#!/usr/bin/env -S emacs -Q --script
;;; package --- Summary

;;; Commentary:

;;; Code:

(require 'cl-lib)

(let ()
  (cl-flet* ((read-file (file-path)
               (with-temp-buffer
                 (insert-file-contents file-path)
                 (buffer-string)))

             (parse-input (input)
               (mapcar
                (lambda (row) (split-string row "" t))
                (split-string input "\n" t)))

             (score-item (item)
               (if (string< item "a")
                   (- (string-to-char item) (string-to-char "A") -1 -26)
                 (- (string-to-char item) (string-to-char "a") -1)))

             (find-badge-item (group)
               (seq-uniq (seq-intersection (caddr group) (seq-intersection (car group) (cadr group) ))))

             (process-file (file-path)
               (let* ((input (read-file file-path))
                      (rucksacks (parse-input input))
                      (partitioned-rucksacks (seq-map
                                              (lambda (rucksack) (seq-partition rucksack (/ (seq-length rucksack) 2)))
                                              rucksacks))
                      (common-items (mapcan
                                     (lambda (partitions) (seq-uniq (apply 'seq-intersection partitions)))
                                     partitioned-rucksacks))
                      (common-item-scores (seq-map #'score-item common-items))
                      (p1-total-score (seq-reduce #'+ common-item-scores 0))
                      (elf-groups (seq-partition rucksacks 3))
                      (badge-items (mapcan
                                    #'find-badge-item
                                    elf-groups))
                      (p2-total-score (seq-reduce #'+ (seq-map #'score-item badge-items) 0)))
                 (princ (format "part1: %d\n" p1-total-score))
                 (princ (format "part2: %d\n" p2-total-score)))))

    (process-file (car command-line-args-left))
    ))

(provide 'solution)
;;; solution.el ends here

