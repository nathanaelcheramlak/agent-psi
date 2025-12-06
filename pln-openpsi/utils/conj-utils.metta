(= (findMatchingConjunctions $ruleContext $ruleAction $rules) (
    if (== $rules ())
        ()
        (let* (
            (($head $tail) (decons-atom $rules))
            ($matchingContext (extractRule ContextValues $head))
            ($matchingAction (extractRule Action $head))
            ($isContextSimilar (areSimilar $ruleContext $matchingContext))
            ($isActionSimilar (areSimilar $ruleAction $matchingAction))
            ($_ (println! (areSimilaring Context: $ruleContext $matchingContext : $isContextSimilar)))
            ($_ (println! (areSimilaring Action: $ruleAction $matchingAction : $isActionSimilar)))
            ($restMatches (findMatchingConjunctions $ruleContext $ruleAction $tail))
        ) (if (and $isContextSimilar $isActionSimilar)
            (cons-atom $head $restMatches)
            $restMatches
        ))
))

(= (findConjunctions $rule $rules) (
    let* (
        ($ruleContext (extractRule ContextValues $rule))
        ($ruleAction (extractRule Action $rule))

        ($matchingRules (findMatchingConjunctions $ruleContext $ruleAction $rules))
        ($_ (println! (Matching Rules for Conjunctions: $matchingRules)))
        ($conjoinedGoals (map-atom $matchingRules $matchingRule (reason-conj $rule $matchingRule)))
        ($_ (println! (Conjoined Goals: $conjoinedGoals)))
    ) $conjoinedGoals
))

(= (reason-conj $rule $matchingRule) (
    let* (
        ($maxRuleId 200) ;; TODO: Fix this for rule IDs

        ($ruleGoal (extractRule Goal $rule))
        ($matchingRuleGoal (extractRule Goal $matchingRule))
        ($ruleContext (extractRule Context $rule))
        ($ruleContextSTV (extractRule ContextSTV $rule))
        ($ruleAction (extractRule Action $rule))
        ($ruleGoalSTV (extractRule GoalSTV $rule))
        ($newGoal (union-atom $ruleGoal $matchingRuleGoal)) ;; TODO: Clean up duplicates

        ((STV $ruleStrength $ruleConfidence) (extractRule STV $rule))
        ((STV $matchingStrength $matchingConfidence) (extractRule STV $matchingRule))
        ($newStrength (* $ruleStrength $matchingStrength))
        ($newConfidence (min $ruleConfidence $matchingConfidence))
        ($newSTV (STV $newStrength $newConfidence))

        ($newRule (: Rule $maxRuleId (TTV 1) $newSTV (Complexity 1) (IMPLICATION (AND (Context $ruleContextSTV (AND $ruleContext)) (Action (SEQ_AND $ruleAction))) (Goal $ruleGoalSTV (AND $newGoal)))))
    ) $newRule
))