; (= (findMatchingRules $direction $rules) (
;     map-atom $rules $rule (unify (Name $name Go $direction) $rule $rule ())
;     ; map-atom $cogscm $rule (let $ruleGoal (extractRule GoalValues $rule) (if (areSimilar $currentGoal $ruleGoal) $rule Empty)) 
; ))

; (= (findMatchingRules $context $rules) (
;     let $rule (superpose $rules) (let $ruleContext (extractRule ContextValues $rule) (if (areSimilar $context $ruleContext) $rule Empty))
; ))

(= (deduction-formula (STV $Ps $Pc) (STV $Qs $Qc) (STV $Rs $Rc) (STV $PQs $PQc) (STV $QRs $QRc)) (
    STV (if (< 0.9999 $Qs)                  ; avoid division by 0
                ;; Qs tends to 1
                $Rs
                ;; Otherwise
                (+ (* $PQs $QRs) (/ (* (- 1 $PQs) (- $Rs (* $Qs $QRs))) (- 1 $Qs))))
            (min $Pc (min $Qc (min $Rc (min $PQc $QRc))))
))

(= (findMatchingRules $ruleGoal $rules) (
    if (== () $rules)
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($matchingContext (extractRule ContextValues $head))
            ($isSimilar (areSimilar $ruleGoal $matchingContext))
            ($restMatches (findMatchingRules $ruleGoal $tail))
        ) (if $isSimilar
            (cons-atom $head $restMatches)
            $restMatches))
))

(= (getMatchingPremises $premises $rule $remRules) (
    let* (
        ($ruleGoal (extractRule GoalValues $rule))
        ($matchingRules (findMatchingRules $ruleGoal $remRules))
        ($reasoned (map-atom $matchingRules $matchingRule (reason-ded $rule $matchingRule $premises)))
    ) $reasoned
))

(= (reason-ded $rule $matchingRule $premises) (
    let* (
        ($randomNo 100) ;; TODO: Fix this
        ($ruleContext (extractRule Context $rule))
        ($matchingGoal (extractRule Goal $matchingRule))
        ($matchingGoalSTV (extractRule GoalSTV $matchingRule))

        ($ruleAction (extractRule Action $rule))
        ($ruleContextSTV (extractRule ContextSTV $rule))
        ($matchingRuleAction (extractRule Action $matchingRule))
        ($newRuleAction (union-atom $ruleAction $matchingRuleAction))

        ($premise-five (extractRule STV $matchingRule))
        ($premise-three (extractRule GoalSTV $matchingRule))
        (($premise-one $premise-two $premise-four) $premises)

        ($newRuleSTV (deduction-formula $premise-one $premise-two $premise-three $premise-four $premise-five))
        ($_ (println! (New Rule STV: $newRuleSTV)))
        ($newRule (: Rule $randomNo (TTV 1) $newRuleSTV (Complexity 1) (IMPLICATION (AND (Context $ruleContextSTV (AND $ruleContext)) (Action (SEQ_AND $newRuleAction))) (Goal $matchingGoalSTV (AND $matchingGoal)))))
    ) $newRule
))

