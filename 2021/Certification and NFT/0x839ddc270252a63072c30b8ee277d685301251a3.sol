['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-05\n', '*/\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// \n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    \n', '    \n', '    \n', '    \n', '    function calculateBurnFee(uint256 _amount) external view returns (uint256);\n', '    \n', '    \n', '    function mint(address account, uint256 amount) external;\n', '    \n', '    \n', '    function burn(address account, uint256 amount) external;\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', 'interface Uniswapv2Pair {\n', '\n', '     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', ' \n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title MoonDayPlus DAO\n', ' * @dev Made by SoliditySam and Grass, fuck bad mouths saying I didnt made OG tendies\n', ' *\n', ' * \n', '          ,\n', '       _/ \\_     *\n', '      <     >\n', "*      /.'.\\                    *\n", '             *    ,-----.,_           ,\n', "               .'`         '.       _/ \\_\n", '    ,         /              `\\    <     >\n', "  _/ \\_      |  ,.---.         \\    /.'.\\\n", " <     >     \\.'    _,'.---.    ;   `   `\n", "  /.'.\\           .'  (-(0)-)   ;\n", "  `   `          /     '---'    |  *\n", '                /    )          |             *\n', '     *         |  .-;           ;        ,\n', "               \\_/ |___,'      ;       _/ \\_ \n", '          ,  |`---.MOON|_       /     <     >\n', " *      _/ \\_ \\         `     /        /.'.\\\n", "       <     > '.          _,'         `   `\n", " MD+    /.'.\\    `'------'`     *   \n", '        `   `\n', ' \n', ' \n', ' */\n', '\n', '// The DAO contract itself\n', 'contract MoondayPlusDAO {\n', '    \n', '        using SafeMath for uint256;\n', '\n', '    // The minimum debate period that a generic proposal can have\n', '       uint256 public minProposalDebatePeriod = 2 weeks;\n', '      \n', '       \n', '       // Period after which a proposal is closed\n', '       // (used in the case `executeProposal` fails because it throws)\n', '       uint256 public executeProposalPeriod = 10 days;\n', '       \n', '       \n', '       \n', '     \n', '\n', '\n', '       IERC20 public MoondayToken;\n', '\n', '       Uniswapv2Pair public MoondayTokenPair;\n', '\n', '\n', "       // Proposals to spend the DAO's ether\n", '       Proposal[] public proposals;\n', '      \n', '       // The unix time of the last time quorum was reached on a proposal\n', '       uint public lastTimeMinQuorumMet;\n', '\n', '      \n', '       // Map of addresses and proposal voted on by this address\n', '       mapping (address => uint[]) public votingRegister;\n', '\n', '\n', '\n', '        uint256 public V = 2 ether;\n', '        //median fixed\n', '        \n', '        uint256 public W = 40;\n', '        //40% of holders approx\n', '        \n', '        uint256 public B = 5;\n', '        //0.005% vote\n', '        \n', '        uint256 public C = 10;\n', '        //10* 0.005% vote\n', '     \n', '\n', '  \n', '       struct Proposal {\n', '           // The address where the `amount` will go to if the proposal is accepted\n', '           address recipient;\n', '           // A plain text description of the proposal\n', '           string description;\n', '           // A unix timestamp, denoting the end of the voting period\n', '           uint votingDeadline;\n', "           // True if the proposal's votes have yet to be counted, otherwise False\n", '           bool open;\n', '           // True if quorum has been reached, the votes have been counted, and\n', '           // the majority said yes\n', '           bool proposalPassed;\n', '           // A hash to check validity of a proposal\n', '           bytes32 proposalHash;\n', '           // Number of Tokens in favor of the proposal\n', '           uint yea;\n', '           // Number of Tokens opposed to the proposal\n', '           uint nay;\n', '           // Simple mapping to check if a shareholder has voted for it\n', '           mapping (address => bool) votedYes;\n', '           // Simple mapping to check if a shareholder has voted against it\n', '           mapping (address => bool) votedNo;\n', '           // Address of the shareholder who created the proposal\n', '           address creator;\n', '       }\n', '\n', '\n', '\n', '       event ProposalAdded(\n', '            uint indexed proposalID,\n', '            address recipient,\n', '            string description\n', '           );\n', '        event Voted(uint indexed proposalID, bool position, address indexed voter);\n', '        event ProposalTallied(uint indexed proposalID, bool result, uint quorum);\n', '       \n', '\n', '    // Modifier that allows only shareholders to vote and create new proposals\n', '    modifier onlyTokenholders {\n', '        if (MoondayToken.balanceOf(msg.sender) == 0) revert();\n', '            _;\n', '    }\n', '\n', '    constructor  (\n', '        \n', '        IERC20 _moontoken,\n', '        Uniswapv2Pair _MoondayTokenPair\n', '    ) public  {\n', '\n', '        MoondayToken = _moontoken;\n', '\n', '        MoondayTokenPair = _MoondayTokenPair;\n', '\n', '       \n', '        lastTimeMinQuorumMet = block.timestamp;\n', '        \n', '        proposals.push(); // avoids a proposal with ID 0 because it is used\n', '\n', '        \n', '    }\n', '\n', '\n', '    receive() payable external {\n', '       //we should get ether there but I doubt\n', '       revert();\n', '    }\n', '\n', '    function newProposal(\n', '        address _recipient,\n', '        string calldata _description,\n', '        bytes calldata _transactionData,\n', '        uint64 _debatingPeriod\n', '    ) onlyTokenholders payable external returns (uint _proposalID) {\n', '\n', '        if (_debatingPeriod < minProposalDebatePeriod\n', '            || _debatingPeriod > 8 weeks\n', '            || msg.sender == address(this) //to prevent a 51% attacker to convert the ether into deposit\n', '            )\n', '                revert("error in debating periods");\n', '\n', '        uint256 received = determineAm().mul(C);\n', '\n', '\t\t\n', '\t    \n', '\t    MoondayToken.burn(msg.sender, received);\n', '\t    \n', '      \n', '       \n', '        \n', '       \n', '        Proposal memory p;\n', '        p.recipient = _recipient;\n', '        p.description = _description;\n', '        p.proposalHash = keccak256(abi.encodePacked(_recipient, _transactionData));\n', '        p.votingDeadline = block.timestamp.add( _debatingPeriod );\n', '        p.open = true;\n', "        //p.proposalPassed = False; // that's default\n", '        p.creator = msg.sender;\n', '        proposals.push(p);\n', '        _proposalID = proposals.length;\n', '       \n', '\n', '        emit ProposalAdded(\n', '            _proposalID,\n', '            _recipient,\n', '            _description\n', '        );\n', '    }\n', '\n', '    function checkProposalCode(\n', '        uint _proposalID,\n', '        address _recipient,\n', '        bytes calldata _transactionData\n', '    ) view external returns (bool _codeChecksOut) {\n', '        Proposal memory p = proposals[_proposalID];\n', '        return p.proposalHash == keccak256(abi.encodePacked(_recipient, _transactionData));\n', '    }\n', '\n', '    function vote(uint _proposalID, bool _supportsProposal) external {\n', '        \n', '        \n', '        //burn md+\n', '        \n', '        uint256 received = determineAm();\n', '\n', '\t\t\n', '\t    \n', '\t    MoondayToken.burn(msg.sender, received);\n', '\t    \n', '\t    \n', '\n', '        Proposal storage p = proposals[_proposalID];\n', '\n', '        if (block.timestamp >= p.votingDeadline) {\n', '            revert();\n', '        }\n', '\n', '        if (p.votedYes[msg.sender]) {\n', '            revert();\n', '        }\n', '\n', '        if (p.votedNo[msg.sender]) {\n', '            revert();\n', '        }\n', '        \n', '\n', '        if (_supportsProposal) {\n', '            p.yea += 1;\n', '            p.votedYes[msg.sender] = true;\n', '        } else {\n', '            p.nay += 1;\n', '            p.votedNo[msg.sender] = true;\n', '        }\n', '\n', '        votingRegister[msg.sender].push(_proposalID);\n', '        emit Voted(_proposalID, _supportsProposal, msg.sender);\n', '    }\n', '\n', '\n', '\n', '\n', '    function executeProposal(\n', '        uint _proposalID,\n', '        bytes calldata _transactionData\n', '    )  external payable  returns (bool _success) {\n', '\n', '        Proposal storage p = proposals[_proposalID];\n', '\n', '        // If we are over deadline and waiting period, assert proposal is closed\n', '        if (p.open && block.timestamp > p.votingDeadline.add(executeProposalPeriod)) {\n', '            p.open = false;\n', '            return false;\n', '        }\n', '\n', '        // Check if the proposal can be executed\n', '        if (block.timestamp < p.votingDeadline  // has the voting deadline arrived?\n', '            // Have the votes been counted?\n', '            || !p.open\n', '            || p.proposalPassed // anyone trying to call us recursively?\n', '            // Does the transaction code match the proposal?\n', '            || p.proposalHash != keccak256(abi.encodePacked(p.recipient, _transactionData))\n', '            )\n', '                revert();\n', '\n', '        \n', '        \n', '         // If we are over deadline and waiting period, assert proposal is closed\n', '        if (p.open && now > p.votingDeadline.add(executeProposalPeriod)) {\n', '            p.open = false;\n', '            return false;\n', '        }\n', '        \n', '        \n', '       \n', '        uint quorum = p.yea;\n', '\n', '\n', '\n', '\n', '        // Execute result\n', '        if (quorum >= minQuorum() && p.yea > p.nay) {\n', '            // we are setting this here before the CALL() value transfer to\n', '            // assure that in the case of a malicious recipient contract trying\n', "            // to call executeProposal() recursively money can't be transferred\n", '            // multiple times out of the DAO\n', '            \n', '            \n', '            lastTimeMinQuorumMet = block.timestamp;\n', '            \n', '            \n', '            p.proposalPassed = true;\n', '\n', '            // this call is as generic as any transaction. It sends all gas and\n', '            // can do everything a transaction can do. It can be used to reenter\n', '            // the DAO. The `p.proposalPassed` variable prevents the call from \n', '            // reaching this line again\n', '            (bool success, ) = p.recipient.call.value(msg.value)(_transactionData);\n', '            require(success,"big fuckup");\n', '\n', '            \n', '        }\n', '\n', '        p.open = false;\n', '\n', '        // Initiate event\n', '        emit ProposalTallied(_proposalID, _success, quorum);\n', '        return true;\n', '    }\n', '\n', '\n', ' \n', '   \n', '    //admin like dao functions change median ETH :(\n', '     function changeMedianV(uint256 _V) external {\n', '        \n', '        require(msg.sender == address(this));\n', '         \n', '        V = _V;\n', '     }\n', '     \n', '    //admin like dao functions change % of holders\n', '     function changeHoldersW(uint256 _W) external {\n', '        \n', '        require(msg.sender == address(this));\n', '         \n', '        W = _W;\n', '     }\n', '\n', '\n', '    //admin like dao functions change % burn vote\n', '     function changeVoteB(uint256 _B) external {\n', '        \n', '        require(msg.sender == address(this));\n', '         \n', '        B = _B;\n', '     }\n', '     \n', '     //admin like dao functions change % burn vote multiplier for proposal\n', '     function changeVoteC(uint256 _C) external {\n', '        \n', '        require(msg.sender == address(this));\n', '         \n', '        C = _C;\n', '     }\n', '\n', '\n', '\n', '     //admin like dao functions change minProposalDebatePeriod\n', '     function changeMinProposalDebatePeriod(uint256 _minProposalDebatePeriod) external {\n', '        \n', '        require(msg.sender == address(this));\n', '         \n', '        minProposalDebatePeriod = _minProposalDebatePeriod;\n', '     }\n', '\n', '\n', '    //admin like dao functions change executeProposalPeriod\n', '     function changeexecuteProposalPeriod(uint256 _executeProposalPeriod) external {\n', '        \n', '        require(msg.sender == address(this));\n', '         \n', '        executeProposalPeriod = _executeProposalPeriod;\n', '     }\n', '     \n', '     \n', '\n', '\n', '\n', ' \n', '\n', '    function minQuorum() public view returns (uint _minQuorum) {\n', '        (uint256 reserve0,uint256 reserve1,) = MoondayTokenPair.getReserves();\n', '   \n', '        uint256 R = ((MoondayToken.totalSupply().div( (V.mul((reserve1.div(reserve0)))))).mul(W)).div(100);\n', '        \n', '        return R;\n', '    }\n', '    \n', '    \n', '     function determineAm() public view returns (uint _amount) {\n', '        uint256 burn = (MoondayToken.totalSupply().mul(B)).div(100000);\n', '        \n', '        return burn;\n', '    }\n', '\n', '\n', ' \n', '\n', '    function numberOfProposals() view external returns (uint _numberOfProposals) {\n', "        // Don't count index 0. It's used by getOrModifyBlocked() and exists from start\n", '        return proposals.length - 1;\n', '    }\n', '\n', '  \n', '}']