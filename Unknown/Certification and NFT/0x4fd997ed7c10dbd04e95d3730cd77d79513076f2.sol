['pragma solidity ^0.4.6;\n', '\n', '//\n', '// ==== DISCLAIMER ====\n', '//\n', '// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.\n', '// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN. \n', '// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR. \n', '// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS. \n', "// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.\n", '//\n', '// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY \n', '// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, \n', '// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, \n', '// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, \n', '// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '// ====\n', '//\n', '//\n', '// ==== PARANOIA NOTICE ==== \n', '// A careful reader will find some additional checks and excessive code, consuming some extra gas. This is intentional. \n', '// Even though the contract should work without these parts, they make the code more secure in production and for future refactoring.\n', '// Also, they show more clearly what we have considered and addressed during development.\n', '// Discussion is welcome!\n', '// ====\n', '//\n', '\n', '/// @author ethernian\n', '/// @notice report bugs to: bugs@ethernian.com\n', '/// @title Presale Contract\n', '\n', 'contract Presale {\n', '\n', '    string public constant VERSION = "0.1.4";\n', '\n', '    /* ====== configuration START ====== */\n', '    uint public constant PRESALE_START  = 3172723; /* approx. 12.02.2017 23:50 */\n', '    uint public constant PRESALE_END    = 3302366; /* approx. 06.03.2017 00:00 */\n', '    uint public constant WITHDRAWAL_END = 3678823; /* approx. 06.05.2017 00:00 */\n', '\n', '    address public constant OWNER = 0xE76fE52a251C8F3a5dcD657E47A6C8D16Fdf4bFA;\n', '\n', '    uint public constant MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH = 4000;\n', '    uint public constant MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH = 12000;\n', '    uint public constant MIN_ACCEPTED_AMOUNT_FINNEY = 1;\n', '\n', '    /* ====== configuration END ====== */\n', '\n', '    string[5] private stateNames = ["BEFORE_START",  "PRESALE_RUNNING", "WITHDRAWAL_RUNNING", "REFUND_RUNNING", "CLOSED" ];\n', '    enum State { BEFORE_START,  PRESALE_RUNNING, WITHDRAWAL_RUNNING, REFUND_RUNNING, CLOSED }\n', '\n', '    uint public total_received_amount;\n', '    mapping (address => uint) public balances;\n', '\n', '    uint private constant MIN_TOTAL_AMOUNT_TO_RECEIVE = MIN_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;\n', '    uint private constant MAX_TOTAL_AMOUNT_TO_RECEIVE = MAX_TOTAL_AMOUNT_TO_RECEIVE_ETH * 1 ether;\n', '    uint private constant MIN_ACCEPTED_AMOUNT = MIN_ACCEPTED_AMOUNT_FINNEY * 1 finney;\n', '    bool public isAborted = false;\n', '\n', '\n', '    //constructor\n', '    function Presale () validSetupOnly() { }\n', '\n', '    //\n', '    // ======= interface methods =======\n', '    //\n', '\n', '    //accept payments here\n', '    function ()\n', '    payable\n', '    noReentrancy\n', '    {\n', '        State state = currentState();\n', '        if (state == State.PRESALE_RUNNING) {\n', '            receiveFunds();\n', '        } else if (state == State.REFUND_RUNNING) {\n', '            // any entring call in Refund Phase will cause full refund\n', '            sendRefund();\n', '        } else {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function refund() external\n', '    inState(State.REFUND_RUNNING)\n', '    noReentrancy\n', '    {\n', '        sendRefund();\n', '    }\n', '\n', '\n', '    function withdrawFunds() external\n', '    inState(State.WITHDRAWAL_RUNNING)\n', '    onlyOwner\n', '    noReentrancy\n', '    {\n', '        // transfer funds to owner if any\n', '        if (!OWNER.send(this.balance)) throw;\n', '    }\n', '\n', '    function abort() external\n', '    inStateBefore(State.REFUND_RUNNING)\n', '    onlyOwner\n', '    {\n', '        isAborted = true;\n', '    }\n', '\n', '    //displays current contract state in human readable form\n', '    function state()  external constant\n', '    returns (string)\n', '    {\n', '        return stateNames[ uint(currentState()) ];\n', '    }\n', '\n', '\n', '    //\n', '    // ======= implementation methods =======\n', '    //\n', '\n', '    function sendRefund() private tokenHoldersOnly {\n', '        // load balance to refund plus amount currently sent\n', '        var amount_to_refund = balances[msg.sender] + msg.value;\n', '        // reset balance\n', '        balances[msg.sender] = 0;\n', '        // send refund back to sender\n', '        if (!msg.sender.send(amount_to_refund)) throw;\n', '    }\n', '\n', '\n', '    function receiveFunds() private notTooSmallAmountOnly {\n', '      // no overflow is possible here: nobody have soo much money to spend.\n', '      if (total_received_amount + msg.value > MAX_TOTAL_AMOUNT_TO_RECEIVE) {\n', '          // accept amount only and return change\n', '          var change_to_return = total_received_amount + msg.value - MAX_TOTAL_AMOUNT_TO_RECEIVE;\n', '          if (!msg.sender.send(change_to_return)) throw;\n', '\n', '          var acceptable_remainder = MAX_TOTAL_AMOUNT_TO_RECEIVE - total_received_amount;\n', '          balances[msg.sender] += acceptable_remainder;\n', '          total_received_amount += acceptable_remainder;\n', '      } else {\n', '          // accept full amount\n', '          balances[msg.sender] += msg.value;\n', '          total_received_amount += msg.value;\n', '      }\n', '    }\n', '\n', '\n', '    function currentState() private constant returns (State) {\n', '        if (isAborted) {\n', '            return this.balance > 0 \n', '                   ? State.REFUND_RUNNING \n', '                   : State.CLOSED;\n', '        } else if (block.number < PRESALE_START) {\n', '            return State.BEFORE_START;\n', '        } else if (block.number <= PRESALE_END && total_received_amount < MAX_TOTAL_AMOUNT_TO_RECEIVE) {\n', '            return State.PRESALE_RUNNING;\n', '        } else if (this.balance == 0) {\n', '            return State.CLOSED;\n', '        } else if (block.number <= WITHDRAWAL_END && total_received_amount >= MIN_TOTAL_AMOUNT_TO_RECEIVE) {\n', '            return State.WITHDRAWAL_RUNNING;\n', '        } else {\n', '            return State.REFUND_RUNNING;\n', '        } \n', '    }\n', '\n', '    //\n', '    // ============ modifiers ============\n', '    //\n', '\n', "    //fails if state dosn't match\n", '    modifier inState(State state) {\n', '        if (state != currentState()) throw;\n', '        _;\n', '    }\n', '\n', '    //fails if the current state is not before than the given one.\n', '    modifier inStateBefore(State state) {\n', '        if (currentState() >= state) throw;\n', '        _;\n', '    }\n', '\n', '    //fails if something in setup is looking weird\n', '    modifier validSetupOnly() {\n', '        if ( OWNER == 0x0 \n', '            || PRESALE_START == 0 \n', '            || PRESALE_END == 0 \n', '            || WITHDRAWAL_END ==0\n', '            || PRESALE_START <= block.number\n', '            || PRESALE_START >= PRESALE_END\n', '            || PRESALE_END   >= WITHDRAWAL_END\n', '            || MIN_TOTAL_AMOUNT_TO_RECEIVE > MAX_TOTAL_AMOUNT_TO_RECEIVE )\n', '                throw;\n', '        _;\n', '    }\n', '\n', '\n', '    //accepts calls from owner only\n', '    modifier onlyOwner(){\n', '        if (msg.sender != OWNER)  throw;\n', '        _;\n', '    }\n', '\n', '\n', '    //accepts calls from token holders only\n', '    modifier tokenHoldersOnly(){\n', '        if (balances[msg.sender] == 0) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    // don`t accept transactions with value less than allowed minimum\n', '    modifier notTooSmallAmountOnly(){\t\n', '        if (msg.value < MIN_ACCEPTED_AMOUNT) throw;\n', '        _;\n', '    }\n', '\n', '\n', '    //prevents reentrancy attacs\n', '    bool private locked = false;\n', '    modifier noReentrancy() {\n', '        if (locked) throw;\n', '        locked = true;\n', '        _;\n', '        locked = false;\n', '    }\n', '}//contract']