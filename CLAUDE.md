# ethernet_pcs — Project Context

## Goal
Model and UVM-verify the COMPLETE digital PCS (Physical Coding Sublayer) of a
1000BASE-X serial link, per IEEE 802.3-2022 Clause 36. This is a full PCS
implementation (TX + RX datapath), NOT just an 8b/10b codec. Purpose: a
portfolio project demonstrating SerDes / interface-IP design + UVM verification.

## Reference spec
IEEE 802.3-2022, Clause 36. Table 36-1 = the 8b/10b code-group table.

## Full PCS scope (the whole thing being modeled)
TX path:  GMII in -> PCS transmit (ordered sets, /K/ control) -> 8b/10b encoder -> 10-bit out
RX path:  10-bit in -> comma detect + word alignment (sync FSM) -> 8b/10b decoder
          -> elastic buffer (clock tolerance / rate matching) -> GMII out
Plus:     running-disparity tracking on both sides, error detection
          (code errors, disparity errors), and the PCS synchronization
          state machine.

## Folder structure
ethernet_pcs/
├── rtl/                  # RTL design (I write this by hand)
│   ├── enc_5b6b.v
│   ├── enc_3b4b.v
│   ├── encoder_8b10b.v
│   ├── decoder_8b10b.v
│   ├── comma_align.v     # comma detect + word alignment
│   ├── pcs_sync.v        # PCS synchronization FSM
│   ├── elastic_buffer.v  # clock tolerance compensation
│   ├── pcs_tx.v          # TX datapath top
│   ├── pcs_rx.v          # RX datapath top
│   └── pcs_top.v         # full PCS top-level
├── tb/                   # UVM testbench (Claude Code helps here)
├── sim/                  # QuestaSim .do / compile scripts
├── docs/                 # notes, block diagrams, coverage reports
└── README.md

## Build order (block by block, test each before moving on)
1. 5b/6b sub-encoder   (32-row case: 5 bits + RD -> 6 bits, updates RD)
2. 3b/4b sub-encoder   (8-row case: 3 bits + RD -> 4 bits, updates RD)
3. RD glue logic       (one FF; RD flows in -> 5b/6b -> 3b/4b -> out)
4. Top 8b/10b encoder  (split 8 into 5+3, concat 6+4 -> 10)
5. 8b/10b decoder      (10 -> 8, with code/disparity error flags)
6. Comma detect + word alignment (find /K28.5/ comma, byte-align the stream)
7. PCS synchronization FSM (Clause 36 sync state machine: loss/gain of sync)
8. Elastic buffer      (idle/ordered-set insert/delete for clock tolerance)
9. TX/RX datapath tops, then pcs_top integration
10. K-codes / ordered sets (control symbols) woven in as needed

## Key design facts (already understood — don't re-explain, just implement)
- 8b/10b splits as 5b/6b + 3b/4b; the Dx.y naming IS the split (x=5-bit, y=3-bit).
- Running disparity (RD) = 1 memory bit (0 = RD-, 1 = RD+).
- RD can flip MID-BYTE between the 5b/6b and 3b/4b halves.
- RD is NEVER on the wire. Every costume of a code decodes to the same value,
  so the RX decodes from the 10 bits alone. RX keeps its own RD only for
  error detection, not decoding.
- Balanced codes have one form (RD- == RD+); unbalanced codes have two
  inverted forms.
- Comma alignment: the /K28.5/ comma symbol has a unique bit pattern that
  can't occur across code-group boundaries -> used to find byte boundaries.

## Division of labor
- Claude Code DOES: repo structure, README, QuestaSim .do/compile scripts,
  UVM testbench boilerplate, code review, sim debugging.
- I (the human) WRITE: all core RTL by hand — encoders, decoder, sync FSM,
  elastic buffer, datapath. This is the learning goal; don't auto-generate it.

## CRITICAL habit
Do NOT trust 8b/10b bit patterns from memory — every code-group value must be
verified against the actual Table 36-1 in the spec before it's committed.

## Toolchain
QuestaSim for simulation. Verilog/SystemVerilog RTL. Git. Tcl scripting.