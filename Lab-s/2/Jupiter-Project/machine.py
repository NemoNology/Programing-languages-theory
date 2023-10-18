import numpy as np
from tabulate import tabulate as tb
import matplotlib.pyplot as plt
import networkx as nx

class Machine:
    currentState = 'H (Start)'
    errorState = 'ES'

    def __init__(self, startState: str = '(S)') -> None:
        self.rules = []
        self.states = [Machine.currentState]
        self.terminals = []
        self.currentState = Machine.currentState
        self.startState = startState

    def addTerminal(self, terminal: str) -> None:
        self.terminals.append(terminal)

    def addState(self, state: str) -> None:
        self.states.append(state)

    def addRule(self, rule: set) -> None:
        '''rule: pair (tuple) of str: (stateFrom, stateTo)'''
        self.rules.append(rule)

    def autoSetRulesAndStatesByTransitions(self) -> None:
        states = [Machine.currentState]
        terminals = []
        
        for r in self.rules:
            state = r[0]
            if (state not in states):
                states.append(state)

        for r in self.rules:
            terminal = r[1]
            for state in states:
                terminal = terminal.replace(state, '', 1)
            if (len(terminal) != 0 and terminal not in terminals):
                terminals.append(terminal)

        self.states = states
        self.terminals = terminals

    def isCompletedChain(self, chain: str) -> bool:
        ts = self.terminals
        for c in chain:
            if (c not in ts):
                return False
        return True

    def getStatesTransitions(self) -> set:
        '''Returns: list of tuple of str: (stateFrom, rule, stateTo)'''
        transitions = []

        for r in self.rules:
            buffer = r[1]
            if (self.isCompletedChain(buffer)):
                transitions.append((Machine.currentState, buffer, r[0]))
            else:
                for state in self.states:
                    if (state in buffer):
                        transitions.append((state, buffer.replace(state, '', 1), r[0]))

        return transitions

    def printTable(self, isPrintCurrentState: bool = True) -> None:
        terminals = self.terminals
        states = self.states
        ts = self.getStatesTransitions()
        lterms = len(terminals)
        if (not isPrintCurrentState):
            states.remove(Machine.currentState)
        data = [[''] * (lterms + 1) for state in states]
        ls = len(states)

        for i in range(ls):
            state = states[i]
            transitions = (np.array(ts))[[t[0] == state for t in ts]]
            data[i][0] = state
            for j in range(lterms):
                transitionsByRule = transitions[[t[1] == terminals[j] for t in transitions]][:, 2]
                statesByRule = '-'
                data[i][j + 1] = statesByRule
                lt = len(transitionsByRule)
                if (lt > 0):
                    statesByRule = ''
                    for k in range(lt):
                        statesByRule += transitionsByRule[k] + '; '
                    data[i][j + 1] = statesByRule[0:-2]

        print(tb(data, headers=['state \\ rule'] + terminals, tablefmt='rounded_grid', stralign='center'))

    def showStatesDiagram(self) -> None:
        options = {
            'node_color': 'Orange',
            'arrowstyle': '-|>',
            'arrowsize': 18,
        }
        g = nx.DiGraph()
        g.add_nodes_from(self.states)
        edges = []
        edgesWithlabels = dict()
        ts = self.getStatesTransitions()
        rules = ''
        lts = len(ts)
        for i in range(lts):
            edge = (ts[i][0], ts[i][2])
            if (edge not in edges):
                edges.append(edge)
                rules = ''

            rules += ts[i][1] + '; '
            edgesWithlabels.update({edge: rules[0:-2]})

        pos = nx.spiral_layout(g)
        g.add_edges_from(edges)
        nx.draw(g, pos, with_labels=True, **options)
        nx.draw_networkx_edge_labels(g, pos, edgesWithlabels)

        for edge, label in edgesWithlabels.items():
            if edge[0] == edge[1]:
                x, y = pos[edge[0]]
                plt.text(x, y + 0.25, label, ha='center', va='center')

    def printLanguage(self) -> None:
        print('L: { ', end='')
        ts = self.terminals
        for i in range(len(ts)):
            if (i == 0):
                print(f'{ts[i]}^n; ', end='')
            else:
                print(f'{ts[i]}^m{i}; ', end='')
        print('(n > 0, mi > 0) }')

    def printRules(self) -> None:
        rules = self.rules
        print('Rules:')
        for r in rules:
            print(f'{r[0]} -> {r[1]};')

    def findChain(self, chain: str, isPrintable: bool = True) -> bool:
        s = []
        s.append((chain, []))
        rules = self.rules
        startState = self.startState

        while (len(s) > 0):
            chainBuffer = s.pop()
            c0 = chainBuffer[0]

            if (isPrintable and c0 != chain):
                print(f'{chainBuffer[1]} --> {c0}')

            if (c0 == startState):
                if (isPrintable):
                    print(f'\n{chain} is foundable')
                return True

            for rule in rules:
                old, new = rule
                if (old != new and new in c0):
                    newChainBuffer = c0.replace(new, old, 1)
                    s.append((newChainBuffer, f'{c0} ({new} -> {old})'))

        if (isPrintable):
            print(f'\n{chain} is not foundable')
        return False

