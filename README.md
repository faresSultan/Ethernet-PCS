# ethernet_pcs

A complete digital PCS (Physical Coding Sublayer) for a 1000BASE-X serial
link, modeled and UVM-verified per **IEEE 802.3-2022, Clause 36**.

This is a full PCS implementation — TX + RX datapath — not just an 8b/10b
codec. Built as a portfolio project demonstrating SerDes / interface-IP
design and UVM verification methodology.

## Scope

```
TX path:  GMII in -> PCS transmit (ordered sets, /K/ control) -> 8b/10b encoder -> 10-bit out
RX path:  10-bit in -> comma detect + word alignment (sync FSM) -> 8b/10b decoder
          -> elastic buffer (clock tolerance / rate matching) -> GMII out
```

Plus running-disparity tracking on both sides, error detection (code errors,
disparity errors), and the PCS synchronization state machine.

## Repo layout

| Folder  | Contents |
|---------|----------|
| `rtl/`  | Hand-written Verilog/SystemVerilog RTL (encoders, decoder, sync FSM, elastic buffer, datapath tops) |
| `tb/`   | UVM testbench (agents, env, sequences, tests) |
| `sim/`  | QuestaSim `.do` compile/run/wave scripts |
| `docs/` | Design notes, block diagrams, coverage reports |

## Build order

RTL blocks are written and verified one at a time, in this order:

1. 5b/6b sub-encoder (32-row case: 5 bits + RD -> 6 bits, updates RD)
2. 3b/4b sub-encoder (8-row case: 3 bits + RD -> 4 bits, updates RD)
3. RD glue logic (one FF; RD flows in -> 5b/6b -> 3b/4b -> out)
4. Top 8b/10b encoder (split 8 into 5+3, concat 6+4 -> 10)
5. 8b/10b decoder (10 -> 8, with code/disparity error flags)
6. Comma detect + word alignment (find /K28.5/ comma, byte-align the stream)
7. PCS synchronization FSM (Clause 36 sync state machine: loss/gain of sync)
8. Elastic buffer (idle/ordered-set insert/delete for clock tolerance)
9. TX/RX datapath tops, then `pcs_top` integration
10. K-codes / ordered sets (control symbols) woven in as needed

## Reference

IEEE 802.3-2022, Clause 36. Table 36-1 is the 8b/10b code-group table — every
code-group bit pattern used in this project is verified against it before
being committed.

## Toolchain

QuestaSim, Verilog/SystemVerilog, Git, Tcl.

See `CLAUDE.md` for the full project context and division of labor.
