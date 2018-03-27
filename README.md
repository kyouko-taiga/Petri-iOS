# Petri-iOS

[Petri net](https://en.wikipedia.org/wiki/Petri_net)
is a very popular formalism to model distributed systems.
It is a directed bipartite graph whose nodes represent either transitions,
representing events in the modeled system,
or places,
representing the state of the system.
It has a formal syntax, a graphical notation and of course a well-defined semantics.

We teach the Petri net formalism at University of Geneva,
in the context of our Bachelor and Master degrees.
But if after years of exposure the formalism became second language for us,
students often struggle with it.
The first obstacle is the semantics,
and in particular the way tokens are consumed and produced.
Unexperienced students often get the idea that tokens *move* from one place to another,
rather than one being *consumed* and another new one being *produced*.

In an effort to improve the whole learning experience,
we decided to develop an iOS game that teaches the important notions of Petri nets.
It consists of solving a puzzle by finding the particular sequence of transition
that unlocks the puzzle objective(s),
hence requiring to understand the semantics of the notions it features.
