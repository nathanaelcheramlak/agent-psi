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


(BackPredictiveImplicationScopeLink (stv 1 0.00669975)
  (VariableSet
  ) ; [80075fffffff523a][3]
  (SLink
    (ZLink
    ) ; [800fbffffffe8ce4][3]
  ) ; [da5f815ba9d4009f][3]
  (BackSequentialAndLink
    (SLink
      (ZLink
      ) ; [800fbffffffe8ce4][3]
    ) ; [da5f815ba9d4009f][3]
    (AndLink (stv 0.03 0.2)
      (EvaluationLink (stv 0.12 0.2)
        (PredicateNode "Pellet Position") ; [56e6ab0f525cb504][3]
        (ConceptNode "None") ; [68c616828fa0f8e6][3]
      ) ; [a609b2dbedb7904e][3]
      (ExecutionLink
        (SchemaNode "Go Right") ; [51c7a48fd94d12d8][3]
      ) ; [c29bf0559d1ad8ec][3]
      (EvaluationLink (stv 0.37 0.2)
        (PredicateNode "Agent Position") ; [3fdca752fd5e5335][3]
        (ConceptNode "Left Square") ; [586f8a0db3b1388a][3]
      ) ; [ec8ec4a729ccab8c][3]
    ) ; [f07c6a1c8318095c][3]
    (ExecutionLink
      (SchemaNode "Eat") ; [3fe4e22345c3679f][3]
    ) ; [9efce1dc8918c209][3]
  ) ; [b7ee6db6cd3a43bf][3]
  (EvaluationLink (stv 0.12 0.2)
    (PredicateNode "Reward") ; [155bb4d713db0d51][3]
    (NumberNode "1") ; [2cf0956d543cff8e][3]
  ) ; [d3cee8bdda06ffcb][3]
) ; [cac8b7b130c2115c][3]