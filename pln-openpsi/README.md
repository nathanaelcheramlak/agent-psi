# PLN-OpenPsi: Probabilistic Logic Networks in MeTTa

This directory contains a MeTTa-based implementation of core reasoning mechanisms from Probabilistic Logic Networks (PLN). It provides a framework for performing inference over a knowledge base of probabilistic rules, allowing the system to derive new knowledge from existing facts and relationships.

The implementation focuses on three fundamental PLN inference rules: **Deduction (Implication Chaining)**, **Conditional Conjunction Introduction (Goal Aggreagation)**, and **Predictive Implication Direct Introduction (Direct Evaluation)**.

### Cognitive Schematics

The knowledge base is composed of rules, each represented as a MeTTa expression. A typical rule has the following structure:

```metta
(: Rule <ID>
    (TTV <TemporalTruthValue>)
    (STV <Strength> <Confidence>)
    (Complexity <Value>)
    (IMPLICATION
        (AND
            (Context (STV ...) (AND ...))
            (Action (SEQ_AND ...))
        )
        (Goal (STV ...) (AND ...))
    )
)
```

- **`ID`**: A unique identifier for the rule.
- **`STV` (Simple Truth Value)**: Represents the probability of the rule's implication being true. It consists of a `Strength` (the probability itself) and `Confidence` (how certain we are about the strength).
- **`IMPLICATION`**: The core logical statement.
  - **`Context`**: The conditions that must be met for the rule to apply.
  - **`Action`**: The action performed that, along with the context, leads to the goal.
  - **`Goal`**: The outcome or state that results from the context and action.

A `Percepta` atom is used to represent observed facts against which rules are evaluated:
```metta
(: Percepta <ID> (
    ... facts ...
))
```

### Inference Rules Implemented

1.  **Deduction (`deduction.metta`)**
    - **Concept**: This rule performs transitive reasoning. Given two rules where the goal of the first matches the context of the second (A -> B and B -> C), it infers a new rule that chains them together (A -> C).
    - **Logic**: The `pln-deduction` function iterates through pairs of rules, and if a match is found, it uses the `deduction-formula` to calculate the STV of the newly inferred rule.

2.  **Conditional Conjunction Introduction (`cond-conj-intro.metta`)**
    - **Concept**: Also known as Goal Aggregation. If multiple rules share the exact same antecedent (context and action) but have different goals (e.g., A -> G1 and A -> G2), this rule combines them into a single rule with a conjoined goal (A -> (G1 & G2)).
    - **Logic**: The `pln-conjunction` function finds rules with identical `Context` and `Action` predicates and merges their `Goal` predicates into a new, composite rule.

3.  **Predictive Implication Direct Introduction (Direct Evaluation) (`directly-evaluate.metta`)**
    - **Concept**: This mechanism grounds the rules in empirical data by evaluating them against a set of observed facts (percepta). It updates the truth value of a rule's context based on how frequently its conditions are met in the percepta.
    - **Logic**: The `pln-directly-evaluate` function takes a rule space and a percepta space. For each rule, it counts how many percepta match the rule's `Context`. It then calculates a new frequency and confidence for the context's `STV`, producing an updated rule.

## How It Works

The reasoning process can be executed via `pln.metta`:

1.  A set of initial rules is loaded into a MeTTa space (`&ruleSpace`).
2.  The `pln-reasoning` function is called.
3.  This function independently executes `pln-deduction` and `pln-conjunction` on the rule space.
4.  Each of these functions applies its specific inference logic, generating a set of new, derived rules.
5.  The final output is the union of the results from both the deduction and conjunction processes.

The Direct Evaluation process is run separately by calling `pln-directly-evaluate` with a rule space and a space containing percepta.

## File Structure

-   **`pln.metta`**: The main entry point that orchestrates PLN reasoning by combining deduction and conjunction.
-   **`deduction.metta`**: Implements the logic for the PLN deduction rule (A->B, B->C => A->C).
-   **`deduction-test.metta`**: A test file with sample rules to validate the deduction logic.
-   **`cond-conj-intro.metta`**: Implements the Conditional Conjunction Introduction rule for goal aggregation.
-   **`conjunction-test.metta`**: A test file to validate the conjunction logic.
-   **`directly-evaluate.metta`**: Implements the logic for the Direct Evaluation mechanism.
-   **`directly-evaluate-test.metta`**: A test file to validate the direct evaluation logic.

### Utilities (`utils/`)

This directory contains essential helper functions and definitions:

-   **`deduction-utils.metta`**: Provides helper functions for the deduction process, such as finding matching rules and the core `deduction-formula` for calculating new STVs.
-   **`conj-utils.metta`**: Contains utilities for the conjunction process, primarily for finding rules that share a common antecedent.
-   **`directly-evaluate-utils.metta`**: Provides helper functions for the direct evaluation process, including confidence calculation and `Percepta` extraction.
-   **`rule-ops.metta`**: A crucial API for interacting with rules. It provides a suite of functions to reliably access specific parts of a rule (e.g., `Context`, `Goal`, `STV`).
-   **`util.metta`**: General-purpose utility functions, such as list comparison (`areSimilar`) and space cleanup (`clearSpace`).

### Tests (`tests/`)
This directory contains additional tests for the utility functions.

-   **`conj-utils-test.metta`**
-   **`deduction-utils-test.metta`**
-   **`directly-eval-utils-test.metta`**
-   **`rule-ops-test.metta`**
-   **`util-test.metta`**

## Usage

To use the PLN reasoning engine, load your probabilistic rules into a space and execute the main `pln-reasoning` function. The test files serve as excellent examples.

**Example from `pln.metta`:**

```metta
!(import! &self pln)

;; 1. Define a space and add rules to it
!(bind! &ruleSpace (new-space))
!(add-reduct &ruleSpace (superpose (
    ;; ... Add your Rule atoms here ...
    (: Rule 1 ... )
    (: Rule 2 ... )
)))

;; 2. Run the reasoning engine on the space
!(pln-reasoning &ruleSpace)
```

You can also run the inference rules individually by importing their respective files and calling `!(pln-deduction &ruleSpace)`, `!(pln-conjunction &ruleSpace)`, or `!(pln-directly-evaluate &ruleSpace &perceptaSpace)`.

## Notes
* The formulas were derived from previously implemented PLN engines and ROCCA.
