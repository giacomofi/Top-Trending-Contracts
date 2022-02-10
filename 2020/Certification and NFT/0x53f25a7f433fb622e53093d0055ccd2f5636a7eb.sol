['/**\n', ' *Submitted for verification at Etherscan.io on 2020-11-02\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', ' /**\n', ' * @title SafeMath\n', ' * @dev   Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256){\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b,"Calculation error");\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256){\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0,"Calculation error");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256){\n', '        require(b <= a,"Calculation error");\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256){\n', '        uint256 c = a + b;\n', '        require(c >= a,"Calculation error");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256){\n', '        require(b != 0,"Calculation error");\n', '        return a % b;\n', '    }\n', '}\n', '\n', ' /**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '  function balanceOf(address account) external view returns (uint256);\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', ' /**\n', ' * @title Layerx Contract For ERC20 Tokens\n', ' * @dev LAYERX tokens as per ERC20 Standards\n', ' */\n', 'contract Layerx is IERC20, Owned {\n', '    using SafeMath for uint256;\n', '    \n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint _totalSupply;\n', '\n', '    uint public ethToNextStake = 0;\n', '    uint stakeNum = 0;\n', '    uint constant CAP = 1000000000000000000;\n', '    uint constant CAP_R = 100000000;\n', '    uint constant DAYMILLI = 86400;\n', '    uint amtByDay = 27397260274000000000;\n', '    address public stakeCreator;\n', '    address[] private activeHolders;\n', '    \n', '    bool isPaused = false;\n', '\n', '    struct Stake {\n', '        uint start;\n', '        uint end;\n', '        uint layerLockedTotal;\n', '        uint layerxReward;\n', '        uint ethReward;\n', '    }\n', '\n', '    struct StakeHolder {\n', '        uint layerLocked;\n', '        uint id;\n', '    }\n', '    \n', '    struct Rewards {\n', '        uint layersx;\n', '        uint eth;\n', '        bool isReceived;\n', '    }\n', '    \n', '    event logLockedTokens(address holder, uint amountLocked, uint stakeId);\n', '    event logUnlockedTokens(address holder, uint amountUnlocked);\n', '    event logNewStakePayment(uint id, uint amount);\n', '    event logWithdraw(address holder, uint layerx, uint eth, uint stakeId);\n', '    \n', '    modifier paused {\n', '        require(isPaused == false, "This contract was paused by the owner!");\n', '        _;\n', '    }\n', '    \n', '    modifier exist (uint index) {\n', "        require(index <= stakeNum, 'This stake does not exist.');\n", '        _;        \n', '    }\n', '    \n', '    mapping (address => StakeHolder) public stakeHolders;\n', '    mapping (address => mapping (uint => Rewards)) public rewards;\n', '    mapping (uint => Stake) public stakes;\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping(address => uint)) allowed;\n', '    \n', '    IERC20 UNILAYER = IERC20(0x0fF6ffcFDa92c53F615a4A75D982f399C989366b); \n', '    \n', '    constructor(address _owner) public {\n', '        owner = _owner;\n', '        stakeCreator = owner;\n', '        symbol = "LAYERX";\n', '        name = "UNILAYERX";\n', '        decimals = 18;\n', '        _totalSupply = 40000 * 10**uint(decimals);\n', '        balances[owner] = _totalSupply;\n', '        emit Transfer(address(0), owner, _totalSupply);\n', '        \n', '        stakes[0] = Stake(now, 0, 0, 0, 0);    \n', '    }\n', '\n', '    /**\n', '     * @dev Total number of tokens in existence.\n', '     */\n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '\n', '    /**\n', '     * @dev Gets the balance of the specified address.\n', '     * @param tokenOwner The address to query the balance of.\n', '     * @return A uint256 representing the amount owned by the passed address.\n', '     */\n', '    function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    \n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '        return true;\n', '    }   \n', '    \n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 value) public onlyOwner {\n', '        require(value > 0, "Invalid Amount.");\n', '        require(_totalSupply >= value, "Invalid account state.");\n', '        require(balances[owner] >= value, "Invalid account balances state.");\n', '        _totalSupply = _totalSupply.sub(value);\n', '        balances[owner] = balances[owner].sub(value);\n', '        emit Transfer(owner, address(0), value);\n', '    }    \n', '    \n', '    /**\n', '     * @dev Set new Stake Creator address.\n', '     * @param _stakeCreator The address of the new Stake Creator.\n', '     */    \n', '    function setNewStakeCreator(address _stakeCreator) external onlyOwner {\n', "        require(_stakeCreator != address(0), 'Do not use 0 address');\n", '        stakeCreator = _stakeCreator;\n', '    }\n', '    \n', '    /**\n', '     * @dev Set new pause status.\n', '     * @param newIsPaused The pause status: 0 - not paused, 1 - paused.\n', '     */ \n', '    function setIsPaused(bool newIsPaused) external onlyOwner {\n', '        isPaused = newIsPaused;\n', '    }     \n', '\n', '    /**\n', '     * @dev Remove holder from the list of active holders.\n', '     * @param holder that must be removed.\n', '     */ \n', '    function removeHolder(StakeHolder memory holder) internal {\n', '        uint openId = holder.id;\n', '        address openWallet = activeHolders[openId];\n', '        if(activeHolders.length > 1) {\n', '            uint lastId = activeHolders.length-1;\n', '            address lastWallet = activeHolders[lastId];\n', '            StakeHolder memory lastHolder = stakeHolders[lastWallet];\n', '            \n', '            lastHolder.id = openId;\n', '            stakeHolders[lastWallet] = lastHolder;\n', '            activeHolders[openId] = lastWallet;\n', '        }\n', '        activeHolders.pop();\n', '        holder.id = 0;\n', '        stakeHolders[openWallet] = holder;        \n', '    }    \n', '    \n', '    /**\n', '    * @dev Stake LAYER tokens for earning rewards, Tokens will be deducted from message sender account\n', '    * @param payment Amount of LAYER to be staked in the pool\n', '    */    \n', '    function lock(uint payment) external paused {\n', "        require(payment > 0, 'Payment must be greater than 0.');\n", "        require(UNILAYER.balanceOf(msg.sender) >= payment, 'Holder does not have enough tokens.');\n", '        UNILAYER.transferFrom(msg.sender, address(this), payment);\n', '        \n', '        StakeHolder memory holder = stakeHolders[msg.sender];\n', '        \n', '        if(holder.layerLocked == 0) {\n', '            uint holderId = activeHolders.length;\n', '            activeHolders.push(msg.sender);\n', '            holder.id = holderId;\n', '        }        \n', '        \n', '        holder.layerLocked = holder.layerLocked.add(payment);\n', '        \n', '        Stake memory stake = stakes[stakeNum];\n', '        stake.layerLockedTotal = stake.layerLockedTotal.add(payment);\n', '        \n', '        stakeHolders[msg.sender] = holder;\n', '        stakes[stakeNum] = stake;\n', '        \n', '        emit logLockedTokens(msg.sender, payment, stakeNum);\n', '    }    \n', '    \n', '    /**\n', '    * @dev Withdraw My Staked Tokens from staker pool\n', '    */    \n', '    function unlock() external paused {\n', '        StakeHolder memory holder = stakeHolders[msg.sender]; \n', '        uint amt = holder.layerLocked;\n', "        require(amt > 0, 'You do not have locked tokens.');\n", "        require(UNILAYER.balanceOf(address(this))  >= amt, 'Insufficient account balance!');\n", '        Stake memory stake = stakes[stakeNum];\n', "        require(stake.end == 0, 'Invalid date for unlock, please use withdraw.');\n", '        stake.layerLockedTotal = stake.layerLockedTotal.sub(amt);\n', '        stakes[stakeNum] = stake;\n', '        holder.layerLocked = 0;\n', '        stakeHolders[msg.sender] = holder;\n', '        removeHolder(holder);        \n', '        UNILAYER.transfer(msg.sender, amt);\n', '        emit logUnlockedTokens(msg.sender, amt);\n', '    }\n', '    \n', '    /**\n', "    * @dev Stake Creator finalizes the stake, the stake receives the accumulated ETH as reward and calculates everyone's percentages.\n", '    */      \n', '    function addStakePayment() external {\n', "        require(msg.sender == stakeCreator, 'You cannot call this function');\n", '        Stake memory stake = stakes[stakeNum]; \n', '        stake.end = now;\n', '        stake.ethReward = stake.ethReward.add(ethToNextStake);\n', '        ethToNextStake = 0;\n', '  \n', '        uint days_passed = stake.end.sub(stake.start).mul(CAP_R).div(DAYMILLI);\n', '        uint amtLayerx = days_passed.mul(amtByDay).div(CAP_R);\n', '        \n', '        if(amtLayerx > balances[owner]) { amtLayerx = balances[owner]; }\n', '        \n', '        stake.layerxReward = stake.layerxReward.add(amtLayerx);\n', '        \n', '        for(uint i = 0; i < activeHolders.length; i++) {\n', '            StakeHolder memory holder = stakeHolders[activeHolders[i]];\n', '            uint rate = holder.layerLocked.mul(CAP).div(stake.layerLockedTotal);\n', '            rewards[activeHolders[i]][stakeNum].layersx = amtLayerx.mul(rate).div(CAP);\n', '            rewards[activeHolders[i]][stakeNum].eth = stake.ethReward.mul(rate).div(CAP);\n', '        }\n', '        \n', '        stakes[stakeNum] = stake;\n', '        emit logNewStakePayment(stakeNum, ethToNextStake);  \n', '        stakeNum++;\n', '        stakes[stakeNum] = Stake(now, 0, stake.layerLockedTotal, 0, 0);\n', '    }\n', '    \n', '    /**\n', '    * @dev Withdraw Reward Layerx Tokens and ETH\n', '    * @param index Stake index\n', '    */    \n', '    function withdraw(uint index) external paused exist(index) {\n', '        Rewards memory rwds = rewards[msg.sender][index];\n', '        Stake memory stake = stakes[index];\n', '        \n', "        require(stake.end <= now, 'Invalid date for withdrawal.');\n", "        require(rwds.isReceived == false, 'You already withdrawal your rewards.');\n", "        require(balances[owner] >= rwds.layersx, 'Insufficient account balance!');\n", "        require(address(this).balance >= rwds.eth,'Invalid account state, not enough funds.');\n", '   \n', '        if(rwds.layersx > 0) {\n', '            balances[owner] = balances[owner].sub(rwds.layersx);\n', '            balances[msg.sender] = balances[msg.sender].add(rwds.layersx);  \n', '            emit Transfer(owner, msg.sender, rwds.layersx);\n', '        }\n', '        \n', '        if(rwds.eth > 0) {\n', '            msg.sender.transfer(rwds.eth);    \n', '        }\n', '        \n', '        rwds.isReceived = true;\n', '        \n', '        rewards[msg.sender][index] = rwds;\n', '        emit logWithdraw(msg.sender, rwds.layersx, rwds.eth, index);\n', '    }\n', '    \n', '    /**\n', '    * @dev Function to get the number of stakes\n', '    * @return number of stakes\n', '    */    \n', '    function getStakesNum() external view returns (uint) {\n', '        return stakeNum+1;\n', '    }\n', '    \n', '\n', '    /**\n', '    * @dev Receive ETH and add value to the accumulated eth for stake\n', '    */      \n', '    function() external payable {\n', '        ethToNextStake = ethToNextStake.add(msg.value); \n', '    }\n', '}']