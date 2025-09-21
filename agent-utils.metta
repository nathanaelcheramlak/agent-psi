;; Match from the rules using the goal
; (= (match-goal $goal $space) (
;     match $space (: Rule $id $stv $context $action (Goal $goal)) (: Rule $id $stv $context $action (Goal $goal))
; ))

(= (match-context $rule $context) (
    let* (
        ($ruleContext ())
    )
))

(= (extract-action $rule) (
    let (: Rule $id $stv $context (Action $action) $goal) $rule $action
))
; !(extract-action (: Rule 2 (STV 0.8 0.6) (Context ((Position 3) (Standing))) (Action (Claim)) (Goal (Reward))))

(= (extract-stv $rule) (
    let (: Rule $id (STV $s $c) $context (Action $action) $goal) $rule ($s $c)
))
; !(extract-stv (: Rule 2 (STV 0.8 0.6) (Context ((Position 3) (Standing))) (Action (Claim)) (Goal (Reward))))

(= (extract-complexity $rule) (
    let (: Rule $id $stv $context (Action $action) $goal (Complexity $complexity)) $rule $complexity
))

(= (confidence-to-count $confidence) (
    / (* $confidence 800) (- 1 $confidence)
))

(= (count-to-confidence $count) (
    / $count (+ 800 $count)
))

(= (stv-to-beta ($strength $confidence)) (
    let* (
        ($count (confidence-to-count $confidence))
        ($alpha (* $strength $count))
        ($beta (- $count $alpha))
    ) ($alpha $beta)
))

(= (beta-to-stv ($alpha $beta)) (
    let* (
        ($count (+ $alpha $beta))
        ($strength (round (/ $alpha $count) 2))
        ($confidence (+ 0.001 (round (count-to-confidence $count) 2))) ;; A small value should be added to avoid 0 when rounding
    ) ($strength $confidence)
))

(= (calculate-weight $ruleHandle) (
    let* (
        ($rule (match-handle $ruleHandle))
        ($action (extract-action $rule))
        ($complexity (extract-complexity $rule))
        ($stv (extract-stv $rule))
        ($priorEstimate (exp (* -0.1 $complexity)))
        (($betaFactor $_) $stv)
        ($weight (* $priorEstimate $betaFactor))
    )
))

; !(stv-to-beta (0.8 0.5))
; !(beta-to-stv (stv-to-beta (0.8 0.5)))
; !(index-atom (1 2 3 3 5) 4)
; !(beta-to-stv (1.0 1.0))