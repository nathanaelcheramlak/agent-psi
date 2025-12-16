;; ============================================================================
;; Percepta Space Utilities
;; ============================================================================


(= (create-percepta-space) (
    new-space
))

;; (add-percepta $space $timeStep $facts) -> Empty

(= (add-percepta $space $timeStep $facts) (
    add-atom $space (: Percepta $timeStep $facts)
))


(= (get-all-perceptions $perceptaSpace) (
    collapse (get-atoms $perceptaSpace)
))

;; ============================================================================
;; Percepta Matching Utilities
;; ============================================================================


(= (percepta-contains-all-facts $facts $percepta) (
    let* (
        ($perceptaFacts (extract-percepta-facts $percepta))
    ) (areSimilar $facts $perceptaFacts)
))

;; (filter-matching-perceptions $contextFacts $allPerceptions) -> $matches

(= (filter-matching-perceptions $contextFacts $allPerceptions) (
    if (== $allPerceptions ())
        ()
        (let* (
            (($head $tail) (decons-atom $allPerceptions))
            ($isMatch (percepta-contains-all-facts $contextFacts $head))
            ($restMatches (filter-matching-perceptions $contextFacts $tail))
        ) (if $isMatch
            (cons-atom $head $restMatches)
            $restMatches))
))

;; ============================================================================
;; Context Extraction Utilities
;; ============================================================================

(= (extract-context-as-list $rule) (
    let* (
        ($context (extractRule Context $rule))
        ($contextList (if (== $context Empty) () $context))
    ) $contextList
))

;; ============================================================================
;; Truth Value Utilities
;; ============================================================================

;; (create-grounded-stv $frequency $confidence) -> $stv
(= (create-grounded-stv $frequency $confidence) (
    STV $frequency $confidence
))

;; (strength-from-frequency $matchCount $totalCount) -> $strength

(= (strength-from-frequency $matchCount $totalCount) (
    if (== $totalCount 0)
        0
        (/ $matchCount $totalCount)
))

;; (apply-confidence-threshold $confidence $minThreshold) -> $adjustedConfidence

(= (apply-confidence-threshold $confidence $minThreshold) (
    let $adjusted (max $confidence $minThreshold)
    $adjusted
))

;; (max $a $b) -> $result
;;
;; Purpose:
;;   Returns the maximum of two numbers
(= (max $a $b) (
    if (> $a $b)
        $a
        $b
))

;; ============================================================================
;; Rule Update Utilities
;; ============================================================================

(= (copy-rule-with-new-context-stv $rule $newContextSTV) (
    let* (
        ($ruleId (extractRule Id $rule))
        ($ruleTTV (extractRule TTV $rule))
        ($ruleSTV (extractRule STV $rule))
        ($complexity (extractRule Complexity $rule))
        ($context (extractRule Context $rule))
        ($action (extractRule Action $rule))
        ($goal (extractRule AllGoal $rule))
    ) (: Rule $ruleId $ruleTTV $ruleSTV $complexity 
         (IMPLICATION (AND (Context $newContextSTV (AND $context)) (Action (SEQ_AND $action))) $goal))
))

;; ============================================================================
;; Statistical Utilities
;; ============================================================================

;; (calculate-sample-size-confidence $matchCount $totalCount) -> $confidence

;; Returns: Confidence value (0.0 to 1.0)
(= (calculate-sample-size-confidence $matchCount $totalCount) (
    let $K 800
    (if (== $totalCount 0)
        0
        (/ $matchCount (+ $K $matchCount))
    )
))

;; (total-perception-count $perceptaSpace) -> $count

;; Returns: The count of perception atoms
(= (total-perception-count $perceptaSpace) (
    let* (
        ($perceptions (collapse (get-atoms $perceptaSpace)))
    ) (size-atom $perceptions)
))
