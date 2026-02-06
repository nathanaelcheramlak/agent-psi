!(import! &self ../rule-ops)
!(import! &self ../world)
!(import! &self ../utils)
;; Test for getting an item
!(test (getItem ((HAS FOOD) (PLANET A))) FOOD)
!(test (getItem ((PLANET A) (HAS FOOD))) FOOD)
!(test (getItem ((PLANET C) (HAS FUEL))) FUEL)

;; Test for evaluating state
!(test (evaluateState ((HAS FOOD) (PLANET A)) 10) 25)
!(test (evaluateState ((HAS FUEL) (PLANET B)) 0) 16)
!(test (evaluateState ((HAS METAL) (PLANET C)) 23) 38)

;; Test for getting the planet
!(test (getPlanetFromContexts ((PLANET C))) C)
!(test (getPlanetFromContexts ((PLANET A) (HAS METAL))) A)
!(test (getPlanetFromContexts ((HAS METAL) (PLANET A))) A)