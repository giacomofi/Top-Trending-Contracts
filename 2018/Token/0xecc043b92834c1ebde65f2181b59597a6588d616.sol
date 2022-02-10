['pragma solidity 0.4.24;\n', 'pragma experimental "v0.5.0";\n', '\n', 'contract Administration {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    address public owner;\n', '    address public admin;\n', '\n', '    event AdminSet(address _admin);\n', '    event OwnershipTransferred(address _previousOwner, address _newOwner);\n', '\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == owner || msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier nonZeroAddress(address _addr) {\n', '        require(_addr != address(0), "must be non zero address");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        admin = msg.sender;\n', '    }\n', '\n', '    function setAdmin(\n', '        address _newAdmin\n', '    )\n', '        public\n', '        onlyOwner\n', '        nonZeroAddress(_newAdmin)\n', '        returns (bool)\n', '    {\n', '        require(_newAdmin != admin);\n', '        admin = _newAdmin;\n', '        emit AdminSet(_newAdmin);\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(\n', '        address _newOwner\n', '    )\n', '        public\n', '        onlyOwner\n', '        nonZeroAddress(_newOwner)\n', '        returns (bool)\n', '    {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '  // We use `pure` bbecause it promises that the value for the function depends ONLY\n', '  // on the function arguments\n', '    function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '        uint256 c = a * b;\n', '        require(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'interface ERC20Interface {\n', '    function owner() external view returns (address);\n', '    function decimals() external view returns (uint8);\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '    function approve(address _spender, uint256 _amount) external returns (bool);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function allowance(address _owner, address _spender) external view returns (uint256);\n', '}\n', '\n', 'interface StakeInterface {\n', '    function activeStakes() external view returns (uint256);\n', '}\n', '\n', '/// @title RTC Token Contract\n', '/// @author Postables, RTrade Technologies Ltd\n', '/// @dev We able V5 for safety features, see https://solidity.readthedocs.io/en/v0.4.24/security-considerations.html#take-warnings-seriously\n', 'contract RTCoin is Administration {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    // this is the initial supply of tokens, 61.6 Million\n', '    uint256 constant public INITIALSUPPLY = 61600000000000000000000000;\n', '    string  constant public VERSION = "production";\n', '\n', '    // this is the interface that allows interaction with the staking contract\n', '    StakeInterface public stake = StakeInterface(0);\n', '    // this is the address of the staking contract\n', '    address public  stakeContractAddress = address(0);\n', '    // This is the address of the merged mining contract, not yet developed\n', '    address public  mergedMinerValidatorAddress = address(0);\n', '    string  public  name = "RTCoin";\n', '    string  public  symbol = "RTC";\n', '    uint256 public  totalSupply = INITIALSUPPLY;\n', '    uint8   public  decimals = 18;\n', '    // allows transfers to be frozen, but enable them by default\n', '    bool    public  transfersFrozen = true;\n', '    bool    public  stakeFailOverRestrictionLifted = false;\n', '\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    mapping (address => bool) public minters;\n', '\n', '    event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _amount);\n', '    event TransfersFrozen(bool indexed _transfersFrozen);\n', '    event TransfersThawed(bool indexed _transfersThawed);\n', '    event ForeignTokenTransfer(address indexed _sender, address indexed _recipient, uint256 _amount);\n', '    event EthTransferOut(address indexed _recipient, uint256 _amount);\n', '    event MergedMinerValidatorSet(address _contractAddress);\n', '    event StakeContractSet(address _contractAddress);\n', '    event FailOverStakeContractSet(address _contractAddress);\n', '    event CoinsMinted(address indexed _stakeContract, address indexed _recipient, uint256 _mintAmount);\n', '\n', '    modifier transfersNotFrozen() {\n', '        require(!transfersFrozen, "transfers must not be frozen");\n', '        _;\n', '    }\n', '\n', '    modifier transfersAreFrozen() {\n', '        require(transfersFrozen, "transfers must be frozen");\n', '        _;\n', '    }\n', '\n', '    // makes sure that only the stake contract, or merged miner validator contract can mint coins\n', '    modifier onlyMinters() {\n', '        require(minters[msg.sender] == true, "sender must be a valid minter");\n', '        _;\n', '    }\n', '\n', '    modifier nonZeroAddress(address _addr) {\n', '        require(_addr != address(0), "must be non zero address");\n', '        _;\n', '    }\n', '\n', '    modifier nonAdminAddress(address _addr) {\n', '        require(_addr != owner && _addr != admin, "addr cant be owner or admin");\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        balances[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '\n', '    /** @notice Used to transfer tokens\n', '        * @param _recipient This is the recipient of the transfer\n', '        * @param _amount This is the amount of tokens to send\n', '     */\n', '    function transfer(\n', '        address _recipient,\n', '        uint256 _amount\n', '    )\n', '        public\n', '        transfersNotFrozen\n', '        nonZeroAddress(_recipient)\n', '        returns (bool)\n', '    {\n', '        // check that the sender has a valid balance\n', '        require(balances[msg.sender] >= _amount, "sender does not have enough tokens");\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_recipient] = balances[_recipient].add(_amount);\n', '        emit Transfer(msg.sender, _recipient, _amount);\n', '        return true;\n', '    }\n', '\n', '    /** @notice Used to transfer tokens on behalf of someone else\n', '        * @param _recipient This is the recipient of the transfer\n', '        * @param _amount This is the amount of tokens to send\n', '     */\n', '    function transferFrom(\n', '        address _owner,\n', '        address _recipient,\n', '        uint256 _amount\n', '    )\n', '        public\n', '        transfersNotFrozen\n', '        nonZeroAddress(_recipient)\n', '        returns (bool)\n', '    {\n', '        // ensure owner has a valid balance\n', '        require(balances[_owner] >= _amount, "owner does not have enough tokens");\n', '        // ensure that the spender has a valid allowance\n', '        require(allowed[_owner][msg.sender] >= _amount, "sender does not have enough allowance");\n', '        // reduce the allowance\n', '        allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_amount);\n', '        // reduce balance of owner\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        // increase balance of recipient\n', '        balances[_recipient] = balances[_recipient].add(_amount);\n', '        emit Transfer(_owner, _recipient, _amount);\n', '        return true;\n', '    }\n', '\n', '    /** @notice This is used to approve someone to send tokens on your behalf\n', '        * @param _spender This is the person who can spend on your behalf\n', '        * @param _value This is the amount of tokens that they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // NON STANDARD FUNCTIONS //\n', '\n', '    /** @notice This is used to set the merged miner validator contract\n', '        * @param _mergedMinerValidator this is the address of the mergedmining contract\n', '     */\n', '    function setMergedMinerValidator(address _mergedMinerValidator) external onlyOwner nonAdminAddress(_mergedMinerValidator) returns (bool) {\n', '        mergedMinerValidatorAddress = _mergedMinerValidator;\n', '        minters[_mergedMinerValidator] = true;\n', '        emit MergedMinerValidatorSet(_mergedMinerValidator);\n', '        return true;\n', '    }\n', '\n', '    /** @notice This is used to set the staking contract\n', '        * @param _contractAddress this is the address of the staking contract\n', '    */\n', '    function setStakeContract(address _contractAddress) external onlyOwner nonAdminAddress(_contractAddress) returns (bool) {\n', '        // this prevents us from changing contracts while there are active stakes going on\n', '        if (stakeContractAddress != address(0)) {\n', '            require(stake.activeStakes() == 0, "staking contract already configured, to change it must have 0 active stakes");\n', '        }\n', '        stakeContractAddress = _contractAddress;\n', '        minters[_contractAddress] = true;\n', '        stake = StakeInterface(_contractAddress);\n', '        emit StakeContractSet(_contractAddress);\n', '        return true;\n', '    }\n', '\n', '    /** @notice Emergency use function designed to prevent stake deadlocks, allowing a fail-over stake contract to be implemented\n', '        * Requires 2 transaction, the first lifts the restriction, the second enables the restriction and sets the contract\n', "        * @dev We restrict to the owner address for security reasons, and don't update the stakeContractAddress variable to avoid breaking compatability\n", '        * @param _contractAddress This is the address of the stake contract\n', '     */\n', '    function setFailOverStakeContract(address _contractAddress) external onlyOwner nonAdminAddress(_contractAddress) returns (bool) {\n', '        if (stakeFailOverRestrictionLifted == false) {\n', '            stakeFailOverRestrictionLifted = true;\n', '            return true;\n', '        } else {\n', '            minters[_contractAddress] = true;\n', '            stakeFailOverRestrictionLifted = false;\n', '            emit FailOverStakeContractSet(_contractAddress);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /** @notice This is used to mint new tokens\n', '        * @dev Can only be executed by the staking, and merged miner validator contracts\n', '        * @param _recipient This is the person who will received the mint tokens\n', '        * @param _amount This is the amount of tokens that they will receive and which will be generated\n', '     */\n', '    function mint(\n', '        address _recipient,\n', '        uint256 _amount)\n', '        public\n', '        onlyMinters\n', '        returns (bool)\n', '    {\n', '        balances[_recipient] = balances[_recipient].add(_amount);\n', '        totalSupply = totalSupply.add(_amount);\n', '        emit Transfer(address(0), _recipient, _amount);\n', '        emit CoinsMinted(msg.sender, _recipient, _amount);\n', '        return true;\n', '    }\n', '\n', "    /** @notice Allow us to transfer tokens that someone might've accidentally sent to this contract\n", '        @param _tokenAddress this is the address of the token contract\n', '        @param _recipient This is the address of the person receiving the tokens\n', '        @param _amount This is the amount of tokens to send\n', '     */\n', '    function transferForeignToken(\n', '        address _tokenAddress,\n', '        address _recipient,\n', '        uint256 _amount)\n', '        public\n', '        onlyAdmin\n', '        nonZeroAddress(_recipient)\n', '        returns (bool)\n', '    {\n', "        // don't allow us to transfer RTC tokens\n", '        require(_tokenAddress != address(this), "token address can\'t be this contract");\n', '        ERC20Interface eI = ERC20Interface(_tokenAddress);\n', '        require(eI.transfer(_recipient, _amount), "token transfer failed");\n', '        emit ForeignTokenTransfer(msg.sender, _recipient, _amount);\n', '        return true;\n', '    }\n', '    \n', '    /** @notice Transfers eth that is stuck in this contract\n', '        * ETH can be sent to the address this contract resides at before the contract is deployed\n', '        * A contract can be suicided, forcefully sending ether to this contract\n', '     */\n', '    function transferOutEth()\n', '        public\n', '        onlyAdmin\n', '        returns (bool)\n', '    {\n', '        uint256 balance = address(this).balance;\n', '        msg.sender.transfer(address(this).balance);\n', '        emit EthTransferOut(msg.sender, balance);\n', '        return true;\n', '    }\n', '\n', '    /** @notice Used to freeze token transfers\n', '     */\n', '    function freezeTransfers()\n', '        public\n', '        onlyAdmin\n', '        returns (bool)\n', '    {\n', '        transfersFrozen = true;\n', '        emit TransfersFrozen(true);\n', '        return true;\n', '    }\n', '\n', '    /** @notice Used to thaw token transfers\n', '     */\n', '    function thawTransfers()\n', '        public\n', '        onlyAdmin\n', '        returns (bool)\n', '    {\n', '        transfersFrozen = false;\n', '        emit TransfersThawed(true);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '    * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To increment\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _addedValue The amount of tokens to increase the allowance by.\n', '    */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '    * approve should be called when allowed[_spender] == 0. To decrement\n', '    * allowed value is better to use this function to avoid 2 calls (and wait until\n', '    * the first transaction is mined)\n', '    * From MonolithDAO Token.sol\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '    */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue >= oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**GETTERS */\n', '\n', '    /** @notice Used to get the total supply\n', '     */\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return totalSupply;\n', '    }\n', '\n', '    /** @notice Used to get the balance of a holder\n', '        * @param _holder The address of the token holder\n', '     */\n', '    function balanceOf(\n', '        address _holder\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return balances[_holder];\n', '    }\n', '\n', '    /** @notice Used to get the allowance of someone\n', '        * @param _owner The address of the token owner\n', '        * @param _spender The address of thhe person allowed to spend funds on behalf of the owner\n', '     */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}']