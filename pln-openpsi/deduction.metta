(= (pln-deduction $ruleSpace) (
    let* (
        ($_ (println! "PLN Deduction Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($deductions (deduction-helper $rules))
    ) $deductions
))

(= (deduction-helper $rules) (
    if (<= (size-atom $rules) 1)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($premise-one (extractRule ContextSTV $rule))
            ($premise-two (extractRule GoalSTV $rule))
            ($premise-four (extractRule STV $rule))
            ($premises ($premise-one $premise-two $premise-four))
            ($matchingRuleDeductions (getMatchingPremises $premises $rule $remRules))
            ($_ (println! (Deductions: $matchingRuleDeductions)))
            ($restDeductions (deduction-helper $remRules))
        ) (union-atom $restDeductions $matchingRuleDeductions))
))