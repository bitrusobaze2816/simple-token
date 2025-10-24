;; clarity-version 1.1

;; ============================================================== 
;; SIMPLE TOKEN CONTRACT 
;; A basic fungible token system with minting and transfer functions 
;; ============================================================== 

;; --------------------------- 
;; CONSTANTS & ERRORS 
;; --------------------------- 
(define-constant ERR-NOT-OWNER (err u100)) 
(define-constant ERR-INSUFFICIENT (err u101)) 
(define-constant ERR-ZERO-AMOUNT (err u102)) 

;; --------------------------- 
;; DATA VARIABLES 
;; --------------------------- 
(define-data-var owner principal tx-sender) 

;; Token metadata 
(define-constant TOKEN-NAME "Simple Token") 
(define-constant TOKEN-SYMBOL "STK") 
(define-constant TOKEN-DECIMALS u6) 

;; Fixed non-ASCII characters in map definition
;; Mapping: user principal -> token balance 
(define-map balances 
  principal 
  uint)

;; --------------------------- 
;; READ-ONLY FUNCTIONS 
;; --------------------------- 

(define-read-only (get-name) 
  (ok TOKEN-NAME)) 

(define-read-only (get-symbol) 
  (ok TOKEN-SYMBOL)) 

(define-read-only (get-decimals) 
  (ok TOKEN-DECIMALS)) 

(define-read-only (get-owner) 
  (ok (var-get owner))) 

;; Fixed match syntax and map-get usage
(define-read-only (balance-of (user principal)) 
  (ok (default-to u0 (map-get? balances user))))

;; --------------------------- 
;; PRIVATE HELPER FUNCTIONS 
;; --------------------------- 

(define-private (only-owner) 
  (is-eq tx-sender (var-get owner))) 

(define-private (update-balance! (user principal) (amount uint)) 
  (map-set balances user amount))

;; --------------------------- 
;; PUBLIC FUNCTIONS 
;; --------------------------- 

;; -------------------------------------------------------------- 
;; mint: 
;; Allows only the owner to mint new tokens to a recipient. 
;; -------------------------------------------------------------- 
;; Fixed error handling and balance retrieval
(define-public (mint (recipient principal) (amount uint)) 
  (if (not (only-owner)) 
      ERR-NOT-OWNER
      (if (<= amount u0) 
          ERR-ZERO-AMOUNT
          (let ((current (default-to u0 (map-get? balances recipient)))
                (new (+ current amount))) 
            (map-set balances recipient new)
            (ok {status: "minted", to: recipient, amount: amount})))))

;; -------------------------------------------------------------- 
;; transfer: 
;; Allows users to transfer tokens to another address. 
;; -------------------------------------------------------------- 
;; Fixed error handling and balance operations
(define-public (transfer (recipient principal) (amount uint)) 
  (if (<= amount u0) 
      ERR-ZERO-AMOUNT
      (let ((sender-balance (default-to u0 (map-get? balances tx-sender)))) 
        (if (< sender-balance amount) 
            ERR-INSUFFICIENT
            (let ((recipient-balance (default-to u0 (map-get? balances recipient)))
                  (new-sender (- sender-balance amount)) 
                  (new-recipient (+ recipient-balance amount))) 
              (map-set balances tx-sender new-sender)
              (map-set balances recipient new-recipient)
              (ok {status: "transfer-success", to: recipient, amount: amount}))))))

;; -------------------------------------------------------------- 
;; burn: 
;; Allows only the owner to burn tokens from any user account. 
;; -------------------------------------------------------------- 
;; Fixed error handling and balance operations
(define-public (burn (target principal) (amount uint)) 
  (if (not (only-owner)) 
      ERR-NOT-OWNER
      (let ((balance (default-to u0 (map-get? balances target)))) 
        (if (< balance amount) 
            ERR-INSUFFICIENT
            (let ((new-balance (- balance amount))) 
              (map-set balances target new-balance)
              (ok {status: "burned", from: target, amount: amount}))))))
