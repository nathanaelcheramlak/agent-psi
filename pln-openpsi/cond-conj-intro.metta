; Conditional Conjunction Introduction (Goal Aggregation): 
;   creates more complex goals. 
;   Eg. A & B => G1 and A & B => G2 it infers A & B => G1 & G2.

(= (pln-conjunction $ruleSpace) (
    let* (
        ($_ (println! "PLN Conjunction Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($conjunctions (conjunction-helper $rules))
    ) $conjunctions
))

(= (conjunction-helper $rules) (
    if (<= (size-atom $rules) 1)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($conjunctions (findConjunctions $rule $remRules))
            ($_ (println! (Conjunctions: $conjunctions)))
            ($restConjunctions (conjunction-helper $remRules))
        ) (union-atom $restConjunctions $conjunctions))
))