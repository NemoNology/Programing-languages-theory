import numpy as np
from tabulate import tabulate as tb
import matplotlib.pyplot as plt
import networkx as nx

class Machine:
    currentState = 'H (Start)'
    errorState = 'ES'

    def __init__(self, startState: str = '(S)'):
        self.rules = []
        self.states = [Machine.currentState]
        self.terminals = []
        self.currentState = Machine.currentState
        self.startState = startState

    def addTerminal(self, terminal: str):
        self.terminals.append(terminal)

    def addState(self, state: str):
        self.states.append(state)

    def addRule(self, rule: set):
        '''rule: pair (tuple) of str: (stateFrom, stateTo)'''
        self.rules.append(rule)

    def autoSetRulesAndStatesByTransitions(self):
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

    def printTable(self, isPrintCurrentState: bool = True):
        terminals = self.terminals
        states = self.states
        ts = self.getStatesTransitions()
        ls = len(states)
        ltm = len(terminals)
        if (not isPrintCurrentState):
            states.remove(Machine.currentState)
        data = [[''] * (ltm + 1) for i in range(ls)]

        for i in range(ls):
            state = states[i]
            data[i][0] = state
            for j in range(ltm):
                statesByRule = ''
                tsForState = np.array(ts)[[(t[0] == state and t[1] == terminals[j]) for t in ts]]
                for t in tsForState:
                    statesByRule += t[2] + '; '
                data[i][j + 1] = statesByRule[0:-2]

        print(tb(data, headers=['state \\ rule'] + terminals, tablefmt='rounded_grid', stralign='center'))

    def test(self):
        plt.title('States diagram')
        plt.axis('off')
        q = 4

        states = self.states
        nodes = []
        for s in states:
            x = np.random.randint(1, 9)
            y = np.random.randint(1, 9)
            plt.text(x, y, s)
            plt.scatter(x, y, 1000, 'orange')
            nodes.append((s, x, y))

        ts = self.getStatesTransitions()
        for t in ts:
            n1, n2 = t[0], t[2]
            currentNode = [(), ()]
            for n in nodes:
                n0 = n[0]
                if (n0 == n1):
                    currentNode[0] = (n[1], n[2])
                if (n0 == n2):
                    currentNode[1] = (n[1], n[2])
            pos1_x, pos1_y = currentNode[0]
            pos2_x, pos2_y = currentNode[1]
            # if (n1 == n2):
            #     p1 = (pos1_x + .25, pos1_y + .25)
            #     p2 = (pos1_x, p1[1] + .25)
            #     p3 = (pos1_x - .25, p1[1])
            #     plt.arrow(pos1_x, pos1_y, p1[0], p1[1])
            #     plt.arrow(p1[0], p1[1], p2[0], p2[1])
            #     plt.arrow(p2[0], p2[1], p3[0], p3[1])
            #     plt.arrow(p3[0], p3[1], pos1_x, pos1_y)
            #     plt.text(p2[0], p2[1] + 0.1, t[1])
            # else:
            plt.arrow(pos1_x, pos1_y, pos2_x, pos2_y)
            plt.text((pos1_x + pos2_x) / q, (pos1_y + pos2_y) / q, t[1])

        plt.show()
        # g.add_nodes_from(['1', '2'])
        # g.add_edges_from([('1', '2'), ('2', '1')])
        # pos = nx.spiral_layout(g)
        # nx.draw_networkx_edge_labels(g, pos, [{('1', '2') : '1->2'}, {('2', '1') : '2->1'}])

    def showStatesDiagram(self):
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

    def printLanguage(self):
        print('L: { ', end='')
        ts = self.terminals
        for i in range(len(ts)):
            if (i == 0):
                print(f'{ts[i]}^n; ', end='')
            else:
                print(f'{ts[i]}^m{i}; ', end='')
        print('(n > 0, mi > 0) }')

    def printRules(self):
        rules = self.rules
        print('Rules:')
        for r in rules:
            print(f'{r[0]} -> {r[1]};')

    def findChain(self, chain: str, isPrintableAnswer: bool = True, isPrintableSearch: bool = False) -> bool:
        s = []
        s.append((chain, []))
        rules = self.rules
        startState = self.startState

        while (len(s) > 0):
            chainBuffer = s.pop()
            c0 = chainBuffer[0]

            if (isPrintableSearch and c0 != chain):
                print(f'{chainBuffer[1]} --> {c0}')

            if (c0 == startState):
                if (isPrintableAnswer):
                    print(f'\n{chain} is foundable')
                return True

            for rule in rules:
                old, new = rule
                if (old != new and new in c0):
                    newChainBuffer = c0.replace(new, old, 1)
                    s.append((newChainBuffer, f'{c0} ({new} -> {old})'))

        if (isPrintableAnswer):
            print(f'\n{chain} is not foundable')
        return False


# m2 = Machine()
# m2.addRule((m2.startState, 'A|'))
# m2.addRule(('A', 'A0'))
# m2.addRule(('A', 'A1'))
# m2.addRule(('A', 'B0'))
# m2.addRule(('A', 'B1'))
# m2.addRule(('A', '0'))
# m2.addRule(('A', '1'))
# m2.addRule(('B', 'A+'))
# m2.addRule(('B', 'A-'))
# m2.autoSetRulesAndStatesByTransitions()
# m2.test()
# input()