['pragma solidity 0.4.18;\n', '\n', 'library SafeMath {\n', '\n', '  // We use `pure` bbecause it promises that the value for the function depends ONLY\n', '  // on the function arguments\n', '  function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '    uint256 c = a * b;\n', '    require(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Administration {\n', '\n', '    address     public owner;\n', '    \n', '    mapping (address => bool) public moderators;\n', '    mapping (address => string) privilegeStatus;\n', '\n', '    event AddMod(address indexed _invoker, address indexed _newMod, bool indexed _modAdded);\n', '    event RemoveMod(address indexed _invoker, address indexed _removeMod, bool indexed _modRemoved);\n', '\n', '    function Administration() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner)\n', '        public\n', '        onlyOwner\n', '        returns (bool success)\n', '    {\n', '        owner = _newOwner;\n', '        return true;\n', '        \n', '    }\n', '\n', '    function addModerator(address _newMod)\n', '        public\n', '        onlyOwner\n', '        returns (bool added)\n', '     {\n', '        require(_newMod != address(0x0));\n', '        moderators[_newMod] = true;\n', '        AddMod(msg.sender, _newMod, true);\n', '        return true;\n', '    }\n', '    \n', '    function removeModerator(address _removeMod)\n', '        public\n', '        onlyOwner\n', '        returns (bool removed)\n', '    {\n', '        require(_removeMod != address(0x0));\n', '        moderators[_removeMod] = false;\n', '        RemoveMod(msg.sender, _removeMod, true);\n', '        return true;\n', '    }\n', '\n', '    function getRoleStatus(address _addr)\n', '        public\n', '        view  // We use view as we promise to not change state, but are reading from a state variable\n', '        returns (string _role)\n', '    {\n', '        return privilegeStatus[_addr];\n', '    }\n', '}\n', '\n', 'contract CoinMarketAlert is Administration {\n', '    using SafeMath for uint256;\n', '\n', '    address[]   public      userAddresses;\n', '    uint256     public      totalSupply;\n', '    uint256     public      usersRegistered;\n', '    uint8       public      decimals;\n', '    string      public      name;\n', '    string      public      symbol;\n', '    bool        public      tokenTransfersFrozen;\n', '    bool        public      tokenMintingEnabled;\n', '    bool        public      contractLaunched;\n', '\n', '\n', '    struct AlertCreatorStruct {\n', '        address alertCreator;\n', '        uint256 alertsCreated;\n', '    }\n', '\n', '    AlertCreatorStruct[]   public      alertCreators;\n', '    \n', '    // Alert Creator Entered (Used to prevetnt duplicates in creator array)\n', '    mapping (address => bool) public userRegistered;\n', '    // Tracks approval\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    //[addr][balance]\n', '    mapping (address => uint256) public balances;\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _amount);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _amount);\n', '    event MintTokens(address indexed _minter, uint256 _amountMinted, bool indexed Minted);\n', '    event FreezeTransfers(address indexed _freezer, bool indexed _frozen);\n', '    event ThawTransfers(address indexed _thawer, bool indexed _thawed);\n', '    event TokenBurn(address indexed _burner, uint256 _amount, bool indexed _burned);\n', '    event EnableTokenMinting(bool Enabled);\n', '\n', '    function CoinMarketAlert()\n', '        public {\n', '        symbol = "CMA";\n', '        name = "Coin Market Alert";\n', '        decimals = 18;\n', '        // 50 Mil in wei\n', '        totalSupply = 50000000000000000000000000;\n', '        balances[msg.sender] = 50000000000000000000000000;\n', '        tokenTransfersFrozen = true;\n', '        tokenMintingEnabled = false;\n', '    }\n', '\n', '    /// @notice Used to launch start the contract\n', '    function launchContract()\n', '        public\n', '        onlyAdmin\n', '        returns (bool launched)\n', '    {\n', '        require(!contractLaunched);\n', '        tokenTransfersFrozen = false;\n', '        tokenMintingEnabled = true;\n', '        contractLaunched = true;\n', '        EnableTokenMinting(true);\n', '        return true;\n', '    }\n', '    \n', '    /// @dev keeps a list of addresses that are participating in the site\n', '    function registerUser(address _user) \n', '        private\n', '        returns (bool registered)\n', '    {\n', '        usersRegistered = usersRegistered.add(1);\n', '        AlertCreatorStruct memory acs;\n', '        acs.alertCreator = _user;\n', '        alertCreators.push(acs);\n', '        userAddresses.push(_user);\n', '        userRegistered[_user] = true;\n', '        return true;\n', '    }\n', '\n', '    /// @notice Manual payout for site users\n', '    /// @param _user Ethereum address of the user\n', '    /// @param _amount The mount of CMA tokens in wei to send\n', '    function singlePayout(address _user, uint256 _amount)\n', '        public\n', '        onlyAdmin\n', '        returns (bool paid)\n', '    {\n', '        require(!tokenTransfersFrozen);\n', '        require(_amount > 0);\n', '        require(transferCheck(owner, _user, _amount));\n', '        if (!userRegistered[_user]) {\n', '            registerUser(_user);\n', '        }\n', '        balances[_user] = balances[_user].add(_amount);\n', '        balances[owner] = balances[owner].add(_amount);\n', '        Transfer(owner, _user, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @dev low-level minting function not accessible externally\n', '    function tokenMint(address _invoker, uint256 _amount) \n', '        private\n', '        returns (bool raised)\n', '    {\n', '        require(balances[owner].add(_amount) > balances[owner]);\n', '        require(balances[owner].add(_amount) > 0);\n', '        require(totalSupply.add(_amount) > 0);\n', '        require(totalSupply.add(_amount) > totalSupply);\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[owner] = balances[owner].add(_amount);\n', '        MintTokens(_invoker, _amount, true);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to mint tokens, only usable by the contract owner\n', '    /// @param _amount The amount of CMA tokens in wei to mint\n', '    function tokenFactory(uint256 _amount)\n', '        public\n', '        onlyAdmin\n', '        returns (bool success)\n', '    {\n', '        require(_amount > 0);\n', '        require(tokenMintingEnabled);\n', '        require(tokenMint(msg.sender, _amount));\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to burn tokens\n', '    /// @param _amount The amount of CMA tokens in wei to burn\n', '    function tokenBurn(uint256 _amount)\n', '        public\n', '        onlyAdmin\n', '        returns (bool burned)\n', '    {\n', '        require(_amount > 0);\n', '        require(_amount < totalSupply);\n', '        require(balances[owner] > _amount);\n', '        require(balances[owner].sub(_amount) >= 0);\n', '        require(totalSupply.sub(_amount) >= 0);\n', '        balances[owner] = balances[owner].sub(_amount);\n', '        totalSupply = totalSupply.sub(_amount);\n', '        TokenBurn(msg.sender, _amount, true);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to freeze token transfers\n', '    function freezeTransfers()\n', '        public\n', '        onlyAdmin\n', '        returns (bool frozen)\n', '    {\n', '        tokenTransfersFrozen = true;\n', '        FreezeTransfers(msg.sender, true);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to thaw token transfers\n', '    function thawTransfers()\n', '        public\n', '        onlyAdmin\n', '        returns (bool thawed)\n', '    {\n', '        tokenTransfersFrozen = false;\n', '        ThawTransfers(msg.sender, true);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to transfer funds\n', '    /// @param _receiver The destination ethereum address\n', '    /// @param _amount The amount of CMA tokens in wei to send\n', '    function transfer(address _receiver, uint256 _amount)\n', '        public\n', '        returns (bool _transferred)\n', '    {\n', '        require(!tokenTransfersFrozen);\n', '        require(transferCheck(msg.sender, _receiver, _amount));\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_receiver] = balances[_receiver].add(_amount);\n', '        Transfer(msg.sender, _receiver, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to transfer funds on behalf of one person\n', '    /// @param _owner Person you are allowed to spend funds on behalf of\n', '    /// @param _receiver Person to receive the funds\n', '    /// @param _amount Amoun of CMA tokens in wei to send\n', '    function transferFrom(address _owner, address _receiver, uint256 _amount)\n', '        public\n', '        returns (bool _transferredFrom)\n', '    {\n', '        require(!tokenTransfersFrozen);\n', '        require(allowance[_owner][msg.sender].sub(_amount) >= 0);\n', '        require(transferCheck(_owner, _receiver, _amount));\n', '        balances[_owner] = balances[_owner].sub(_amount);\n', '        balances[_receiver] = balances[_receiver].add(_amount);\n', '        allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);\n', '        Transfer(_owner, _receiver, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to approve a third-party to send funds on your behalf\n', '    /// @param _spender The person you are allowing to spend on your behalf\n', '    /// @param _amount The amount of CMA tokens in wei they are allowed to spend\n', '    function approve(address _spender, uint256 _amount)\n', '        public\n', '        returns (bool approved)\n', '    {\n', '        require(_amount > 0);\n', '        require(balances[msg.sender] > 0);\n', '        allowance[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '     //GETTERS//\n', '    ///////////\n', '\n', '    \n', '    /// @dev low level function used to do a sanity check of input data for CMA token transfers\n', '    /// @param _sender This is the msg.sender, the person sending the CMA tokens\n', '    /// @param _receiver This is the address receiving the CMA tokens\n', '    /// @param _value This is the amount of CMA tokens in wei to send\n', '    function transferCheck(address _sender, address _receiver, uint256 _value) \n', '        private\n', '        view\n', '        returns (bool safe) \n', '    {\n', '        require(_value > 0);\n', '        require(_receiver != address(0));\n', '        require(balances[_sender].sub(_value) >= 0);\n', '        require(balances[_receiver].add(_value) > balances[_receiver]);\n', '        return true;\n', '    }\n', '\n', '    /// @notice Used to retrieve total supply\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256 _totalSupply)\n', '    {\n', '        return totalSupply;\n', '    }\n', '\n', '    /// @notice Used to look up balance of a user\n', '    function balanceOf(address _person)\n', '        public\n', '        view\n', '        returns (uint256 balance)\n', '    {\n', '        return balances[_person];\n', '    }\n', '\n', '    /// @notice Used to look up allowance of a user\n', '    function allowance(address _owner, address _spender)\n', '        public\n', '        view\n', '        returns (uint256 allowed)\n', '    {\n', '        return allowance[_owner][_spender];\n', '    }\n', '}']