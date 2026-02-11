!(register-module! ../../pln-openpsi)
!(import! &self pln-openpsi:utils:filter-rules)
!(import! &self pln-openpsi:utils:rule-ops)
!(import! &self pln-openpsi:utils:util)

!(bind! &ruleSpace (new-space))
!(add-reduct &ruleSpace (superpose (
    (: Rule 1
        (TTV 0) (STV 0.5 0.002) (Complexity 1)
        (IMPLICATION
            (AND 
                (Context (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
    ))
    (: Rule 2
        (TTV 0) (STV 0.05 0.002) (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND ((CENTER_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND ((RIGHT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
    ))
    (: Rule 3
        (TTV 0) (STV 0.02 0.2) (Complexity 1)
        (IMPLICATION 
            (AND 
                (Context (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
                (Action (SEQ_AND (MOVE_LEFT MOVE_RIGHT))))
            (Goal (STV 0.2 0.1) (AND ((LEFT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))))
    ))
)))

; !(filterRules &ruleSpace simpleSTVChecker)
!(filterRules &ruleSpace weightedSTVChecker)