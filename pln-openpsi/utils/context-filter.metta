;; Filters rules from a rule space based on matching context values
(= (filterByContext $context $ruleSpace) (
    let* (
        ($rules (collapse (get-atoms $ruleSpace)))
        ($filtered (filter-rules-by-context $context $rules))
    ) $filtered
))

(= (filter-rules-by-context $context $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($ruleContext (extractRule ContextValues $head))
            ($isMatch (areSimilar $context $ruleContext))
            ($restMatches (filter-rules-by-context $context $tail))
        ) (if $isMatch
            (cons-atom $head $restMatches)
            $restMatches))
))

