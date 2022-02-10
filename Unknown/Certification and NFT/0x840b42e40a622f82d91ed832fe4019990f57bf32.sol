['pragma solidity ^0.4.11;\n', '\n', '//\n', '// ==== DISCLAIMER ====\n', '//\n', '// ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.\n', '// ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.\n', '// IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.\n', '// YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.\n', "// DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.\n", '//\n', '// THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY\n', '// AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,\n', '// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,\n', '// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\n', '// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n', '// ====\n', '//\n', '//\n', '// ==== PARANOIA NOTICE ====\n', '// A careful reader will find some additional checks and excessive code, consuming some extra gas. This is intentional.\n', '// Even though the contract should work without these parts, they make the code more secure in production and for future refactoring.\n', '// Also, they show more clearly what we have considered and addressed during development.\n', '// Discussion is welcome!\n', '// ====\n', '//\n', '\n', '/// @author ethernian\n', '/// @notice report bugs to: bugs@ethernian.com\n', '/// @title Presaler Voting Contract\n', '\n', 'interface TokenStorage {\n', '    function balances(address account) public returns(uint balance);\n', '}\n', '\n', 'contract PresalerVoting {\n', '\n', '    string public constant VERSION = "0.0.2";\n', '\n', '    /* ====== configuration START ====== */\n', '\n', '    uint public VOTING_START_BLOCKNR  = 0;\n', '    uint public VOTING_END_TIME       = 0;\n', '\n', '    /* ====== configuration END ====== */\n', '\n', '    TokenStorage PRESALE_CONTRACT = TokenStorage(0x4Fd997Ed7c10DbD04e95d3730cd77D79513076F2);\n', '\n', '    string[5] private stateNames = ["BEFORE_START",  "VOTING_RUNNING", "CLOSED" ];\n', '    enum State { BEFORE_START,  VOTING_RUNNING, CLOSED }\n', '\n', '    mapping (address => uint) public rawVotes;\n', '\n', '    uint private constant MAX_AMOUNT_EQU_0_PERCENT   = 1 finney;\n', '    uint private constant MIN_AMOUNT_EQU_100_PERCENT = 1 ether ;\n', '\n', '    address owner;\n', '\n', '    //constructor\n', '    function PresalerVoting () {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    //accept (and send back) voting payments here\n', '    function ()\n', '    onlyPresaler\n', '    onlyState(State.VOTING_RUNNING)\n', '    payable {\n', '        if (msg.value > 1 ether || !msg.sender.send(msg.value)) throw;\n', '        rawVotes[msg.sender] = msg.value;\n', '    }\n', '\n', '    /// @notice start voting at `startBlockNr` for `durationHrs`.\n', '    /// Restricted for owner only.\n', '    /// @param startBlockNr block number to start voting; starts immediatly if less than current block number.\n', '    /// @param durationHrs voting duration (from now!); at least 1 hour.\n', '    function startVoting(uint startBlockNr, uint durationHrs) onlyOwner {\n', '        VOTING_START_BLOCKNR = max(block.number, startBlockNr);\n', '        VOTING_END_TIME = now + max(durationHrs,1) * 1 hours;\n', '    }\n', '\n', '    function setOwner(address newOwner) onlyOwner {owner = newOwner;}\n', '\n', '    /// @notice returns current voting result for given address in percent.\n', '    /// @param voter balance holder address.\n', '    function votedPerCent(address voter) constant external returns (uint) {\n', '        var rawVote = rawVotes[voter];\n', '        if (rawVote<=MAX_AMOUNT_EQU_0_PERCENT) return 0;\n', '        else if (rawVote>=MIN_AMOUNT_EQU_100_PERCENT) return 100;\n', '        else return rawVote * 100 / 1 ether;\n', '    }\n', '\n', '    /// @notice return voting remaining time (hours, minutes).\n', '    function votingEndsInHHMM() constant returns (uint16, uint16) {\n', '        var tsec = VOTING_END_TIME - now;\n', '        return VOTING_END_TIME==0 ? (0,0) : (uint16(tsec / 1 hours), uint16(tsec % 1 hours / 1 minutes));\n', '    }\n', '\n', '    function currentState() internal constant returns (State) {\n', '        if (VOTING_START_BLOCKNR == 0 || block.number < VOTING_START_BLOCKNR) {\n', '            return State.BEFORE_START;\n', '        } else if (now <= VOTING_END_TIME) {\n', '            return State.VOTING_RUNNING;\n', '        } else {\n', '            return State.CLOSED;\n', '        }\n', '    }\n', '\n', '    /// @notice returns current state of the voting.\n', '    function state() public constant returns(string) {\n', '        return stateNames[uint(currentState())];\n', '    }\n', '\n', '    function max(uint a, uint b) internal constant returns (uint maxValue) { return a>b ? a : b; }\n', '\n', '    modifier onlyPresaler() {\n', '        if (PRESALE_CONTRACT.balances(msg.sender) == 0) throw;\n', '        _;\n', '    }\n', '\n', '    modifier onlyState(State state) {\n', '        if (currentState()!=state) throw;\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender!=owner) throw;\n', '        _;\n', '    }\n', '\n', '}//contract']