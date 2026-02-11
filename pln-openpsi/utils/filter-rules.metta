;; Given a rule space it removes rules with very low stv values
(= (filterRules $ruleSpace $evalFunc) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($_ (println! (Started with (size-atom $rules) rules.)))
        ($filteredRules (filterRulesHelper $rules $evalFunc))
        ($_ (println! (Remaining Rules are (size-atom $filteredRules))))
    ) ()
))

(= (filterRulesHelper $rules $evalFunc) (
    if (== $rules ())
        ()
        (let* (
            (($rule $remaining) (decons-atom $rules))
            ($ruleSTV (extractRule STV $rule))
            ($isGood ($evalFunc $ruleSTV))
            ($rest (filterRulesHelper $remaining $evalFunc))
        ) (if $isGood 
            (cons-atom $rule $rest) 
            $rest))
))

(= (simpleSTVChecker (STV $s $c)) (
    if (and (< $s 0.1) (< $c 0.1))
        False
        True
))

(= (weightedSTVChecker (STV $s $c)) (
    if (< (* $s $c) 0.001)
        False
        True
))