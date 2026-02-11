;; Main PLN + Thompson Sampling Demo

;; Steps:
;;  1. Initialize the rule is a rule space according to the usecase
;;  2. Do Thompson Sampling
;;  3. Apply the Chosen Action
;;      * Prepare some kind of environment using python
;;  4. Start the PLN Reasoning
;;      * Sample the rules to avoid reasoning over the whole space 
;;  5. Include the new rules to the Rule Space
;;  6. Repeat 2 - 5