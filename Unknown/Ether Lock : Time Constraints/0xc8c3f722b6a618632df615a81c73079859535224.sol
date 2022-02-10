['pragma solidity ^0.4.11;\n', '\n', 'contract BLOCKCHAIN_DEPOSIT_BETA_1M {\n', '\t\n', '\t/* CONTRACT SETUP */\n', '\n', '\tuint constant PAYOUT_INTERVAL = 1 minutes;\n', '\n', "\t/* NB: Solidity doesn't support fixed or floats yet, so we use promille instead of percent */\t\n", '\tuint constant DEPONENT_INTEREST= 10;\n', '\tuint constant INTEREST_DENOMINATOR = 1000;\n', '\n', '\t/* DATA TYPES */\n', '\n', '\t/* the payout happend */\n', '\tevent Payout(uint paidPeriods, uint depositors);\n', '\t\n', '\t/* Depositor struct: describes a single Depositor */\n', '\tstruct Depositor\n', '\t{\t\n', '\t\taddress etherAddress;\n', '\t\tuint deposit;\n', '\t\tuint depositTime;\n', '\t}\n', '\n', '\t/* FUNCTION MODIFIERS */\n', '\tmodifier founderOnly { if (msg.sender == contract_founder) _; }\n', '\n', '\t/* VARIABLE DECLARATIONS */\n', '\n', '\t/* the contract founder*/\n', '\taddress private contract_founder;\n', '\n', '\t/* the time of last payout */\n', '\tuint private contract_latestPayoutTime;\n', '\n', '\t/* Array of depositors */\n', '\tDepositor[] private contract_depositors;\n', '\n', '\t\n', '\t/* PUBLIC FUNCTIONS */\n', '\n', '\t/* contract constructor */\n', '\tfunction BLOCKCHAIN_DEPOSIT_BETA_1M() \n', '\t{\n', '\t\tcontract_founder = msg.sender;\n', '\t\tcontract_latestPayoutTime = now;\t\t\n', '\t}\n', '\n', '\t/* fallback function: called when the contract received plain ether */\n', '\tfunction() payable\n', '\t{\n', '\t\taddDepositor();\n', '\t}\n', '\n', '\tfunction Make_Deposit() payable\n', '\t{\n', '\t\taddDepositor();\t\n', '\t}\n', '\n', '\tfunction status() constant returns (uint deposit_fond_sum, uint depositorsCount, uint unpaidTime, uint unpaidIntervals)\n', '\t{\n', '\t\tdeposit_fond_sum = this.balance;\n', '\t\tdepositorsCount = contract_depositors.length;\n', '\t\tunpaidTime = now - contract_latestPayoutTime;\n', '\t\tunpaidIntervals = unpaidTime / PAYOUT_INTERVAL;\n', '\t}\n', '\n', '\n', "\t/* checks if it's time to make payouts. if so, send the ether */\n", '\tfunction performPayouts()\n', '\t{\n', '\t\tuint paidPeriods = 0;\n', '\t\tuint depositorsDepositPayout;\n', '\n', '\t\twhile(contract_latestPayoutTime + PAYOUT_INTERVAL < now)\n', '\t\t{\t\t\t\t\t\t\n', '\t\t\tuint idx;\n', '\n', '\t\t\t/* pay the depositors  */\n', '\t\t\t/* we use reverse iteration here */\n', '\t\t\tfor (idx = contract_depositors.length; idx-- > 0; )\n', '\t\t\t{\n', '\t\t\t\tif(contract_depositors[idx].depositTime > contract_latestPayoutTime + PAYOUT_INTERVAL)\n', '\t\t\t\t\tcontinue;\n', '\t\t\t\tuint payout = (contract_depositors[idx].deposit * DEPONENT_INTEREST) / INTEREST_DENOMINATOR;\n', '\t\t\t\tif(!contract_depositors[idx].etherAddress.send(payout))\n', '\t\t\t\t\tthrow;\n', '\t\t\t\tdepositorsDepositPayout += payout;\t\n', '\t\t\t}\n', '\t\t\t\n', '\t\t\t/* save the latest paid time */\n', '\t\t\tcontract_latestPayoutTime += PAYOUT_INTERVAL;\n', '\t\t\tpaidPeriods++;\n', '\t\t}\n', '\t\t\t\n', '\t\t/* emit the Payout event */\n', '\t\tPayout(paidPeriods, depositorsDepositPayout);\n', '\t}\n', '\n', '\t/* PRIVATE FUNCTIONS */\n', '\tfunction addDepositor() private \n', '\t{\n', '\t\tcontract_depositors.push(Depositor(msg.sender, msg.value, now));\n', '\t}\n', '\n', '\t/* ADMIN FUNCTIONS */\n', '\n', '\t/* pass the admin rights to another address */\n', '\tfunction changeFounderAddress(address newFounder) founderOnly \n', '\t{\n', '\t\tcontract_founder = newFounder;\n', '\t}\n', '}']