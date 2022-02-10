['pragma solidity ^0.4.11;\n', '\n', 'contract Owned {\n', '\n', '    address public owner = msg.sender;\n', '    address public potentialOwner;\n', '\n', '    modifier onlyOwner {\n', '      require(msg.sender == owner);\n', '      _;\n', '    }\n', '\n', '    modifier onlyPotentialOwner {\n', '      require(msg.sender == potentialOwner);\n', '      _;\n', '    }\n', '\n', '    event NewOwner(address old, address current);\n', '    event NewPotentialOwner(address old, address potential);\n', '\n', '    function setOwner(address _new)\n', '      onlyOwner\n', '    {\n', '      NewPotentialOwner(owner, _new);\n', '      potentialOwner = _new;\n', '      // owner = _new;\n', '    }\n', '\n', '    function confirmOwnership()\n', '      onlyPotentialOwner\n', '    {\n', '      NewOwner(owner, potentialOwner);\n', '      owner = potentialOwner;\n', '      potentialOwner = 0;\n', '    }\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract AbstractToken {\n', "    // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions\n", '    function totalSupply() constant returns (uint256) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Issuance(address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', 'contract StandardToken is AbstractToken {\n', '\n', '    /*\n', '     *  Data structures\n', '     */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    /*\n', '     *  Read and write storage functions\n', '     */\n', "    /// @dev Transfers sender's tokens to a given address. Returns success.\n", '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Read storage functions\n', '     */\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', '/// @title Token contract - Implements Standard Token Interface for TrueFlip.\n', '/// @author Zerion - <inbox@zerion.io>\n', 'contract TrueFlipToken is StandardToken, SafeMath, Owned {\n', '    /*\n', '     * External contracts\n', '     */\n', '    address public mintAddress;\n', '    /*\n', '     * Token meta data\n', '     */\n', '    string constant public name = "TrueFlip";\n', '    string constant public symbol = "TFL";\n', '    uint8 constant public decimals = 8;\n', '\n', '    // 1 050 000 TFL tokens were minted during PreICO\n', '    // 13\xa0650\xa0000 TFL tokens can be minted during ICO\n', '    // 2 100 000 TFL tokens can be minted for Advisory\n', '    // 4 200 000 TFL tokens can be minted for Team\n', '    // Overall, 21 000 000 TFL tokens can be minted\n', '    uint constant public maxSupply = 21000000 * 10 ** 8;\n', '\n', '    // Only true until finalize function is called.\n', '    bool public mintingAllowed = true;\n', '    // Address where minted tokens are reserved\n', '    address constant public mintedTokens = 0x6049604960496049604960496049604960496049;\n', '\n', '    modifier onlyMint() {\n', '        // Only minter is allowed to proceed.\n', '        require(msg.sender == mintAddress);\n', '        _;\n', '    }\n', '\n', '    /// @dev Function to change address that is allowed to do emission.\n', '    /// @param newAddress Address of new emission contract.\n', '    function setMintAddress(address newAddress)\n', '        public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        if (mintAddress == 0x0)\n', '            mintAddress = newAddress;\n', '    }\n', '\n', '    /// @dev Contract constructor function sets initial token balances.\n', '    function TrueFlipToken(address ownerAddress)\n', '    {\n', '        owner = ownerAddress;\n', '        balances[mintedTokens] = mul(1050000, 10 ** 8);\n', '        totalSupply = balances[mintedTokens];\n', '    }\n', '\n', '    function mint(address beneficiary, uint amount, bool transfer)\n', '        external\n', '        onlyMint\n', '        returns (bool success)\n', '    {\n', '        require(mintingAllowed == true);\n', '        require(add(totalSupply, amount) <= maxSupply);\n', '        totalSupply = add(totalSupply, amount);\n', '        if (transfer) {\n', '            balances[beneficiary] = add(balances[beneficiary], amount);\n', '        } else {\n', '            balances[mintedTokens] = add(balances[mintedTokens], amount);\n', '            if (beneficiary != 0) {\n', '                allowed[mintedTokens][beneficiary] = amount;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function finalize()\n', '        public\n', '        onlyMint\n', '        returns (bool success)\n', '    {\n', '        mintingAllowed = false;\n', '        return true;\n', '    }\n', '\n', '    function requestWithdrawal(address beneficiary, uint amount)\n', '        public\n', '        onlyOwner\n', '    {\n', '        allowed[mintedTokens][beneficiary] = amount;\n', '    }\n', '\n', '    function withdrawTokens()\n', '        public\n', '    {\n', '        transferFrom(mintedTokens, msg.sender, allowance(mintedTokens, msg.sender));\n', '    }\n', '}']