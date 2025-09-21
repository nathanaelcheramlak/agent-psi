;; Add rules to space 
(= (addRules $space) (
    add-reduct $space 
        (superpose (
            (: Rule 1
                (STV 0.5 0.1) 
                (Context ((Position 1)))
                (Action (Move Right))
                (Goal (Position-2))
            )       

            (: Rule 2
                (STV 0.5 0.1) 
                (Context ((Position 2)))
                (Action (Move Left))
                (Goal (Position 1))
            )  

            (: Rule 3
                (STV 0.5 0.1) 
                (Context ((Position 2)))
                (Action (Move Right))
                (Goal (Position 3))
            )  

            (: Rule 4
                (STV 0.5 0.1) 
                (Context ((Position 3)))
                (Action (Move Left))
                (Goal (Position 2))
            ) 

            (: Rule 5
                (STV 0.5 0.1) 
                (Context ((Position 3)))
                (Action (Move Right))
                (Goal (Position 4))
            ) 

            (: Rule 6
                (STV 0.5 0.1) 
                (Context ((Position 4)))
                (Action (Move Left))
                (Goal (Position 3))
            ) 

            (: Rule 7
                (STV 0.8 0.6) 
                (Context ((Standing)))
                (Action (Sitting Down))
                (Goal (Sitting))
            ) 

            (: Rule 8
                (STV 0.8 0.6) 
                (Context (Sitting))
                (Action (Standing Up))
                (Goal (Standing))
            )

            (: Rule 9
                (STV 0.8 0.6) 
                (Context ((Position 3) (Standing)))
                (Action (Claim))
                (Goal (Reward))
            )
        ))
))

(= (addRules2 $space) (
    add-reduct $space 
        (superpose (
            (: Rule 1
                (TTV 0)
                (STV 0.5 0.002)  
                (Complexity 1)
                (Context ((Position CLOSE_RANGE)))
                (Action (ATTACK SWORD))
                (Goal (HIT))   ; high success
            )

            (: Rule 2
                (TTV 0)
                (STV 0.5 0.002) 
                (Complexity 1)
                (Context ((Position CLOSE_RANGE)))
                (Action (ATTACK BOW))
                (Goal (HIT))   ; low success
            )

            (: Rule 3
                (TTV 0)
                (STV 0.5 0.002) 
                (Complexity 1)
                (Context ((Position CLOSE_RANGE)))
                (Action (CAST FIREBALL))
                (Goal (HIT))   ; medium success
            )

            (: Rule 4
                (TTV 0)
                (STV 0.5 0.002) 
                (Complexity 1)
                (Context ((Position MID_RANGE)))
                (Action (ATTACK SWORD))
                (Goal (HIT))   ; low success (too far for sword)
            )

            (: Rule 5
                (TTV 0)
                (STV 0.5 0.002)  
                (Complexity 1)
                (Context ((Position MID_RANGE)))
                (Action (ATTACK BOW))
                (Goal (HIT))   ; high success (optimal here)
            )

            (: Rule 6
                (TTV 0)
                (STV 0.5 0.002)  
                (Complexity 1)
                (Context ((Position MID_RANGE)))
                (Action (CAST FIREBALL))
                (Goal (HIT))   ; medium success
            )

            (: Rule 7
                (TTV 0)
                (STV 0.5 0.002) 
                (Complexity 1)
                (Context ((Position LONG_RANGE)))
                (Action (ATTACK SWORD))
                (Goal (HIT))   ; 0% success (too far)
            )

            (: Rule 8
                (TTV 0)
                (STV 0.5 0.002) 
                (Complexity 1)
                (Context ((Position LONG_RANGE)))
                (Action (ATTACK BOW))
                (Goal (HIT))   ; medium success
            )

            (: Rule 9
                (TTV 0)
                (STV 0.5 0.002) 
                (Complexity 1)
                (Context ((Position LONG_RANGE)))
                (Action (CAST FIREBALL))
                (Goal (HIT))   ; medium success
            )
        ))
))

; !(bind! &space (new-space))
; !(addRules &space)

; !(get-atoms &space)