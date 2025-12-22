(= (calculate-confidence $matchCount $totalCount) (
    let $K 800
    (if (== $totalCount 0)
        0
        (round (div $matchCount (+ $K $matchCount)) 4)
    )
))

(= (construct-rule-with-new-context-stv $rule $newContextSTV) (
    let* (
        ((: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $_ $contexts) $action) $goal)) $rule)
    ) (: Rule $id $ttv $stv $complexity (IMPLICATION (AND (Context $newContextSTV $contexts) $action) $goal))
))

(= (extract-percepta-values $percepta) (
    unify (: Percepta $id $facts) $percepta
        $facts
        ()
))

(= (facts-in-percepta $contextFact $perceptionFacts) (
    if (== () $perceptionFacts)
        0
        (let* (
            (($pfact $remPfacts) (decons-atom $perceptionFacts))
            ($matchFound (areSimilar $contextFact $pfact))
            ; ($_ (println! ("Comparing Context Fact:" $contextFact " with Perception Fact:" $pfact " Resulted: " $matchFound)))
            ($restResult (facts-in-percepta $contextFact $remPfacts))
        ) (if $matchFound
            (+ 1 $restResult)
            $restResult))
))

;; Can be simplified using superpose or map-atom
(= (count-matching-perceptions $contextFacts $perceptions) (
    if (== $perceptions ())
        0
        (let* (
            (($perception $remaining) (decons-atom $perceptions))
            ($isMatch (facts-in-percepta $contextFacts $perceptions))
            ($_ (println! ("Checking perception:" $perceptions Resulted: $isMatch)))
            ($rest (count-matching-perceptions $contextFacts $remaining))
        ) (if $isMatch
            (+ 1 $rest)
            $rest))
))