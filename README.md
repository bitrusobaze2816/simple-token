Simple Token Smart Contract

Overview
The **Simple Token Smart Contract** is a lightweight fungible token implementation written in **Clarity** for the **Stacks blockchain**.  
It provides the foundational logic for creating, minting, transferring, and tracking balances of a basic token.

This contract can serve as the foundation for community rewards, governance systems, or decentralized marketplace transactions.

---

Features
- **Mint Tokens:** Create new tokens and assign them to specific addresses.  
- **Transfer Tokens:** Send tokens between users.  
- **Track Balances:** View the balance of any account.  
- **Total Supply:** Retrieve the total number of tokens minted so far.  

---

Contract Functions

| Function | Type | Description |
|-----------|------|-------------|
| `mint(recipient, amount)` | Public | Mints new tokens and assigns them to the specified recipient. Restricted to contract deployer. |
| `transfer(recipient, amount)` | Public | Transfers a specified amount of tokens from the sender to the recipient. |
| `get-balance(owner)` | Read-Only | Returns the token balance of the specified address. |
| `get-total-supply()` | Read-Only | Returns the total number of tokens currently in circulation. |

---

Data Structures

```clarity
(define-map balances
  { owner: principal }
  { balance: uint })

(define-data-var total-supply uint u0)
