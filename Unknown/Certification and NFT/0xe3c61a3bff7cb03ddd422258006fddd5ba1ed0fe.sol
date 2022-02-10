['pragma solidity ^0.4.6;\n', '\n', '// Presale Smart Contract\n', '//\n', '// **** START:  WORK IN PROGRESS DISCLAIMER ****\n', '// This is a work in progress and not intended for reuse.\n', "// So don't reuse unless you know exactly what are you doing! \n", '// **** END:  WORK IN PROGRESS DISCLAIMER ****\n', '//\n', '// **** START:  PARANOIA DISCLAIMER ****\n', '// A careful reader will find here some unnecessary checks and excessive code consuming some extra valuable gas. It is intentionally. \n', '// Even contract will works without these parts, they make the code more secure in production as well for future refactoring.\n', '// Additionally it shows more clearly what we have took care of.\n', '// You are welcome to discuss that places.\n', '// **** END OF: PARANOIA DISCLAIMER *****\n', '//\n', '//\n', '// @author ethernian\n', '//\n', '\n', '\n', 'contract Presale {\n', '\n', '    string public constant VERSION = "0.1.3-beta";\n', '\n', '\t/* ====== configuration START ====== */\n', '\n', '\tuint public constant PRESALE_START  = 3116646; //\tapprox. \t03.02.2017 18:50\n', '\tuint public constant PRESALE_END    = 3116686; //\tapprox. \t03.02.2017 19:00\n', '\tuint public constant WITHDRAWAL_END = 3116726; //\tapprox. \t03.02.2017 19:10\n', '\n', '\n', '\taddress public constant OWNER = 0xA4769870EB607A4fDaBFfbcC3AD066c8213bD87D;\n', '\t\n', '    uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 1;\n', '    uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 5;\n', '    uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;\n', '\n', '    /* ====== configuration END ====== */\n', '\t\n', '    string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];\n', '    enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }\n', '\n', '    uint public total_received_amount;\n', '\tmapping (address => uint) public balances;\n', '\t\n', '    uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;\n', '    uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;\n', '    uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;\n', '\t\n', '\n', '    //constructor\n', '    function Presale () validSetupOnly() { }\n', '\n', '    //\n', '    // ======= interface methods =======\n', '    //\n', '\n', '    //accept payments here\n', '    function ()\n', '    payable\n', '    noReentrancy\n', '    {\n', '        State state = currentState();\n', '        if (state == State.PRESALE_RUNNING) {\n', '            receiveFunds();\n', '        } else if (state == State.REFUND_RUNNING) {\n', '            // any entring call in Refund Phase will cause full refund\n', '            sendRefund();\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function refund() external\n', '    inState(State.REFUND_RUNNING)\n', '    noReentrancy\n', '    {\n', '        sendRefund();\n', '    }\n', '\n', '\n', '    function withdrawFunds() external\n', '    inState(State.WITHDRAWAL_RUNNING)\n', '    onlyOwner\n', '    noReentrancy\n', '    {\n', '        // transfer funds to owner if any\n', '        if (this.balance > 0) {\n', '            if (!OWNER.send(this.balance)) throw;\n', '        }\n', '    }\n', '\n', '\n', '    //displays current contract state in human readable form\n', '    function state()  external constant\n', '    returns (string)\n', '    {\n', '        return stateNames[ uint(currentState()) ];\n', '    }\n', '\n', '\n', '    //\n', '    // ======= implementation methods =======\n', '    //\n', '\n', '    function sendRefund() private tokenHoldersOnly {\n', '        // load balance to refund plus amount currently sent\n', '        var amount_to_refund = balances[msg.sender] + msg.value;\n', '        // reset balance\n', '        balances[msg.sender] = 0;\n', '        // send refund back to sender\n', '        if (!msg.sender.send(amount_to_refund)) throw;\n', '    }\n', '\n', '\n', '    function receiveFunds() private notTooSmallAmountOnly {\n', '      // no overflow is possible here: nobody have soo much money to spend.\n', '      if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {\n', '          // accept amount only and return change\n', '          var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;\n', '          if (!msg.sender.send(change_to_return)) throw;\n', '\n', '          var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;\n', '          balances[msg.sender] += acceptable_remainder;\n', '          total_received_amount += acceptable_remainder;\n', '      } else {\n', '          // accept full amount\n', '          balances[msg.sender] += msg.value;\n', '          total_received_amount += msg.value;\n', '      }\n', '    }\n', '\n', '\n', '    function currentState() private constant returns (State) {\n', '        if (block.number < PRESALE_START) {\n', '            return State.BEFORE_START;\n', '        } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {\n', '            return State.PRESALE_RUNNING;\n', '        } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {\n', '            return State.WITHDRAWAL_RUNNING;\n', '        } else if (this.balance > 0){\n', '            return State.REFUND_RUNNING;\n', '        } else {\n', '            return State.CLOSED;\t\t\n', '\t\t} \n', '    }\n', '\n', '    //\n', '    // ============ modifiers ============\n', '    //\n', '\n', "    //fails if state dosn't match\n", '    modifier inState(State state) {\n', '        if (state != currentState()) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    //fails if something in setup is looking weird\n', '    modifier validSetupOnly() {\n', '        if ( OWNER == 0x0 \n', '            || PRESALE_START == 0 \n', '            || PRESALE_END == 0 \n', '            || WITHDRAWAL_END ==0\n', '            || PRESALE_START <= block.number\n', '            || PRESALE_START >= PRESALE_END\n', '            || PRESALE_END   >= WITHDRAWAL_END\n', '            || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )\n', '\t\t\t\tthrow;\n', '        _;\n', '    }\n', '\n', '\n', '    //accepts calls from owner only\n', '    modifier onlyOwner(){\n', '    \tif (msg.sender != OWNER)  throw;\n', '    \t_;\n', '    }\n', '\n', '\n', '    //accepts calls from token holders only\n', '    modifier tokenHoldersOnly(){\n', '        if (balances[msg.sender] == 0) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    // don`t accept transactions with value less than allowed minimum\n', '    modifier notTooSmallAmountOnly(){\t\n', '        if (msg.value < MIN_ACCEPTED_AMOUNT) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    //prevents reentrancy attacs\n', '    bool private locked = false;\n', '    modifier noReentrancy() {\n', '        if (locked) throw;\n', '        locked = true;\n', '        _;\n', '        locked = false;\n', '    }\n', '}//contract']