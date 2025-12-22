(= (pln-directly-evaluate $ruleSpace $perceptaSpace) (
    let* (
        ($_ (println! "PLN Direct Evaluation Started"))
        ($rules (collapse (get-atoms $ruleSpace)))
        ($allPerceptas (collapse (get-atoms $perceptaSpace)))
        ($perceptas (map-atom $allPerceptas $percept (extract-percepta-values $percept)))
        ($evaluatedRules (evaluate-all-rules $rules $perceptas))
        ($_ (println! "PLN Direct Evaluation Completed"))
    ) $evaluatedRules
))

(= (evaluate-all-rules $rules $perceptas) (
    if (<= (size-atom $rules) 0)
        ()
        (let* (
            (($rule $remRules) (decons-atom $rules))
            ($evaluatedRule (directly-evaluate $rule $perceptas))
            ($restEvaluated (evaluate-all-rules $remRules $perceptas))
        ) (cons-atom $evaluatedRule $restEvaluated))
))

(= (directly-evaluate $rule $perceptas) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($perceptaCount (size-atom $perceptas))
        ($matchCount (facts-in-percepta $ruleContext $perceptas))
        ($totalCount $perceptaCount)
        ($frequency (if (== $totalCount 0) 0 (div $matchCount $totalCount)))
        ($confidence (calculate-confidence $matchCount $totalCount))
        ($roundedConfidence (round $confidence 4))
        ($newContextSTV (STV $frequency $roundedConfidence))
        ($_ (println! (Total Count: $totalCount " | Match Count: " $matchCount " | Frequency: " $frequency " | Confidence: " $roundedConfidence)))
        
        ($updatedRule (construct-rule-with-new-context-stv $rule $newContextSTV))
        ($_ (println! ("Rule ID: " (extractRule Id $rule) " | Matches: " $matchCount " / " $totalCount " | Frequency: " $frequency)))
    ) $updatedRule
))





