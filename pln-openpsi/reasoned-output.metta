(: Rule 100 
    (TTV 1) 
    (STV 0.3125 0.002) 
    (Complexity 1) 
    (IMPLICATION 
        (AND 
            (Context (STV 0.2 0.1) (AND 
                (RIGHT_SQUARE (STV 0.2 0.1)) 
                (STILL_ALIVE (STV 0.2 0.1)))) 
            (Action (SEQ_AND (MOVE_LEFT MOVE_RIGHT)))) 
        (Goal (STV 0.2 0.1) (AND 
            (RIGHT_SQUARE (STV 0.2 0.1)) 
            (STILL_ALIVE (STV 0.2 0.1)))
        ))) 

(: Rule 100 
    (TTV 1) 
    (STV 0.3125 0.002) 
    (Complexity 1) 
    (IMPLICATION 
        (AND 
            (Context (STV 0.2 0.1) (AND 
                (LEFT_SQUARE (STV 0.2 0.1)) 
                (STILL_ALIVE (STV 0.2 0.1)))) 
            (Action (SEQ_AND (MOVE_RIGHT MOVE_RIGHT)))) 
        (Goal (STV 0.2 0.1) (AND 
        (RIGHT_SQUARE (STV 0.2 0.1)) (STILL_ALIVE (STV 0.2 0.1)))
    )))