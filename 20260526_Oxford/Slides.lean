import VersoSlides

open VersoSlides

#doc (Slides) "Presentation Title" =>
%%%
theme := "white"
slideNumber := true
transition := "none"
%%%

# AI and mathematics

Kim Morrison

Oxford, 26 May 2026

# Lean

I'm just going to assume that you know what Lean is!

AIs are increasingly good at many aspects of mathematics.
Whether they "need" formal methods to become really good is an open question.

I'd be happy if that's true, and for today lets just take it for granted!

# The models

* Frontier models
  * GPT 5.6 (Codex/OpenAI)
  * Opus 4.7 (Claude/Anthropic)
  * Gemini 3.1 (Antigravity/Google)
  * ... plus unreleased models from the big labs

* Lean specialized models
  * Aristotle (Harmonic)
  * Gauss (Math Inc)
  * SeedProver (DeepSeek)
  * Aleph Prover (Logical Intelligence)
  * AlphaProof (DeepMind)
  * AxiomProver (Axiom)
  * Leanstral (Mistral)

# Recent announcements

* Erdos unit distance problem (OpenAI [announce](https://openai.com/index/model-disproves-discrete-geometry-conjecture/) / [proof](https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-proof.pdf) / [paper](https://cdn.openai.com/pdf/74c24085-19b0-4534-9c90-465b8e29ad73/unit-distance-remarks.pdf))
  * _Superhuman mathematics is here_.
  * Entirely informal!
  * Formalizing the proof would [require](https://leanprover.zulipchat.com/#narrow/channel/219941-Machine-Learning-for-Theorem-Proving/topic/OpenAI.20with.20a.20shiny.20new.20claim.20.3A.20the.20unit.20distance.20problem/near/596642356) a big chunk of global class field theory, where we can't even state the main results in Lean+Mathlib today.

> "If a human had written the paper and submitted it to the Annals of Mathematics and I had been asked for a quick opinion, I would have recommended acceptance without any hesitation" — Tim Gowers

> "They are capable of having original ingenious ideas, and then carrying them out to fruition." — Arul Shankar

> "The construction and its analysis apply fairly sophisticated tools from algebraic number theory in an elegant and clever way." — Noga Alon

# DeepMind "AI-driven formal proof search"

* AlphaProof Nexus, essentially an orchestrator driving
  * Gemini 3.1 Pro, as both prover and critic subagents
  * AlphaProof
  (DeepMind's Lean model, used in the IMO gold medal equivalent result)
* Takes inspiration from AlphaEvolve to decide which proof sketches to incorporate into future episodes.
* Last week [announced](https://arxiv.org/html/2605.22763v1) solving 9 out of the 353 open Erdos problems with vetted formal statements,
  all formalized in Lean.
* Remarkably, when restricted to the 9 successful problems, the bare Gemini agent can also solve the problems, but more expensively.

# Sphere packing

* Gauss took an existing blueprint by a team led by Siddharth and Maryna,
  and formalized Maryna's resolution of sphere packing in 8 dimensions.
* This was controversial, and Math Inc acted badly.
* Siddharth and Maryna's team are now digesting and rewriting the formalization.
* Gauss followed up with a formalization of the 24-dimensional case.

# Proof abundance

* How do we adapt to the new world of AI written proofs, and AI research?
* You can't bring a sack of potatoes to a potluck!
* We need to adapt, by identifying our respective comparative advantages.
  * AIs will do more of the proof work, informal and formal.
  * Humans will direct, digest, and organize.
* The value of a curated, well-designed, coherent literature is higher than ever.
  * The AIs work better, the better their foundations are!
  * "Getting there first" matters less than "getting it right".
  * This applies both in the informal literature, and _particularly_ for formal libraries, e.g. *Mathlib*.

# Where next?

* Mathlib
  * downstream libraries
  * formalization in the halo
  * biases
* Mathlib Initiative
* Formal Frontiers: "doing autoformalization right".
* [`lean-eval`](https://lean-lang.org/eval/), a leaderboard for hard autoformalization tasks.
  * e.g. the "Jacobian challenge"
* Language choice, automation, and semantic search.
* Formalization and translation of software libraries.
* `Verso`: exposition, pedagogy, and blueprints, working natively in Lean.
* `lean-workbench`: overleaf for Lean+Verso.

# Mathlib

...

# Mathlib Initiative

...

# Formal Frontiers

...

# The `lean-eval` leaderboard

* A collection of formalization problems, mostly beyond current AI capabilities.
* Problems require formalization of research papers / books (but not open problems).
* Completely automated, unhackable evaluation using Lean and [`comparator`](https://github.com/leanprover/comparator).
* Drive competition amongst labs to focus on Lean and formalization.
* I keep being surprised by successful submissions!

# The "Jacobian challenge"

# Language choice, automation, and semantic search.

* Does the language matter?
  * expressivity for mathematics (dependent types, quotient types, typeclasses)
  * metaprogramming and automation, implemented in the same language
    * the AIs can write new tactics (e.g. [`sum-of-squares`](https://github.com/leanprover/sos)) (and sometimes even request them!)
  * tooling and ecosystem (editors, profiling, build tools, libraries)
  * scalability

* ... yes!

* Every layer of additional automation makes life easier for humans and for AIs.
* Semantic search / premise selection reduces the LLM context size needed to work with large libraries.

# Formalization and translation of software libraries

* Can we just port the Rust + Python ecosystems into Lean, adding verification layers as well go?

[{image "img/leo-quote.png" (height := "60vh")}[Leo on lean-zip]](https://github.com/kim-em/lean-zip/blob/master/Zip/Spec/ZlibCorrect.lean#L146)

# Computational algebra in Lean via spec-driven development.

* [`hex`](https://github.com/kim-em/hex)
* work-in-progress
* `SPEC.md` tells the agents what to make
  * many sublibraries [`SPEC/Libraries/hex-berlekamp-zassenhaus.md`](https://github.com/kim-em/hex/blob/main/SPEC/Libraries/hex-berlekamp-zassenhaus.md)
  * verification layer, relying on Mathlib, proving correctness
* `PLAN.md` tells the agents how to make it
  * conformance testing against existing CAS implementations
  * benchmarks to ensure expected asymptotics and reasonable constants

# Computational algebra in Lean

* driven by an orchestrator running frontier model subagents

  {image "img/orchestrator.png" (height := "20vh")}[orchestrator]

# Computational algebra in Lean

* we have fast+verified lattice basis reduction and integer polynomial factorization
* everything is in the spec: you can throw out the artefacts and re-run, and get the library back again
* next: computable finite fields, complex/real root isolation, number fields and algebraic numbers

# Verification of "legacy" languages

* Tools for verifying existing code in other languages
  * [`aeneas`](https://github.com/AeneasVerif/aeneas/blob/main/README.md) (Rust)
  * [`iris-lean`](https://github.com/leanprover-community/iris-lean/blob/master/readme.md) (separation logic)
  * [`veil`](https://veil.dev/) (distributed protocols)
  * [`velvet`](https://github.com/verse-lab/velvet) (like Dafny, but with a Lean backend)
* Verification of hardware design
  * industry groups, big and small

# Verso

These slides are written in Lean!

[Verso](https://verso.lean-lang.org/) is a library for documents that integrate with Lean.
Lean is an extremely flexible language that supports DSLs,
and Verso enables a markdown dialect with embedded Lean.

Your code is compiled live, and hovers and code-completion work as expected.

```leanModule
example (n : Nat) : n + 0 = n := by
  rfl
```

We've written the [Lean language reference](https://lean-lang.org/doc/reference/latest/) in Verso,
so code examples are always up-to-date.

We've written [research papers](https://grind-paper.netlify.app/) in Verso.

# lean-workbench

... coming soon?
... Numina Fuse?
