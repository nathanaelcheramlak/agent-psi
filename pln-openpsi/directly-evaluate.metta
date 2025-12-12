;; ROCCA Direct Evaluation Module
;; Grounds abstract rule contexts in empirical observations from percepta history
;; 
;; Main API:
;; - pln-directly-evaluate: Processes all rules against percepta space
;; - directly-evaluate: Evaluates a single rule's context against percepta

!(import! &self utils:rule-ops)
!(import! &self utils:util)
!(import! &self directly-evaluate-utils)

;; ============================================================================
;; Main Entry Point: pln-directly-evaluate
;; ============================================================================

;; (pln-directly-evaluate $ruleSpace $perceptaSpace) -> $updatedRules
;;
;; Purpose: 
;;   Processes all rules in a rule space, grounding their context STVs 
;;   in empirical observations from the percepta space.
;;
;; Process:
;;   1. Extracts all rules from the rule space
;;   2. For each rule, calls directly-evaluate to compute context frequency
;;   3. Collects all updated rules with grounded context STVs
;;   4. Returns the updated rules
;;
;; Returns: A list of rules with context STVs updated based on observations
(= (pln-directly-evaluate $ruleSpace $perceptaSpace) (
    let* (
        ($_ (println! "PLN Direct Evaluation Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($evaluatedRules (evaluate-all-rules $rules $perceptaSpace))
        ($_ (println! "PLN Direct Evaluation Completed"))
    ) $evaluatedRules
))

;; ============================================================================
;; Rule Evaluation Recursion
;; ============================================================================

;; (evaluate-all-rules $rules $perceptaSpace) -> $evaluatedRules
;;
;; Purpose:
;;   Recursively evaluates each rule against the percepta space
;;
;; Process:
;;   1. Base case: if only 1 or fewer rules remain, return empty
;;   2. Recursive case:
;;      a. Deconstruct list into first rule and remaining rules
;;      b. Evaluate the first rule
;;      c. Recursively evaluate remaining rules
;;      d. Combine results
(= (evaluate-all-rules $rules $perceptaSpace) (
    if (<= (size-atom $rules) 0)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($evaluatedRule (directly-evaluate $rule $perceptaSpace))
            ($_ (println! ("Evaluated Rule: " (extractRule Id $rule))))
            ($restEvaluated (evaluate-all-rules $remRules $perceptaSpace))
        ) (cons-atom $evaluatedRule $restEvaluated))
))

;; ============================================================================
;; Core Evaluation Function: directly-evaluate
;; ============================================================================

;; (directly-evaluate $rule $perceptaSpace) -> $updatedRule
;;
;; Purpose:
;;   Calculates the empirical probability of a rule's context occurring
;;   based on historical perceptions, and updates the rule's context STV
;;
;; Process:
;;   1. Extracts context facts from the rule
;;   2. Retrieves all perceptions from the percepta space
;;   3. Counts how many perceptions contain all context facts
;;   4. Calculates frequency (matches / total perceptions)
;;   5. Calculates confidence based on sample size
;;   6. Creates new context STV with grounded values
;;   7. Builds and returns updated rule
;;
;; Parameters:
;;   $rule: A rule atom with context to evaluate
;;   $perceptaSpace: A space containing percepta atoms
;;
;; Returns: Updated rule with grounded context STV
(= (directly-evaluate $rule $perceptaSpace) (
    let* (
        ;; Step 1: Extract context information from rule
        ($contextFacts (extractRule Context $rule))
        ($contextFacts (if (== $contextFacts Empty) () $contextFacts))
        
        ;; Step 2: Get all perceptions from percepta space
        ($allPerceptions (collapse (get-atoms $perceptaSpace)))
        ($totalCount (size-atom $allPerceptions))
        
        ;; Step 3: Count matching perceptions
        ($matchCount (count-matching-perceptions $contextFacts $allPerceptions 0))
        
        ;; Step 4 & 5: Calculate frequency and confidence
        ($frequency (if (== $totalCount 0) 0 (/ $matchCount $totalCount)))
        ($confidence (calculate-confidence $matchCount $totalCount))
        ($newContextSTV (STV $frequency $confidence))
        
        ;; Step 6 & 7: Build updated rule with new context STV
        ($updatedRule (construct-rule-with-new-context-stv $rule $newContextSTV))
        ($_ (println! ("Rule ID: " (extractRule Id $rule) " | Matches: " $matchCount " / " $totalCount " | Frequency: " $frequency)))
    ) $updatedRule
))

;; ============================================================================
;; Utility Functions for directly-evaluate
;; ============================================================================

;; (count-matching-perceptions $contextFacts $perceptions $accumulator) -> $count
;;
;; Purpose:
;;   Recursively counts how many perceptions contain all required context facts
;;
;; Process:
;;   1. Base case: if no perceptions remain, return accumulator
;;   2. Recursive case:
;;      a. Get first perception
;;      b. Check if it contains all context facts
;;      c. Increment accumulator if match found
;;      d. Recurse on remaining perceptions
(= (count-matching-perceptions $contextFacts $perceptions $accumulator) (
    if (== $perceptions ())
        $accumulator
        (let* (
            (($perception $remaining) (decons-atom $perceptions))
            ($perceptionFacts (extract-percepta-facts $perception))
            ($isMatch (facts-in-percepta $contextFacts $perceptionFacts))
            ($newAccumulator (if $isMatch (+ $accumulator 1) $accumulator))
        ) (count-matching-perceptions $contextFacts $remaining $newAccumulator))
))

;; (facts-in-percepta $contextFacts $perceptionFacts) -> Bool
;;
;; Purpose:
;;   Checks if all context facts are present in a perception
;;
;; Process:
;;   Uses areSimilar to verify all required facts exist in the perception
(= (facts-in-percepta $contextFacts $perceptionFacts) (
    areSimilar $contextFacts $perceptionFacts
))

;; (extract-percepta-facts $percepta) -> $factsList
;;
;; Purpose:
;;   Extracts the actual facts from a percepta atom
;;
;; Process:
;;   Pattern matches on percepta structure and extracts facts
;;   Handles both AND-linked facts and single facts
(= (extract-percepta-facts $percepta) (
    unify (: Percepta $id (AND $facts)) $percepta
        $facts
        (unify (: Percepta $id $fact) $percepta
            ($fact)
            ()
        )
))

;; (construct-rule-with-new-context-stv $rule $newContextSTV) -> $updatedRule
;;
;; Purpose:
;;   Creates a new rule atom with the context STV updated
;;
;; Process:
;;   Pattern matches on rule structure and reconstructs with new context STV
(= (construct-rule-with-new-context-stv $rule $newContextSTV) (
    unify (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $_ (AND $contextFacts)) $action) $goal))
        $rule
        (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $newContextSTV (AND $contextFacts)) $action) $goal))
        $rule
))

;; ============================================================================
;; Confidence Calculation
;; ============================================================================

;; (calculate-confidence $matchCount $totalCount) -> $confidence
;;
;; Purpose:
;;   Converts observation count into a confidence value
;;   Based on the formula: confidence = count / (K + count)
;;   where K is a scaling factor (default 800 from agent-utils.metta)
;;
;; Logic:
;;   - More observations = higher confidence
;;   - Formula ensures confidence is bounded between 0 and 1
;;   - K=800 means we need ~800 observations to reach confidence ~0.5
(= (calculate-confidence $matchCount $totalCount) (
    let $K 800
    (if (== $totalCount 0)
        0
        (/ $matchCount (+ $K $matchCount))
    )
))
