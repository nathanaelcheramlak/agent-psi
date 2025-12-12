!(import! &self cond-conj-intro)
!(import! &self utils:conj-utils)
!(import! &self utils:util)
!(import! &self utils:rule-ops)
!(import! &self utils:deduction-utils)
!(import! &self utils:directly-evaluate-utils)
!(import! &self deduction)
!(import! &self directly-evaluate)

!(bind! &ruleSpace (new-space))
!(bind! &perceptaSpace (new-space))

;; ============================================================================
;; Add Sample Percepta Data
;; ============================================================================
;; These represent the agent's observations over time.
;; Each percepta records what the agent observed at a specific time step.

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

!(add-reduct &ruleSpace (superpose (
    ;; Rule 1
    (: Rule 1
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))
        )) 
    ))

    ;; Rule 3
    (: Rule 3
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (LEFT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (DEAD (STV 0.2 0.1)))
        )) 
    ))

    ;; Rule 2
    (: Rule 2
        (TTV 0)
        (STV 0.5 0.002)  
        (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND (
                    (CENTER_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT)) ) )
            (Goal (STV 0.2 0.1) (AND (
                    (RIGHT_SQUARE (STV 0.2 0.1))
                    (STILL_ALIVE (STV 0.2 0.1)))
        )) 
    ))
)))

(= (pln-reasoning $ruleSpace $perceptaSpace) (
    let* (
        ;; Step 1: Ground context STVs in empirical observations using ROCCA
        ($_ (println! ""))
        ($_ (println! "=== Step 1: ROCCA Direct Evaluation ==="))
        ($groundedRules (pln-directly-evaluate $ruleSpace $perceptaSpace))
        
        ;; Step 2: Apply deduction to derive chained rules
        ($_ (println! ""))
        ($_ (println! "=== Step 2: PLN Deduction ==="))
        ($deductionResults (pln-deduction $groundedRules))
        
        ;; Step 3: Apply conjunction to merge goals
        ($_ (println! ""))
        ($_ (println! "=== Step 3: PLN Conjunction ==="))
        ($conjunctionResults (pln-conjunction $groundedRules))

        ;; Step 4: Combine all results
        ($_ (println! ""))
        ($_ (println! "=== Step 4: Combining Results ==="))
        ($reasonedRules (union-atom $deductionResults $conjunctionResults))
    ) $reasonedRules
))

;; Overload: Support calling with just ruleSpace (for backward compatibility)
;; In this case, we create an empty percepta space
(= (pln-reasoning $ruleSpace) (
    let* (
        ($emptyPerceptaSpace (new-space))
    ) (pln-reasoning $ruleSpace $emptyPerceptaSpace)
))

!(pln-reasoning &ruleSpace &perceptaSpace)