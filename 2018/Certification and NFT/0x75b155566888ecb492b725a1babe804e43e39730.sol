['pragma solidity ^0.4.21;\n', '\n', '// File: contracts/ISimpleCrowdsale.sol\n', '\n', 'interface ISimpleCrowdsale {\n', '    function getSoftCap() external view returns(uint256);\n', '}\n', '\n', '// File: contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract.\n', '    */\n', '    function Ownable(address _owner) public {\n', '        owner = _owner == address(0) ? msg.sender : _owner;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev confirm ownership by a new owner\n', '    */\n', '    function confirmOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '// File: contracts/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '}\n', '\n', '// File: contracts/fund/ICrowdsaleFund.sol\n', '\n', '/**\n', ' * @title ICrowdsaleFund\n', ' * @dev Fund methods used by crowdsale contract\n', ' */\n', 'interface ICrowdsaleFund {\n', '    /**\n', '    * @dev Function accepts user`s contributed ether and logs contribution\n', '    * @param contributor Contributor wallet address.\n', '    */\n', '    function processContribution(address contributor) external payable;\n', '    /**\n', '    * @dev Function is called on the end of successful crowdsale\n', '    */\n', '    function onCrowdsaleEnd() external;\n', '    /**\n', '    * @dev Function is called if crowdsale failed to reach soft cap\n', '    */\n', '    function enableCrowdsaleRefund() external;\n', '}\n', '\n', '\n', '// File: contracts/token/IERC20Token.sol\n', '\n', '/**\n', ' * @title IERC20Token - ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract IERC20Token {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value)  public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '    function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '    /**\n', '    * @dev constructor\n', '    */\n', '    function SafeMath() public {\n', '    }\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/token/LockedTokens.sol\n', '\n', '/**\n', ' * @title LockedTokens\n', ' * @dev Lock tokens for certain period of time\n', ' */\n', 'contract LockedTokens is SafeMath {\n', '    struct Tokens {\n', '        uint256 amount;\n', '        uint256 lockEndTime;\n', '        bool released;\n', '    }\n', '\n', '    event TokensUnlocked(address _to, uint256 _value);\n', '\n', '    IERC20Token public token;\n', '    address public crowdsaleAddress;\n', '    mapping(address => Tokens[]) public walletTokens;\n', '\n', '    /**\n', '     * @dev LockedTokens constructor\n', '     * @param _token ERC20 compatible token contract\n', '     * @param _crowdsaleAddress Crowdsale contract address\n', '     */\n', '    function LockedTokens(IERC20Token _token, address _crowdsaleAddress) public {\n', '        token = _token;\n', '        crowdsaleAddress = _crowdsaleAddress;\n', '    }\n', '\n', '    /**\n', '     * @dev Functions locks tokens\n', '     * @param _to Wallet address to transfer tokens after _lockEndTime\n', '     * @param _amount Amount of tokens to lock\n', '     * @param _lockEndTime End of lock period\n', '     */\n', '    function addTokens(address _to, uint256 _amount, uint256 _lockEndTime) external {\n', '        require(msg.sender == crowdsaleAddress);\n', '        walletTokens[_to].push(Tokens({amount: _amount, lockEndTime: _lockEndTime, released: false}));\n', '    }\n', '\n', '    /**\n', '     * @dev Called by owner of locked tokens to release them\n', '     */\n', '    function releaseTokens() public {\n', '        require(walletTokens[msg.sender].length > 0);\n', '\n', '        for(uint256 i = 0; i < walletTokens[msg.sender].length; i++) {\n', '            if(!walletTokens[msg.sender][i].released && now >= walletTokens[msg.sender][i].lockEndTime) {\n', '                walletTokens[msg.sender][i].released = true;\n', '                token.transfer(msg.sender, walletTokens[msg.sender][i].amount);\n', '                TokensUnlocked(msg.sender, walletTokens[msg.sender][i].amount);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/ownership/MultiOwnable.sol\n', '\n', '/**\n', ' * @title MultiOwnable\n', ' * @dev The MultiOwnable contract has owners addresses and provides basic authorization control\n', ' * functions, this simplifies the implementation of "users permissions".\n', ' */\n', 'contract MultiOwnable {\n', '    address public manager; // address used to set owners\n', '    address[] public owners;\n', '    mapping(address => bool) public ownerByAddress;\n', '\n', '    event SetOwners(address[] owners);\n', '\n', '    modifier onlyOwner() {\n', '        require(ownerByAddress[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev MultiOwnable constructor sets the manager\n', '     */\n', '    function MultiOwnable() public {\n', '        manager = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to set owners addresses\n', '     */\n', '    function setOwners(address[] _owners) public {\n', '        require(msg.sender == manager);\n', '        _setOwners(_owners);\n', '\n', '    }\n', '\n', '    function _setOwners(address[] _owners) internal {\n', '        for(uint256 i = 0; i < owners.length; i++) {\n', '            ownerByAddress[owners[i]] = false;\n', '        }\n', '\n', '\n', '        for(uint256 j = 0; j < _owners.length; j++) {\n', '            ownerByAddress[_owners[j]] = true;\n', '        }\n', '        owners = _owners;\n', '        SetOwners(_owners);\n', '    }\n', '\n', '    function getOwners() public constant returns (address[]) {\n', '        return owners;\n', '    }\n', '}\n', '\n', '// File: contracts/token/ERC20Token.sol\n', '\n', '/**\n', ' * @title ERC20Token - ERC20 base implementation\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Token is IERC20Token, SafeMath {\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '// File: contracts/token/ITokenEventListener.sol\n', '\n', '/**\n', ' * @title ITokenEventListener\n', ' * @dev Interface which should be implemented by token listener\n', ' */\n', 'interface ITokenEventListener {\n', '    /**\n', '     * @dev Function is called after token transfer/transferFrom\n', '     * @param _from Sender address\n', '     * @param _to Receiver address\n', '     * @param _value Amount of tokens\n', '     */\n', '    function onTokenTransfer(address _from, address _to, uint256 _value) external;\n', '}\n', '\n', '// File: contracts/token/ManagedToken.sol\n', '\n', '/**\n', ' * @title ManagedToken\n', ' * @dev ERC20 compatible token with issue and destroy facilities\n', ' * @dev All transfers can be monitored by token event listener\n', ' */\n', 'contract ManagedToken is ERC20Token, MultiOwnable {\n', '    bool public allowTransfers = false;\n', '    bool public issuanceFinished = false;\n', '\n', '    ITokenEventListener public eventListener;\n', '\n', '    event AllowTransfersChanged(bool _newState);\n', '    event Issue(address indexed _to, uint256 _value);\n', '    event Destroy(address indexed _from, uint256 _value);\n', '    event IssuanceFinished();\n', '\n', '    modifier transfersAllowed() {\n', '        require(allowTransfers);\n', '        _;\n', '    }\n', '\n', '    modifier canIssue() {\n', '        require(!issuanceFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev ManagedToken constructor\n', '     * @param _listener Token listener(address can be 0x0)\n', '     * @param _owners Owners list\n', '     */\n', '    function ManagedToken(address _listener, address[] _owners) public {\n', '        if(_listener != address(0)) {\n', '            eventListener = ITokenEventListener(_listener);\n', '        }\n', '        _setOwners(_owners);\n', '    }\n', '\n', '    /**\n', '     * @dev Enable/disable token transfers. Can be called only by owners\n', '     * @param _allowTransfers True - allow False - disable\n', '     */\n', '    function setAllowTransfers(bool _allowTransfers) external onlyOwner {\n', '        allowTransfers = _allowTransfers;\n', '        AllowTransfersChanged(_allowTransfers);\n', '    }\n', '\n', '    /**\n', '     * @dev Set/remove token event listener\n', '     * @param _listener Listener address (Contract must implement ITokenEventListener interface)\n', '     */\n', '    function setListener(address _listener) public onlyOwner {\n', '        if(_listener != address(0)) {\n', '            eventListener = ITokenEventListener(_listener);\n', '        } else {\n', '            delete eventListener;\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {\n', '        bool success = super.transfer(_to, _value);\n', '        if(hasListener() && success) {\n', '            eventListener.onTokenTransfer(msg.sender, _to, _value);\n', '        }\n', '        return success;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {\n', '        bool success = super.transferFrom(_from, _to, _value);\n', '        if(hasListener() && success) {\n', '            eventListener.onTokenTransfer(_from, _to, _value);\n', '        }\n', '        return success;\n', '    }\n', '\n', '    function hasListener() internal view returns(bool) {\n', '        if(eventListener == address(0)) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Issue tokens to specified wallet\n', '     * @param _to Wallet address\n', '     * @param _value Amount of tokens\n', '     */\n', '    function issue(address _to, uint256 _value) external onlyOwner canIssue {\n', '        totalSupply = safeAdd(totalSupply, _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Issue(_to, _value);\n', '        Transfer(address(0), _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroy tokens on specified address (Called by owner or token holder)\n', '     * @dev Fund contract address must be in the list of owners to burn token during refund\n', '     * @param _from Wallet address\n', '     * @param _value Amount of tokens to destroy\n', '     */\n', '    function destroy(address _from, uint256 _value) external {\n', '        require(ownerByAddress[msg.sender] || msg.sender == _from);\n', '        require(balances[_from] >= _value);\n', '        totalSupply = safeSub(totalSupply, _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        Transfer(_from, address(0), _value);\n', '        Destroy(_from, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From OpenZeppelin StandardToken.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From OpenZeppelin StandardToken.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Finish token issuance\n', '     * @return True if success\n', '     */\n', '    function finishIssuance() public onlyOwner returns (bool) {\n', '        issuanceFinished = true;\n', '        IssuanceFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/token/TransferLimitedToken.sol\n', '\n', '/**\n', ' * @title TransferLimitedToken\n', ' * @dev Token with ability to limit transfers within wallets included in limitedWallets list for certain period of time\n', ' */\n', 'contract TransferLimitedToken is ManagedToken {\n', '    uint256 public constant LIMIT_TRANSFERS_PERIOD = 365 days;\n', '\n', '    mapping(address => bool) public limitedWallets;\n', '    uint256 public limitEndDate;\n', '    address public limitedWalletsManager;\n', '    bool public isLimitEnabled;\n', '\n', '    event TransfersEnabled();\n', '\n', '    modifier onlyManager() {\n', '        require(msg.sender == limitedWalletsManager);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Check if transfer between addresses is available\n', '     * @param _from From address\n', '     * @param _to To address\n', '     */\n', '    modifier canTransfer(address _from, address _to)  {\n', '        require(now >= limitEndDate || !isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev TransferLimitedToken constructor\n', '     * @param _limitStartDate Limit start date\n', '     * @param _listener Token listener(address can be 0x0)\n', '     * @param _owners Owners list\n', '     * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets\n', '     */\n', '    function TransferLimitedToken(\n', '        uint256 _limitStartDate,\n', '        address _listener,\n', '        address[] _owners,\n', '        address _limitedWalletsManager\n', '    ) public ManagedToken(_listener, _owners)\n', '    {\n', '        limitEndDate = _limitStartDate + LIMIT_TRANSFERS_PERIOD;\n', '        isLimitEnabled = true;\n', '        limitedWalletsManager = _limitedWalletsManager;\n', '    }\n', '\n', '    /**\n', '     * @dev Enable token transfers\n', '     */\n', '    function enableTransfers() public {\n', '        require(msg.sender == limitedWalletsManager);\n', '        allowTransfers = true;\n', '        TransfersEnabled();\n', '    }\n', '\n', '    /**\n', '     * @dev Add address to limitedWallets\n', '     * @dev Can be called only by manager\n', '     */\n', '    function addLimitedWalletAddress(address _wallet) public {\n', '        require(msg.sender == limitedWalletsManager || ownerByAddress[msg.sender]);\n', '        limitedWallets[_wallet] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Del address from limitedWallets\n', '     * @dev Can be called only by manager\n', '     */\n', '    function delLimitedWalletAddress(address _wallet) public onlyManager {\n', '        limitedWallets[_wallet] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Disable transfer limit manually. Can be called only by manager\n', '     */\n', '    function disableLimit() public onlyManager {\n', '        isLimitEnabled = false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {\n', '        return super.approve(_spender,_value);\n', '    }\n', '}\n', '\n', '// File: contracts/Crowdsale.sol\n', '\n', 'contract TheEvolthDAICO is Ownable, SafeMath, Pausable, ISimpleCrowdsale {\n', '    enum AdditionalBonusState {\n', '        Unavailable,\n', '        Active,\n', '        Applied\n', '    }\n', '\n', '    uint256 public constant ADDITIONAL_BONUS_NUM = 3;\n', '    uint256 public constant ADDITIONAL_BONUS_DENOM = 100;\n', '\n', '    uint256 public constant ETHER_MIN_CONTRIB = 0.2 ether;\n', '    uint256 public constant ETHER_MAX_CONTRIB = 20 ether;\n', '\n', '    uint256 public constant SALE_START_TIME = 1536566400; // 10.09.2018 08:00:00 UTC\n', '    uint256 public constant SALE_END_TIME = 1538956800; // 08.10.2018 08:00:00 UTC\n', '\n', '    uint256 public constant BONUS_WINDOW_1_END_TIME = SALE_START_TIME + 3 days;\n', '    uint256 public constant BONUS_WINDOW_2_END_TIME = SALE_START_TIME + 8 days;\n', '    uint256 public constant BONUS_WINDOW_3_END_TIME = SALE_START_TIME + 14 days;\n', '    uint256 public constant BONUS_WINDOW_4_END_TIME = SALE_START_TIME + 21 days;\n', '\n', '    uint256 public constant MAX_CONTRIB_CHECK_END_TIME = SALE_START_TIME + 1 days;\n', '\n', '    uint256 public tokenPriceNum = 0;\n', '    uint256 public tokenPriceDenom = 0;\n', '    \n', '    TransferLimitedToken public token;\n', '    ICrowdsaleFund public fund;\n', '    LockedTokens public lockedTokens;\n', '\n', '    mapping(address => AdditionalBonusState) public additionalBonusOwnerState;\n', '    mapping(address => uint256) public userTotalContributed;\n', '\n', '    address public mainSaleTokenWallet;\n', '    address public foundationTokenWallet;\n', '    address public advisorsTokenWallet;\n', '    address public teamTokenWallet;\n', '    address public marketingTokenWallet;\n', '\n', '    uint256 public totalEtherContributed = 0;\n', '    uint256 public rawTokenSupply = 0;\n', '\n', '    uint256 public hardCap = 0; // World hard cap will be set right before Token Sale\n', '    uint256 public softCap = 0; // World soft cap will be set right before Token Sale\n', '\n', '    uint256 public tokenMaxSupply;\n', '\n', '    event LogContribution(address contributor, uint256 amountWei, uint256 tokenAmount, uint256 tokenBonus, bool additionalBonusApplied, uint256 timestamp);\n', '\n', '    modifier checkContribution() {\n', '        require(isValidContribution());\n', '        _;\n', '    }\n', '\n', '    modifier checkCap() {\n', '        require(validateCap());\n', '        _;\n', '    }\n', '\n', '    modifier checkTime() {\n', '        require(now >= SALE_START_TIME && now <= SALE_END_TIME);\n', '        _;\n', '    }\n', '\n', '    function TheEvolthDAICO(\n', '        address tokenAddress,\n', '        address fundAddress,\n', '        address _mainSaleTokenWallet,\n', '        address _foundationTokenWallet,\n', '        address _advisorsTokenWallet,\n', '        address _teamTokenWallet,\n', '        address _marketingTokenWallet,\n', '        address _owner\n', '    ) public\n', '        Ownable(_owner)\n', '    {\n', '        require(tokenAddress != address(0));\n', '\n', '        token = TransferLimitedToken(tokenAddress);\n', '        fund = ICrowdsaleFund(fundAddress);\n', '\n', '        mainSaleTokenWallet = _mainSaleTokenWallet;\n', '        foundationTokenWallet = _foundationTokenWallet;\n', '        advisorsTokenWallet = _advisorsTokenWallet;\n', '        teamTokenWallet = _teamTokenWallet;\n', '        marketingTokenWallet = _marketingTokenWallet;\n', '\n', '        tokenMaxSupply = 100*10**25; // 1B\n', '    }\n', '\n', '    /**\n', '     * @dev check contribution amount and time\n', '     */\n', '    function isValidContribution() internal view returns(bool) {\n', '        uint256 currentUserContribution = safeAdd(msg.value, userTotalContributed[msg.sender]);\n', '        if(msg.value >= ETHER_MIN_CONTRIB) {\n', '            if(now <= MAX_CONTRIB_CHECK_END_TIME && currentUserContribution > ETHER_MAX_CONTRIB ) {\n', '                    return false;\n', '            }\n', '            return true;\n', '\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * @dev Check hard cap overflow\n', '     */\n', '    function validateCap() internal view returns(bool){\n', '        if(msg.value <= safeSub(hardCap, totalEtherContributed)) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * @dev Set token price once before start of crowdsale\n', '     */\n', '    function setTokenPrice(uint256 _tokenPriceNum, uint256 _tokenPriceDenom) public onlyOwner {\n', '        require(tokenPriceNum == 0 && tokenPriceDenom == 0);\n', '        require(_tokenPriceNum > 0 && _tokenPriceDenom > 0);\n', '        tokenPriceNum = _tokenPriceNum;\n', '        tokenPriceDenom = _tokenPriceDenom;\n', '    }\n', '\n', '    /**\n', '     * @dev Set hard cap.\n', '     * @param _hardCap - Hard cap value\n', '     */\n', '    function setHardCap(uint256 _hardCap) public onlyOwner {\n', '        require(hardCap == 0);\n', '        hardCap = _hardCap;\n', '    }\n', '\n', '    /**\n', '     * @dev Set soft cap.\n', '     * @param _softCap - Soft cap value\n', '     */\n', '    function setSoftCap(uint256 _softCap) public onlyOwner {\n', '        require(softCap == 0);\n', '        softCap = _softCap;\n', '    }\n', '\n', '    /**\n', '     * @dev Get soft cap amount\n', '     **/\n', '    function getSoftCap() external view returns(uint256) {\n', '        return softCap;\n', '    }\n', '\n', '    /**\n', '     * @dev Calc bonus amount by contribution time\n', '     */\n', '    function getBonus() internal constant returns (uint256, uint256) {\n', '        uint256 numerator = 0;\n', '        uint256 denominator = 100;\n', '\n', '        if(now < BONUS_WINDOW_1_END_TIME) {\n', '            numerator = 30;\n', '        } else if(now < BONUS_WINDOW_2_END_TIME) {\n', '            numerator = 20;\n', '        } else if(now < BONUS_WINDOW_3_END_TIME) {\n', '            numerator = 10;\n', '        } else if(now < BONUS_WINDOW_4_END_TIME) {\n', '            numerator = 5;\n', '        } else {\n', '            numerator = 0;\n', '        }\n', '\n', '        return (numerator, denominator);\n', '    }\n', '\n', '    function addToLists(\n', '        address _wallet,\n', '        bool isInLimitedList,\n', '        bool hasAdditionalBonus\n', '    ) public onlyOwner {\n', '        if(isInLimitedList) {\n', '            token.addLimitedWalletAddress(_wallet);\n', '        }\n', '        if(hasAdditionalBonus) {\n', '            additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Add wallet to additional bonus members. For contract owner only.\n', '     */\n', '    function addAdditionalBonusMember(address _wallet) public onlyOwner {\n', '        additionalBonusOwnerState[_wallet] = AdditionalBonusState.Active;\n', '    }\n', '\n', '    /**\n', '     * @dev Set LockedTokens contract address\n', '     */\n', '    function setLockedTokens(address lockedTokensAddress) public onlyOwner {\n', '        lockedTokens = LockedTokens(lockedTokensAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev Fallback function to receive ether contributions\n', '     */\n', '    function () payable public whenNotPaused {\n', '        processContribution(msg.sender, msg.value);\n', '    }\n', '\n', '    /**\n', '     * @dev Process ether contribution. Calc bonuses and issue tokens to contributor.\n', '     */\n', '    function processContribution(address contributor, uint256 amount) private checkTime checkContribution checkCap {\n', '        bool additionalBonusApplied = false;\n', '        uint256 bonusNum = 0;\n', '        uint256 bonusDenom = 100;\n', '        (bonusNum, bonusDenom) = getBonus();\n', '        uint256 tokenBonusAmount = 0;\n', '\n', '        uint256 tokenAmount = safeDiv(safeMul(amount, tokenPriceNum), tokenPriceDenom);\n', '        rawTokenSupply = safeAdd(rawTokenSupply, tokenAmount);\n', '\n', '        if(bonusNum > 0) {\n', '            tokenBonusAmount = safeDiv(safeMul(tokenAmount, bonusNum), bonusDenom);\n', '        }\n', '\n', '        if(additionalBonusOwnerState[contributor] ==  AdditionalBonusState.Active) {\n', '            additionalBonusOwnerState[contributor] = AdditionalBonusState.Applied;\n', '            uint256 additionalBonus = safeDiv(safeMul(tokenAmount, ADDITIONAL_BONUS_NUM), ADDITIONAL_BONUS_DENOM);\n', '            tokenBonusAmount = safeAdd(tokenBonusAmount, additionalBonus);\n', '            additionalBonusApplied = true;\n', '        }\n', '\n', '        processPayment(contributor, amount, tokenAmount, tokenBonusAmount, additionalBonusApplied);\n', '    }\n', '\n', '    function processPayment(address contributor, uint256 etherAmount, uint256 tokenAmount, uint256 tokenBonusAmount, bool additionalBonusApplied) internal {\n', '        uint256 tokenTotalAmount = safeAdd(tokenAmount, tokenBonusAmount);\n', '\n', '        token.issue(contributor, tokenTotalAmount);\n', '        fund.processContribution.value(etherAmount)(contributor);\n', '        totalEtherContributed = safeAdd(totalEtherContributed, etherAmount);\n', '        userTotalContributed[contributor] = safeAdd(userTotalContributed[contributor], etherAmount);\n', '        LogContribution(contributor, etherAmount, tokenAmount, tokenBonusAmount, additionalBonusApplied, now);\n', '    }\n', '\n', '    /**\n', '     * @dev Force crowdsale refund\n', '     */\n', '    function forceCrowdsaleRefund() public onlyOwner {\n', '        pause();\n', '        fund.enableCrowdsaleRefund();\n', '        token.finishIssuance();\n', '    }\n', '\n', '    /**\n', '     * @dev Finalize crowdsale if we reached hard cap or current time > SALE_END_TIME\n', '     */\n', '    function finalizeCrowdsale() public onlyOwner {\n', '        if(\n', '            totalEtherContributed >= hardCap ||\n', '            (now >= SALE_END_TIME && totalEtherContributed >= softCap)\n', '        ) {\n', '            fund.onCrowdsaleEnd();\n', '\n', '            uint256 mintedTokenAmount = token.totalSupply();\n', '            uint256 unmintedTokenAmount = safeSub(tokenMaxSupply, mintedTokenAmount);\n', '\n', '            // Main Sale\n', '            uint256 mainSaleTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 4), 10); // 40 %\n', '            token.issue(address(lockedTokens), mainSaleTokenAmount);\n', '            lockedTokens.addTokens(mainSaleTokenWallet, mainSaleTokenAmount, now + 90 days);\n', '\n', '            // Foundation\n', '            uint256 foundationTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 4), 10); // 40%\n', '            token.issue(foundationTokenWallet, foundationTokenAmount);\n', '\n', '            // Advisors\n', '            uint256 advisorsTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 5), 100); // 5%\n', '            token.issue(address(lockedTokens), advisorsTokenAmount);\n', '            lockedTokens.addTokens(advisorsTokenWallet, advisorsTokenAmount, now + 365 days);\n', '\n', '            // Team\n', '            uint256 teamTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 5), 100); // 5%\n', '            token.issue(address(lockedTokens), teamTokenAmount);\n', '            lockedTokens.addTokens(teamTokenWallet, teamTokenAmount, now + 365 days);\n', '\n', '            // Marketing\n', '            uint256 maketingTokenAmount = safeDiv(safeMul(unmintedTokenAmount, 1), 10); // 10%\n', '            token.issue(marketingTokenWallet, maketingTokenAmount);\n', '\n', '            token.finishIssuance();\n', '\n', '        } else if(now >= SALE_END_TIME) {\n', '            // Enable fund`s crowdsale refund if soft cap is not reached\n', '            fund.enableCrowdsaleRefund();\n', '            token.finishIssuance();\n', '        }\n', '    }\n', '\n', '}']