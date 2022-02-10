['pragma solidity ^0.4.2;\n', '\n', '/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20\n', '/// @title Abstract token contract - Functions to be implemented by token contracts.\n', '\n', 'contract AbstractToken {\n', "    // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions\n", '    function totalSupply() constant returns (uint256 supply) {}\n', '    function balanceOf(address owner) constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) returns (bool success);\n', '    function transferFrom(address from, address to, uint256 value) returns (bool success);\n', '    function approve(address spender, uint256 value) returns (bool success);\n', '    function allowance(address owner, address spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Issuance(address indexed to, uint256 value);\n', '}\n', '\n', 'contract StandardToken is AbstractToken {\n', '\n', '    /*\n', '     *  Data structures\n', '     */\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '\n', '    /*\n', '     *  Read and write storage functions\n', '     */\n', "    /// @dev Transfers sender's tokens to a given address. Returns success.\n", '    /// @param _to Address of token receiver.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.\n', '    /// @param _from Address from where tokens are withdrawn.\n', '    /// @param _to Address to where tokens are sent.\n', '    /// @param _value Number of tokens to transfer.\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    /// @dev Returns number of tokens owned by given address.\n', '    /// @param _owner Address of token owner.\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /// @dev Sets approved amount of tokens for spender. Returns success.\n', '    /// @param _spender Address of allowed account.\n', '    /// @param _value Number of approved tokens.\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /*\n', '     * Read storage functions\n', '     */\n', '    /// @dev Returns number of allowed tokens for given address.\n', '    /// @param _owner Address of token owner.\n', '    /// @param _spender Address of token spender.\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/// @title Token contract - Implements Standard Token Interface but adds Pyramid Scheme Support :)\n', '/// @author Rishab Hegde - <contact@rishabhegde.com>\n', '/// Missed the boat on the first PonziCoin?\n', "/// Re-deployed by !author because that was fun, so let's do it again.\n", "/// Get in while the gettin's good, and get out while you still can!\n", 'contract PonziCoinRedux is StandardToken, SafeMath {\n', '\n', '    /*\n', '     * Token meta data\n', '     */\n', '    string constant public name = "PonziCoin";\n', '    string constant public symbol = "SEC";\n', '    uint8 constant public decimals = 3;\n', '\n', '    uint public buyPrice = 10 szabo;\n', '    uint public sellPrice = 2500000000000 wei;\n', '    uint public tierBudget = 100000;\n', '\n', '    // Address of the founder of PonziCoin.\n', '    address public founder = 0x4688e5C3410B423DC749265Dfd4d513473445FE3;\n', '\n', '    /*\n', '     * Contract functions\n', '     */\n', '    /// @dev Allows user to create tokens if token creation is still going\n', '    /// and cap was not reached. Returns token count.\n', '    function fund()\n', '      public\n', '      payable \n', '      returns (bool)\n', '    {\n', '      uint tokenCount = msg.value / buyPrice;\n', '      if (tokenCount > tierBudget) {\n', '        tokenCount = tierBudget;\n', '      }\n', '      \n', '      uint investment = tokenCount * buyPrice;\n', '\n', '      balances[msg.sender] += tokenCount;\n', '      Issuance(msg.sender, tokenCount);\n', '      totalSupply += tokenCount;\n', '      tierBudget -= tokenCount;\n', '\n', '      if (tierBudget <= 0) {\n', '        tierBudget = 100000;\n', '        buyPrice *= 2;\n', '        sellPrice *= 2;\n', '      }\n', '      if (msg.value > investment) {\n', '        msg.sender.transfer(msg.value - investment);\n', '      }\n', '      return true;\n', '    }\n', '\n', '    function withdraw(uint tokenCount)\n', '      public\n', '      returns (bool)\n', '    {\n', '      if (balances[msg.sender] >= tokenCount) {\n', '        uint withdrawal = tokenCount * sellPrice;\n', '        balances[msg.sender] -= tokenCount;\n', '        totalSupply -= tokenCount;\n', '        msg.sender.transfer(withdrawal);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    /// @dev Contract constructor function sets initial token balances.\n', '    function PonziCoinRedux()\n', '    {   \n', "        // It's not a good scam unless it's pre-mined. No I'm not going to dump on you, don't worry. This isn't a scam (at least not entirely). If I feel like maintaining the website is too much I'll give the keys to someone else.\n", '        balances[founder] = 200000;\n', '        totalSupply += 200000;\n', '    }\n', '}']