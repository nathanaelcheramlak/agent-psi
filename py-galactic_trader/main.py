import copy
from rule import starting_rules, reasoned_rules
from world import *

class State:
    def __init__(self, context, money):
        self.context = context
        self.money = money
    
    def __str__(self):
        return f"Context: {self.context}, Money: {self.money}"

if __name__ == "__main__":
    rules = starting_rules
    state = State(context={"planet": "A"}, money=1000)

    for i in range(5000):
        # Add a newly reasoned rule
        if reasoned_rules:
            rules.append(reasoned_rules.pop())

        applicable_rules = []
        for rule in rules:
            if not is_valid_rule(rule, state):
                continue
            
            sampled_value = rule.get_sample_value()
            applicable_rules.append((rule, sampled_value))

        if not applicable_rules:
            print(f"INFO: Step {i}: Couldn't find any applicable rules")
            break
        
        sorted_rules = sorted(applicable_rules, key= lambda x: x[1], reverse=True)
        chosen_rule = sorted_rules[0][0]

        # new_state = execute_rule(chosen_rule, state)
        new_state = execute_rule(chosen_rule, copy.deepcopy(state))

        # Calculate reward (skip for travel)
        reward = 0
        if chosen_rule.action != "travel":
            reward = evaluate_state(new_state, state)
        
        chosen_rule.update(reward)
        
        old_money = state.money
        state = new_state
        money_change = state.money - old_money

        # Log step information
        print(f"Step {i:4d} | {chosen_rule.action:6s} | {chosen_rule.name:25s} | "
              f"Money: {state.money:6.0f} ({money_change:+.0f}) | "
              f"Reward: {reward:+.1f}")

        if state.money <= 0:
            print('Ran out of money on iteration:', i)
            break