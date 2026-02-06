!(import! &self ../rule-ops)
!(import! &self ../world)
!(import! &self ../utils)

;; Test for adding an item
!(test (addItem ((PLANET A)) FOOD) ((PLANET A) (HAS FOOD)))
!(test (addItem ((PLANET A) (HAS FUEL)) FOOD) ((PLANET A) (HAS FOOD)))
!(test (addItem ((PLANET A) (HAS FOOD)) FOOD) ((PLANET A) (HAS FOOD)))

;; Test for removing an item
!(test (removeItem ((PLANET A) (HAS FOOD)) FOOD) ((PLANET A)))
!(test (removeItem ((PLANET A) (HAS FUEL)) FOOD) ((PLANET A) (HAS FUEL)))
!(test (removeItem ((PLANET A)) FOOD) ((PLANET A)))

;; Test for updating planet 
!(test (updatePlanet ((PLANET A)) B) ((PLANET B)))
!(test (updatePlanet ((PLANET A)) C) ((PLANET C)))
!(test (updatePlanet ((PLANET A)(HAS FOOD)) B) ((PLANET B) (HAS FOOD)))