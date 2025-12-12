;; ROCCA Direct Evaluation Test Suite
;; 
;; Tests the directly_evaluate system by:
;; 1. Creating a percepta history (agent's observations over time)
;; 2. Creating rules with initial context STVs
;; 3. Running pln-directly-evaluate to ground context STVs in empirical data
;; 4. Verifying that context STVs are updated correctly
;;

!(import! &self directly-evaluate)
!(import! &self utils:directly-evaluate-utils)
!(import! &self utils:rule-ops)
!(import! &self utils:util)

;; ============================================================================
;; Test Setup: Create Percepta Space with Historical Observations
;; ============================================================================

;; Create percepta space to store observations
!(bind! &perceptaSpace (new-space))

;; Add observations from agent's history


!(add-atom &perceptaSpace (: Percepta 0 (AND (LEFT_SQUARE) (STILL_ALIVE))))
!(add-atom &perceptaSpace (: Percepta 1 (AND (CENTER_SQUARE) (STILL_ALIVE))))
!(add-atom &perceptaSpace (: Percepta 2 (AND (LEFT_SQUARE) (STILL_ALIVE))))
!(add-atom &perceptaSpace (: Percepta 3 (AND (CENTER_SQUARE) (DEAD))))
!(add-atom &perceptaSpace (: Percepta 4 (AND (LEFT_SQUARE) (STILL_ALIVE))))
!(add-atom &perceptaSpace (: Percepta 5 (AND (RIGHT_SQUARE) (STILL_ALIVE))))
!(add-atom &perceptaSpace (: Percepta 6 (AND (CENTER_SQUARE) (STILL_ALIVE))))
!(add-atom &perceptaSpace (: Percepta 7 (AND (LEFT_SQUARE) (DEAD))))
!(add-atom &perceptaSpace (: Percepta 8 (AND (RIGHT_SQUARE) (DEAD))))
!(add-atom &perceptaSpace (: Percepta 9 (AND (CENTER_SQUARE) (STILL_ALIVE))))

;; ============================================================================
;; Test Setup: Create Rule Space with Test Rules
;; ============================================================================

;; Create rule space
!(bind! &ruleSpace (new-space))


;; Result: 1 match out of 10 observations = 0.1 frequency
!(add-atom &ruleSpace (: Rule 3
    (TTV 0)
    (STV 0.5 0.002)
    (Complexity 1)
    (IMPLICATION
        (AND 
            (Context (STV 0.2 0.1) (AND (
                (RIGHT_SQUARE)
                (STILL_ALIVE))))
            (Action (SEQ_AND (MOVE_LEFT))))
        (Goal (STV 0.2 0.1) (AND (
                (CENTER_SQUARE)
                (STILL_ALIVE)))
    ))
))

;; ============================================================================
;; Run Direct Evaluation
;; ============================================================================

;; Process all rules to ground their context STVs
!(println! "=== STARTING DIRECT EVALUATION ===")
!(bind! &evaluatedRules (pln-directly-evaluate &ruleSpace &perceptaSpace))
!(println! "=== EVALUATION COMPLETE ===")

;; ============================================================================
;; Verification and Output
;; ============================================================================

;; Display the empirical evaluation results
!(println! "")
!(println! "=== EVALUATION RESULTS ===")
!(println! "")
!(println! "Rule 1 (LEFT_SQUARE + STILL_ALIVE):")
!(println! "  Expected: 3 matches out of 10 = 0.3 frequency")
!(println! "  Expected Confidence: 3/(800+3) ≈ 0.00375")
!(println! "")
!(println! "Rule 2 (CENTER_SQUARE + STILL_ALIVE):")
!(println! "  Expected: 3 matches out of 10 = 0.3 frequency")
!(println! "  Expected Confidence: 3/(800+3) ≈ 0.00375")
!(println! "")
!(println! "Rule 3 (RIGHT_SQUARE + STILL_ALIVE):")
!(println! "  Expected: 1 match out of 10 = 0.1 frequency")
!(println! "  Expected Confidence: 1/(800+1) ≈ 0.00125")
!(println! "")

;; Display updated rules
!(println! "Evaluated rules:")
!(map-atom &evaluatedRules $rule (println! $rule))
