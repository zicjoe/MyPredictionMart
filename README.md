# MyPredictionMart
# Canton Predict

Canton Predict is a privacy-aware prediction market prototype built on the Canton ledger using DAML for smart contracts and Flutter for the web frontend. It shows how real-world events can be modeled as on-ledger markets while keeping resolution logic auditable and outcomes tied to verifiable information.

## 🎯 Idea

Most prediction markets run on fully public blockchains where every bet and position is visible to everyone. That makes them hard to use in institutional, regulated, or commercially sensitive contexts.

Canton Predict uses Canton’s permissioned, data-partitioned ledger model and DAML templates to demonstrate how prediction markets can be:

- **Private** – only the parties involved see their bets and contracts.
- **Auditable** – all actions are recorded on-ledger with clear resolution logic.
- **Oracle-driven** – outcomes are resolved by a designated oracle based on real-world data.

## 🧱 Core Components

### 1. DAML / Canton (Backend)

Located in the `cantonPredict` folder.

Key elements:

- `Outcome` and `MarketStatus` data types  
- `Market` template  
  - fields: `creator`, `oracle`, `question`, `yesLabel`, `noLabel`, `dataSource`, `status`, `resolutionEvidence`
  - `Resolve` choice callable only by the `oracle`
- `Bet` template  
  - linked to a `Market`
  - `Claim` choice to model payout logic after resolution
- `setup` and `setupFromJson` scripts to create example markets and bets

### Real-world data and verifiable outcomes

Each market includes:

- `oracle : Party` – the only party allowed to resolve the market.
- `dataSource : Text` – description of the external system used as the source of truth (e.g. official price feed, sports API, election result feed).
- `resolutionEvidence : Optional Text` – evidence string the oracle stores when resolving (e.g. “BTC price 102,000 USD from Coinbase API at 2030-01-01T00:00Z”).

In a full deployment, an off-ledger oracle service would:

1. Query the external API or data provider named in `dataSource`.
2. Decide the final `Outcome`.
3. Call the Canton JSON API / gRPC.
4. Exercise the `Resolve` choice, passing both the outcome and the evidence string.

This design ensures that every resolved outcome is tied to verifiable information and that the resolution process is enforced and auditable on-ledger.

### 2. Flutter Web (Frontend)

Located in the `canton_predict_web` folder.

The Flutter app shows:

- A list of prediction markets (demo data).
- A market detail page with:
  - question
  - YES/NO options
  - stake input
  - “Submit bet” button

For this prototype, the bet submission uses a **mock service** so the UI always responds quickly and reliably during demo. The same flow can later be wired to the Canton JSON API to send real commands to the ledger.

## 🏗 Architecture (High Level)

- Flutter Web UI  
- (Future) Canton JSON API for sending commands / queries  
- Canton sandbox ledger  
- DAML smart contracts for markets, bets, and resolution

## ▶️ How to Run (Local)

### Backend

```bash
cd cantonPredict
daml build
daml start
```

This starts:
-Canton sandbox
-JSON API (depending on SDK version / config)

### Frontend

```bash
cd canton_predict_web
flutter pub get
flutter run -d chrome

```
## 🧪 Judge Testing Notes

• The demo runs entirely locally using DAML Sandbox and Flutter Web.  
• No external APIs are required.  
• The "Submit Bet" action uses a local mock service for consistency.  
• Market creation and resolution logic is fully implemented in DAML.  
• Judges may browse the Main.daml file to view market, bet, and oracle logic.


## 🏗 Architecture

+-------------------------------------------------------------+
|                         User (Browser)                      |
|  - Views markets                                            |
|  - Places bets                                              |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                    Flutter Web Frontend                     |
|  - UI for markets, outcomes, bet form                       |
|  - Calls mock service (demo)                                |
|  - Future: Calls Canton JSON API                            |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                  (Future) Canton JSON API                   |
|  - Accepts commands (create/exercise)                       |
|  - Returns ledger data                                      |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                     Canton Sandbox Ledger                   |
|  - Executes DAML smart contracts                            |
|  - Enforces privacy & data-partitioning                     |
+------------------------------+------------------------------+
                               |
                               v
+-------------------------------------------------------------+
|                         DAML Contracts                      |
|                                                             |
|  Market                                                     |
|   - Fields: creator, oracle, question, labels               |
|   - Fields: dataSource, status, evidence                    |
|   - Choice: Resolve (oracle-only)                           |
|                                                             |
|  Bet                                                        |
|   - Fields: outcome, amount, claimed                        |
|   - Choice: Claim (payout logic)                            |
+-------------------------------------------------------------+
       
### Future Work
-Wire the Flutter app directly to the Canton JSON API for live bets.
- Add automated settlement and real token payouts.
- Integrate a real oracle service that queries external APIs.
- Extend markets to support more complex outcomes and odds.
- Add user identity / party onboarding flows.




### Context

Canton Predict was built as an ideathon / hackathon prototype to explore how Canton and DAML can be used to support private, verifiable prediction markets.