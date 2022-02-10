['pragma solidity 0.5.7;\n', '/** \n', ' _____                   __  __      ______      ____                 ____       ______      ______   \n', "/\\  __`\\     /'\\_/`\\    /\\ \\/\\ \\    /\\__  _\\    /\\  _`\\              /\\  _`\\    /\\__  _\\    /\\__  _\\  \n", '\\ \\ \\/\\ \\   /\\      \\   \\ \\ `\\\\ \\   \\/_/\\ \\/    \\ \\,\\L\\_\\            \\ \\ \\L\\ \\  \\/_/\\ \\/    \\/_/\\ \\/  \n', " \\ \\ \\ \\ \\  \\ \\ \\__\\ \\   \\ \\ , ` \\     \\ \\ \\     \\/_\\__ \\    _______  \\ \\  _ <'    \\ \\ \\       \\ \\ \\  \n", '  \\ \\ \\_\\ \\  \\ \\ \\_/\\ \\   \\ \\ \\`\\ \\     \\_\\ \\__    /\\ \\L\\ \\ /\\______\\  \\ \\ \\L\\ \\    \\_\\ \\__     \\ \\ \\ \n', '   \\ \\_____\\  \\ \\_\\\\ \\_\\   \\ \\_\\ \\_\\    /\\_____\\   \\ `\\____\\\\/______/   \\ \\____/    /\\_____\\     \\ \\_\\\n', '    \\/_____/   \\/_/ \\/_/    \\/_/\\/_/    \\/_____/    \\/_____/             \\/___/     \\/_____/      \\/_/\n', '\n', '    WEBSITE: www.omnis-bit.com\n', '\n', '\n', "    This contract's staking features are based on the code provided at\n", '    https://github.com/PoSToken/PoSToken\n', '\n', '    SafeMath Library provided by OpenZeppelin\n', '    https://github.com/OpenZeppelin/openzeppelin-solidity\n', '\n', '    TODO: Third Party Audit\n', '    \n', '    Contract Developed and Designed by StartBlock for the Omnis-Bit Team\n', '    Contract Writer: Fares A. Akel C.\n', '    Service Provider Contact: info@startblock.tech\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Admined\n', ' * @dev The Admined contract has an owner address, can set administrators,\n', ' * and provides authorization control functions. These features can be used in other contracts\n', ' * through interfacing, so external contracts can check main contract admin levels\n', ' */\n', 'contract Admined {\n', '    address public owner; //named owner for etherscan compatibility\n', '    mapping(address => uint256) public level;\n', '\n', '    /**\n', '     * @dev The Admined constructor sets the original `owner` of the contract to the sender\n', '     * account and assing high level privileges.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        level[owner] = 3;\n', '        emit OwnerSet(owner);\n', '        emit LevelSet(owner, level[owner]);\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account with lower level than minLvl.\n', '     * @param _minLvl Minimum level to use the function\n', '     */\n', '    modifier onlyAdmin(uint256 _minLvl) {\n', "        require(level[msg.sender] >= _minLvl, 'You do not have privileges for this transaction');\n", '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) onlyAdmin(3) public {\n', "        require(newOwner != address(0), 'Address cannot be zero');\n", '\n', '        owner = newOwner;\n', '        level[owner] = 3;\n', '\n', '        emit OwnerSet(owner);\n', '        emit LevelSet(owner, level[owner]);\n', '\n', '        level[msg.sender] = 0;\n', '        emit LevelSet(msg.sender, level[msg.sender]);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the assignment of new privileges to a new address.\n', '     * @param userAddress The address to transfer ownership to.\n', '     * @param lvl Lvl to assign.\n', '     */\n', '    function setLevel(address userAddress, uint256 lvl) onlyAdmin(2) public {\n', "        require(userAddress != address(0), 'Address cannot be zero');\n", "        require(lvl < level[msg.sender], 'You do not have privileges for this level assignment');\n", '\n', '        level[userAddress] = lvl;\n', '        emit LevelSet(userAddress, level[userAddress]);\n', '    }\n', '\n', '    event LevelSet(address indexed user, uint256 lvl);\n', '    event OwnerSet(address indexed user);\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address who) public view returns(uint256);\n', '\n', '    function transfer(address to, uint256 value) public returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StakerToken {\n', '    uint256 public stakeStartTime;\n', '    uint256 public stakeMinAge;\n', '    uint256 public stakeMaxAge;\n', '\n', '    function claimStake() public returns(bool);\n', '\n', '    function coinAge() public view returns(uint256);\n', '\n', '    function annualInterest() public view returns(uint256);\n', '}\n', '\n', 'contract OMNIS is ERC20, StakerToken, Admined {\n', '    using SafeMath\n', '    for uint256;\n', '    ///////////////////////////////////////////////////////////////////\n', '    //TOKEN RELATED\n', '    string public name = "OMNIS-BIT";\n', '    string public symbol = "OMNIS";\n', '    string public version = "v3";\n', '    uint8 public decimals = 18;\n', '\n', '    uint public totalSupply;\n', '    uint public maxTotalSupply;\n', '    uint public totalInitialSupply;\n', '    bool public globalBalancesFreeze; //In case of a Migration to let make a SnapShot\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    //TOKEN SECTION END\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //AIRDROP RELATED\n', '    struct Airdrop {\n', '        uint value;\n', '        bool claimed;\n', '    }\n', '\n', '    address public airdropWallet;\n', '\n', '    mapping(address => Airdrop) public airdrops; //One airdrop at a time allowed\n', '    //AIRDROP SECTION END\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //ESCROW RELATED\n', '    enum PaymentStatus {\n', '        Requested,\n', '        Rejected,\n', '        Pending,\n', '        Completed,\n', '        Refunded\n', '    }\n', '\n', '    struct Payment {\n', '        address provider;\n', '        address customer;\n', '        uint value;\n', '        string comment;\n', '        PaymentStatus status;\n', '        bool refundApproved;\n', '    }\n', '\n', '    uint escrowCounter;\n', '    uint public escrowFeePercent = 5; //initially set to 0.5%\n', '    bool public escrowEnabled = true;\n', '\n', '    /**\n', '     * @dev Throws if escrow is disabled.\n', '     */\n', '    modifier escrowIsEnabled() {\n', "        require(escrowEnabled == true, 'Escrow is Disabled');\n", '        _;\n', '    }\n', '\n', '    mapping(uint => Payment) public payments;\n', '    address public collectionAddress;\n', '    //ESCROW SECTION END\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //STAKING RELATED\n', '    struct transferInStruct {\n', '        uint128 amount;\n', '        uint64 time;\n', '    }\n', '\n', '    uint public chainStartTime;\n', '    uint public chainStartBlockNumber;\n', '    uint public stakeStartTime;\n', '    uint public stakeMinAge = 3 days;\n', '    uint public stakeMaxAge = 90 days;\n', '\n', '    mapping(address => bool) public userFreeze;\n', '\n', '    mapping(address => transferInStruct[]) transferIns;\n', '\n', '    modifier canPoSclaimStake() {\n', "        require(totalSupply < maxTotalSupply, 'Max supply reached');\n", '        _;\n', '    }\n', '    //STAKING SECTION END\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    /**\n', '     * @dev Throws if any frozen is applied.\n', '     * @param _holderWallet Address of the actual token holder\n', '     */\n', '    modifier notFrozen(address _holderWallet) {\n', "        require(globalBalancesFreeze == false, 'Balances are globally frozen');\n", "        require(userFreeze[_holderWallet] == false, 'Balance frozen by the user');\n", '        _;\n', '    }\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //EVENTS\n', '    event ClaimStake(address indexed _address, uint _reward);\n', '    event NewCollectionWallet(address newWallet);\n', '\n', '    event ClaimDrop(address indexed user, uint value);\n', '    event NewAirdropWallet(address newWallet);\n', '\n', '    event GlobalFreeze(bool status);\n', '\n', '    event EscrowLock(bool status);\n', '    event NewFeeRate(uint newFee);\n', '    event PaymentCreation(\n', '        uint indexed orderId,\n', '        address indexed provider,\n', '        address indexed customer,\n', '        uint value,\n', '        string description\n', '    );\n', '    event PaymentUpdate(\n', '        uint indexed orderId,\n', '        address indexed provider,\n', '        address indexed customer,\n', '        uint value,\n', '        PaymentStatus status\n', '    );\n', '    event PaymentRefundApprove(\n', '        uint indexed orderId,\n', '        address indexed provider,\n', '        address indexed customer,\n', '        bool status\n', '    );\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    constructor() public {\n', '\n', '        maxTotalSupply = 1000000000 * 10 ** 18; //MAX SUPPLY EVER\n', '        totalInitialSupply = 820000000 * 10 ** 18; //INITIAL SUPPLY\n', '        chainStartTime = now; //Deployment Time\n', '        chainStartBlockNumber = block.number; //Deployment Block\n', '        totalSupply = totalInitialSupply;\n', '        collectionAddress = msg.sender; //Initially fees collection wallet to creator\n', '        airdropWallet = msg.sender; //Initially airdrop wallet to creator\n', '        balances[msg.sender] = totalInitialSupply;\n', '\n', '        emit Transfer(address(0), msg.sender, totalInitialSupply);\n', '    }\n', '\n', '    /**\n', '     * @dev setCurrentEscrowFee\n', '     * @dev Allow an admin from level 3 to set the Escrow Service Fee\n', '     * @param _newFee The new fee rate\n', '     */\n', '    function setCurrentEscrowFee(uint _newFee) onlyAdmin(3) public {\n', "        require(_newFee < 1000, 'Fee is higher than 100%');\n", '        escrowFeePercent = _newFee;\n', '        emit NewFeeRate(escrowFeePercent);\n', '    }\n', '\n', '    /**\n', '     * @dev setCollectionWallet\n', '     * @dev Allow an admin from level 3 to set the Escrow Service Fee Wallet\n', '     * @param _newWallet The new fee wallet\n', '     */\n', '    function setCollectionWallet(address _newWallet) onlyAdmin(3) public {\n', "        require(_newWallet != address(0), 'Address cannot be zero');\n", '        collectionAddress = _newWallet;\n', '        emit NewCollectionWallet(collectionAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev setAirDropWallet\n', '     * @dev Allow an admin from level 3 to set the Airdrop Service Wallet\n', '     * @param _newWallet The new Airdrop wallet\n', '     */\n', '    function setAirDropWallet(address _newWallet) onlyAdmin(3) public {\n', "        require(_newWallet != address(0), 'Address cannot be zero');\n", '        airdropWallet = _newWallet;\n', '        emit NewAirdropWallet(airdropWallet);\n', '    }\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //ERC20 FUNCTIONS\n', '    function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns(bool) {\n', "        require(_to != address(0), 'Address cannot be zero');\n", '\n', '        if (msg.sender == _to) return claimStake();\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        //STAKING RELATED//////////////////////////////////////////////\n', '        if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];\n', '        uint64 _now = uint64(now);\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));\n', '        transferIns[_to].push(transferInStruct(uint128(_value), _now));\n', '        ///////////////////////////////////////////////////////////////\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) notFrozen(_from) public returns(bool) {\n', "        require(_to != address(0), 'Address cannot be zero');\n", '\n', '        uint256 _allowance = allowed[_from][msg.sender];\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        //STAKING RELATED//////////////////////////////////////////////\n', '        if (transferIns[_from].length > 0) delete transferIns[_from];\n', '        uint64 _now = uint64(now);\n', '        transferIns[_from].push(transferInStruct(uint128(balances[_from]), _now));\n', '        transferIns[_to].push(transferInStruct(uint128(_value), _now));\n', '        ///////////////////////////////////////////////////////////////\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    //ERC20 SECTION END\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //STAKING FUNCTIONS\n', '    /**\n', '     * @dev claimStake\n', '     * @dev Allow any user to claim stake earned\n', '     */\n', '    function claimStake() canPoSclaimStake public returns(bool) {\n', '        if (balances[msg.sender] <= 0) return false;\n', '        if (transferIns[msg.sender].length <= 0) return false;\n', '\n', '        uint reward = getProofOfStakeReward(msg.sender);\n', '        if (reward <= 0) return false;\n', '        totalSupply = totalSupply.add(reward);\n', '        balances[msg.sender] = balances[msg.sender].add(reward);\n', '\n', '        //STAKING RELATED//////////////////////////////////////////////\n', '        delete transferIns[msg.sender];\n', '        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), uint64(now)));\n', '        ///////////////////////////////////////////////////////////////\n', '\n', '        emit Transfer(address(0), msg.sender, reward);\n', '        emit ClaimStake(msg.sender, reward);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev getBlockNumber\n', '     * @dev Returns the block number since deployment\n', '     */\n', '    function getBlockNumber() public view returns(uint blockNumber) {\n', '        blockNumber = block.number.sub(chainStartBlockNumber);\n', '    }\n', '\n', '    /**\n', '     * @dev coinAge\n', '     * @dev Returns the coinage for the callers account\n', '     */\n', '    function coinAge() public view returns(uint myCoinAge) {\n', '        myCoinAge = getCoinAge(msg.sender, now);\n', '    }\n', '\n', '    /**\n', '     * @dev annualInterest\n', '     * @dev Returns the current interest rate\n', '     */\n', '    function annualInterest() public view returns(uint interest) {\n', '        uint _now = now;\n', '        // If all periods are finished but not max supply is reached,\n', '        // a default small interest rate is left until max supply\n', '        // get reached\n', '        interest = (1 * 1e15); //fallback interest\n', '        if ((_now.sub(stakeStartTime)).div(365 days) == 0) {\n', '            interest = (106 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {\n', '            interest = (49 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 2) {\n', '            interest = (24 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 3) {\n', '            interest = (13 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 4) {\n', '            interest = (11 * 1e15);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev getProofOfStakeReward\n', '     * @dev Returns the current stake of a wallet\n', '     * @param _address is the user wallet\n', '     */\n', '    function getProofOfStakeReward(address _address) public view returns(uint) {\n', "        require((now >= stakeStartTime) && (stakeStartTime > 0), 'Staking is not yet enabled');\n", '\n', '        uint _now = now;\n', '        uint _coinAge = getCoinAge(_address, _now);\n', '        if (_coinAge <= 0) return 0;\n', '\n', '        // If all periods are finished but not max supply is reached,\n', '        // a default small interest rate is left until max supply\n', '        // get reached\n', '        uint interest = (1 * 1e15); //fallback interest\n', '\n', '        if ((_now.sub(stakeStartTime)).div(365 days) == 0) {\n', '            interest = (106 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 1) {\n', '            interest = (49 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 2) {\n', '            interest = (24 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 3) {\n', '            interest = (13 * 1e15);\n', '        } else if ((_now.sub(stakeStartTime)).div(365 days) == 4) {\n', '            interest = (11 * 1e1);\n', '        }\n', '\n', '        return (_coinAge * interest).div(365 * (10 ** uint256(decimals)));\n', '    }\n', '\n', '    function getCoinAge(address _address, uint _now) internal view returns(uint _coinAge) {\n', '        if (transferIns[_address].length <= 0) return 0;\n', '\n', '        for (uint i = 0; i < transferIns[_address].length; i++) {\n', '            if (_now < uint(transferIns[_address][i].time).add(stakeMinAge)) continue;\n', '\n', '            uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));\n', '            if (nCoinSeconds > stakeMaxAge) nCoinSeconds = stakeMaxAge;\n', '\n', '            _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(1 days));\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev setStakeStartTime\n', '     * @dev Used by the owner to define the staking period start\n', '     * @param timestamp time in UNIX format\n', '     */\n', '    function setStakeStartTime(uint timestamp) onlyAdmin(3) public {\n', "        require((stakeStartTime <= 0) && (timestamp >= chainStartTime), 'Wrong time set');\n", '        stakeStartTime = timestamp;\n', '    }\n', '    //STACKING SECTION END\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //UTILITY FUNCTIONS\n', '    /**\n', '     * @dev batchTransfer\n', '     * @dev Used by the owner to deliver several transfers at the same time (Airdrop)\n', '     * @param _recipients Array of addresses\n', '     * @param _values Array of values\n', '     */\n', '    function batchTransfer(\n', '        address[] calldata _recipients,\n', '        uint[] calldata _values\n', '    ) onlyAdmin(1)\n', '    external returns(bool) {\n', '        //Check data sizes\n', "        require(_recipients.length > 0 && _recipients.length == _values.length, 'Addresses and Values have wrong sizes');\n", '        //Total value calc\n', '        uint total = 0;\n', '        for (uint i = 0; i < _values.length; i++) {\n', '            total = total.add(_values[i]);\n', '        }\n', '        //Sender must hold funds\n', "        require(total <= balances[msg.sender], 'Not enough funds for the transaction');\n", '        //Make transfers\n', '        uint64 _now = uint64(now);\n', '        for (uint j = 0; j < _recipients.length; j++) {\n', '            balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);\n', '            //STAKING RELATED//////////////////////////////////////////////\n', '            transferIns[_recipients[j]].push(transferInStruct(uint128(_values[j]), _now));\n', '            ///////////////////////////////////////////////////////////////\n', '            emit Transfer(msg.sender, _recipients[j], _values[j]);\n', '        }\n', '        //Reduce all balance on a single transaction from sender\n', '        balances[msg.sender] = balances[msg.sender].sub(total);\n', '        if (transferIns[msg.sender].length > 0) delete transferIns[msg.sender];\n', '        if (balances[msg.sender] > 0) transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]), _now));\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev dropSet\n', '     * @dev Used by the owner to set several self-claiming drops at the same time (Airdrop)\n', '     * @param _recipients Array of addresses\n', '     * @param _values Array of values1\n', '     */\n', '    function dropSet(\n', '        address[] calldata _recipients,\n', '        uint[] calldata _values\n', '    ) onlyAdmin(1)\n', '    external returns(bool) {\n', '        //Check data sizes \n', "        require(_recipients.length > 0 && _recipients.length == _values.length, 'Addresses and Values have wrong sizes');\n", '\n', '        for (uint j = 0; j < _recipients.length; j++) {\n', '            //Store user drop info\n', '            airdrops[_recipients[j]].value = _values[j];\n', '            airdrops[_recipients[j]].claimed = false;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev claimAirdrop\n', '     * @dev Allow any user with a drop set to claim it\n', '     */\n', '    function claimAirdrop() external returns(bool) {\n', '        //Check if not claimed\n', "        require(airdrops[msg.sender].claimed == false, 'Airdrop already claimed');\n", "        require(airdrops[msg.sender].value != 0, 'No airdrop value to claim');\n", '\n', '        //Original value\n', '        uint _value = airdrops[msg.sender].value;\n', '\n', '        //Set as Claimed\n', '        airdrops[msg.sender].claimed = true;\n', '        //Clear value\n', '        airdrops[msg.sender].value = 0;\n', '\n', '        //Tokens are on airdropWallet\n', '        address _from = airdropWallet;\n', '        //Tokens goes to costumer\n', '        address _to = msg.sender;\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        emit ClaimDrop(_to, _value);\n', '\n', '        //STAKING RELATED//////////////////////////////////////////////\n', '        if (transferIns[_from].length > 0) delete transferIns[_from];\n', '        uint64 _now = uint64(now);\n', '        transferIns[_from].push(transferInStruct(uint128(balances[_from]), _now));\n', '        transferIns[_to].push(transferInStruct(uint128(_value), _now));\n', '        ///////////////////////////////////////////////////////////////\n', '\n', '        return true;\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev userFreezeBalance\n', "     * @dev Allow a user to safe Lock/Unlock it's balance\n", '     * @param _lock Lock Status to set\n', '     */\n', '    function userFreezeBalance(bool _lock) public returns(bool) {\n', '        userFreeze[msg.sender] = _lock;\n', '    }\n', '\n', '    /**\n', '     * @dev ownerFreeze\n', '     * @dev Allow the owner to globally freeze tokens for a migration/snapshot\n', '     * @param _lock Lock Status to set\n', '     */\n', '    function ownerFreeze(bool _lock) onlyAdmin(3) public returns(bool) {\n', '        globalBalancesFreeze = _lock;\n', '        emit GlobalFreeze(globalBalancesFreeze);\n', '    }\n', '\n', '    //UTILITY SECTION ENDS\n', '    ///////////////////////////////////////////////////////////////////\n', '\n', '    ///////////////////////////////////////////////////////////////////\n', '    //ESCROW FUNCTIONS\n', '    /**\n', '     * @dev createPaymentRequest\n', '     * @dev Allow an user to request start a Escrow process\n', '     * @param _customer Counterpart that will receive payment on success\n', '     * @param _value Amount to be escrowed\n', '     * @param _description Description\n', '     */\n', '    function createPaymentRequest(\n', '        address _customer,\n', '        uint _value,\n', '        string calldata _description\n', '    )\n', '    escrowIsEnabled()\n', '    notFrozen(msg.sender)\n', '    external returns(uint) {\n', '\n', "        require(_customer != address(0), 'Address cannot be zero');\n", "        require(_value > 0, 'Value cannot be zero');\n", '\n', '        payments[escrowCounter] = Payment(msg.sender, _customer, _value, _description, PaymentStatus.Requested, false);\n', '        emit PaymentCreation(escrowCounter, msg.sender, _customer, _value, _description);\n', '\n', '        escrowCounter = escrowCounter.add(1);\n', '        return escrowCounter - 1;\n', '\n', '    }\n', '\n', '    /**\n', '     * @dev answerPaymentRequest\n', '     * @dev Allow a user to answer to a Escrow process\n', '     * @param _orderId the request ticket number\n', '     * @param _answer request answer\n', '     */\n', '    function answerPaymentRequest(uint _orderId, bool _answer) external returns(bool) {\n', '        //Get Payment Handler\n', '        Payment storage payment = payments[_orderId];\n', '\n', '        require(payment.status == PaymentStatus.Requested, \'Ticket wrong status, expected "Requested"\');\n', "        require(payment.customer == msg.sender, 'You are not allowed to manage this ticket');\n", '\n', '        if (_answer == true) {\n', '\n', '            address _to = address(this);\n', '\n', '            balances[payment.provider] = balances[payment.provider].sub(payment.value);\n', '            balances[_to] = balances[_to].add(payment.value);\n', '            emit Transfer(payment.provider, _to, payment.value);\n', '\n', '            //STAKING RELATED//////////////////////////////////////////////\n', '            if (transferIns[payment.provider].length > 0) delete transferIns[payment.provider];\n', '            uint64 _now = uint64(now);\n', '            transferIns[payment.provider].push(transferInStruct(uint128(balances[payment.provider]), _now));\n', '            ///////////////////////////////////////////////////////////////\n', '\n', '            payments[_orderId].status = PaymentStatus.Pending;\n', '\n', '            emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, PaymentStatus.Pending);\n', '\n', '        } else {\n', '\n', '            payments[_orderId].status = PaymentStatus.Rejected;\n', '\n', '            emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, PaymentStatus.Rejected);\n', '\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev release\n', '     * @dev Allow a provider or admin user to release a payment\n', '     * @param _orderId Ticket number of the escrow service\n', '     */\n', '    function release(uint _orderId) external returns(bool) {\n', '        //Get Payment Handler\n', '        Payment storage payment = payments[_orderId];\n', '        //Only if pending\n', '        require(payment.status == PaymentStatus.Pending, \'Ticket wrong status, expected "Pending"\');\n', '        //Only owner or token provider\n', "        require(level[msg.sender] >= 2 || msg.sender == payment.provider, 'You are not allowed to manage this ticket');\n", '        //Tokens are on contract\n', '        address _from = address(this);\n', '        //Tokens goes to costumer\n', '        address _to = payment.customer;\n', '        //Original value\n', '        uint _value = payment.value;\n', '        //Fee calculation\n', '        uint _fee = _value.mul(escrowFeePercent).div(1000);\n', '        //Value less fees\n', '        _value = _value.sub(_fee);\n', '        //Costumer transfer\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        //collectionAddress fee recolection\n', '        balances[_from] = balances[_from].sub(_fee);\n', '        balances[collectionAddress] = balances[collectionAddress].add(_fee);\n', '        emit Transfer(_from, collectionAddress, _fee);\n', '        //Delete any staking from contract address itself\n', '        if (transferIns[_from].length > 0) delete transferIns[_from];\n', '        //Store staking information for receivers\n', '        uint64 _now = uint64(now);\n', '        //Costumer\n', '        transferIns[_to].push(transferInStruct(uint128(_value), _now));\n', '        //collectionAddress\n', '        transferIns[collectionAddress].push(transferInStruct(uint128(_fee), _now));\n', '        //Payment Escrow Completed\n', '        payment.status = PaymentStatus.Completed;\n', '        //Emit Event\n', '        emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, payment.status);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev refund\n', '     * @dev Allow a user to refund a payment\n', '     * @param _orderId Ticket number of the escrow service\n', '     */\n', '    function refund(uint _orderId) external returns(bool) {\n', '        //Get Payment Handler\n', '        Payment storage payment = payments[_orderId];\n', '        //Only if pending\n', '        require(payment.status == PaymentStatus.Pending, \'Ticket wrong status, expected "Pending"\');\n', '        //Only if refund was approved\n', "        require(payment.refundApproved, 'Refund has not been approved yet');\n", '        //Tokens are on contract\n', '        address _from = address(this);\n', '        //Tokens go back to provider\n', '        address _to = payment.provider;\n', '        //Original value\n', '        uint _value = payment.value;\n', '        //Provider transfer\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        //Delete any staking from contract address itself\n', '        if (transferIns[_from].length > 0) delete transferIns[_from];\n', '        //Store staking information for receivers\n', '        uint64 _now = uint64(now);\n', '        transferIns[_to].push(transferInStruct(uint128(_value), _now));\n', '        //Payment Escrow Refunded\n', '        payment.status = PaymentStatus.Refunded;\n', '        //Emit Event\n', '        emit PaymentUpdate(_orderId, payment.provider, payment.customer, payment.value, payment.status);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev approveRefund\n', '     * @dev Allow a user to approve a refund\n', '     * @param _orderId Ticket number of the escrow service\n', '     */\n', '    function approveRefund(uint _orderId) external returns(bool) {\n', '        //Get Payment Handler\n', '        Payment storage payment = payments[_orderId];\n', '        //Only if pending\n', '        require(payment.status == PaymentStatus.Pending, \'Ticket wrong status, expected "Pending"\');\n', '        //Only owner or costumer\n', "        require(level[msg.sender] >= 2 || msg.sender == payment.customer, 'You are not allowed to manage this ticket');\n", '        //Approve Refund\n', '        payment.refundApproved = true;\n', '\n', '        emit PaymentRefundApprove(_orderId, payment.provider, payment.customer, payment.refundApproved);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev escrowLockSet\n', '     * @dev Allow the owner to lock the escrow feature\n', '     * @param _lock lock indicator\n', '     */\n', '    function escrowLockSet(bool _lock) external onlyAdmin(3) returns(bool) {        \n', '        escrowEnabled = _lock;\n', '        emit EscrowLock(escrowEnabled);\n', '        return true;\n', '    }\n', '\n', '    //ESCROW SECTION END\n', '    ///////////////////////////////////////////////////////////////////\n', '}']