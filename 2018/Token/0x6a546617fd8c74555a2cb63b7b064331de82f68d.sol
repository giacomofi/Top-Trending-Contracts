['pragma solidity ^0.4.21;\n', '\n', '// File: contracts/ownership/MultiOwnable.sol\n', '\n', '/**\n', ' * @title MultiOwnable\n', ' * @dev The MultiOwnable contract has owners addresses and provides basic authorization control\n', ' * functions, this simplifies the implementation of "users permissions".\n', ' */\n', 'contract MultiOwnable {\n', '    address public manager; // address used to set owners\n', '    address[] public owners;\n', '    mapping(address => bool) public ownerByAddress;\n', '\n', '    event SetOwners(address[] owners);\n', '\n', '    modifier onlyOwner() {\n', '        require(ownerByAddress[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev MultiOwnable constructor sets the manager\n', '     */\n', '    function MultiOwnable() public {\n', '        manager = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to set owners addresses\n', '     */\n', '    function setOwners(address[] _owners) public {\n', '        require(msg.sender == manager);\n', '        _setOwners(_owners);\n', '\n', '    }\n', '\n', '    function _setOwners(address[] _owners) internal {\n', '        for(uint256 i = 0; i < owners.length; i++) {\n', '            ownerByAddress[owners[i]] = false;\n', '        }\n', '\n', '\n', '        for(uint256 j = 0; j < _owners.length; j++) {\n', '            ownerByAddress[_owners[j]] = true;\n', '        }\n', '        owners = _owners;\n', '        SetOwners(_owners);\n', '    }\n', '\n', '    function getOwners() public constant returns (address[]) {\n', '        return owners;\n', '    }\n', '}\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '    /**\n', '    * @dev constructor\n', '    */\n', '    function SafeMath() public {\n', '    }\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/token/IERC20Token.sol\n', '\n', '/**\n', ' * @title IERC20Token - ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract IERC20Token {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value)  public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '    function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// File: contracts/token/ERC20Token.sol\n', '\n', '/**\n', ' * @title ERC20Token - ERC20 base implementation\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Token is IERC20Token, SafeMath {\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '// File: contracts/token/ITokenEventListener.sol\n', '\n', '/**\n', ' * @title ITokenEventListener\n', ' * @dev Interface which should be implemented by token listener\n', ' */\n', 'interface ITokenEventListener {\n', '    /**\n', '     * @dev Function is called after token transfer/transferFrom\n', '     * @param _from Sender address\n', '     * @param _to Receiver address\n', '     * @param _value Amount of tokens\n', '     */\n', '    function onTokenTransfer(address _from, address _to, uint256 _value) external;\n', '}\n', '\n', '// File: contracts/token/ManagedToken.sol\n', '\n', '/**\n', ' * @title ManagedToken\n', ' * @dev ERC20 compatible token with issue and destroy facilities\n', ' * @dev All transfers can be monitored by token event listener\n', ' */\n', 'contract ManagedToken is ERC20Token, MultiOwnable {\n', '    bool public allowTransfers = false;\n', '    bool public issuanceFinished = false;\n', '\n', '    ITokenEventListener public eventListener;\n', '\n', '    event AllowTransfersChanged(bool _newState);\n', '    event Issue(address indexed _to, uint256 _value);\n', '    event Destroy(address indexed _from, uint256 _value);\n', '    event IssuanceFinished();\n', '\n', '    modifier transfersAllowed() {\n', '        require(allowTransfers);\n', '        _;\n', '    }\n', '\n', '    modifier canIssue() {\n', '        require(!issuanceFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev ManagedToken constructor\n', '     * @param _listener Token listener(address can be 0x0)\n', '     * @param _owners Owners list\n', '     */\n', '    function ManagedToken(address _listener, address[] _owners) public {\n', '        if(_listener != address(0)) {\n', '            eventListener = ITokenEventListener(_listener);\n', '        }\n', '        _setOwners(_owners);\n', '    }\n', '\n', '    /**\n', '     * @dev Enable/disable token transfers. Can be called only by owners\n', '     * @param _allowTransfers True - allow False - disable\n', '     */\n', '    function setAllowTransfers(bool _allowTransfers) external onlyOwner {\n', '        allowTransfers = _allowTransfers;\n', '        AllowTransfersChanged(_allowTransfers);\n', '    }\n', '\n', '    /**\n', '     * @dev Set/remove token event listener\n', '     * @param _listener Listener address (Contract must implement ITokenEventListener interface)\n', '     */\n', '    function setListener(address _listener) public onlyOwner {\n', '        if(_listener != address(0)) {\n', '            eventListener = ITokenEventListener(_listener);\n', '        } else {\n', '            delete eventListener;\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {\n', '        bool success = super.transfer(_to, _value);\n', '        if(hasListener() && success) {\n', '            eventListener.onTokenTransfer(msg.sender, _to, _value);\n', '        }\n', '        return success;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {\n', '        bool success = super.transferFrom(_from, _to, _value);\n', '        if(hasListener() && success) {\n', '            eventListener.onTokenTransfer(_from, _to, _value);\n', '        }\n', '        return success;\n', '    }\n', '\n', '    function hasListener() internal view returns(bool) {\n', '        if(eventListener == address(0)) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Issue tokens to specified wallet\n', '     * @param _to Wallet address\n', '     * @param _value Amount of tokens\n', '     */\n', '    function issue(address _to, uint256 _value) external onlyOwner canIssue {\n', '        totalSupply = safeAdd(totalSupply, _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Issue(_to, _value);\n', '        Transfer(address(0), _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroy tokens on specified address (Called by owner or token holder)\n', '     * @dev Fund contract address must be in the list of owners to burn token during refund\n', '     * @param _from Wallet address\n', '     * @param _value Amount of tokens to destroy\n', '     */\n', '    function destroy(address _from, uint256 _value) external {\n', '        require(ownerByAddress[msg.sender] || msg.sender == _from);\n', '        require(balances[_from] >= _value);\n', '        totalSupply = safeSub(totalSupply, _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        Transfer(_from, address(0), _value);\n', '        Destroy(_from, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From OpenZeppelin StandardToken.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From OpenZeppelin StandardToken.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Finish token issuance\n', '     * @return True if success\n', '     */\n', '    function finishIssuance() public onlyOwner returns (bool) {\n', '        issuanceFinished = true;\n', '        IssuanceFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/token/TransferLimitedToken.sol\n', '\n', '/**\n', ' * @title TransferLimitedToken\n', ' * @dev Token with ability to limit transfers within wallets included in limitedWallets list for certain period of time\n', ' */\n', 'contract TransferLimitedToken is ManagedToken {\n', '    uint256 public constant LIMIT_TRANSFERS_PERIOD = 365 days;\n', '\n', '    mapping(address => bool) public limitedWallets;\n', '    uint256 public limitEndDate;\n', '    address public limitedWalletsManager;\n', '    bool public isLimitEnabled;\n', '\n', '    modifier onlyManager() {\n', '        require(msg.sender == limitedWalletsManager);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Check if transfer between addresses is available\n', '     * @param _from From address\n', '     * @param _to To address\n', '     */\n', '    modifier canTransfer(address _from, address _to)  {\n', '        require(now >= limitEndDate || !isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev TransferLimitedToken constructor\n', '     * @param _limitStartDate Limit start date\n', '     * @param _listener Token listener(address can be 0x0)\n', '     * @param _owners Owners list\n', '     * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets\n', '     */\n', '    function TransferLimitedToken(\n', '        uint256 _limitStartDate,\n', '        address _listener,\n', '        address[] _owners,\n', '        address _limitedWalletsManager\n', '    ) public ManagedToken(_listener, _owners)\n', '    {\n', '        limitEndDate = _limitStartDate + LIMIT_TRANSFERS_PERIOD;\n', '        isLimitEnabled = true;\n', '        limitedWalletsManager = _limitedWalletsManager;\n', '    }\n', '\n', '    /**\n', '     * @dev Add address to limitedWallets\n', '     * @dev Can be called only by manager\n', '     */\n', '    function addLimitedWalletAddress(address _wallet) public {\n', '        require(msg.sender == limitedWalletsManager || ownerByAddress[msg.sender]);\n', '        limitedWallets[_wallet] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Del address from limitedWallets\n', '     * @dev Can be called only by manager\n', '     */\n', '    function delLimitedWalletAddress(address _wallet) public onlyManager {\n', '        limitedWallets[_wallet] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Disable transfer limit manually. Can be called only by manager\n', '     */\n', '    function disableLimit() public onlyManager {\n', '        isLimitEnabled = false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {\n', '        return super.approve(_spender,_value);\n', '    }\n', '}\n', '\n', '// File: contracts/AbyssToken.sol\n', '\n', 'contract AbyssToken is TransferLimitedToken {\n', '    uint256 public constant SALE_END_TIME = 1526479200; // 16.05.2018 14:00:00 UTC\n', '\n', '    function AbyssToken(address _listener, address[] _owners, address manager) public\n', '        TransferLimitedToken(SALE_END_TIME, _listener, _owners, manager)\n', '    {\n', '        name = "ABYSS";\n', '        symbol = "ABYSS";\n', '        decimals = 18;\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// File: contracts/ownership/MultiOwnable.sol\n', '\n', '/**\n', ' * @title MultiOwnable\n', ' * @dev The MultiOwnable contract has owners addresses and provides basic authorization control\n', ' * functions, this simplifies the implementation of "users permissions".\n', ' */\n', 'contract MultiOwnable {\n', '    address public manager; // address used to set owners\n', '    address[] public owners;\n', '    mapping(address => bool) public ownerByAddress;\n', '\n', '    event SetOwners(address[] owners);\n', '\n', '    modifier onlyOwner() {\n', '        require(ownerByAddress[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev MultiOwnable constructor sets the manager\n', '     */\n', '    function MultiOwnable() public {\n', '        manager = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Function to set owners addresses\n', '     */\n', '    function setOwners(address[] _owners) public {\n', '        require(msg.sender == manager);\n', '        _setOwners(_owners);\n', '\n', '    }\n', '\n', '    function _setOwners(address[] _owners) internal {\n', '        for(uint256 i = 0; i < owners.length; i++) {\n', '            ownerByAddress[owners[i]] = false;\n', '        }\n', '\n', '\n', '        for(uint256 j = 0; j < _owners.length; j++) {\n', '            ownerByAddress[_owners[j]] = true;\n', '        }\n', '        owners = _owners;\n', '        SetOwners(_owners);\n', '    }\n', '\n', '    function getOwners() public constant returns (address[]) {\n', '        return owners;\n', '    }\n', '}\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'contract SafeMath {\n', '    /**\n', '    * @dev constructor\n', '    */\n', '    function SafeMath() public {\n', '    }\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(a >= b);\n', '        return a - b;\n', '    }\n', '\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/token/IERC20Token.sol\n', '\n', '/**\n', ' * @title IERC20Token - ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract IERC20Token {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value)  public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);\n', '    function approve(address _spender, uint256 _value)  public returns (bool success);\n', '    function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// File: contracts/token/ERC20Token.sol\n', '\n', '/**\n', ' * @title ERC20Token - ERC20 base implementation\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Token is IERC20Token, SafeMath {\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[msg.sender] >= _value);\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);\n', '\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '// File: contracts/token/ITokenEventListener.sol\n', '\n', '/**\n', ' * @title ITokenEventListener\n', ' * @dev Interface which should be implemented by token listener\n', ' */\n', 'interface ITokenEventListener {\n', '    /**\n', '     * @dev Function is called after token transfer/transferFrom\n', '     * @param _from Sender address\n', '     * @param _to Receiver address\n', '     * @param _value Amount of tokens\n', '     */\n', '    function onTokenTransfer(address _from, address _to, uint256 _value) external;\n', '}\n', '\n', '// File: contracts/token/ManagedToken.sol\n', '\n', '/**\n', ' * @title ManagedToken\n', ' * @dev ERC20 compatible token with issue and destroy facilities\n', ' * @dev All transfers can be monitored by token event listener\n', ' */\n', 'contract ManagedToken is ERC20Token, MultiOwnable {\n', '    bool public allowTransfers = false;\n', '    bool public issuanceFinished = false;\n', '\n', '    ITokenEventListener public eventListener;\n', '\n', '    event AllowTransfersChanged(bool _newState);\n', '    event Issue(address indexed _to, uint256 _value);\n', '    event Destroy(address indexed _from, uint256 _value);\n', '    event IssuanceFinished();\n', '\n', '    modifier transfersAllowed() {\n', '        require(allowTransfers);\n', '        _;\n', '    }\n', '\n', '    modifier canIssue() {\n', '        require(!issuanceFinished);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev ManagedToken constructor\n', '     * @param _listener Token listener(address can be 0x0)\n', '     * @param _owners Owners list\n', '     */\n', '    function ManagedToken(address _listener, address[] _owners) public {\n', '        if(_listener != address(0)) {\n', '            eventListener = ITokenEventListener(_listener);\n', '        }\n', '        _setOwners(_owners);\n', '    }\n', '\n', '    /**\n', '     * @dev Enable/disable token transfers. Can be called only by owners\n', '     * @param _allowTransfers True - allow False - disable\n', '     */\n', '    function setAllowTransfers(bool _allowTransfers) external onlyOwner {\n', '        allowTransfers = _allowTransfers;\n', '        AllowTransfersChanged(_allowTransfers);\n', '    }\n', '\n', '    /**\n', '     * @dev Set/remove token event listener\n', '     * @param _listener Listener address (Contract must implement ITokenEventListener interface)\n', '     */\n', '    function setListener(address _listener) public onlyOwner {\n', '        if(_listener != address(0)) {\n', '            eventListener = ITokenEventListener(_listener);\n', '        } else {\n', '            delete eventListener;\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {\n', '        bool success = super.transfer(_to, _value);\n', '        if(hasListener() && success) {\n', '            eventListener.onTokenTransfer(msg.sender, _to, _value);\n', '        }\n', '        return success;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {\n', '        bool success = super.transferFrom(_from, _to, _value);\n', '        if(hasListener() && success) {\n', '            eventListener.onTokenTransfer(_from, _to, _value);\n', '        }\n', '        return success;\n', '    }\n', '\n', '    function hasListener() internal view returns(bool) {\n', '        if(eventListener == address(0)) {\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Issue tokens to specified wallet\n', '     * @param _to Wallet address\n', '     * @param _value Amount of tokens\n', '     */\n', '    function issue(address _to, uint256 _value) external onlyOwner canIssue {\n', '        totalSupply = safeAdd(totalSupply, _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        Issue(_to, _value);\n', '        Transfer(address(0), _to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroy tokens on specified address (Called by owner or token holder)\n', '     * @dev Fund contract address must be in the list of owners to burn token during refund\n', '     * @param _from Wallet address\n', '     * @param _value Amount of tokens to destroy\n', '     */\n', '    function destroy(address _from, uint256 _value) external {\n', '        require(ownerByAddress[msg.sender] || msg.sender == _from);\n', '        require(balances[_from] >= _value);\n', '        totalSupply = safeSub(totalSupply, _value);\n', '        balances[_from] = safeSub(balances[_from], _value);\n', '        Transfer(_from, address(0), _value);\n', '        Destroy(_from, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From OpenZeppelin StandardToken.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From OpenZeppelin StandardToken.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Finish token issuance\n', '     * @return True if success\n', '     */\n', '    function finishIssuance() public onlyOwner returns (bool) {\n', '        issuanceFinished = true;\n', '        IssuanceFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', '// File: contracts/token/TransferLimitedToken.sol\n', '\n', '/**\n', ' * @title TransferLimitedToken\n', ' * @dev Token with ability to limit transfers within wallets included in limitedWallets list for certain period of time\n', ' */\n', 'contract TransferLimitedToken is ManagedToken {\n', '    uint256 public constant LIMIT_TRANSFERS_PERIOD = 365 days;\n', '\n', '    mapping(address => bool) public limitedWallets;\n', '    uint256 public limitEndDate;\n', '    address public limitedWalletsManager;\n', '    bool public isLimitEnabled;\n', '\n', '    modifier onlyManager() {\n', '        require(msg.sender == limitedWalletsManager);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Check if transfer between addresses is available\n', '     * @param _from From address\n', '     * @param _to To address\n', '     */\n', '    modifier canTransfer(address _from, address _to)  {\n', '        require(now >= limitEndDate || !isLimitEnabled || (!limitedWallets[_from] && !limitedWallets[_to]));\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev TransferLimitedToken constructor\n', '     * @param _limitStartDate Limit start date\n', '     * @param _listener Token listener(address can be 0x0)\n', '     * @param _owners Owners list\n', '     * @param _limitedWalletsManager Address used to add/del wallets from limitedWallets\n', '     */\n', '    function TransferLimitedToken(\n', '        uint256 _limitStartDate,\n', '        address _listener,\n', '        address[] _owners,\n', '        address _limitedWalletsManager\n', '    ) public ManagedToken(_listener, _owners)\n', '    {\n', '        limitEndDate = _limitStartDate + LIMIT_TRANSFERS_PERIOD;\n', '        isLimitEnabled = true;\n', '        limitedWalletsManager = _limitedWalletsManager;\n', '    }\n', '\n', '    /**\n', '     * @dev Add address to limitedWallets\n', '     * @dev Can be called only by manager\n', '     */\n', '    function addLimitedWalletAddress(address _wallet) public {\n', '        require(msg.sender == limitedWalletsManager || ownerByAddress[msg.sender]);\n', '        limitedWallets[_wallet] = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Del address from limitedWallets\n', '     * @dev Can be called only by manager\n', '     */\n', '    function delLimitedWalletAddress(address _wallet) public onlyManager {\n', '        limitedWallets[_wallet] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Disable transfer limit manually. Can be called only by manager\n', '     */\n', '    function disableLimit() public onlyManager {\n', '        isLimitEnabled = false;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public canTransfer(msg.sender, _to) returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {\n', '        return super.approve(_spender,_value);\n', '    }\n', '}\n', '\n', '// File: contracts/AbyssToken.sol\n', '\n', 'contract AbyssToken is TransferLimitedToken {\n', '    uint256 public constant SALE_END_TIME = 1526479200; // 16.05.2018 14:00:00 UTC\n', '\n', '    function AbyssToken(address _listener, address[] _owners, address manager) public\n', '        TransferLimitedToken(SALE_END_TIME, _listener, _owners, manager)\n', '    {\n', '        name = "ABYSS";\n', '        symbol = "ABYSS";\n', '        decimals = 18;\n', '    }\n', '}']
