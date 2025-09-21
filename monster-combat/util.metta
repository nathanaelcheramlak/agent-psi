(= (match-goal $goal $space) (
    collapse (match $space (: Rule $id $ttv $stv $comp $context $action (Goal $goal)) $id)
))

(= (get-rule $ruleId $space) (
    match $space (: Rule $ruleId $ttv $stv $comp $context $action $goal) (: Rule $ruleId $ttv $stv $comp $context $action $goal)
))

(= (get-context $ruleId $space) (
    match $space (: Rule $ruleId $ttv $stv $comp (Context $context) $action $goal) $context
))

(= (get-stv $ruleId $space) (
    match $space (: Rule $ruleId $ttv (STV $s $c) $comp $context $action $goal) ($s $c)
))

(= (get-action $ruleId $space) (
    match $space (: Rule $ruleId $ttv $stv $comp $context (Action $action) $goal) $action
))

(= (get-complexity $ruleId $space) (
    match $space (: Rule $ruleId $ttv $stv (Complexity $complexity) $context $action $goal) $complexity
))

(= (match-context $ruleId $context $space) (
    let* (
        ($ruleContext (get-context $ruleId $space))
        ; ($_ (println! ("Rule context: " $ruleContext)))
        ($contextCount (size-atom $ruleContext))
        ; ($_ (println! ("Context count: " $contextCount)))
        ; ($_ (println! ("Given context: " $context)))
        ($intersection (intersection-atom $ruleContext $context))
        ; ($_ (println! ("Test: " $intersection)))
        ($matchCount (size-atom $intersection))
        ; ($_ (println! ("Match count: " $matchCount)))
    ) (if (== $contextCount $matchCount)
        $ruleId
        Empty
    )
))

(= (match-contexts $ruleIds $context $space) (
    collapse (let $ruleId (superpose $ruleIds) (match-context $ruleId $context $space))
))



(= (thompson-sample $ruleIds $space) (
    if (== $ruleIds ())
        (-1 0) ; (RuleID, Sampled)
    (let* (
        (($ruleId $rest) (decons-atom $ruleIds))
        ($_ (println! ("Considering rule: " $ruleId)))
        (($strength $confidence) (get-stv $ruleId $space))
        ; ($_ (println! ("Rule " $ruleId " STV: " $strength "," $confidence)))
        (($alpha $beta) (stv-to-beta ($strength $confidence)))
        ; ($_ (println! (Alpha $alpha ", Beta " $beta)))
        ($sample (beta-sample $alpha $beta))
        ($_ (println! ("Rule " $ruleId " gave sample: " $sample)))
        (($chosenId $chosenSample) (thompson-sample $rest $space))
    ) (if (>= $sample $chosenSample) 
        ($ruleId $sample) 
        ($chosenId $chosenSample)
    ))
))

(= (perform-action $ruleId $context $space) (
    let* (
        ($action (get-action $ruleId $space))
        ($_ (println! ("Performing action: " $action " in context: " $context)))
    ) (if (and (== $action (ATTACK SWORD)) (== $context ((Position CLOSE_RANGE))))
        1
        (if (and (== $action (ATTACK BOW)) (== $context ((Position MID_RANGE))))
            1
            (if (and (== $action (CAST FIREBALL)) (== $context ((Position LONG_RANGE))))
                1
                0
            )
        )
    )
))

(: update-atom (-> Grounded Atom Atom (->)))
(= (update-atom $space $oatom $natom) (let $_ (remove-atom $space $oatom) (add-atom $space $natom)))

(= (update-stv $ruleId ($s $c) $space) (
    let* (
        ($rule (get-rule $ruleId $space))
        ($_ (println! ("Old rule: " $rule)))
        ((: Rule $ruleId $ttv (STV $os $oc) $comp $context $action $goal) $rule)
        ($newRule (: Rule $ruleId $ttv (STV $s $c) $comp $context $action $goal))
        ($_ (update-atom $space $rule $newRule))
        ($_ (println! ("New rule: " $newRule)))
    ) ()
))

(= (update-rule $ruleId $result $space) (
    let* (
        (($strength $confidence) (get-stv $ruleId $space))
        ($_ (println! ("Current STV: " ($strength $confidence))))
        (($alpha $beta) (stv-to-beta ($strength $confidence)))
        ($_ (println! ("Current alpha: " $alpha ", beta: " $beta)))
        ($newAlpha (if (== $result 1) (+ $alpha 1) $alpha))
        ($_ (println! ("New alpha: " $newAlpha)))
        ($newBeta (if (== $result 1) $beta (+ $beta 1)))
        ($_ (println! ("New beta: " $newBeta)))
        (($newStrength $newConfidence) (beta-to-stv ($newAlpha $newBeta)))
        ($_ (println! ("New strength: " $newStrength)))
        ($_ (println! ("New confidence: " $newConfidence)))
        ($_ (update-stv $ruleId ($newStrength $newConfidence) $space))
    ) ()
))

(: Rule 1
    (TTV 0)
    (STV 0.7 0.1) 
    (Complexity 1)
    (Context ((Position LONG_RANGE)))
    (Action (ATTACK SWORD))
    (Goal (HIT))   ; high success
)
(: Rule 2
    (TTV 0)
    (STV 0.5 0.1) 
    (Complexity 1)
    (Context ((Position CLOSE_RANGE)))
    (Action (ATTACK BOW))
    (Goal (HIT))  ; low success
)

; !(let $x (intersection-atom ((Position CLOSE_RANGE)) ((Position CLOSE_RANGE))) $x)
; !(match-goal (HIT) &self)
; !(get-context 1 &self)
; !(match-context 2 ((Position CLOSE_RANGE)) &self)
; !(match-contexts (1 2) ((Position CLOSE_RANGE)) &self)
; !(thompson-sample (1 2) &self)
; !(perform-action 1 (MID_RANGE) &self)

; !(bind! &space (new-space))
; !(addRules2 &space)

; !(get-atoms &space)
; !("--- Updating STV of Rule 1 to (0.9, 0.5) ---")
; !(update-stv 1 (0.9 0.5) &space)
; !("--- After update ---")
; !(get-atoms &space)